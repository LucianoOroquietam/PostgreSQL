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


