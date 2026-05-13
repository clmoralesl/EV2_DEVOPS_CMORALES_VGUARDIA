CREATE TABLE IF NOT EXISTS despacho (
    id_despacho BIGINT NOT NULL,
    fecha_despacho DATE,
    patente_camion VARCHAR(255),
    intento INT NOT NULL,
    id_compra BIGINT,
    direccion_compra VARCHAR(255),
    valor_compra BIGINT,
    despachado BIT NOT NULL,
    PRIMARY KEY (id_despacho)
);

INSERT INTO despacho (id_despacho, fecha_despacho, patente_camion, intento, id_compra, direccion_compra, valor_compra, despachado) VALUES 
(1, '2026-05-03', 'ABCD-12', 1, 3, 'P Sherman Calle Wallabi 42, Sydney', 45000, 0),
(2, '2026-05-05', 'XY-9876', 1, 5, 'Ruta 5 Sur KM 400, Chillán', 85000, 1),
(3, '2026-05-06', 'BZ-1122', 2, 10, 'Calle Los Alerces 45, Puerto Montt', 22000, 0),
(4, '2026-05-07', 'TR-4455', 1, 11, 'Av. Alemania 120, Temuco', 31500, 1),
(5, '2026-05-08', 'KJ-8899', 3, 15, 'Calle Los Copihues 67, La Serena', 19990, 0);
