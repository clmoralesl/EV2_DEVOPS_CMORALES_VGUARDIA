CREATE TABLE IF NOT EXISTS venta (
    id_venta BIGINT NOT NULL,
    direccion_compra VARCHAR(255),
    valor_compra INT NOT NULL,
    fecha_compra DATE NOT NULL,
    despacho_generado BIT NOT NULL,
    PRIMARY KEY (id_venta)
);

INSERT INTO venta (id_venta, direccion_compra, valor_compra, fecha_compra, despacho_generado) VALUES 
(100, 'Avenida Nueva Arquitectura 101, Valdivia', 55000, '2026-06-01', 0),
(101, 'Calle del Docker 202, Punta Arenas', 35000, '2026-06-02', 0),
(102, 'Pasaje El Microservicio 303, Arica', 75000, '2026-06-03', 1);
(4, 'Pasaje El Olvido 999, Concepción', 12990, '2026-05-04', 0),
(5, 'Ruta 5 Sur KM 400, Chillán', 85000, '2026-05-05', 1);
