-- Creación de Vistas, Funciones, Stored Procedures y Triggers

USE CamionesIVECO;
-- FUNCIONES:
DELIMITER //
-- Devuelve el precio vigente para un camión y fecha dada
CREATE FUNCTION fn_precio_vigente(p_id_camion INT, p_fecha DATE)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_precio DECIMAL(12,2);
    SELECT pr.precio
      INTO v_precio
      FROM precio pr
     WHERE pr.id_camion = p_id_camion
       AND pr.fecha_inicio <= p_fecha
       AND (pr.fecha_fin IS NULL OR pr.fecha_fin >= p_fecha)
     ORDER BY pr.fecha_inicio DESC
     LIMIT 1;
    RETURN v_precio;
END//
//

-- Devuelve el % de descuento vigente según la categoría del camión y la fecha
CREATE FUNCTION fn_descuento_vigente(p_id_camion INT, p_fecha DATE)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE v_desc DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_id_categoria INT;

    SELECT c.id_categoria INTO v_id_categoria
      FROM camion c
     WHERE c.id_camion = p_id_camion
     LIMIT 1;

    IF v_id_categoria IS NOT NULL THEN
        SELECT d.porcentaje
          INTO v_desc
          FROM descuento d
         WHERE d.id_categoria = v_id_categoria
           AND d.fecha_inicio <= p_fecha
           AND (d.fecha_fin IS NULL OR d.fecha_fin >= p_fecha)
         ORDER BY d.fecha_inicio DESC
         LIMIT 1;
    END IF;

    RETURN IFNULL(v_desc, 0.00);
END//
//

-- Devuelve el precio final aplicando descuento vigente
CREATE FUNCTION fn_precio_final(p_id_camion INT, p_fecha DATE)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_base DECIMAL(12,2);
    DECLARE v_desc DECIMAL(5,2);
    DECLARE v_final DECIMAL(12,2);

    SET v_base = fn_precio_vigente(p_id_camion, p_fecha);
    SET v_desc = fn_descuento_vigente(p_id_camion, p_fecha);

    IF v_base IS NULL THEN
        RETURN NULL;
    END IF;

    SET v_final = v_base * (1 - (IFNULL(v_desc,0)/100));
    RETURN ROUND(v_final, 2);
END//
//

-- Devuelve el stock disponible de un camión
CREATE FUNCTION fn_stock_disponible(p_id_camion INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_stock INT;
    SELECT s.cantidad_actual INTO v_stock
      FROM stock s
     WHERE s.id_camion = p_id_camion
     LIMIT 1;
    RETURN IFNULL(v_stock, 0);
END//
//

DELIMITER ;

-- VISTAS:

CREATE VIEW vw_precios_vigentes AS
SELECT 
    c.id_camion,
    c.modelo,
    c.año,
    c.color,
    pr.precio,
    pr.fecha_inicio,
    pr.fecha_fin
FROM camion c
JOIN precio pr ON pr.id_camion = c.id_camion
WHERE pr.fecha_inicio <= CURDATE()
  AND (pr.fecha_fin IS NULL OR pr.fecha_fin >= CURDATE());

CREATE OR REPLACE VIEW vw_descuentos_vigentes AS
SELECT 
    cat.id_categoria,
    cat.nombre_categoria,
    d.porcentaje,
    d.fecha_inicio,
    d.fecha_fin
FROM categoria_camion cat
JOIN descuento d ON d.id_categoria = cat.id_categoria
WHERE d.fecha_inicio <= CURDATE()
  AND (d.fecha_fin IS NULL OR d.fecha_fin >= CURDATE());

CREATE OR REPLACE VIEW vw_catalogo_camiones AS
SELECT 
    c.id_camion,
    c.modelo,
    c.año,
    c.color,
    cat.nombre_categoria,
    fn_precio_vigente(c.id_camion, CURDATE()) AS precio_vigente,
    fn_descuento_vigente(c.id_camion, CURDATE()) AS descuento_vigente_pct,
    fn_precio_final(c.id_camion, CURDATE()) AS precio_final_hoy,
    fn_stock_disponible(c.id_camion) AS stock_disponible
FROM camion c
JOIN categoria_camion cat ON cat.id_categoria = c.id_categoria;

CREATE OR REPLACE VIEW vw_pedidos_detallados AS
SELECT 
    p.id_pedido,
    p.fecha_pedido,
    p.estado,
    cl.id_cliente,
    CONCAT(cl.nombre, ' ', cl.apellido) AS cliente,
    dp.id_camion,
    c.modelo,
    dp.cantidad,
    fn_precio_vigente(dp.id_camion, p.fecha_pedido) AS precio_unitario_al_pedir,
    fn_precio_final(dp.id_camion, p.fecha_pedido) AS precio_unitario_final_al_pedir,
    (dp.cantidad * fn_precio_final(dp.id_camion, p.fecha_pedido)) AS total_linea
FROM pedido p
JOIN cliente cl ON cl.id_cliente = p.id_cliente
JOIN detalle_pedido dp ON dp.id_pedido = p.id_pedido
JOIN camion c ON c.id_camion = dp.id_camion;

CREATE OR REPLACE VIEW vw_stock_bajo AS
SELECT 
    c.id_camion, c.modelo, s.cantidad_actual
FROM camion c
JOIN stock s ON s.id_camion = c.id_camion
WHERE s.cantidad_actual < 3;

-- STORED PROCEDURES:

DELIMITER //

CREATE PROCEDURE sp_crear_pedido(IN p_id_cliente INT, OUT p_id_pedido INT)
BEGIN
    INSERT INTO pedido (id_cliente, fecha_pedido, estado)
    VALUES (p_id_cliente, CURDATE(), 'pendiente');
    SET p_id_pedido = LAST_INSERT_ID();
END//
//

CREATE PROCEDURE sp_agregar_item_pedido(
    IN p_id_pedido INT,
    IN p_id_camion INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_estado VARCHAR(20);
    DECLARE v_stock INT;

    -- Validaciones básicas
    IF p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad debe ser mayor a 0';
    END IF;

    SELECT estado INTO v_estado
      FROM pedido
     WHERE id_pedido = p_id_pedido
     LIMIT 1;

    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pedido inexistente';
    END IF;

    IF v_estado <> 'pendiente' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se pueden agregar items a pedidos en estado pendiente';
    END IF;

    SET v_stock = fn_stock_disponible(p_id_camion);
    IF v_stock < p_cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para el item';
    END IF;

    -- Inserta o acumula cantidad si ya existe el mismo camión en el pedido
    INSERT INTO detalle_pedido (id_pedido, id_camion, cantidad)
    VALUES (p_id_pedido, p_id_camion, p_cantidad)
    ON DUPLICATE KEY UPDATE cantidad = cantidad + VALUES(cantidad);
END//
//

CREATE PROCEDURE sp_confirmar_pedido(IN p_id_pedido INT)
BEGIN
    DECLARE v_estado VARCHAR(20);
    DECLARE v_faltante INT;

    START TRANSACTION;

    SELECT estado INTO v_estado
      FROM pedido
     WHERE id_pedido = p_id_pedido FOR UPDATE;

    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pedido inexistente';
    END IF;

    IF v_estado = 'confirmado' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido ya está confirmado';
    END IF;

    -- Verificar stock por cada item
    SELECT COUNT(*) INTO v_faltante
    FROM detalle_pedido dp
    JOIN stock s ON s.id_camion = dp.id_camion
    WHERE dp.id_pedido = p_id_pedido
      AND dp.cantidad > s.cantidad_actual;

    IF v_faltante > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para confirmar el pedido';
    END IF;

    -- Descontar stock
    UPDATE stock s
    JOIN detalle_pedido dp ON dp.id_camion = s.id_camion
    SET s.cantidad_actual = s.cantidad_actual - dp.cantidad
    WHERE dp.id_pedido = p_id_pedido;

    -- Cambiar estado
    UPDATE pedido
       SET estado = 'confirmado'
     WHERE id_pedido = p_id_pedido;

    COMMIT;
END//
//

DELIMITER ;

-- TRIGGERS:
DELIMITER //

-- 1) Valida que la cantidad del detalle de pedido sea mayor a cero
CREATE TRIGGER trg_detalle_bi_valida_cantidad
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad del pedido debe ser mayor a cero.';
    END IF;
END;
//

CREATE TRIGGER trg_camion_ad_auditoria
AFTER DELETE ON camion
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_borrados(tabla_afectada, id_registro, descripcion, fecha_borrado, usuario)
    VALUES(
        'camion',
        OLD.id_camion,
        CONCAT('Modelo: ', OLD.modelo, ', Año: ', OLD.año, ', Motor: ', OLD.motor),
        NOW(),
        USER()
    );
END;
//

DELIMITER ;
