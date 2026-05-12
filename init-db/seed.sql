CREATE TABLE IF NOT EXISTS venta (
    id_venta BIGINT NOT NULL,
    direccion_compra VARCHAR(255),
    valor_compra INT NOT NULL,
    fecha_compra DATE NOT NULL,
    despacho_generado BIT NOT NULL,
    PRIMARY KEY (id_venta)
);

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

INSERT INTO venta (id_venta, direccion_compra, valor_compra, fecha_compra, despacho_generado) VALUES 
(1, 'Calle Falsa 123, Santiago', 15000, '2026-05-10', 0),
(2, 'Avenida Siempreviva 742, Valparaiso', 25000, '2026-05-11', 0),
(3, 'P Sherman Calle Wallabi 42, Sydney', 45000, '2026-05-12', 1);

INSERT INTO despacho (id_despacho, fecha_despacho, patente_camion, intento, id_compra, direccion_compra, valor_compra, despachado) VALUES 
(1, '2026-05-12', 'ABCD-12', 1, 3, 'P Sherman Calle Wallabi 42, Sydney', 45000, 0);
