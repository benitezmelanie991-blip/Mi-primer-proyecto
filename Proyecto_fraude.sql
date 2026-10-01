DROP DATABASE IF EXISTS Fraude;
CREATE DATABASE Fraude;
USE Fraude;
GO

CREATE TABLE usuarios(
usuario_id INT PRIMARY KEY NOT NULL,
nombre VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL,
telefono VARCHAR (20),
pais VARCHAR (50),
fecha_registro DATETIME DEFAULT GETDATE(),
estado VARCHAR(50)
);

CREATE TABLE cuentas(
cuenta_id INT PRIMARY KEY NOT NULL,
usuario_id INT NOT NULL,
tipo_cuenta VARCHAR(50) NOT NULL,
saldo DECIMAL(18,4),
fecha_apertura DATETIME NOT NULL,
CONSTRAINT fk_usuario_id FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON UPDATE CASCADE
);

CREATE TABLE tarjetas(
tarjeta_id INT PRIMARY KEY NOT NULL,
usuario_id INT NOT NULL,
numero_enmascarado VARCHAR(50) NOT NULL,
tipo VARCHAR(20) NOT NULL,
fecha_emision DATETIME NOT NULL,
estado VARCHAR(50) NOT NULL,
CONSTRAINT fk_usuario_id_cuentas FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON UPDATE CASCADE
);

CREATE TABLE dispositivos(
dispositivo_id INT PRIMARY KEY NOT NULL,
usuario_id INT NOT NULL,
tipo_dispositivo VARCHAR(50) NOT NULL,
sistema_operativo VARCHAR(50),
ip_registro VARCHAR(20),
fecha_registro DATETIME NOT NULL,
CONSTRAINT fk_usuarios_id_dispositivos FOREIGN KEY (usuario_id) REFERENCES usuarios (usuario_id) ON UPDATE CASCADE
);

CREATE TABLE lista_negra_ip (
    ip              VARCHAR(50) PRIMARY KEY NOT NULL,
    motivo          TEXT NOT NULL,
    fecha_agregado  DATETIME
);
 
CREATE TABLE transacciones (
    transaccion_id      INT PRIMARY KEY,
    cuenta_id           INT NOT NULL,
    tarjeta_id          INT NOT NULL,
    dispositivo_id      INT NOT NULL,
    monto               DECIMAL(10,2) NOT NULL,
    fecha               DATE NOT NULL,
    tipo_transaccion    VARCHAR(20) NOT NULL, -- compra, transferencia, retiro, deposito
    comercio            VARCHAR(20) NOT NULL,
    ip_origen           VARCHAR(20) NOT NULL,
    pais_transaccion    VARCHAR(20),
    estado              VARCHAR(20) DEFAULT 'aprobada', -- aprobada, rechazada, revertida
    CONSTRAINT fk_cuenta_id_transacciones FOREIGN KEY (cuenta_id) REFERENCES cuentas(cuenta_id),
    CONSTRAINT fk_tarjeta_id_transacciones FOREIGN KEY (tarjeta_id) REFERENCES tarjetas(tarjeta_id),
    CONSTRAINT fk_dispositivo_id_transacciones FOREIGN KEY (dispositivo_id) REFERENCES dispositivos(dispositivo_id)
);
 
 CREATE TABLE alertas_fraude (
    alerta_id       INT PRIMARY KEY NOT NULL,
    transaccion_id  INT NOT NULL,
    regla_activada  TEXT NOT NULL,
    score_riesgo    INT NOT NULL, -- 0-100
    fecha_alerta    DATETIME NOT NULL,
    estado          VARCHAR(50) DEFAULT 'pendiente', -- pendiente, confirmado_fraude, falso_positivo
    CONSTRAINT fk_transaccion_id_alertas_fraude FOREIGN KEY (transaccion_id) REFERENCES transacciones(transaccion_id)
);

-- Usuarios
INSERT INTO usuarios (usuario_id, nombre, email, telefono, pais, fecha_registro, estado) VALUES
(1, 'Juan Pérez', 'juan.perez@mail.com', '+54 9 11 1234-5678', 'Argentina', '2025-01-10 10:00:00', 'activo'),
(2, 'María Gómez', 'maria.gomez@mail.com', '+54 9 11 8765-4321', 'Argentina', '2025-02-15 14:30:00', 'activo');
INSERT INTO usuarios (usuario_id, nombre, email, telefono, pais, fecha_registro, estado) VALUES
(3,'Axel Martinez','martinez.24@fmail.com','+541123457896','Argentina','2026-02-01 20:15:00','Activo');
INSERT INTO usuarios (usuario_id, nombre, email, telefono, pais, fecha_registro, estado) VALUES
(16, N'Lucas Gomez', N'lucas.gomez1@mail.com', N'+54 9 11 5506-5012', N'Chile', N'2026-05-04 05:34:25', N'activo'),
(17, N'Facundo Rodriguez', N'facundo.rodriguez2@mail.com', N'+54 9 11 7912-1520', N'Argentina', N'2026-06-20 09:48:08', N'activo'),
(18, N'Thiago Gomez', N'thiago.gomez3@mail.com', N'+54 9 11 4257-9928', N'Paraguay', N'2026-02-10 18:11:49', N'activo'),
(4, N'Victoria Sanchez', N'victoria.sanchez4@mail.com', N'+54 9 11 1106-3615', N'Mexico', N'2025-07-18 14:13:48', N'activo'),
(5, N'Isabella Diaz', N'isabella.diaz5@mail.com', N'+54 9 11 4527-6514', N'Argentina', N'2026-06-21 15:40:28', N'activo'),
(6, N'Lucas Flores', N'lucas.flores6@mail.com', N'+54 9 11 6635-5333', N'Colombia', N'2026-08-10 18:34:08', N'activo'),
(7, N'Facundo Lopez', N'facundo.lopez7@mail.com', N'+54 9 11 7201-2291', N'Brasil', N'2025-11-28 00:43:48', N'activo'),
(8, N'Nicolas Flores', N'nicolas.flores8@mail.com', N'+54 9 11 4150-2139', N'Argentina', N'2024-11-15 10:08:22', N'activo'),
(9, N'Joaquin Rodriguez', N'joaquin.rodriguez9@mail.com', N'+54 9 11 4814-2654', N'Paraguay', N'2025-12-13 18:21:00', N'activo'),
(10, N'Santiago Martinez', N'santiago.martinez10@mail.com', N'+54 9 11 7065-6820', N'Chile', N'2024-11-06 11:33:44', N'activo'),
(11, N'Valentina Martinez', N'valentina.martinez11@mail.com', N'+54 9 11 9751-5010', N'Chile', N'2025-06-07 15:39:26', N'activo'),
(12, N'Isabella Garcia', N'isabella.garcia12@mail.com', N'+54 9 11 6313-1916', N'Chile', N'2026-08-22 13:19:38', N'activo'),
(13, N'Renata Sanchez', N'renata.sanchez13@mail.com', N'+54 9 11 2084-4456', N'Brasil', N'2025-11-05 09:35:00', N'activo'),
(14, N'Agustin Acosta', N'agustin.acosta14@mail.com', N'+54 9 11 8517-3340', N'Uruguay', N'2026-05-04 10:49:16', N'activo'),
(15, N'Facundo Sanchez', N'facundo.sanchez15@mail.com', N'+54 9 11 8019-7543', N'Uruguay', N'2026-02-11 06:52:42', N'activo');
INSERT INTO usuarios (usuario_id, nombre, email, telefono, pais, fecha_registro, estado) VALUES
(61, N'Catalina Molina', N'catalina.molina16@mail.com', N'+54 9 11 2489-1771', N'Colombia', N'2026-06-03 07:24:24', N'activo'),
(62, N'Benjamin Benitez', N'benjamin.benitez17@mail.com', N'+54 9 11 2040-7304', N'Paraguay', N'2025-01-21 18:52:59', N'activo'),
(63, N'Catalina Sanchez', N'catalina.sanchez18@mail.com', N'+54 9 11 1188-2876', N'Mexico', N'2025-03-23 11:33:24', N'activo'),
(19, N'Emma Lopez', N'emma.lopez19@mail.com', N'+54 9 11 5808-8123', N'Chile', N'2025-06-16 01:57:36', N'activo'),
(20, N'Isabella Martinez', N'isabella.martinez20@mail.com', N'+54 9 11 9317-2743', N'Colombia', N'2024-12-22 12:42:28', N'activo'),
(21, N'Catalina Perez', N'catalina.perez21@mail.com', N'+54 9 11 3504-7126', N'Colombia', N'2026-04-11 21:28:48', N'activo'),
(22, N'Catalina Gomez', N'catalina.gomez22@mail.com', N'+54 9 11 6310-9005', N'Argentina', N'2026-06-01 15:03:27', N'activo'),
(23, N'Joaquin Garcia', N'joaquin.garcia23@mail.com', N'+54 9 11 1949-4946', N'Brasil', N'2026-07-05 04:57:37', N'activo'),
(24, N'Agustin Rodriguez', N'agustin.rodriguez24@mail.com', N'+54 9 11 9727-3060', N'Chile', N'2024-11-17 19:08:47', N'activo'),
(25, N'Facundo Martinez', N'facundo.martinez25@mail.com', N'+54 9 11 5342-9645', N'Colombia', N'2025-01-10 17:14:52', N'activo'),
(26, N'Martina Perez', N'martina.perez26@mail.com', N'+54 9 11 6107-7537', N'Mexico', N'2024-11-27 15:26:15', N'activo'),
(27, N'Julieta Suarez', N'julieta.suarez27@mail.com', N'+54 9 11 2982-5061', N'Chile', N'2026-07-20 14:09:04', N'activo'),
(28, N'Sofia Garcia', N'sofia.garcia28@mail.com', N'+54 9 11 4608-1117', N'Argentina', N'2024-12-16 03:59:07', N'activo'),
(29, N'Thiago Rodriguez', N'thiago.rodriguez29@mail.com', N'+54 9 11 1514-6413', N'Argentina', N'2025-04-15 10:30:26', N'activo'),
(30, N'Isabella Molina', N'isabella.molina30@mail.com', N'+54 9 11 4510-9834', N'Chile', N'2025-02-16 22:49:16', N'activo'),
(31, N'Agustin Garcia', N'agustin.garcia31@mail.com', N'+54 9 11 8749-7669', N'Chile', N'2026-06-19 05:22:15', N'activo'),
(32, N'Bautista Flores', N'bautista.flores32@mail.com', N'+54 9 11 7939-7735', N'Paraguay', N'2026-07-31 01:38:00', N'activo'),
(33, N'Lucas Fernandez', N'lucas.fernandez33@mail.com', N'+54 9 11 7596-6559', N'Colombia', N'2026-06-04 10:53:42', N'activo'),
(34, N'Martina Perez', N'martina.perez34@mail.com', N'+54 9 11 9786-8350', N'Chile', N'2025-07-18 08:31:21', N'activo'),
(35, N'Isabella Suarez', N'isabella.suarez35@mail.com', N'+54 9 11 5092-2235', N'Paraguay', N'2025-03-09 05:24:24', N'activo'),
(36, N'Mateo Gomez', N'mateo.gomez36@mail.com', N'+54 9 11 2528-4872', N'Chile', N'2025-08-03 19:31:24', N'activo'),
(37, N'Agustin Perez', N'agustin.perez37@mail.com', N'+54 9 11 7570-1960', N'Chile', N'2025-08-31 01:55:13', N'activo'),
(38, N'Renata Sanchez', N'renata.sanchez38@mail.com', N'+54 9 11 8454-5673', N'Paraguay', N'2024-10-10 22:04:36', N'activo'),
(39, N'Agustin Diaz', N'agustin.diaz39@mail.com', N'+54 9 11 4111-5861', N'Chile', N'2026-07-26 22:55:45', N'activo'),
(40, N'Facundo Fernandez', N'facundo.fernandez40@mail.com', N'+54 9 11 6138-1936', N'Argentina', N'2025-02-02 19:12:04', N'activo'),
(41, N'Catalina Martinez', N'catalina.martinez41@mail.com', N'+54 9 11 1931-9320', N'Argentina', N'2026-03-17 04:20:12', N'activo'),
(42, N'Nicolas Rodriguez', N'nicolas.rodriguez42@mail.com', N'+54 9 11 4853-7615', N'Argentina', N'2025-02-17 10:48:22', N'activo'),
(43, N'Victoria Fernandez', N'victoria.fernandez43@mail.com', N'+54 9 11 2343-7868', N'Mexico', N'2025-02-03 22:25:16', N'activo'),
(44, N'Catalina Torres', N'catalina.torres44@mail.com', N'+54 9 11 5272-4346', N'Mexico', N'2025-11-06 10:31:56', N'activo'),
(45, N'Isabella Acosta', N'isabella.acosta45@mail.com', N'+54 9 11 3144-5915', N'Paraguay', N'2025-11-04 04:28:59', N'activo'),
(46, N'Sofia Suarez', N'sofia.suarez46@mail.com', N'+54 9 11 2638-2200', N'Brasil', N'2026-02-17 20:15:38', N'activo'),
(47, N'Isabella Diaz', N'isabella.diaz47@mail.com', N'+54 9 11 6718-2127', N'Chile', N'2025-09-10 12:13:04', N'activo'),
(48, N'Benjamin Suarez', N'benjamin.suarez48@mail.com', N'+54 9 11 9900-5956', N'Brasil', N'2024-11-23 21:06:00', N'activo'),
(49, N'Sofia Romero', N'sofia.romero49@mail.com', N'+54 9 11 2697-3200', N'Uruguay', N'2026-05-28 05:44:20', N'activo'),
(50, N'Facundo Diaz', N'facundo.diaz50@mail.com', N'+54 9 11 5462-5616', N'Brasil', N'2026-02-20 14:19:33', N'activo'),
(51, N'Martina Sanchez', N'martina.sanchez51@mail.com', N'+54 9 11 9280-9004', N'Uruguay', N'2026-08-02 05:12:08', N'activo'),
(52, N'Bautista Sanchez', N'bautista.sanchez52@mail.com', N'+54 9 11 1722-1058', N'Uruguay', N'2026-05-14 01:02:18', N'activo'),
(53, N'Isabella Martinez', N'isabella.martinez53@mail.com', N'+54 9 11 8239-8007', N'Brasil', N'2026-09-14 05:54:54', N'activo'),
(54, N'Valentina Diaz', N'valentina.diaz54@mail.com', N'+54 9 11 9938-1590', N'Colombia', N'2025-09-10 23:03:01', N'activo'),
(55, N'Facundo Diaz', N'facundo.diaz55@mail.com', N'+54 9 11 8041-3088', N'Argentina', N'2025-11-12 15:07:06', N'activo'),
(56, N'Mateo Flores', N'mateo.flores56@mail.com', N'+54 9 11 4441-5088', N'Mexico', N'2026-06-10 14:43:08', N'activo'),
(57, N'Facundo Benitez', N'facundo.benitez57@mail.com', N'+54 9 11 3532-4878', N'Colombia', N'2026-04-10 08:17:17', N'activo'),
(58, N'Bautista Gomez', N'bautista.gomez58@mail.com', N'+54 9 11 3938-6442', N'Colombia', N'2025-07-29 10:52:38', N'activo'),
(59, N'Isabella Martinez', N'isabella.martinez59@mail.com', N'+54 9 11 2771-7267', N'Colombia', N'2026-08-15 18:58:45', N'activo'),
(60, N'Thiago Perez', N'thiago.perez60@mail.com', N'+54 9 11 8541-6728', N'Uruguay', N'2026-02-02 09:57:30', N'activo');

-- Cuentas
INSERT INTO cuentas (cuenta_id, usuario_id, tipo_cuenta, saldo, fecha_apertura) VALUES
(101, 1, 'Corriente', 50000.0000, '2025-01-11 09:00:00'),
(102, 2, 'Ahorro', 12500.5000, '2025-02-16 11:00:00');
INSERT INTO cuentas (cuenta_id, usuario_id, tipo_cuenta, saldo, fecha_apertura) VALUES
(103,3,'Ahorro',27000.5000,'2026-02-02 10:00:00');

INSERT INTO cuentas (cuenta_id, usuario_id, tipo_cuenta, saldo, fecha_apertura) VALUES
(1, 13, N'wallet', 55247.49, N'2025-07-24 23:05:38'),
(2, 14, N'wallet', 436113.51, N'2024-12-18 02:48:43'),
(3, 3, N'corriente', 483551.81, N'2025-02-08 22:52:22'),
(4, 3, N'ahorro', 360839.36, N'2025-02-03 19:20:04'),
(5, 4, N'wallet', 314698.11, N'2024-12-28 15:41:03'),
(6, 5, N'wallet', 121477.18, N'2025-02-14 05:50:35'),
(7, 6, N'ahorro', 220798.76, N'2025-07-22 07:21:19'),
(8, 7, N'wallet', 102343.9, N'2025-04-29 00:06:18'),
(9, 7, N'corriente', 436472.45, N'2026-07-22 06:52:09'),
(10, 8, N'wallet', 162862.24, N'2024-11-14 19:15:32'),
(11, 9, N'corriente', 478364.4, N'2025-06-10 21:15:09'),
(12, 15, N'corriente', 273363.47, N'2024-11-01 01:15:50'),
(13, 10, N'wallet', 242347.96, N'2026-01-14 12:00:00'),
(14, 11, N'ahorro', 470772.03, N'2025-11-23 12:21:51'),
(15, 12, N'wallet', 352641.64, N'2025-11-03 19:18:39');

INSERT INTO cuentas (cuenta_id, usuario_id, tipo_cuenta, saldo, fecha_apertura) VALUES
(16, 62, N'wallet', 466883.34, N'2025-12-17 12:19:12'),
(17, 61, N'wallet', 338472.81, N'2025-08-31 16:12:23'),
(18, 63, N'ahorro', 145581.1, N'2025-12-03 04:43:09'),
(19, 16, N'corriente', 328158.04, N'2025-05-21 09:37:58'),
(20, 17, N'wallet', 135930.79, N'2025-02-25 11:43:52'),
(21, 18, N'ahorro', 308030.68, N'2025-01-31 10:33:14'),
(22, 19, N'ahorro', 335082.07, N'2025-03-29 10:03:30'),
(23, 20, N'ahorro', 50548.88, N'2025-10-20 19:02:29'),
(24, 21, N'wallet', 385497.65, N'2026-09-18 21:52:46'),
(25, 22, N'corriente', 326619.95, N'2025-05-24 19:13:31'),
(26, 23, N'corriente', 160923.27, N'2024-12-01 03:59:45'),
(27, 24, N'wallet', 287279.61, N'2025-03-25 03:11:59'),
(28, 25, N'corriente', 441181.36, N'2026-03-27 03:09:54'),
(29, 26, N'corriente', 93562.66, N'2025-12-01 03:12:21'),
(30, 26, N'ahorro', 149546.91, N'2025-01-14 05:44:55'),
(31, 27, N'corriente', 227447.36, N'2024-12-06 21:37:22'),
(32, 28, N'ahorro', 425604.34, N'2025-06-01 11:46:32'),
(33, 28, N'ahorro', 404502.53, N'2025-10-20 07:45:29'),
(34, 29, N'wallet', 129003.81, N'2026-03-17 02:21:17'),
(35, 29, N'wallet', 168887.53, N'2025-11-25 22:30:51'),
(36, 30, N'ahorro', 305671.77, N'2024-12-08 16:36:19'),
(37, 31, N'wallet', 164299.37, N'2025-08-09 05:18:53'),
(38, 31, N'ahorro', 490851.75, N'2025-05-23 13:37:26'),
(39, 32, N'ahorro', 130762.25, N'2026-01-25 18:06:25'),
(40, 33, N'corriente', 151321.95, N'2025-02-14 02:15:29'),
(41, 34, N'wallet', 180096.27, N'2026-01-25 04:06:13'),
(42, 35, N'corriente', 153749.77, N'2025-08-04 20:08:17'),
(43, 36, N'wallet', 59149.17, N'2025-11-25 15:13:25'),
(44, 37, N'ahorro', 478701.59, N'2025-05-22 07:25:09'),
(45, 38, N'wallet', 494424.56, N'2025-09-06 16:58:56'),
(46, 38, N'wallet', 274842.64, N'2025-05-29 21:24:44'),
(47, 39, N'ahorro', 340330.79, N'2025-01-21 04:49:21'),
(48, 40, N'wallet', 352031.18, N'2026-07-06 22:22:57'),
(49, 40, N'ahorro', 31348.14, N'2025-03-12 20:14:46'),
(50, 41, N'wallet', 268561.75, N'2026-04-08 13:47:18'),
(51, 42, N'ahorro', 340307.47, N'2025-02-03 19:38:22'),
(52, 42, N'ahorro', 449495.23, N'2025-06-24 03:52:03'),
(53, 43, N'ahorro', 256867.3, N'2025-06-13 22:22:23'),
(54, 43, N'ahorro', 279619.2, N'2024-11-04 13:03:43'),
(55, 44, N'corriente', 127601.38, N'2026-09-20 09:46:31'),
(56, 45, N'ahorro', 212136.84, N'2026-07-20 21:32:42'),
(57, 46, N'ahorro', 493075.56, N'2025-05-28 02:59:50'),
(58, 47, N'corriente', 90400.67, N'2026-05-09 01:11:56'),
(59, 48, N'corriente', 496431.87, N'2025-08-28 18:10:21'),
(60, 48, N'corriente', 188134.94, N'2024-10-24 21:28:38');

-- Tarjetas
INSERT INTO tarjetas (tarjeta_id, usuario_id, numero_enmascarado, tipo, fecha_emision, estado) VALUES
(201, 1, '****-****-****-1234', 'Débito', '2025-01-12 00:00:00', 'activa'),
(202, 2, '****-****-****-5678', 'Crédito', '2025-02-17 00:00:00', 'activa');

INSERT INTO tarjetas (tarjeta_id, usuario_id, numero_enmascarado, tipo, fecha_emision, estado) VALUES
(1, 10, N'4532-****-****-5670', N'debito', N'2025-08-24 03:38:58', N'activa'),
(2, 11, N'5412-****-****-4511', N'debito', N'2024-11-30 10:02:16', N'activa'),
(3, 2, N'5412-****-****-5408', N'credito', N'2025-04-16 02:34:19', N'activa'),
(4, 2, N'4532-****-****-8767', N'debito', N'2024-11-30 08:08:52', N'activa'),
(5, 3, N'4532-****-****-4666', N'credito', N'2025-01-09 12:57:48', N'activa'),
(6, 3, N'4916-****-****-7943', N'credito', N'2025-10-01 18:33:12', N'activa'),
(7, 4, N'5412-****-****-8646', N'credito', N'2024-10-30 20:47:52', N'activa'),
(8, 5, N'2223-****-****-2676', N'debito', N'2025-04-18 15:28:02', N'activa'),
(9, 5, N'4916-****-****-5890', N'debito', N'2025-05-18 04:09:58', N'activa'),
(10, 6, N'4916-****-****-6327', N'credito', N'2025-12-31 01:43:49', N'activa'),
(11, 7, N'4916-****-****-4086', N'debito', N'2025-04-12 10:35:27', N'activa'),
(12, 7, N'4532-****-****-7620', N'credito', N'2024-10-26 06:56:11', N'activa'),
(13, 8, N'4532-****-****-9148', N'credito', N'2026-01-01 17:04:53', N'activa'),
(14, 8, N'2223-****-****-7361', N'debito', N'2025-02-03 22:40:09', N'activa'),
(15, 9, N'4916-****-****-4643', N'credito', N'2024-11-05 14:53:39', N'activa');
INSERT INTO tarjetas (tarjeta_id, usuario_id, numero_enmascarado, tipo, fecha_emision, estado) VALUES
(61, 9, N'4916-****-****-4643', N'credito', N'2024-11-05 14:53:39', N'activa'),
(16, 10, N'4916-****-****-3785', N'debito', N'2025-11-27 05:23:44', N'activa'),
(17, 10, N'2223-****-****-3096', N'credito', N'2025-02-28 08:30:26', N'activa'),
(18, 11, N'4916-****-****-2463', N'debito', N'2025-09-25 09:58:23', N'activa'),
(19, 11, N'4916-****-****-7889', N'credito', N'2025-09-08 11:19:43', N'activa'),
(20, 12, N'4916-****-****-8598', N'debito', N'2025-05-30 03:47:46', N'activa'),
(21, 12, N'4532-****-****-8736', N'debito', N'2025-04-29 06:12:15', N'activa'),
(22, 13, N'2223-****-****-9680', N'credito', N'2025-07-27 03:48:37', N'activa'),
(23, 13, N'5412-****-****-3250', N'debito', N'2025-10-08 16:44:24', N'activa'),
(24, 14, N'2223-****-****-3346', N'credito', N'2026-03-23 04:47:03', N'activa'),
(25, 14, N'2223-****-****-6449', N'debito', N'2025-11-08 00:56:36', N'activa'),
(26, 15, N'4532-****-****-8406', N'credito', N'2026-02-21 07:58:50', N'activa'),
(27, 16, N'5412-****-****-9021', N'debito', N'2026-05-15 00:12:52', N'activa'),
(28, 16, N'2223-****-****-8035', N'credito', N'2025-07-11 19:13:24', N'activa'),
(29, 17, N'4532-****-****-1618', N'debito', N'2025-09-06 02:21:16', N'activa'),
(30, 18, N'5412-****-****-1293', N'debito', N'2024-12-21 10:54:04', N'activa'),
(31, 19, N'4916-****-****-6113', N'debito', N'2026-06-10 15:48:23', N'activa'),
(32, 20, N'4916-****-****-3736', N'debito', N'2026-08-08 12:41:56', N'activa'),
(33, 20, N'4916-****-****-8469', N'credito', N'2025-07-06 06:42:47', N'activa'),
(34, 21, N'2223-****-****-6885', N'debito', N'2026-04-08 16:31:44', N'activa'),
(35, 22, N'5412-****-****-4675', N'debito', N'2026-02-19 02:38:23', N'activa'),
(36, 23, N'5412-****-****-3017', N'credito', N'2024-11-26 03:12:08', N'activa'),
(37, 23, N'2223-****-****-5190', N'debito', N'2025-01-23 03:35:17', N'activa'),
(38, 24, N'4532-****-****-1323', N'debito', N'2026-05-28 17:00:58', N'activa'),
(39, 24, N'2223-****-****-7230', N'debito', N'2025-03-12 11:02:37', N'activa'),
(40, 25, N'5412-****-****-4366', N'debito', N'2025-11-19 17:09:55', N'activa'),
(41, 26, N'4532-****-****-9524', N'credito', N'2024-12-25 23:53:32', N'activa'),
(42, 26, N'5412-****-****-7862', N'debito', N'2025-04-19 00:19:53', N'activa'),
(43, 27, N'4916-****-****-2867', N'debito', N'2025-05-02 09:04:28', N'activa'),
(44, 28, N'5412-****-****-5308', N'debito', N'2025-09-22 16:45:38', N'activa'),
(45, 28, N'4916-****-****-3627', N'debito', N'2025-03-11 19:54:49', N'activa'),
(46, 29, N'2223-****-****-6416', N'debito', N'2026-09-21 02:18:22', N'activa'),
(47, 30, N'4532-****-****-2809', N'credito', N'2026-04-24 05:07:18', N'activa'),
(48, 30, N'4532-****-****-2659', N'credito', N'2024-12-03 10:15:29', N'activa'),
(49, 31, N'4916-****-****-5327', N'credito', N'2026-08-03 05:28:33', N'activa'),
(50, 32, N'4532-****-****-5760', N'credito', N'2024-10-30 13:13:38', N'activa'),
(51, 33, N'4532-****-****-2556', N'debito', N'2026-09-14 06:52:50', N'activa'),
(52, 34, N'5412-****-****-6384', N'credito', N'2025-07-03 00:28:52', N'activa'),
(53, 34, N'4916-****-****-2522', N'credito', N'2025-10-08 08:30:00', N'activa'),
(54, 35, N'2223-****-****-7557', N'credito', N'2025-12-19 15:53:07', N'activa'),
(55, 36, N'2223-****-****-7909', N'debito', N'2026-05-31 06:39:59', N'activa'),
(56, 36, N'4532-****-****-3611', N'debito', N'2025-07-24 23:21:01', N'activa'),
(57, 37, N'2223-****-****-3969', N'credito', N'2025-09-22 00:06:02', N'activa'),
(58, 38, N'5412-****-****-8914', N'credito', N'2026-05-31 16:48:58', N'activa'),
(59, 39, N'4532-****-****-2037', N'credito', N'2024-11-22 13:16:58', N'activa'),
(60, 40, N'5412-****-****-6542', N'debito', N'2025-07-07 10:53:32', N'activa');

-- Dispositivos
INSERT INTO dispositivos (dispositivo_id, usuario_id, tipo_dispositivo, sistema_operativo, ip_registro, fecha_registro) VALUES
(301, 1, 'Smartphone', 'Android', '190.221.45.12', '2025-01-10 10:05:00'),
(302, 2, 'PC', 'Windows', '181.15.20.99', '2025-02-15 14:35:00');
INSERT INTO dispositivos (dispositivo_id, usuario_id, tipo_dispositivo, sistema_operativo, ip_registro, fecha_registro) VALUES
(303,3,'Smartphone','IOS','182.220.43.14','2026-03-02 01:00:00');

INSERT INTO dispositivos (dispositivo_id, usuario_id, tipo_dispositivo, sistema_operativo, ip_registro, fecha_registro) VALUES
(1, 1, N'tablet', N'macOS', N'190.84.143.25', N'2025-06-25 08:15:22'),
(2, 2, N'desktop', N'Android', N'190.154.28.176', N'2025-01-21 15:38:15'),
(3, 3, N'desktop', N'Android', N'190.24.56.210', N'2026-05-04 22:59:13'),
(4, 4, N'movil', N'iOS', N'190.170.39.116', N'2025-03-28 12:27:18'),
(5, 4, N'desktop', N'macOS', N'190.51.53.175', N'2025-11-03 12:45:17'),
(6, 5, N'tablet', N'Windows', N'190.236.242.240', N'2025-07-05 14:22:34'),
(7, 5, N'movil', N'Android', N'190.157.253.131', N'2025-08-06 06:29:09'),
(8, 6, N'movil', N'Windows', N'190.231.141.248', N'2026-07-31 01:52:21'),
(9, 7, N'tablet', N'Windows', N'190.29.221.73', N'2026-08-23 10:24:24'),
(10, 7, N'desktop', N'macOS', N'190.161.82.183', N'2025-08-28 16:37:30'),
(11, 8, N'desktop', N'iOS', N'190.170.45.122', N'2026-05-04 08:41:42'),
(12, 9, N'desktop', N'Windows', N'190.216.107.40', N'2025-12-02 06:24:46'),
(13, 9, N'movil', N'Android', N'190.19.166.5', N'2026-04-29 19:33:43'),
(14, 10, N'desktop', N'iOS', N'190.22.36.165', N'2025-07-25 18:26:43'),
(15, 10, N'tablet', N'macOS', N'190.160.47.117', N'2025-04-20 17:17:01');
INSERT INTO dispositivos (dispositivo_id, usuario_id, tipo_dispositivo, sistema_operativo, ip_registro, fecha_registro) VALUES
(16, 11, N'desktop', N'macOS', N'190.91.58.48', N'2025-07-16 23:51:13'),
(17, 11, N'movil', N'macOS', N'190.217.188.61', N'2025-04-28 11:38:42'),
(18, 12, N'tablet', N'Windows', N'190.9.251.10', N'2025-02-19 19:26:13'),
(19, 13, N'desktop', N'Android', N'190.149.124.247', N'2026-07-04 07:00:54'),
(20, 13, N'tablet', N'Windows', N'190.120.133.21', N'2025-04-07 00:03:14'),
(21, 14, N'movil', N'macOS', N'190.162.190.170', N'2024-11-08 04:41:05'),
(22, 15, N'tablet', N'Windows', N'190.157.14.232', N'2025-10-07 21:19:18'),
(23, 15, N'movil', N'macOS', N'190.117.132.232', N'2025-05-31 22:44:21'),
(24, 16, N'desktop', N'macOS', N'190.91.246.251', N'2025-11-26 12:22:18'),
(25, 16, N'movil', N'Android', N'190.178.237.153', N'2025-11-16 22:21:57'),
(26, 17, N'movil', N'macOS', N'190.149.44.147', N'2026-08-03 01:44:16'),
(27, 18, N'tablet', N'Android', N'190.74.125.22', N'2026-05-17 20:15:00'),
(28, 19, N'desktop', N'Windows', N'190.34.158.72', N'2025-12-16 11:11:50'),
(29, 20, N'tablet', N'Android', N'190.155.45.233', N'2025-01-26 07:20:40'),
(30, 21, N'desktop', N'Windows', N'190.207.45.67', N'2026-01-25 19:29:50'),
(31, 21, N'movil', N'Android', N'190.88.252.22', N'2026-04-28 23:31:30'),
(32, 22, N'desktop', N'macOS', N'190.198.99.61', N'2024-11-16 17:52:06'),
(33, 23, N'tablet', N'iOS', N'190.54.148.188', N'2025-10-05 03:49:11'),
(34, 23, N'tablet', N'Windows', N'190.194.210.30', N'2026-08-01 07:56:38'),
(35, 24, N'desktop', N'macOS', N'190.78.122.192', N'2025-03-27 10:20:57'),
(36, 25, N'tablet', N'macOS', N'190.122.68.38', N'2025-03-29 17:40:12'),
(37, 26, N'desktop', N'macOS', N'190.98.174.81', N'2025-03-30 03:20:07'),
(38, 27, N'tablet', N'Windows', N'190.245.217.111', N'2025-01-07 01:34:58'),
(39, 28, N'desktop', N'Windows', N'190.69.206.26', N'2026-01-06 01:39:57'),
(40, 29, N'desktop', N'macOS', N'190.198.173.192', N'2026-01-19 23:16:36'),
(41, 29, N'movil', N'Windows', N'190.174.177.255', N'2026-03-23 13:14:51'),
(42, 30, N'movil', N'Android', N'190.213.18.4', N'2025-07-29 05:23:56'),
(43, 30, N'tablet', N'Android', N'190.176.115.90', N'2026-02-11 12:09:23'),
(44, 31, N'movil', N'Android', N'190.7.159.24', N'2026-07-27 23:28:25'),
(45, 32, N'movil', N'Android', N'190.182.246.31', N'2026-06-27 23:51:28'),
(46, 32, N'movil', N'macOS', N'190.169.196.231', N'2024-11-29 22:27:06'),
(47, 33, N'movil', N'iOS', N'190.65.76.120', N'2024-11-16 04:35:55'),
(48, 34, N'desktop', N'Windows', N'190.197.110.178', N'2024-11-09 13:37:00'),
(49, 34, N'desktop', N'iOS', N'190.200.19.71', N'2026-07-22 15:46:45'),
(50, 35, N'desktop', N'Android', N'190.67.245.209', N'2025-12-26 08:19:12'),
(51, 36, N'movil', N'macOS', N'190.251.238.52', N'2025-01-07 16:08:14'),
(52, 37, N'tablet', N'macOS', N'190.28.37.139', N'2025-07-09 09:47:35'),
(53, 38, N'tablet', N'Android', N'190.234.114.184', N'2026-01-01 05:36:09'),
(54, 38, N'movil', N'Android', N'190.19.147.187', N'2026-01-10 18:04:33'),
(55, 39, N'desktop', N'iOS', N'190.168.164.1', N'2026-08-16 16:03:32'),
(56, 40, N'movil', N'Windows', N'190.232.101.148', N'2026-09-20 20:36:23'),
(57, 41, N'desktop', N'macOS', N'190.112.104.217', N'2026-07-14 21:30:26'),
(58, 41, N'movil', N'Android', N'190.99.245.177', N'2025-05-18 06:15:17'),
(59, 42, N'tablet', N'Windows', N'190.86.175.78', N'2025-08-09 03:51:05'),
(60, 42, N'tablet', N'Android', N'190.94.137.219', N'2025-10-10 04:46:16');

INSERT INTO lista_negra_ip (ip, motivo, fecha_agregado) VALUES
('203.0.113.42', 'Intentos masivos de fuerza bruta', '2026-01-05 08:00:00'),
('198.51.100.15', 'Reportado por fraude en pasarela', '2026-02-10 12:30:00');
INSERT INTO lista_negra_ip (ip, motivo, fecha_agregado) VALUES
(N'185.251.177.109', N'Proxy/VPN anonimo', N'2026-08-07 00:36:36'),
(N'185.246.20.235', N'Proxy/VPN anonimo', N'2025-12-01 06:23:12'),
(N'185.64.51.43', N'Reportada en fraude previo', N'2026-08-23 03:03:21'),
(N'185.85.80.17', N'Proxy/VPN anonimo', N'2026-04-16 04:12:34'),
(N'185.161.161.25', N'Reportada en fraude previo', N'2026-08-23 17:55:54'),
(N'185.8.123.111', N'Reportada en fraude previo', N'2026-04-23 00:04:41'),
(N'185.207.7.152', N'Uso en bots de carding', N'2026-02-14 04:14:14'),
(N'185.205.161.240', N'Reportada en fraude previo', N'2025-10-12 03:52:23'),
(N'185.86.216.65', N'Uso en bots de carding', N'2026-08-28 12:34:46'),
(N'185.64.28.122', N'Proxy/VPN anonimo', N'2026-03-02 05:19:51'),
(N'185.62.246.88', N'Uso en bots de carding', N'2026-02-25 10:19:45'),
(N'185.214.14.211', N'Uso en bots de carding', N'2025-10-22 00:33:40'),
(N'185.86.134.204', N'Reportada en fraude previo', N'2026-02-03 15:49:12'),
(N'185.61.242.19', N'Proxy/VPN anonimo', N'2026-02-17 00:25:23');
INSERT INTO lista_negra_ip (ip, motivo, fecha_agregado) VALUES
(N'190.221.45.12', N'Reportada en fraude previo', N'2026-03-01 00:25:23');

INSERT INTO transacciones (transaccion_id, cuenta_id, tarjeta_id, dispositivo_id, monto, fecha, tipo_transaccion, comercio, ip_origen, pais_transaccion, estado) VALUES
(1001, 101, 201, 301, 1500.50, '2026-03-01', 'compra', 'Supermercado A', '190.221.45.12', 'Argentina', 'aprobada'),
(1002, 102, 202, 302, 45000.00, '2026-03-02', 'transferencia', 'Banco B', '181.15.20.99', 'Argentina', 'aprobada');
INSERT INTO transacciones (transaccion_id, cuenta_id, tarjeta_id, dispositivo_id, monto, fecha, tipo_transaccion, comercio, ip_origen, pais_transaccion, estado) VALUES
(1, 1, 2, 1, 332.94, N'2026-09-22 23:30:41', N'deposito', NULL, N'190.18.152.203', N'Chile', N'aprobada'),
(2, 1, 1, 1, 1072.62, N'2026-07-25 00:26:47', N'transferencia', NULL, N'190.48.63.36', N'Chile', N'aprobada'),
(3, 1, NULL, 1, 1757.72, N'2026-07-21 01:34:11', N'compra', N'Netflix', N'190.150.227.139', N'Chile', N'aprobada'),
(4, 1, NULL, 1, 1813.96, N'2026-08-17 15:16:14', N'compra', N'Steam', N'190.151.169.174', N'Chile', N'aprobada'),
(5, 1, NULL, 1, 1271.96, N'2026-08-29 09:08:14', N'deposito', NULL, N'190.233.52.202', N'Chile', N'aprobada'),
(6, 1, 2, 1, 1803.29, N'2026-08-12 22:54:04', N'retiro', NULL, N'190.247.86.158', N'Chile', N'aprobada'),
(7, 1, 1, 1, 1368.36, N'2026-09-18 19:53:53', N'compra', N'MercadoLibre', N'190.164.58.178', N'Chile', N'aprobada'),
(8, 1, 1, 1, 1447.43, N'2026-08-12 15:31:42', N'compra', N'Supermercado Dia', N'190.48.212.254', N'Chile', N'aprobada'),
(9, 1, 1, 1, 99.75, N'2026-09-09 07:01:35', N'compra', N'Farmacity', N'190.50.162.150', N'Chile', N'aprobada'),
(10, 1, NULL, 1, 605.38, N'2026-08-18 08:10:56', N'compra', N'Netflix', N'190.185.45.87', N'Chile', N'aprobada'),
(11, 1, NULL, 1, 536.47, N'2026-08-21 05:31:34', N'compra', N'PlayStation Store', N'190.174.36.98', N'Chile', N'aprobada'),
(12, 1, 1, 1, 1374.05, N'2026-08-07 15:23:55', N'deposito', NULL, N'190.44.241.135', N'Chile', N'aprobada'),
(13, 1, 1, 1, 441.85, N'2026-09-07 08:44:47', N'compra', N'Steam', N'190.97.178.96', N'Chile', N'aprobada'),
(14, 2, 3, 2, 2291.62, N'2026-07-10 08:43:36', N'retiro', NULL, N'190.76.203.39', N'Argentina', N'aprobada'),
(15, 2, 4, 2, 2555.99, N'2026-07-11 19:38:43', N'compra', N'YPF', N'190.21.201.121', N'Argentina', N'aprobada');
INSERT INTO transacciones (transaccion_id, cuenta_id, tarjeta_id, dispositivo_id, monto, fecha, tipo_transaccion, comercio, ip_origen, pais_transaccion, estado) VALUES
(17, 2, 4, 2, 1426.54, N'2026-07-11 16:26:23', N'deposito', NULL, N'190.236.203.150', N'Argentina', N'aprobada'),
(18, 2, 3, 2, 2590.87, N'2026-08-04 09:48:02', N'compra', N'Supermercado Dia', N'190.228.97.147', N'Argentina', N'aprobada'),
(19, 2, 4, 2, 1656.15, N'2026-09-06 04:54:04', N'compra', N'Farmacity', N'190.133.91.59', N'Argentina', N'aprobada'),
(20, 2, 4, 2, 1358.94, N'2026-07-30 16:43:53', N'compra', N'Booking.com', N'190.128.82.70', N'Argentina', N'aprobada'),
(21, 2, NULL, 2, 709.03, N'2026-07-03 04:36:17', N'compra', N'Amazon', N'190.76.216.129', N'Argentina', N'aprobada'),
(22, 3, 5, 3, 364.58, N'2026-08-08 03:14:08', N'retiro', NULL, N'190.52.86.51', N'Paraguay', N'aprobada'),
(23, 4, 6, 3, 2119.87, N'2026-09-06 21:36:59', N'compra', N'MercadoLibre', N'190.198.77.73', N'Paraguay', N'aprobada'),
(24, 4, 6, 3, 2467.37, N'2026-07-02 02:16:29', N'transferencia', NULL, N'190.168.132.254', N'Paraguay', N'aprobada'),
(25, 3, 5, 3, 2172.77, N'2026-08-28 19:06:56', N'compra', N'Steam', N'190.151.202.142', N'Paraguay', N'aprobada'),
(26, 4, 6, 3, 2377.83, N'2026-08-14 08:40:52', N'transferencia', NULL, N'190.198.242.179', N'Paraguay', N'aprobada'),
(27, 4, 6, 3, 1130.35, N'2026-07-12 06:30:53', N'transferencia', N'YPF', N'190.3.128.208', N'Paraguay', N'aprobada'),
(28, 4, 6, 3, 2060.43, N'2026-08-03 21:24:55', N'transferencia', N'Spotify', N'190.151.6.146', N'Paraguay', N'aprobada'),
(29, 3, 5, 3, 1708.89, N'2026-07-08 23:58:21', N'transferencia', NULL, N'190.222.101.251', N'Paraguay', N'aprobada'),
(30, 4, 6, 3, 1608.13, N'2026-08-30 19:07:41', N'compra', N'Spotify', N'190.146.247.116', N'Paraguay', N'aprobada'),
(31, 4, NULL, 3, 2027.91, N'2026-09-01 03:00:33', N'deposito', NULL, N'190.155.126.7', N'Paraguay', N'aprobada'),
(32, 3, NULL, 3, 858.61, N'2026-08-25 12:26:26', N'deposito', NULL, N'190.135.18.117', N'Paraguay', N'aprobada'),
(33, 5, 7, 5, 2580.52, N'2026-08-02 16:04:53', N'compra', N'Amazon', N'190.34.138.108', N'Mexico', N'aprobada'),
(34, 5, 7, 4, 398.5, N'2026-08-28 13:07:11', N'transferencia', NULL, N'190.210.182.171', N'Mexico', N'aprobada'),
(35, 5, NULL, 5, 1766.6, N'2026-07-21 18:33:07', N'compra', N'Uber', N'190.2.254.37', N'Mexico', N'aprobada'),
(36, 6, 8, 7, 2731.8, N'2026-07-23 18:35:50', N'transferencia', NULL, N'190.148.11.189', N'Argentina', N'aprobada'),
(37, 6, 9, 7, 2103.95, N'2026-08-16 16:04:51', N'transferencia', NULL, N'190.211.208.218', N'Argentina', N'aprobada'),
(38, 6, 8, 7, 1378.91, N'2026-07-01 08:31:15', N'transferencia', NULL, N'190.146.25.101', N'Argentina', N'aprobada'),
(39, 6, 8, 7, 2648.84, N'2026-07-17 12:28:09', N'transferencia', NULL, N'190.235.18.179', N'Argentina', N'aprobada'),
(40, 6, 9, 6, 2986.0, N'2026-09-14 05:40:22', N'transferencia', NULL, N'190.197.200.84', N'Argentina', N'aprobada'),
(41, 6, 9, 6, 1523.13, N'2026-07-26 02:48:52', N'transferencia', N'PedidosYa', N'190.178.173.192', N'Argentina', N'aprobada'),
(42, 6, 9, 6, 1196.06, N'2026-09-22 10:57:58', N'compra', N'YPF', N'190.235.35.84', N'Argentina', N'aprobada'),
(43, 6, 8, 6, 1649.8, N'2026-08-23 17:46:44', N'compra', N'Farmacity', N'190.211.72.216', N'Argentina', N'aprobada'),
(44, 6, NULL, 6, 1824.9, N'2026-09-01 12:33:05', N'compra', N'Steam', N'190.190.101.44', N'Argentina', N'aprobada'),
(45, 6, 8, 7, 468.95, N'2026-08-09 08:19:13', N'compra', N'YPF', N'190.9.229.173', N'Argentina', N'aprobada'),
(46, 7, 10, 8, 1177.95, N'2026-08-15 18:00:25', N'compra', N'AliExpress', N'190.2.13.198', N'Colombia', N'aprobada'),
(47, 7, 10, 8, 2727.18, N'2026-08-29 05:10:09', N'compra', N'Supermercado Dia', N'190.8.254.4', N'Colombia', N'aprobada'),
(48, 7, 10, 8, 2876.65, N'2026-09-11 07:57:15', N'deposito', NULL, N'190.43.12.107', N'Colombia', N'aprobada'),
(49, 7, 10, 8, 1877.77, N'2026-07-16 16:13:32', N'transferencia', NULL, N'190.31.60.55', N'Colombia', N'aprobada'),
(50, 7, 10, 8, 1212.4, N'2026-08-14 02:16:41', N'transferencia', NULL, N'190.55.118.57', N'Colombia', N'aprobada'),
(51, 7, 10, 8, 141.38, N'2026-08-27 16:48:34', N'compra', N'Booking.com', N'190.154.128.252', N'Colombia', N'aprobada'),
(52, 7, 10, 8, 2877.51, N'2026-07-09 13:39:04', N'deposito', NULL, N'190.179.100.174', N'Colombia', N'aprobada'),
(53, 7, 10, 8, 211.87, N'2026-09-21 23:59:52', N'retiro', NULL, N'190.115.98.131', N'Colombia', N'aprobada'),
(54, 7, 10, 8, 73.43, N'2026-09-08 13:05:12', N'compra', N'YPF', N'190.110.194.63', N'Colombia', N'aprobada'),
(55, 7, NULL, 8, 1501.19, N'2026-08-29 07:21:50', N'transferencia', NULL, N'190.53.165.10', N'Colombia', N'aprobada'),
(56, 7, 10, 8, 411.46, N'2026-08-15 01:16:29', N'compra', N'Steam', N'190.203.251.107', N'Colombia', N'aprobada'),
(57, 9, 11, 10, 1034.76, N'2026-08-28 21:28:39', N'compra', N'PedidosYa', N'190.254.64.206', N'Brasil', N'aprobada'),
(58, 8, 12, 10, 558.8, N'2026-07-05 02:03:43', N'compra', N'PlayStation Store', N'190.126.18.245', N'Brasil', N'aprobada'),
(59, 8, NULL, 9, 2815.44, N'2026-09-07 05:10:58', N'compra', N'AliExpress', N'190.141.213.204', N'Brasil', N'aprobada'),
(60, 8, 11, 10, 2177.72, N'2026-08-15 07:49:07', N'transferencia', NULL, N'190.51.63.109', N'Brasil', N'aprobada'),
(61, 8, 12, 10, 1733.5, N'2026-07-04 09:10:29', N'transferencia', N'PlayStation Store', N'190.201.124.21', N'Brasil', N'aprobada'),
(62, 9, 11, 10, 1329.71, N'2026-07-22 00:01:45', N'transferencia', NULL, N'190.111.195.40', N'Brasil', N'aprobada'),
(63, 9, NULL, 10, 1287.92, N'2026-09-13 12:46:22', N'transferencia', NULL, N'190.138.40.142', N'Brasil', N'aprobada'),
(64, 8, 12, 10, 1366.27, N'2026-08-06 22:18:32', N'transferencia', NULL, N'190.124.19.86', N'Brasil', N'aprobada'),
(65, 8, 11, 9, 2749.23, N'2026-09-23 02:18:33', N'retiro', NULL, N'190.187.186.96', N'Brasil', N'aprobada'),
(66, 9, 12, 10, 2911.77, N'2026-08-07 15:49:27', N'transferencia', NULL, N'190.79.165.253', N'Brasil', N'aprobada'),
(67, 8, 11, 9, 1160.63, N'2026-07-13 07:45:12', N'compra', N'Booking.com', N'190.112.246.66', N'Brasil', N'aprobada'),
(68, 9, 12, 10, 2092.4, N'2026-07-02 15:52:17', N'transferencia', NULL, N'190.189.64.63', N'Brasil', N'aprobada'),
(69, 9, NULL, 10, 1896.55, N'2026-06-29 02:52:14', N'transferencia', NULL, N'190.171.166.38', N'Brasil', N'aprobada'),
(70, 10, 13, 11, 749.77, N'2026-07-11 07:43:09', N'transferencia', N'Amazon', N'190.198.24.165', N'Argentina', N'aprobada'),
(71, 10, 13, 11, 2629.26, N'2026-09-02 17:23:01', N'transferencia', N'YPF', N'190.78.129.248', N'Argentina', N'aprobada');
INSERT INTO transacciones (transaccion_id, cuenta_id, tarjeta_id, dispositivo_id, monto, fecha, tipo_transaccion, comercio, ip_origen, pais_transaccion, estado) VALUES
(73, 9, 12, 10, 2911.77, N'2026-08-07 15:49:27', N'transferencia', NULL, N'190.79.165.253', N'Brasil', N'aprobada'),
(74, 10, 11, 9, 1160.63, N'2026-09-02 17:15:12', N'compra', N'Booking.com', N'190.112.246.66', N'Brasil', N'aprobada'),
(75, 10, 12, 10, 2092.4, N'2026-09-02 16:55:17', N'transferencia', NULL, N'190.189.64.63', N'Brasil', N'aprobada'),
(76, 10, NULL, 10, 1896.55, N'2026-09-02 16:45:14', N'transferencia', NULL, N'190.171.166.38', N'Brasil', N'aprobada'),
(77, 10, 13, 11, 749.77, N'2026-09-02 16:30:09', N'transferencia', N'Amazon', N'190.198.24.165', N'Argentina', N'aprobada'),
(78, 10, 13, 11, 2629.26, N'2026-09-02 17:10:01', N'transferencia', N'YPF', N'190.78.129.248', N'Argentina', N'aprobada');

INSERT INTO alertas_fraude (alerta_id, transaccion_id, regla_activada, score_riesgo, fecha_alerta, estado) VALUES
(5001, 1002, 'Monto inusual para el perfil del usuario', 85, '2026-03-02 10:15:00', 'pendiente');
INSERT INTO alertas_fraude (alerta_id, transaccion_id, regla_activada, score_riesgo, fecha_alerta, estado) VALUES
(5002,1001,'IP_LISTA_NEGRA',93,'2026-03-01 00:30:00','pendiente');
INSERT INTO alertas_fraude (alerta_id, transaccion_id, regla_activada, score_riesgo, fecha_alerta, estado) VALUES
(1, 1, 'IP_LISTA_NEGRA', 93, N'2026-09-08 00:15:19', N'pendiente'),
(2, 2, 'IP_LISTA_NEGRA', 72, N'2026-09-08 03:24:55', N'pendiente'),
(3, 3, 'IP_LISTA_NEGRA', 71, N'2026-09-12 07:20:36', N'pendiente'),
(4, 4, 'IP_LISTA_NEGRA', 74, N'2026-09-04 04:48:36', N'pendiente'),
(5, 5, 'IP_LISTA_NEGRA', 86, N'2026-09-15 14:34:10', N'pendiente'),
(6, 6, 'IP_LISTA_NEGRA', 84, N'2026-09-03 12:35:59', N'pendiente'),
(7, 7, 'IP_LISTA_NEGRA', 88, N'2026-09-10 15:00:59', N'pendiente'),
(8, 8, 'IP_LISTA_NEGRA', 89, N'2026-09-04 02:36:14', N'pendiente'),
(9, 9, 'IP_LISTA_NEGRA', 80, N'2026-09-19 19:03:58', N'pendiente'),
(10, 10, 'IP_LISTA_NEGRA', 70, N'2026-09-18 14:38:02', N'pendiente');
INSERT INTO alertas_fraude (alerta_id, transaccion_id, regla_activada, score_riesgo, fecha_alerta, estado) VALUES
(38, 68, 'IP_LISTA_NEGRA', 70, N'2026-07-02 15:52:17', N'pendiente');

SELECT * FROM cuentas;
SELECT * FROM dispositivos;
SELECT * FROM lista_negra_ip;
SELECT * FROM tarjetas;
SELECT * FROM transacciones;
SELECT * FROM usuarios;
SELECT * FROM alertas_fraude;

ALTER TABLE transacciones
ALTER COLUMN comercio VARCHAR(20) NULL;

ALTER TABLE transacciones
ALTER COLUMN tarjeta_id INT NULL;
