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


CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    email VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Precio (
    id_precio INT AUTO_INCREMENT PRIMARY KEY,
    id_camion INT,
    precio DECIMAL(12,2),
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (id_camion) REFERENCES camion(id_camion)
);

CREATE TABLE IF NOT EXISTS descuento (
    id_descuento INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50),
    porcentaje DECIMAL(3,2),
    fecha_inicio DATE,
    fecha_fin DATE,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categoria_camion(id_categoria)
);

CREATE TABLE IF NOT EXISTS stock (
    id_stock INT AUTO_INCREMENT PRIMARY KEY,
    id_camion INT,
    cantidad_actual INT,
    FOREIGN KEY (id_camion) REFERENCES Camion(id_camion)
);

CREATE TABLE IF NOT EXISTS Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE,
    estado VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_camion INT,
    cantidad INT,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_camion) REFERENCES Camion(id_camion)
);