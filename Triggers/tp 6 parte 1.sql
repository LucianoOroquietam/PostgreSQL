
--Ejercicio 1
/*Implemente de manera procedural las restricciones que no pudo realizar de manera declarativa en
el ejercicio 3 del Práctico 5 Parte 2;

 C- Cada palabra clave puede aparecer como máximo en 5 artículos.

  habria que agrupar por cod_palabra y idioma entonces sabriamos que x cantidad de palabras son la misma porque tienen
  el mismo codigo y mismo idioma .
  */

--Evento/tabla: Contiene
--INSERT: SI- Si inserto y la palabra clave ya aparecia en 5 y con el insert pasa a 6 articulos no me debria dejar
--UPDATE: SI- si updateo y pasa algo parecido al insert por ejemplo tambien deberia controlarlo
--DELETE: NO- no pasa nada si elimino, es mas tal vez elimino una y puedo agregar otra


CREATE OR REPLACE FUNCTION fn_cantidadMaxPclave_por_articulo()
RETURNS TRIGGER AS $$
DECLARE
    cantidad_articulos INTEGER;
BEGIN
    SELECT COUNT(id_articulo) INTO cantidad_articulos
    FROM p5p1e1_contiene
    WHERE cod_palabra = NEW.cod_palabra AND idioma = NEW.idioma;

    IF TG_OP = 'INSERT' AND cantidad_articulos >= 5 THEN
        RAISE EXCEPTION 'La palabra clave "%" ya está asociada con 5 artículos en el idioma "%"', NEW.cod_palabra, NEW.idioma;
    ELSIF TG_OP = 'UPDATE' AND cantidad_articulos > 5 THEN
        RAISE EXCEPTION 'La actualización resultaría en más de 5 artículos asociados con la misma palabra clave en el idioma "%"', NEW.idioma;
    END IF;

    -- Permitir la inserción o actualización si la condición no se cumple
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER antes_insertar_o_actualizar_palabra_clave
BEFORE INSERT OR UPDATE OF cod_palabra,idioma
ON p5p1e1_contiene
FOR EACH ROW EXECUTE FUNCTION fn_cantidadMaxPclave_por_articulo();


-- Ejemplo de relaciones de palabras clave que deberían funcionar si hay menos de 5 artículos ya asociados
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES
(2, 'ES', 1), --1
(3, 'ES', 1), --2
(4, 'ES', 1), -- 3
(5, 'ES', 1), --4
(6, 'ES', 1); --5

-- Intento de inserción que debería lanzar una excepción porque ya hay 5 artículos con la misma palabra clave
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES(7, 'ES', 1);


/*
D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
artículos que contengan hasta 10 palabras claves.

TABLA
ARTICULO = nacionalidad = argentina .
cod_palabra = palabras claves.

tenes un articulo que tiene x cantidad de veces esa palbra clave
entonces la idea seria que:
si ese articulo tiene nacionalidad argentina el tope es de 15
sino el tope es de 10


--Evento/tabla: Articulo (porque en articulo tengo la nacionalidad del que va a insertar un articulo)
--INSERT: SI- Si
--UPDATE: SI- Si por si actualizo nacionalidad por ejemplo. (preguntar o revisar)
--DELETE: NO-

*/

CREATE OR REPLACE FUNCTION fn_cantmaximapclavespornacionalidad()
RETURNS TRIGGER AS $$
    DECLARE
        declare nacionalidad p5p1e1_articulo.NACIONALIDAD%type;
        cant_pclaves INTEGER;

    BEGIN
        SELECT  a.nacionalidad, COUNT(c.cod_palabra)
        INTO nacionalidad, cant_pclaves
        FROM p5p1e1_articulo a
        JOIN p5p1e1_contiene c ON a.id_articulo = c.id_articulo
        WHERE a.id_articulo = NEW.id_articulo
        GROUP BY a.nacionalidad;

        IF((LOWER(nacionalidad) = 'ARGENTINA' AND cant_pclaves <= 15) OR (LOWER(nacionalidad) != 'ARGENTINA' AND cant_pclaves <= 10))
        THEN
             RAISE EXCEPTION 'El artículo con ID % tiene % palabras claves, lo cual excede el límite permitido de %',
                        NEW.id_articulo,
                        cant_pclaves,
                        CASE
                            when LOWER(nacionalidad) = 'ARGENTINA' THEN 15 ELSE 10
                        END;
        end if;
    RETURN NEW;
    end;
$$
language plpgsql;



CREATE TRIGGER antesDeInsertar_Actualizar_Articulo_Por_Nacionalidad_pClave
BEFORE INSERT OR UPDATE OF id_articulo, nacionalidad
ON p5p1e1_articulo
FOR EACH ROW
EXECUTE FUNCTION fn_cantmaximapclavespornacionalidad();


/*
SELECT a.nacionalidad,
       (SELECT COUNT(c.cod_palabra)
        FROM p5p1e1_contiene c
        WHERE c.id_articulo = NEW.id_articulo) INTO cant_pclaves,
        a.nacionalidad INTO nacionalidad
FROM p5p1e1_articulo a
WHERE a.id_articulo = NEW.id_articulo;
*/


/*
Ejercicio 2
Implemente de manera procedural las restricciones que no pudo realizar de manera declarativa en
el ejercicio 4 del Práctico 5 Parte 2; cuyo script de creación del esquema se encuentra aquí.
Ayuda: las restricciones que no se pudieron realizar de manera declarativa fueron las de los items
B, C, D, E;
*/

/*B. Cada imagen no debe tener más de 5 procesamientos.
  la iamgen medica esta asociada a un paciente
  esa imagen medica asociada a un paciente no debe tener mas de 5 procesamientos

--Evento/tabla: procesamiento porque quiero contrar que a x imagen no se le hagan mas de 5 procesamientos.
--INSERT: SI- Si
--UPDATE: SI- Si por si actualizo nacionalidad por ejemplo. (preguntar o revisar)
--DELETE: NO-
  */


CREATE OR REPLACE FUNCTION cantMaxProcsamiento_porImgMedica()
RETURNS TRIGGER AS $$
    DECLARE
        cantProcesamiento INTEGER;
    BEGIN
        SELECT count(*) INTO cantProcesamiento
        FROM p5p2e4_procesamiento
        WHERE id_paciente = NEW.id_paciente AND id_imagen = NEW.id_imagen;
        IF(cantProcesamiento <= 5) THEN
            RAISE EXCEPTION 'La cantidad de procesamientos en la imagen % del paciente % es mayor o igual a 5 procesamientos ',
            NEW.id_imagen,
            NEW.id_paciente;
        END IF;
    RETURN NEW;
    END $$
    LANGUAGE plpgsql;


--ctrl enter
--shifht inicio selecciona toda la linea
CREATE TRIGGER controlAlInsertar_update_cantProcesamientoPaciente
    BEFORE INSERT OR UPDATE OF id_imagen, id_paciente
    ON p5p2e4_procesamiento
    FOR EACH ROW
    EXECUTE FUNCTION cantMaxProcsamiento_porImgMedica();


/*
ejercicio 2-tp5
6.1

Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una
indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle
que la segunda no sea menor que la primera.

controlar que la fecha de procesamiento no sea menor (sea mayor) a la fecha de img medica

--Evento/tabla: Procesamiento
--INSERT: SI- Si- para que no me ingresen una fecha invalida.
--UPDATE: SI- Si por si me actualizan una fecha y queda mayor la de imagen por ejemplo.
--DELETE: NO-
*/


CREATE OR REPLACE FUNCTION fn_verificar_fechas_procesamiento()
RETURNS TRIGGER AS $$
    DECLARE

    BEGIN
        SELECT fecha_img_medica
        FROM p5p2e4_imagen_medica i
        JOIN p5p2e4_procesamiento p ON i.id_paciente = p.id_paciente and i.id_imagen = p.id_imagen
        WHERE fecha_img_medica = NEW.fecha_img_medica AND fecha_img_procesamiento = NEW.fecha_img_procesamiento;

    IF (NEW.fecha_img_procesamiento < NEW.fecha_img_medica) THEN
        RAISE EXCEPTION 'La fecha de procesamiento (%s) no puede ser anterior a la fecha de la imagen médica (%s)', NEW.fecha_img_procesamiento, NEW.fecha_img_medica;
    END IF;
RETURN NEW;
END $$
LANGUAGE plpgsql;

CREATE TRIGGER controlarFechasImgMedica_Procesamiento
    BEFORE INSERT OR UPDATE
    ON p5p2e4_procesamiento
    FOR EACH ROW
EXECUTE FUNCTION fn_verificar_fechas_procesamiento();



/* Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.

--Evento/tabla: imagen_medica
--INSERT: SI-
--UPDATE: SI-
--DELETE: NO-

   controlar el new ,si ya tiene 2 que no pueda insertar

cada paciente (id_paciente tabla paciente) puede realizar dos imagen_medica de la modalidad ("FLUROSCOPIA").
   podria tener una variable que guarde cantidad de modalidades hechas.
   preguntar si tiene mas de 2 en el lapso de un año y si es de la modalidad fluoroscopia que salte el trigger.

   anio_actual := EXTRACT(YEAR FROM CURRENT_DATE);
   AND EXTRACT(YEAR FROM fecha_img_medica) = anio_actual;
   estoy extrayendo el año actual de la fecha actual y luego comparando este año con el año de la fecha_img_medica en las filas de la tabla imagen_medica.
   lo que permite contar solo las fluoroscopias realizadas por el paciente en el año actual.
*/


CREATE OR REPLACE FUNCTION fn_cantidadMaximaFluoroscopia_porPaciente()
RETURNS TRIGGER AS $$
    DECLARE
        cantidad_fluoroscopias INTEGER;
        anio_actual INTEGER;
BEGIN
        -- Obtenemos el año actual
    anio_actual := EXTRACT(YEAR FROM CURRENT_DATE);

    SELECT COUNT(*) INTO cantidad_fluoroscopias
        FROM p5p2e4_imagen_medica
        WHERE id_paciente = new.id_paciente
        AND modalidad = 'FLUOROSCOPIA' AND EXTRACT(YEAR FROM fecha_img_medica) = anio_actual;

        IF (cantidad_fluoroscopias >=2) THEN
            RAISE EXCEPTION 'El paciente ya ha realizado dos fluoroscopias en el año actual';
        end if;


    RETURN NEW;
END $$
LANGUAGE plpgsql;


CREATE TRIGGER verificarCantFluoroscopia_despuesDeInsertar
    BEFORE INSERT
    ON p5p2e4_imagen_medica
    FOR EACH ROW
    EXECUTE FUNCTION fn_cantidadMaximaFluoroscopia_porPaciente();

CREATE TRIGGER verificarCantFluoroscopia_antesDeActualizar
    AFTER UPDATE
    ON p5p2e4_imagen_medica
    FOR EACH ROW
    EXECUTE FUNCTION fn_cantidadMaximaFluoroscopia_porPaciente();

/*
    No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de FLUOROSCOPIA


    tabla procesamiento
    agarro el id_imagen y el id_algoritmo
    y ahi con un join accedo al costo computacional



--Evento/tabla: Procesamiento /ya que ahi aplico a x modalidad x costo computacional
--INSERT: SI-
--UPDATE: SI-
--DELETE: NO-
*/


CREATE OR REPLACE FUNCTION fn_testearCostoComputacionalPermitido()
RETURNS TRIGGER AS $$
    DECLARE
        tipo_modalidad p5p2e4_imagen_medica.modalidad%type;
        costo_algoritmo p5p2e4_algoritmo.costo_computacional%type;
    BEGIN
        SELECT modalidad from p5p2e4_imagen_medica
        WHERE id_paciente = new.id_paciente AND id_imagen = NEW.id_imagen;

        SELECT costo_computacional FROM p5p2e4_algoritmo
        WHERE id_algoritmo = new.id_algoritmo;

        RAISE NOTICE 'la modalidad es % ',tipo_modalidad;
        RAISE NOTICE 'el costo del algoritmo es %  ',costo_algoritmo;

        IF (tipo_modalidad = 'FLUOROSCOPIA' AND costo_algoritmo = 'o(n)') THEN
            RAISE EXCEPTION 'No esta permitido un costo computacional o(n) para la modalidad fluoroscopia ';
        end if;
    RETURN NEW;
    END$$
LANGUAGE plpgsql;


CREATE TRIGGER controlarCostoComputacional_ImgMedica_AlInsertar
    BEFORE INSERT
    ON p5p2e4_procesamiento
    FOR EACH ROW
    EXECUTE FUNCTION fn_testearCostoComputacionalPermitido();

CREATE TRIGGER controlarCostoComputacional_ImgMedica_AlActualizar
    AFTER UPDATE
    ON p5p2e4_procesamiento
    FOR EACH ROW
    EXECUTE FUNCTION fn_testearCostoComputacionalPermitido();

