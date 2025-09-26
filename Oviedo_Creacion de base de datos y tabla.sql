CREATE DATABASE CamionesIVECO;
USE CamionesIVECO;

-- Tabla Categoria Camion para las categorías (Light, Medium, Heavy)
CREATE TABLE IF NOT EXISTS categoria_camion (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE IF NOT EXISTS camion (
    id_camion INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    año INT,
    color VARCHAR(20),
    motor VARCHAR(50),
    estado VARCHAR(20),
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categoria_camion(id_categoria)
);

-- Tabla Cliente
CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    email VARCHAR(50),
    telefono VARCHAR(20)
);
-- Tabla Precio
CREATE TABLE IF NOT EXISTS precio (
    id_precio INT AUTO_INCREMENT PRIMARY KEY,
    id_camion INT,
    precio DECIMAL(12,2),
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (id_camion) REFERENCES camion(id_camion)
);

-- Tabla Descuento
CREATE TABLE IF NOT EXISTS descuento (
    id_descuento INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50),
    porcentaje DECIMAL(5,2),
    fecha_inicio DATE,
    fecha_fin DATE,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categoria_camion(id_categoria)
);

-- Tabla Stock
CREATE TABLE IF NOT EXISTS stock (
    id_stock INT AUTO_INCREMENT PRIMARY KEY,
    id_camion INT,
    cantidad_actual INT,
    FOREIGN KEY (id_camion) REFERENCES camion(id_camion)
);

-- Tabla Pedido
CREATE TABLE IF NOT EXISTS Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE,
    estado VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabla detalle de pedido 
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_camion INT,
    cantidad INT,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_camion) REFERENCES Camion(id_camion)
);
ALTER TABLE detalle_pedido
  ADD CONSTRAINT uq_pedido_camion UNIQUE (id_pedido, id_camion);
  
-- Tabla Proveedor
CREATE TABLE IF NOT EXISTS proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    contacto VARCHAR(50),
    telefono VARCHAR(20)
);

-- Tabla Factura
CREATE TABLE IF NOT EXISTS factura (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    fecha_factura DATE,
    total DECIMAL(12,2),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

-- Tabla Envio
CREATE TABLE IF NOT EXISTS envio (
    id_envio INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    fecha_envio DATE,
    transportista VARCHAR(50),
    estado_envio VARCHAR(20),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

-- Tabla Pago
CREATE TABLE IF NOT EXISTS pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT,
    fecha_pago DATE,
    metodo_pago VARCHAR(20),
    monto DECIMAL(12,2),
    FOREIGN KEY (id_factura) REFERENCES factura(id_factura)
);

-- Tabla Auditoría Stock
CREATE TABLE IF NOT EXISTS auditoria_stock (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_camion INT,
    cantidad_anterior INT,
    cantidad_nueva INT,
    fecha_modificacion DATETIME,
    usuario VARCHAR(50),
    FOREIGN KEY (id_camion) REFERENCES camion(id_camion)
);
-- Tabla Auditoría de borrado de camiones
CREATE TABLE IF NOT EXISTS auditoria_borrados (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    id_registro INT,
    descripcion TEXT,
    fecha_borrado DATETIME,
    usuario VARCHAR(50)
);
-- Tabla Log de cambios de precios
CREATE TABLE IF NOT EXISTS log_precio (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_camion INT,
    precio_anterior DECIMAL(12,2),
    precio_nuevo DECIMAL(12,2),
    fecha_modificacion DATETIME,
    usuario VARCHAR(50),
    FOREIGN KEY (id_camion) REFERENCES camion(id_camion)
);