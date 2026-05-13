CREATE TABLE IF NOT EXISTS venta (
    id_venta BIGINT NOT NULL,
    direccion_compra VARCHAR(255),
    valor_compra INT NOT NULL,
    fecha_compra DATE NOT NULL,
    despacho_generado BIT NOT NULL,
    PRIMARY KEY (id_venta)
);

INSERT INTO venta (id_venta, direccion_compra, valor_compra, fecha_compra, despacho_generado) VALUES 
(1, 'Calle Falsa 123, Santiago', 15000, '2026-05-01', 0),
(2, 'Avenida Siempreviva 742, Valparaiso', 25500, '2026-05-02', 0),
(3, 'P Sherman Calle Wallabi 42, Sydney', 45000, '2026-05-03', 1),
(4, 'Pasaje El Olvido 999, Concepción', 12990, '2026-05-04', 0),
(5, 'Ruta 5 Sur KM 400, Chillán', 85000, '2026-05-05', 1);
