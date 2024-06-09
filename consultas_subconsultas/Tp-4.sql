/*TP 4 VOLUNTARIO parte 1*/

/*el path me anda cuando lo ejecuto con la consulta ...*/
SET search_path = unc_esq_voluntario;

/*1. Seleccione el identificador y nombre de todas las instituciones que son Fundaciones.(V)*/

SELECT id_institucion, nombre_institucion
FROM unc_esq_voluntario.institucion
WHERE nombre_institucion ILIKE '%fundacion%';


/*5. Muestre el apellido y el identificador de la tarea de todos los voluntarios que no tienen
coordinador.(V)*/

SELECT apellido,id_coordinador
    FROM unc_esq_voluntario.voluntario
WHERE id_coordinador IS NULL;

/*9. Muestre el apellido, nombre y mail de todos los voluntarios cuyo teléfono comienza con
+51. Coloque el encabezado de las columnas de los títulos;Apellido y Nombre; y ;Dirección
de mail;. (V)*/

SELECT nombre || ' ' || apellido AS "Nombre y Apellido", e_mail AS "Dirección de Mail"
FROM unc_esq_voluntario.voluntario
WHERE telefono LIKE '+51%';


/*11. Recupere la cantidad mínima, máxima y promedio de horas aportadas por los voluntarios
nacidos desde 1990. (V)
  hay uno solo
  ALEXNDARE HUNOLD por eso todas dan 9000 mil
  */

SELECT MIN(horas_aportadas) AS " minimo de horas aportadas",
       MAX(horas_aportadas) AS " max de horas aportadas",
       AVG(horas_aportadas) AS " promedio de horas aportadas"
    FROM unc_esq_voluntario.voluntario
WHERE EXTRACT(YEAR FROM fecha_nacimiento) = 1990;

/*15. ¿Cuántos cumpleaños de voluntarios hay cada mes?*/

select EXTRACT(MONTH FROM fecha_nacimiento) AS "Mes", count(*) AS "cantidad_cumples"
from unc_esq_voluntario.voluntario
group by EXTRACT(MONTH FROM fecha_nacimiento)
order by "Mes";


/*16. ¿Cuáles son las 2 instituciones que más voluntarios tienen?
  la limitamos a 2 ya que los dos primeros nos devuelven los valores que buscamos
  */
SELECT id_institucion, count(nro_voluntario) AS cantidad
from voluntario
group by id_institucion
order by cantidad DESC
limit 2;


/*cual es el promedio de horas aportadas por tarea*/

SELECT id_tarea, avg(horas_aportadas) AS horas_aportadas
    FROM unc_esq_voluntario.voluntario
group by id_tarea
order by horas_aportadas DESC;


/*ME QUIERO QUEDAR CON AQUELLAS TAREAS QUE SUPEREN LOS 6000 DE PROMEDIO*/
SELECT id_tarea, AVG(horas_aportadas) AS promedio_horas_aportadas
    FROM unc_esq_voluntario.voluntario
group by id_tarea
having AVG(horas_aportadas) >6000
order by promedio_horas_aportadas;

/*cuales son las tareas que tienen mas de 10 voluntarios*/
SELECT id_tarea, count(*) AS cantidad_voluntarios_por_tarea
    FROM unc_esq_voluntario.voluntario
GROUP BY id_tarea
HAVING COUNT(*) > 10;


/*cual es el promedio de horas aportadas por tarea solo de aquellos voluntarios nacidos a partir del año 2000
  deberia considerar agrupar por id_tarea y id_voluntario. De esta manera,
  obtendre el promedio de horas aportadas por tarea por cada voluntario nacido a partir del año 2000.
  no cada tarea individual con su promedio general.
  */

SELECT id_tarea,nro_voluntario ,AVG(horas_aportadas) as promedio_por_tareas
    FROM unc_esq_voluntario.voluntario
WHERE EXTRACT(YEAR FROM fecha_nacimiento) >= 2000
GROUP BY id_tarea,nro_voluntario
ORDER BY promedio_por_tareas;

/*sin el where*/
SELECT id_tarea, nro_voluntario, AVG(horas_aportadas) AS promedio_por_tareas
FROM unc_esq_voluntario.voluntario
GROUP BY id_tarea, nro_voluntario
HAVING EXTRACT(YEAR FROM fecha_nacimiento) >= 2000
ORDER BY promedio_por_tareas;

/*tarea individual con respecto a la consulta de arriba*/
SELECT id_tarea ,AVG(horas_aportadas) as promedio_por_tareas
    FROM unc_esq_voluntario.voluntario
WHERE EXTRACT(YEAR FROM fecha_nacimiento) >= 2000
GROUP BY id_tarea
ORDER BY promedio_por_tareas;


/*Cuales son las tareas cuyo promedio de horas aportadas por tarea de los voluntario nacidos a partir del año 1995 es superior
  al promedio general de dicho grupo de voluntarios*/
 SELECT id_tarea, AVG(horas_aportadas)
      FROM voluntario
      where EXTRACT(YEAR FROM fecha_nacimiento ) >= 1995
  GROUP BY id_tarea
 HAVING AVG(horas_aportadas) > (SELECT AVG(horas_aportadas)
      FROM unc_esq_voluntario.voluntario
  where EXTRACT(YEAR FROM fecha_nacimiento ) >= 1995);

/*Cuales son las tareas cuyo promedio de horas aportadas por tarea de los voluntario nacidos a partir del año 1995*/
  SELECT id_tarea, AVG(horas_aportadas)
      FROM voluntario
      where EXTRACT(YEAR FROM fecha_nacimiento ) >= 1995
  GROUP BY id_tarea;

/*promedio general de dicho grupo de voluntario de arriba*/
  SELECT AVG(horas_aportadas)
      FROM unc_esq_voluntario.voluntario
  where EXTRACT(YEAR FROM fecha_nacimiento ) >= 1995;


/*todos los voluntarios con sus instituciones */

SELECT v.*, i.*
    FROM voluntario v
JOIN institucion i ON  v.id_institucion = i.id_institucion;
/*con using*/
SELECT v.*, i.*
    FROM voluntario v
JOIN institucion i USING (id_institucion);

/*Full join me trae los id nulos tambien 123 filas*/
SELECT v.*, i.*
    FROM voluntario v
FULL JOIN institucion i USING (id_institucion);




/*PELICULAS*/
SET search_path = unc_esq_peliculas;


/*2. Seleccione el identificador de distribuidor, identificador de departamento y nombre de todos
los departamentos.(P)*/

SELECT DISTINCT id_distribuidor, id_departamento, nombre
FROM unc_esq_peliculas.departamento
LIMIT 6;


/*3. Muestre el nombre, apellido y el teléfono de todos los empleados cuyo id_tarea sea 7231,
ordenados por apellido y nombre.(P)*/


SELECT nombre, apellido, telefono, id_tarea
    FROM unc_esq_peliculas.empleado
WHERE id_tarea = '7231'
ORDER BY apellido, nombre DESC;

/*4. Muestre el apellido e identificador de todos los empleados que no cobran porcentaje de
comisión.(P)*/

SELECT apellido, id_empleado, porc_comision
    FROM unc_esq_peliculas.empleado
WHERE porc_comision IS NULL
LIMIT 10;

/*6. Muestre los datos de los distribuidores internacionales que no tienen registrado teléfono.
(P)*/

SELECT *
FROM unc_esq_peliculas.distribuidor
WHERE telefono IS NULL;

/*7. Muestre los apellidos, nombres y mails de los empleados con cuentas de gmail y cuyo
sueldo sea superior a $ 1000. (P)*/

SELECT DISTINCT nombre, apellido, e_mail, sueldo
    FROM unc_esq_peliculas.empleado
WHERE e_mail ILIKE '%GMAIL%' AND sueldo > 1000
ORDER BY nombre,apellido,e_mail,sueldo
LIMIT 10;


/*8. Seleccione los diferentes identificadores de tareas que se utilizan en la tabla empleado. (P)*/
SELECT id_tarea
    FROM unc_esq_peliculas.empleado
LIMIT 10;


/*10. Hacer un listado de los cumpleaños de todos los empleados donde se muestre el nombre y
el apellido (concatenados y separados por una coma) y su fecha de cumpleaños (solo el
día y el mes), ordenado de acuerdo al mes y día de cumpleaños en forma ascendente. (P)*/

/*La función TO_CHAR se utiliza para formatear la fecha de cumpleaños en el formato 'DD-MM', mostrará solo el día y el mes.
  La función EXTRACT se utiliza para extraer el mes y el día de la fecha de nacimiento */

SELECT nombre || ' ' ||apellido AS "nombre, apellido" , TO_CHAR(fecha_nacimiento, 'DD-MM') AS cumpleaños
    FROM unc_esq_peliculas.empleado
ORDER BY EXTRACT(MONTH FROM fecha_nacimiento), EXTRACT(DAY FROM fecha_nacimiento)
LIMIT 10
OFFSET 95;

/*12. Listar la cantidad de películas que hay por cada idioma. (P)*/

/*La cláusula GROUP BY en SQL se utiliza para agrupar filas que tienen los mismos valores en una o más columnas
  y aplicar funciones de agregación a cada grupo. */

SELECT idioma, COUNT(*) AS cantidad_de_peliculas
FROM unc_esq_peliculas.pelicula
GROUP BY idioma;


/*13. Calcular la cantidad de empleados por departamento.*/
SELECT id_departamento, COUNT(id_departamento) AS "cantidad_empleados_por_depto"
    FROM unc_esq_peliculas.empleado
GROUP BY id_departamento
LIMIT 10;

/*14. Mostrar los códigos de películas que han recibido entre 3 y 5 entregas. (veces entregadas,
NO cantidad de películas entregadas).*/

SELECT código_pelicula
    FROM unc_esq_peliculas.pelis_mas_entragadas
GROUP BY código_pelicula
HAVING COUNT(*) BETWEEN 3 AND 5;



/*17. ¿Cuáles son los id de ciudades que tienen más de un departamento?*/
SELECT id_ciudad
FROM departamento
GROUP BY id_ciudad
HAVING COUNT(*) > 1;



/*Tp 4 parte 2 Peliculas*/





SELECT *
FROM pelicula P
WHERE (p.idioma LIKE '%Ingl%') IN
                  (SELECT fecha_entrega FROM unc_esq_peliculas.entrega e
                    WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2006);


SELECT *
FROM pelicula P
WHERE P.idioma LIKE '%Ingl%' AND P.codigo_pelicula IN
    (SELECT codigo_pelicula
     FROM unc_esq_peliculas.entrega e
     WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2006);


/*1.1. Listar todas las películas que poseen entregas de películas de idioma inglés durante
el año 2006. (P)*/

/*Tabla peliculas:
tenemos que listar todo de aca .
tenemos el idioma que buscamos (ingles)

en el medio tenemos que pasar por la tabla RENGLON_ENTREGA

ESQ_PEL_ENTREGA:
esta tabla nos va a brindar el año (2006)

podriamos usar EXIST IN NOT IN en cualquier lado.
*/

SELECT *
FROM pelicula p
WHERE p.codigo_pelicula = ANY (
    SELECT r.codigo_pelicula
    FROM renglon_entrega r
    WHERE EXISTS (
        SELECT 1
        FROM entrega e
        WHERE r.nro_entrega = e.nro_entrega
        AND EXTRACT(YEAR FROM e.fecha_entrega) = 2006
    )
)
AND idioma LIKE '%Ingl%';


SELECT p.codigo_pelicula AS "codigo", p.titulo, p.idioma
     FROM pelicula p
     WHERE (idioma = 'Inglés' AND EXISTS (SELECT 1
                                          FROM renglon_entrega r
                                          WHERE p.codigo_pelicula = r.codigo_pelicula AND EXISTS (
                                          SELECT 2 FROM entrega e WHERE r.nro_entrega = e.nro_entrega
                                                                    AND EXTRACT(YEAR FROM fecha_entrega) = 2006))) LIMIT 200;



/*1.3. Indicar los departamentos que no posean empleados cuya diferencia de sueldo
máximo y mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo.
(P) (Probar con 10% para que retorne valores)

TABLA DEPARTAMENTOS


*/

SELECT id_departamento, nombre
FROM departamento d
WHERE d.id_departamento IN (
    SELECT e.id_departamento
    FROM EMPLEADO e
    WHERE e.id_tarea IN (
        SELECT t.id_tarea
        FROM TAREA t
        WHERE e.id_tarea = t.id_tarea
        AND (sueldo_maximo)-(sueldo_minimo) <= 0.1 * (sueldo_maximo)
    )
);


/*1.4. Liste las películas que nunca han sido entregadas por un distribuidor nacional.(P)

Uso NOT EXISTS para verificar si no existe ninguna entrega asociada a la película en la tabla ESQ_PEL_ENTREGA con el ID_distribuidor de la tabla ciudadl ('N')

*/

SELECT *
FROM pelicula p
WHERE NOT EXISTS (
    SELECT 1
    FROM renglon_entrega ep
    WHERE ep.codigo_pelicula = p.codigo_pelicula
    AND EXISTS (
        SELECT 1
        FROM entrega e
        WHERE e.nro_entrega = ep.nro_entrega
        AND EXISTS (
            SELECT 1
            FROM distribuidor d
            WHERE d.id_distribuidor = e.id_distribuidor
            AND d.tipo = 'N'
        )
    )
);



/*
1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos (los del
jefe) se encuentren en la Argentina.

a tener en cuenta
cada jefe es indidividual ( DISINCT  ) y no quiero tener jefes Nulos (IS NOT NULL).
parto de la tabla empleado , para ver que jefe tienen empleados a cargo
en (IN) algun departamento (EXISTS) ubicado en Argentina
*/

/*cucu*/
SELECT d.jefe_departamento
FROM departamento d
WHERE EXISTS (
    SELECT 1
    FROM empleado e
    WHERE e.id_jefe IS NOT NULL
    GROUP BY e.id_jefe

)
AND EXISTS (
    SELECT 2
    FROM ciudad c
    WHERE c.id_ciudad = d.id_ciudad AND c.id_pais = 'AR'
);

/*lulo*/
SELECT d.jefe_departamento
FROM departamento d
WHERE d.jefe_departamento IN (
    SELECT DISTINCT e.id_jefe
    FROM empleado e
    WHERE e.id_jefe IS NOT NULL AND EXISTS (
        SELECT 1
        FROM ciudad c
        WHERE d.id_ciudad = c.id_ciudad AND id_pais = 'AR'
    )
);




/*1.6. Liste el apellido y nombre de los empleados
que pertenecen a aquellos departamentos de Argentina y donde el jefe de departamento posee una comisión de más del 10% de la que posee su empleado a cargo.


  */



SELECT nombre,apellido,porc_comision
    FROM empleado e
WHERE e.id_departamento IN (
    SELECT d.id_departamento
        FROM departamento d
        WHERE e.id_departamento = d.id_departamento AND EXISTS(
            SELECT 1
            FROM empleado jefe
            WHERE jefe.id_empleado = d.jefe_departamento
            AND jefe.porc_comision > e.porc_comision * 1.1
        )AND EXISTS (
            SELECT 1
            FROM ciudad c
            WHERE d.id_ciudad = c.id_ciudad AND c.id_pais = 'AR'
       )
      );


/*1.7. Indicar la cantidad de películas entregadas a partir del 2010, por género.
  pelicuas y genera tabla pelicuas
  renglo entrega
  ENTREGA año 2010
  */


  SELECT p.genero , COUNT(p.genero)
  FROM pelicula p
  WHERE p.codigo_pelicula IN(
      SELECT r.codigo_pelicula
          FROM renglon_entrega r
          WHERE p.codigo_pelicula = r.codigo_pelicula AND EXISTS(
              SELECT 1
              FROM entrega e
              WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2010
          )
      )
  GROUP BY (p.genero);


/*1.8. Realizar un resumen de entregas por día, indicando el video club al cual se le
realizó la entrega y la cantidad entregada. Ordenar el resultado por fecha.*/

 SELECT DISTINCT e.fecha_entrega, v.propietario , SUM(re.cantidad) AS cantidad_entregada
FROM entrega e
JOIN renglon_entrega re ON e.nro_entrega = re.nro_entrega
JOIN video v ON re.nro_entrega = v.id_video
GROUP BY e.fecha_entrega, v.propietario
ORDER BY e.fecha_entrega;


  /*
  1.9. Listar, para cada ciudad, el nombre de la ciudad y la cantidad de empleados
mayores de edad que desempeñan tareas en departamentos de la misma y que posean al
menos 30 empleados.

  ciudad nombre y cant empleaados
  */




/*DATAGRIP RESPALDO*/


-- tables
-- Table: TP5_P1_EJ2_AUSPICIO
CREATE TABLE TP5_P1_EJ2_AUSPICIO (
    id_proyecto int  NOT NULL,
    nombre_auspiciante varchar(20)  NOT NULL,
    tipo_empleado char(2)  NULL,
    nro_empleado int  NULL,
    CONSTRAINT TP5_P1_EJ2_AUSPICIO_pk PRIMARY KEY (id_proyecto,nombre_auspiciante)
);

-- Table: TP5_P1_EJ2_EMPLEADO
CREATE TABLE TP5_P1_EJ2_EMPLEADO (
    tipo_empleado char(2)  NOT NULL,
    nro_empleado int  NOT NULL,
    nombre varchar(40)  NOT NULL,
    apellido varchar(40)  NOT NULL,
    cargo varchar(15)  NOT NULL,
    CONSTRAINT TP5_P1_EJ2_EMPLEADO_pk PRIMARY KEY (tipo_empleado,nro_empleado)
);

-- Table: TP5_P1_EJ2_PROYECTO
CREATE TABLE TP5_P1_EJ2_PROYECTO (
    id_proyecto int  NOT NULL,
    nombre_proyecto varchar(40)  NOT NULL,
    anio_inicio int  NOT NULL,
    anio_fin int  NULL,
    CONSTRAINT TP5_P1_EJ2_PROYECTO_pk PRIMARY KEY (id_proyecto)
);

-- Table: TP5_P1_EJ2_TRABAJA_EN
CREATE TABLE TP5_P1_EJ2_TRABAJA_EN (
    tipo_empleado char(2)  NOT NULL,
    nro_empleado int  NOT NULL,
    id_proyecto int  NOT NULL,
    cant_horas int  NOT NULL,
    tarea varchar(20)  NOT NULL,
    CONSTRAINT TP5_P1_EJ2_TRABAJA_EN_pk PRIMARY KEY (tipo_empleado,nro_empleado,id_proyecto)
);

-- foreign keys
-- Reference: FK_TP5_P1_EJ2_AUSPICIO_EMPLEADO (table: TP5_P1_EJ2_AUSPICIO)
ALTER TABLE TP5_P1_EJ2_AUSPICIO ADD CONSTRAINT FK_TP5_P1_EJ2_AUSPICIO_EMPLEADO
    FOREIGN KEY (tipo_empleado, nro_empleado)
    REFERENCES TP5_P1_EJ2_EMPLEADO (tipo_empleado, nro_empleado)
	MATCH FULL
    ON DELETE  SET NULL
    ON UPDATE  RESTRICT
;

-- Reference: FK_TP5_P1_EJ2_AUSPICIO_PROYECTO (table: TP5_P1_EJ2_AUSPICIO)
ALTER TABLE TP5_P1_EJ2_AUSPICIO ADD CONSTRAINT FK_TP5_P1_EJ2_AUSPICIO_PROYECTO
    FOREIGN KEY (id_proyecto)
    REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
    ON DELETE  RESTRICT
    ON UPDATE  RESTRICT
;

-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_EMPLEADO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_EMPLEADO
    FOREIGN KEY (tipo_empleado, nro_empleado)
    REFERENCES TP5_P1_EJ2_EMPLEADO (tipo_empleado, nro_empleado)
    ON DELETE  CASCADE
    ON UPDATE  RESTRICT
;

-- Reference: FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO (table: TP5_P1_EJ2_TRABAJA_EN)
ALTER TABLE TP5_P1_EJ2_TRABAJA_EN ADD CONSTRAINT FK_TP5_P1_EJ2_TRABAJA_EN_PROYECTO
    FOREIGN KEY (id_proyecto)
    REFERENCES TP5_P1_EJ2_PROYECTO (id_proyecto)
    ON DELETE  RESTRICT
    ON UPDATE  CASCADE
;

-- End of file.
-- EMPLEADO
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 1, 'Juan', 'Garcia', 'Jefe');
INSERT INTO tp5_p1_ej2_empleado VALUES ('B', 1, 'Luis', 'Lopez', 'Adm');
INSERT INTO tp5_p1_ej2_empleado VALUES ('A ', 2, 'María', 'Casio', 'CIO');
INSERT INTO tp5_p1_ej2_empleado VALUES ('E ', 5, 'Luciano', 'Oroquieta', 'Developer');

-- PROYECTO
INSERT INTO tp5_p1_ej2_proyecto VALUES (1, 'Proy 1', 2019, NULL);
INSERT INTO tp5_p1_ej2_proyecto VALUES (2, 'Proy 2', 2018, 2019);
INSERT INTO tp5_p1_ej2_proyecto VALUES (3, 'Proy 3', 2020, NULL);
INSERT INTO tp5_p1_ej2_proyecto VALUES (22, 'Proy 22', 2024, NULL);

-- TRABAJA_EN
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 1, 1, 35, 'T1');
INSERT INTO tp5_p1_ej2_trabaja_en VALUES ('A ', 2, 2, 25, 'T3');

-- AUSPICIO
INSERT INTO tp5_p1_ej2_auspicio VALUES (2, 'McDonald', 'A ', 2);
INSERT INTO tp5_p1_ej2_auspicio VALUES (64, 'Google', 'E', 5);


--b.1) delete from tp5_p1_ej2_proyecto where id_proyecto = 3;
--esta consulta va a proceder por mas que sus restricciones de borrado sean restrict ya que el id_proyecto 3 no se encuentra en la tabla
--trabaja_en y en la tabla proyecto.
delete from tp5_p1_ej2_proyecto where id_proyecto = 3;


--b.2) update tp5_p1_ej2_proyecto set id_proyecto = 7 where id_proyecto = 3;
-- si puedo actualizar el id_proyecto 3 por el 7 , ya que de nuevo no tengo referencias asigandas a id_proyecto
update tp5_p1_ej2_proyecto set id_proyecto = 22 where id_proyecto = 64;


--b.3) delete from tp5_p1_ej2_proyecto where id_proyecto = 1;
-- esta consulta no va a proceder ya que el id_proyecto = 1 esta asignado a un proyecto particular y las tablas que
-- se encargan de establecer la integridad la definien como restrict, deberian definirlas como cascade para proceder.
delete from tp5_p1_ej2_proyecto where id_proyecto = 1;


--b.4) delete from tp5_p1_ej2_empleado where tipo_empleado = ‘A’ and nro_empleado = 2;
-- se va a borrar a maria ya que
--auspicio se va a setear como null  set null y en la tabla trabaja_en se va a eliminar ya que tiene cascade
delete from tp5_p1_ej2_empleado where tipo_empleado = 'A' and nro_empleado = 2;

--borro el id 2 porque me quedo con null y aparece como repetido , ya que la referencia la tiene pero es null y quiero que no sea null
--luego ejecuto el insert into para dejarlo como estaba
delete from tp5_p1_ej2_auspicio where id_proyecto = 2;


--b.5) update tp5_p1_ej2_trabaja_en set id_proyecto = 3 where id_proyecto =1;
--no procede porque en la tabla auspicio el update es restrict , en la tabla trabaja_en si porque es cascade ,
-- pero como al final tiene un restrict ya no procede.
update tp5_p1_ej2_trabaja_en set id_proyecto = 3 where id_proyecto =1;


--b.6) update tp5_p1_ej2_proyecto set id_proyecto = 5 where id_proyecto = 2;
-- lo mismo que en la 5 .
update tp5_p1_ej2_proyecto set id_proyecto = 5 where id_proyecto = 2;

--2-b
--i. realiza la modificación si existe el proyecto 64 y el empleado Tipo =E; ,NroE = 5
--cambie valores porque me equivoque al ingresar, pero igualmente no va a proceder ya que hay restrict en las restricciones
-- para que funcione deberiamos cambiar el tipo de restriccion por cascade en cada caso.

update unc_250464.tp5_p1_ej2_auspicio set id_proyecto= 100, nro_empleado = 10
where id_proyecto = 64
and tipo_empleado = 'E'
and nro_empleado = 5;

--realiza la modificación si existe el proyecto 64 sin importar si existe el empleado TipoE ='E' Y NROE= 5
--en la tbla trabaja en procederia pero en auspicio no ya que la restriccion esta definida como restrict
update unc_250464.tp5_p1_ej2_auspicio set id_proyecto= 100, nro_empleado = 10
where id_proyecto = 64;

--la respuesta correcta seria:
--v. no permite en ningún caso la actualización debido a la modalidad de la restricción entre la tabla empleado y auspicio.


