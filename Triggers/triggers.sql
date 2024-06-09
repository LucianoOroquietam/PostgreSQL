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


SELECT cod_palabra, idioma ,COUNT (id_articulo) AS cantidad_pclaves_por_articulo
FROM p5p1e1_contiene
GROUP BY cod_palabra, idioma
HAVING COUNT(id_articulo) <= 5;


CREATE OR REPLACE FUNCTION fn_cantidadMaxPclave_por_articulo()
RETURNS Trigger AS $$
    BEGIN
        IF(SELECT (id_articulo) FROM p5p1e1_contiene WHERE cod_palabra = NEW.cod_palabra)  >= 5 THEN
            RAISE EXCEPTION 'La palabra clave "%" ya está asociada con 5 artículos', NEW.cod_palabra;
        end if;
        RETURN NEW;
    END
    $$ language plpgsql;

CREATE TRIGGER antes_insertar_o_actualizar_palabra_clave
    BEFORE INSERT OR UPDATE
    ON p5p1e1_contiene
    EXECUTE FUNCTION fn_cantidadMaxPclave_por_articulo();

CREATE OR REPLACE FUNCTION fn_antes_de_insertar_articulo()
RETURNS Trigger AS $$
    BEGIN
        RAISE NOTICE 'Se va a agregar un articulo';
        RETURN NEW;
    END
    $$ language plpgsql;

CREATE TRIGGER antes_de_insertar
    BEFORE INSERT
    ON p5p1e1_articulo
    FOR EACH ROW EXECUTE PROCEDURE fn_antes_de_insertar_articulo();

CREATE OR REPLACE FUNCTION fn_despues_de_insertar_articulo()
RETURNS Trigger AS $$
    BEGIN
        RAISE NOTICE 'El articulo se agrego exitosamente';
        RETURN NULL;
    END;

    $$ language plpgsql;

CREATE TRIGGER despues_de_insertar
    AFTER INSERT
    ON p5p1e1_articulo
    FOR EACH ROW EXECUTE FUNCTION  fn_despues_de_insertar_articulo();





