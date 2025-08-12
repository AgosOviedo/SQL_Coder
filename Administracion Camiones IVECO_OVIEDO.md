# SQL_Coder
SQL Coder House - Maria Agostina Oviedo
ENTREGA 1 - SQL - CODERHOUSE
# INTRODUCCIÓN
El presente proyecto tiene como finalidad el desarrollo de una base de datos relacional para la gestión integral del stock comercial y las operaciones de venta de camiones en IVECO Group. Este sistema permitirá centralizar la información de los vehículos disponibles para la venta, registrar pedidos de clientes, gestionar listas de precios, aplicar descuentos y llevar un seguimiento de los pagos, facturación y cambios de estado de los camiones.
La propuesta busca optimizar la disponibilidad de datos para la toma de decisiones comerciales y administrativas, facilitando el acceso rápido y preciso a información clave sobre el inventario y las operaciones de ventas.
# OBJETIVOS
-Diseñar y desarrollar una base de datos relacional que:
-Permita gestionar el stock comercial de camiones disponibles para venta.
-Registre y administre pedidos de clientes, incluyendo detalles de productos, precios y descuentos.
-Gestione las listas de precios y descuentos vigentes.
-Controle los cambios de estado de los camiones (disponible, reservado, vendido).
-Registre pagos y facturación vinculados a cada pedido.
-Brinde soporte a la generación de reportes de stock, ventas por modelo y periodos determinados.
# SITUACIÓN PROBLEMATICA
Actualmente, la gestión del stock comercial y las operaciones de venta de camiones se realiza en sistemas independientes y/o mediante registros manuales, lo que genera dificultades en el seguimiento del inventario, en la actualización de precios y en el control de pedidos y pagos.
La falta de integración provoca inconsistencias de datos, retrasos en la información disponible para las áreas comerciales y administrativas, y limita la capacidad de análisis de ventas y stock en tiempo real.
La implementación de una base de datos centralizada permitirá unificar la información, reducir errores, optimizar procesos y mejorar la trazabilidad de las operaciones.
# MODELO DE NEGOCIO
El sistema está diseñado para la gestión interna del área comercial de IVECO Group.
Clientes realizan pedidos de camiones disponibles en stock.
Vendedores gestionan y asignan los pedidos.
El área comercial mantiene actualizadas las listas de precios y descuentos aplicables.
El sistema registra el historial de estados de cada camión, desde su disponibilidad hasta su venta.
El área administrativa gestiona pagos y facturación vinculados a los pedidos.
El sistema permite generar reportes de stock y ventas para análisis gerencial.
Este modelo asegura un control integral del flujo comercial, desde el stock inicial hasta la venta y postventa, mejorando la coordinación entre áreas y la eficiencia operativa.
# DIAGRAMA E-R (Entidad-Relación)
<img width="1068" height="755" alt="image" src="https://github.com/user-attachments/assets/05ec8fe6-d170-4ebc-a394-3242fabcfd37" />

# LISTA DE TABLAS
## Tabla "categoria_camion"
Descripción: Contiene las categorías de camiones (ejemplo: Light, Medium, Heavy)
Clave primaria: id_categoria
## Tabla "camion"
Descripción: Guarda la información de los camiones disponibles para la venta.
Clave primaria: id_camion
Clave foránea: id_categoria 
## Tabla "cliente"
Descripción: Datos de los clientes que realizan pedidos.
Clave primaria: id_cliente
## Tabla "precio"
Descripción: Registra los precios vigentes para cada camión, con períodos de validez.
Clave primaria: id_precio
Clave foránea: id_camion
## Tabla "descuento"
Descripción: Lista de descuentos aplicables a categorías de camiones, con vigencia.
Clave primaria: id_descuento
Clave foránea: id_categoria
## Tabla "stock"
Descripción: Controla la cantidad actual disponible en stock para cada camión.
Clave primaria: id_stock
Clave foránea: id_camion 
## Tabla "pedido"
Descripción: Registro de pedidos realizados por los clientes.
Clave primaria: id_pedido
Clave foránea: id_cliente 
## Tabla "detalle pedido"
Descripción: Detalles de los camiones incluidos en cada pedido, con cantidades.
Clave primaria: id_detalle
Clave foránea:
id_pedido
id_camion 

# AUTOR: MARIA AGOSTINA OVIEDO
