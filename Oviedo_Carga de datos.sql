-- Entrega 2
-- DATOS (Inserciones de prueba)

USE CamionesIVECO;

-- Categorías
INSERT INTO categoria_camion (nombre_categoria) VALUES
('Light'), ('Medium'), ('Heavy');

-- Camiones
INSERT INTO camion (modelo, año, color, motor, estado, id_categoria) VALUES
('Daily 35S14', 2025, 'Blanco', 'F1A 2.3L', 'disponible', 1),
('Tector 170E28', 2024, 'Azul', 'NEF 6.7L', 'disponible', 2),
('S-Way 560', 2025, 'Rojo', 'Cursor 13', 'disponible', 3);

-- Stock:
UPDATE stock SET cantidad_actual = 25 WHERE id_camion = 1;
UPDATE stock SET cantidad_actual = 30 WHERE id_camion = 2;
UPDATE stock SET cantidad_actual = 21 WHERE id_camion = 3;

-- Clientes
INSERT INTO cliente (nombre, apellido, email, telefono) VALUES
('Valeria', 'Wander', 'valeria.wander@gmail.com', '+54 3541 7476538'),
('María', 'Gómez', 'maria.gomez@mail.com', '+54 351 8474847');

-- Precios (sin solapamiento)
INSERT INTO precio (id_camion, precio, fecha_inicio, fecha_fin) VALUES
(1, 35000000.00, '2025-09-01', NULL),
(2, 52000000.00, '2025-09-01', NULL),
(3, 98000000.00, '2025-09-01', NULL);

-- Descuentos por categoría ( 5% Gamma Medium, 2% Gamma Heavy)
INSERT INTO descuento (descripcion, porcentaje, fecha_inicio, fecha_fin, id_categoria) VALUES
('Promo septiembre Light', 0.00, '2025-01-01', NULL, 1),
('Plan Medium', 5.00, '2025-01-01', NULL, 2),
('Bonificacion Heavy', 2.00, '2025-01-01', NULL, 3);

-- Pedidos
INSERT INTO pedido (id_cliente, fecha_pedido, estado) VALUES
(1, '2025-09-01', 'pendiente'),
(2, '2025-09-05', 'pendiente');

-- Detalles de pedido
INSERT INTO detalle_pedido (id_pedido, id_camion, cantidad) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1);
