-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-09-23 21:41:16.165

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

--En PostgreSQL, la cláusula CHECK no permite subconsultas que hagan referencia a otras tablas, 
--lo cual es necesario en este caso para realizar la comprobación basada en otra tabla (P5P1E1_CONTIENE).

ALTER TABLE P5P1E1_ARTICULO
    ADD CONSTRAINT ck_palabra_clave_max
    CHECK (NOT EXISTS (
        SELECT 1
        FROM P5P1E1_CONTIENE
        GROUP BY cod_palabra
        HAVING COUNT(DISTINCT id_articulo) <= 5
    ));

--D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
--claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
--artículos que contengan hasta 10 palabras claves.


autor (ARTICULO) nacionalidad ARGENTINA PUEDE PUBLICAR ARTICULO que tengan mas de 10 palabras claves con un tope de 15 palabras como max
otros q no sean argentinos solo pueden publicar ARTICULOS que contengan como maximo 10 palabras claves

Ambito: mas de una tabla 
Tipo RI: Global 

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


--LIKE '%Argentina%' OR NOT LIKE '%Argentina%' <> Es como un != 


/*
CHECK CONSTRAINTS: Se utilizan para imponer restricciones en los valores de una columna individual. 
Por ejemplo, limitar los valores que puede contener una columna (como tu ejemplo de dominio), o verificar una condición específica para cada fila individualmente.

ASSERTIONS: Se utilizan para imponer restricciones a nivel de tupla, lo que significa que afectan a múltiples filas en una o varias tablas.
 Son útiles para imponer restricciones más complejas que no pueden expresarse fácilmente con CHECK CONSTRAINTS, como reglas de negocio que involucran múltiples tablas y relaciones.

DOMAINS: Se utilizan para definir un conjunto de valores permitidos para una columna. 
Son útiles cuando necesitas reutilizar el mismo conjunto de restricciones en varias columnas de diferentes tablas.
*/


/*
Ejercicio 4
Para el esquema de la figura cuyo script de creación de tablas lo podes descargar de aquí



*/


--A. La modalidad de la imagen médica puede tomar los siguientes valores RADIOLOGIA CONVENCIONAL, FLUOROSCOPIA, ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA, MAMOGRAFIA, SONOGRAFIA,


Ambito : Columna (modalidad)
Tipo de RI : de dominio o atributo

ALTER TABLE IMAGEN_MEDICA
ADD CONSTRAINT ck_modalidad_imgMedica
CHECK ((modalidad) IN ('RADIOLOGIA CONVENCIONAL', 'FLUOROSCOPIA', 'ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA', 'MAMOGRAFIA', 'SONOGRAFIA'));


--B. Cada imagen no debe tener más de 5 procesamientos.

Ambito: tupla 
Tipo de RI: tupla

ALTER TABLE PROCESAMIENTO
ADD CONSTRAINT ck_img_max
CHECK (NOT EXISTS (
    SELECT 1 
    FROM PROCESAMIENTO 
    GROUP BY id_paciente, id_imagen
    HAVING COUNT(*) > 5
))


--C. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento

-- UNA indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen
--y controle que la segunda no sea menor que la primera.



ALTER TABLE IMAGEN_MEDICA ADD fecha_imagen DATE;
ALTER TABLE PROCESAMIENTO ADD fecha_procesamiento DATE; 

AMBITO : mas de una tabla
tipo de RI: global

CREATE ASSERTION ck_fecha_restringida
CHECK (NOT EXISTS (
                    SELECT 1 
                    FROM IMAGEN_MEDICA i
                    JOIN PROCESAMIENTO p ON (i.id_imagen = p.id_imagen)
                    WHERE fecha_imagen > fecha_procesamiento
                  ));



--D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.

tabla paciente (modalidad = FLUOROSCOPIA)

Ambito: columna
tipo de Ri : tabla


ALTER TABLE IMAGEN_MEDICA 
ADD CONSTRAINT ck_limit_modalidad
CHECK(NOT EXISTS (
                    SELECT 1 
                    FROM IMAGEN_MEDICA 
                    WHERE modalidad = 'FLUROSCOPIA'
                    GROUP BY id_paciente, extract(year from fecha_img)
                    HAVING COUNT(*) > 2 )
    )
                   
--E. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de FLUOROSCOPIA

--AMBITO : Atributo (Columna), Tupla(Fila), Tabla , Mas de una tabla
--Tipo Ri: Global, de tabla , de tupla , de dominio o atributo

TABLA ALGORITMO (COLUMNA = COSTO COMPUTACION ) A IMAGENES_MEDICA CON LA modalidad FLUOROSCOPIA

AMBITO: Mas de una tabla
Tipo de RI : Global

CHECK ck_costo_computacional_modalidad
CHECK (NOT EXISTS (
                    SELECT 1 
                    FROM IMAGEN_MEDICA i
                    JOIN PROCESAMIENTO p on (i.id_imagen = p.id_imagen)
                    JOIN ALGORITMO a on (p.id_algoritmo = a.id_algoritmo)
                    WHERE modalidad = 'FLUROSCOPIA' AND costo_computacional = 'O(n)'
))

--La combinación de todas las condiciones en una sola cláusula WHERE después de los JOIN es la forma correcta de estructurar la consulta.




--Ejercicio 5 

--A. Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.

Ambito : Atributo(columna)
Tipo de ri: de atributo o dominio

ALTER TABLE VENTA ADD CONSTRAINT ck_porcentaje_venta
CHECK ((descuento) BETWEEN 0 AND 100 );


--B. Los descuentos realizados en fechas de liquidación deben superar el 30%.
--tabla venta tiene los descuento , cuando se hace un descuento en fecha de liquidadcion ese descuento debe superar el 30%

--Ambito: mas de una tabla
--Tipo de RI: global

CREATE ASSERTION ck_descuento_fecha_liq
       CHECK(NOT EXIST (SELECT 1
                        FROM P5P2E5_VENTA
                        WHERE EXTRACT(DAY FROM P5P2E5_fecha_liq) 
                        IN (
                            SELECT dia_liq
                            FROM P5P2E5_fecha_liq 
                        ) AND EXTRACT(MONTH FROM P5P2E5_fecha_liq) IN (
                            SELECT mes_liq
                            FROM P5P2E5_fecha_liq
                        ) AND
                        descuento <= 30.0
       ))

--C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
--tabla fecha_liq columnas mes y dia 

--Ambito: de tupla
--Tipo RI : tupla

ALTER TABLE fecha_liq ADD CONSTRAINT ck_liq_mes_dia
CHECK(NOT EXISTS (SELECT 1 
                  FROM fecha_liq
                  WHERE EXTRACT(MONTH FROM fecha_liq) = 7 AND EXTRACT(DAY FROM fecha_liq) < 5 
                  OR 
                  EXTRACT(MONTH FROM fecha_liq) = 12 AND EXTRACT(DAY FROM fecha_liq) < 5)
      );


           
 --D. Las prendas de categoría ‘oferta’ no tienen descuentos.
 --TABLA prenda COLUMNA categoria no tienen descuento (TABLA venta)   
 -- si categoria = oferta entonces no tiene descuento

 CREATE ASSERTION ck_oferta_sin_desc
 CHECK (NOT EXISTS (SELECT 1
                    FROM PRENDA p
                    JOIN VENTA on (p.id_prenda = v.id_prenda) 
                    WHERE p.categoria = 'oferta' AND v.descuento <> 0.0;
                    ));