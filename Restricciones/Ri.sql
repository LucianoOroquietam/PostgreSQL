-- tables
-- Table: P5P1E1_ARTICULO
CREATE TABLE P5P1E1_ARTICULO (
    id_articulo int  NOT NULL,
    titulo varchar(120)  NOT NULL,
    autor varchar(30)  NOT NULL,
    CONSTRAINT P5P1E1_ARTICULO_pk PRIMARY KEY (id_articulo)
);

-- Table: P5P1E1_CONTIENE
CREATE TABLE P5P1E1_CONTIENE (
    id_articulo int  NOT NULL,
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    CONSTRAINT P5P1E1_CONTIENE_pk PRIMARY KEY (id_articulo,idioma,cod_palabra)
);

-- Table: P5P1E1_PALABRA
CREATE TABLE P5P1E1_PALABRA (
    idioma char(2)  NOT NULL,
    cod_palabra int  NOT NULL,
    descripcion varchar(25)  NOT NULL,
    CONSTRAINT P5P1E1_PALABRA_pk PRIMARY KEY (idioma,cod_palabra)
);

-- foreign keys
-- Reference: FK_P5P1E1_CONTIENE_ARTICULO (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_ARTICULO
    FOREIGN KEY (id_articulo)
    REFERENCES P5P1E1_ARTICULO (id_articulo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;


--Ejercicio 3



--Creo la columba nacionalidad ya que no estaba
ALTER TABLE P5P1E1_ARTICULO ADD nacionalidad varchar(100) NOT NULL;

--A. Controlar que las nacionalidades sean Argentina;Español; Inglés; Alemán o Chilena;.

ALTER TABLE P5P1E1_ARTICULO
    ADD CONSTRAINT ck_nacionalidad_restringida
        CHECK ( UPPER(nacionalidad) IN ('ARGENTINA','ESPAÑOL','INGLÉS','ALEMÁN','CHILENA') );

INSERT INTO P5P1E1_ARTICULO VALUES (1,'el lulo', 'lulox', 'argentina');


--ERROR: new row for relation "p5p1e1_articulo" violates check constraint "ck_nacionalidad_restringida"
INSERT INTO P5P1E1_ARTICULO VALUES  (2, 'Prueba 2', 'prueba', 'suecia');

--ERROR: new row for relation "p5p1e1_articulo" violates check constraint "ck_nacionalidad_restringida"
INSERT INTO P5P1E1_ARTICULO VALUES  (2, 'Prueba 3', 'prueba', 'inglés');



ALTER TABLE P5P1E1_ARTICULO ADD fecha_publicacion date NOT NULL;

--BORRO LOS INSERT
DELETE FROM P5P1E1_ARTICULO WHERE id_articulo=2;

--B. Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales al 2010.
ALTER TABLE p5p1e1_articulo ADD
    CONSTRAINT ck_fecha_publicacion_restringida
CHECK ( (EXTRACT (YEAR FROM fecha_publicacion) >= 2010)  );

INSERT INTO P5P1E1_ARTICULO VALUES (2, 'Prueba 3', 'prueba', 'inglés', '2012-12-7');

--ERROR: new row for relation "p5p1e1_articulo" violates check constraint "ck_fecha_publicacion_restringida"
INSERT INTO P5P1E1_ARTICULO VALUES (2, 'Prueba 3', 'prueba', 'inglés', '2007-12-7');


--C. Cada palabra clave puede aparecer como máximo en 5 artículos.
ALTER TABLE P5P1E1_CONTIENE
    ADD CONSTRAINT ck_palabra_clave_max
    CHECK (NOT EXISTS (
        SELECT id_articulo
        FROM P5P1E1_CONTIENE
        GROUP BY id_articulo
        HAVING COUNT(*) > 5
    ));


--D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
--claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
--artículos que contengan hasta 10 palabras claves.


--autor (ARTICULO) nacionalidad ARGENTINA PUEDE PUBLICAR ARTICULO que tengan mas de 10 palabras claves con un tope de 15 palabras como max
--otros q no sean argentinos solo pueden publicar ARTICULOS que contengan como maximo 10 palabras claves

--Ambito: mas de una tabla
--Tipo RI: Global

--Declara el assertion
CREATE ASSERTION CK_ARTICULO_PCLAVE
--condicion
CHECK(NOT EXISTS (
    SELECT 1
    FROM P5P1E1_ARTICULO p
    WHERE (p.nacionalidad = 'Argentina') AND
    id_articulo IN(
        SELECT id_articulo
        FROM P5P1E1_CONTIENE
        GROUP BY id_articulo
        HAVING COUNT(*) > 15)
        OR (p.nacionalidad <> 'Argentina' AND id_articulo IN(
            SELECT id_articulo
            FROM P5P1E1_CONTIENE
            GROUP BY id_articulo
            HAVING COUNT(*) > 10
        ) )

    ));




--- tp 5 parte 2 ejercicio 4
-- Last modification date: 2020-09-28 21:22:26.905

-- tables
-- Table: P5P2E4_ALGORITMO
CREATE TABLE P5P2E4_ALGORITMO (
    id_algoritmo int  NOT NULL,
    nombre_metadata varchar(40)  NOT NULL,
    descripcion varchar(256)  NOT NULL,
    costo_computacional varchar(15)  NOT NULL,
    CONSTRAINT PK_P5P2E4_ALGORITMO PRIMARY KEY (id_algoritmo)
);

-- Table: P5P2E4_IMAGEN_MEDICA
CREATE TABLE P5P2E4_IMAGEN_MEDICA (
    id_paciente int  NOT NULL,
    id_imagen int  NOT NULL,
    modalidad varchar(80)  NOT NULL,
    descripcion varchar(180)  NOT NULL,
    descripcion_breve varchar(80)  NULL,
    CONSTRAINT PK_P5P2E4_IMAGEN_MEDICA PRIMARY KEY (id_paciente,id_imagen)
);

-- Table: P5P2E4_PACIENTE
CREATE TABLE P5P2E4_PACIENTE (
    id_paciente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    domicilio varchar(120)  NOT NULL,
    fecha_nacimiento date  NOT NULL,
    CONSTRAINT PK_P5P2E4_PACIENTE PRIMARY KEY (id_paciente)
);

-- Table: P5P2E4_PROCESAMIENTO
CREATE TABLE P5P2E4_PROCESAMIENTO (
    id_algoritmo int  NOT NULL,
    id_paciente int  NOT NULL,
    id_imagen int  NOT NULL,
    nro_secuencia int  NOT NULL,
    parametro decimal(15,3)  NOT NULL,
    CONSTRAINT PK_P5P2E4_PROCESAMIENTO PRIMARY KEY (id_algoritmo,id_paciente,id_imagen,nro_secuencia)
);

-- foreign keys
-- Reference: FK_P5P2E4_IMAGEN_MEDICA_PACIENTE (table: P5P2E4_IMAGEN_MEDICA)
ALTER TABLE P5P2E4_IMAGEN_MEDICA ADD CONSTRAINT FK_P5P2E4_IMAGEN_MEDICA_PACIENTE
    FOREIGN KEY (id_paciente)
    REFERENCES P5P2E4_PACIENTE (id_paciente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E4_PROCESAMIENTO_ALGORITMO (table: P5P2E4_PROCESAMIENTO)
ALTER TABLE P5P2E4_PROCESAMIENTO ADD CONSTRAINT FK_P5P2E4_PROCESAMIENTO_ALGORITMO
    FOREIGN KEY (id_algoritmo)
    REFERENCES P5P2E4_ALGORITMO (id_algoritmo)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E4_PROCESAMIENTO_IMAGEN_MEDICA (table: P5P2E4_PROCESAMIENTO)
ALTER TABLE P5P2E4_PROCESAMIENTO ADD CONSTRAINT FK_P5P2E4_PROCESAMIENTO_IMAGEN_MEDICA
    FOREIGN KEY (id_paciente, id_imagen)
    REFERENCES P5P2E4_IMAGEN_MEDICA (id_paciente, id_imagen)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

--A. La modalidad de la imagen médica puede tomar los siguientes valores RADIOLOGIA CONVENCIONAL, FLUOROSCOPIA, ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA, MAMOGRAFIA, SONOGRAFIA,


--Ambito : Columna (modalidad)
--Tipo de RI : de dominio o atributo

ALTER TABLE P5P2E4_IMAGEN_MEDICA
ADD CONSTRAINT ck_modalidad_imgMedica
CHECK (modalidad IN ('RADIOLOGIA CONVENCIONAL', 'FLUOROSCOPIA', 'ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA', 'MAMOGRAFIA', 'SONOGRAFIA'));

INSERT INTO  P5P2E4_IMAGEN_MEDICA (ID_PACIENTE, ID_IMAGEN, MODALIDAD, DESCRIPCION, DESCRIPCION_BREVE) VALUES (1, 2, 'FLUOROSCOPIA', 'TIENE COSITAS', 'cosas');
INSERT INTO  P5P2E4_PACIENTE (id_paciente, apellido, nombre, domicilio, fecha_nacimiento) VALUES (1,'DURE','CAMILA','del valle 1200','1999-12-21-');


--TABLA EJERCICIO 5
-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-28 23:11:03.915

-- tables
-- Table: P5P2E5_CLIENTE
CREATE TABLE P5P2E5_CLIENTE (
    id_cliente int  NOT NULL,
    apellido varchar(80)  NOT NULL,
    nombre varchar(80)  NOT NULL,
    estado char(5)  NOT NULL,
    CONSTRAINT PK_P5P2E5_CLIENTE PRIMARY KEY (id_cliente)
);

-- Table: P5P2E5_FECHA_LIQ
CREATE TABLE P5P2E5_FECHA_LIQ (
    dia_liq int  NOT NULL,
    mes_liq int  NOT NULL,
    cant_dias int  NOT NULL,
    CONSTRAINT PK_P5P2E5_FECHA_LIQ PRIMARY KEY (dia_liq,mes_liq)
);

-- Table: P5P2E5_PRENDA
CREATE TABLE P5P2E5_PRENDA (
    id_prenda int  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    descripcion varchar(120)  NOT NULL,
    tipo varchar(40)  NOT NULL,
    categoria varchar(80)  NOT NULL,
    CONSTRAINT PK_P5P2E5_PRENDA PRIMARY KEY (id_prenda)
);

-- Table: P5P2E5_VENTA
CREATE TABLE P5P2E5_VENTA (
    id_venta int  NOT NULL,
    descuento decimal(10,2)  NOT NULL,
    fecha timestamp  NOT NULL,
    id_prenda int  NOT NULL,
    id_cliente int  NOT NULL,
    CONSTRAINT PK_P5P2E5_VENTA PRIMARY KEY (id_venta)
);

-- foreign keys
-- Reference: FK_P5P2E5_VENTA_CLIENTE (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES P5P2E5_CLIENTE (id_cliente)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_P5P2E5_VENTA_PRENDA (table: P5P2E5_VENTA)
ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT FK_P5P2E5_VENTA_PRENDA
    FOREIGN KEY (id_prenda)
    REFERENCES P5P2E5_PRENDA (id_prenda)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.


--A. Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.

--Ambito : Atributo(columna)
--Tipo de ri: de atributo o dominio

ALTER TABLE P5P2E5_VENTA ADD CONSTRAINT ck_porcentaje_venta
CHECK ((descuento) BETWEEN 0 AND 100 );

INSERT INTO P5P2E5_VENTA (id_venta, descuento, fecha, id_prenda, id_cliente) VALUES (1,40.0, '2024-5-14', 1, 1);
INSERT INTO p5p2e5_cliente (id_cliente, apellido, nombre, estado) VALUES (1,'cavani','edinson','crack');
INSERT INTO p5p2e5_prenda(id_prenda, precio, descripcion, tipo, categoria) VALUES (1,9200.80,'la pilcha de bocaaa', 'remera ', 'futbol');

--ERROR: new row for relation "p5p2e5_venta" violates check constraint "ck_porcentaje_venta"
INSERT INTO P5P2E5_VENTA (id_venta, descuento, fecha, id_prenda, id_cliente) VALUES (1,105.0, '2024-5-14', 1, 1);

--B. Los descuentos realizados en fechas de liquidación deben superar el 30%.
--tabla venta tiene los descuento , cuando se hace un descuento en fecha de liquidadcion ese descuento debe superar el 30%

--Ambito: mas de una tabla
--Tipo de RI: global

CREATE ASSERTION ck_descuento_fecha_liq
       CHECK(NOT EXIST (SELECT 1
                        FROM P5P2E5_VENTA
                        WHERE EXTRACT(DAY FROM P5P2E5_fecha_liq) AND (MONTH FROM P5P2E5_fecha_liq)
                        IN (
                            SELECT dia_liq, mes_liq
                            FROM P5P2E5_fecha_liq
                        ) AND
                        descuento <= 30.0
       ))
