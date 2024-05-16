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
FROM peliculas 
WHERE codigo_pelicula p IN (
                            SELECT codigo_pelicula r
                            FROM RENGLON_ENTREGA
                            WHERE p.codigo_pelicula = r.codigo_pelicula AND = ANY (
                                    SELECT fecha_entrega
                                    FROM ESQ_PEL_ENTREGA e
                                    WHERE r.nro_entrega = e.nro_entrega AND EXTRACT(YEAR FROM fecha_entrega) = 2006

                                )
                            )
AND idioma LIKE'%ingl%';


/*1.2. Indicar la cantidad de películas que han sido entregadas en 2006 por un distribuidor
nacional.(P)

Tabla PELICULAS: 
cantidad pelicuas 

ESQ_PEL_ENTREGA: 
esta tabla nos va a brindar el año (2006) y la fk de id_distribuidor 
*/

 /*
 CON EXISTS NO DEBO USAR WHERE p.codigo_pelicula solo necesito una subconsulta que devuelva algún resultado que se pueda evaluar como verdadero o falso. 
 El uso de la clave primaria (p.codigo_pelicula) sin una comparación o condición en la subconsulta no proporciona ninguna información útil para la evaluación.
 */

SELECT COUNT(*)
FROM peliculas p WHERE EXISTS
(SELECT 1
FROM RENGLON_ENTREGA r
WHERE p.codigo_pelicula = r.codigo_pelicula AND EXISTS (SELECT 1
                                                        FROM ESQ_PEL_ENTREGA e 
                                                        WHERE r.nro_entrega = e.nro_entrega
                                                        AND EXTRACT(YEAR FROM fecha_entrega) = 2006
                                                        AND id_distribuidor = "N"))


/*1.3. Indicar los departamentos que no posean empleados cuya diferencia de sueldo
máximo y mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo.
(P) (Probar con 10% para que retorne valores)

TABLA DEPARTAMENTOS 


*/ 

SELECT id_departamento, nombre_departamento
FROM departamento d
WHERE d.id_departamento IN (
    SELECT e.id_departamento
    FROM EMPLEADO e
    WHERE e.id_tarea IN (
        SELECT t.id_tarea
        FROM TAREA t 
        WHERE e.id_tarea = t.id_tarea
        AND MAX(sueldo_maximo)-MIN(sueldo_minimo) <= 0.1 * MAX(sueldo_maximo)
    )
)

/*1.4. Liste las películas que nunca han sido entregadas por un distribuidor nacional.(P)

Uso NOT EXISTS para verificar si no existe ninguna entrega asociada a la película en la tabla ESQ_PEL_ENTREGA con el ID del distribuidor nacional ('N')
 
*/

SELECT *
FROM PELICULAS p 
WHERE NOT EXISTS (
    SELECT 1
    FROM RENGLON_ENTREGA r
    WHERE p.codigo_pelicula = r.codigo_pelicula AND EXISTS (
        SELECT 1 
        FROM ESQ_PEL_ENTREGA e
        WHERE r.nro_entrega = e.nro_entrega
        AND id_distribuidor = 'N'
    )
);


/*1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos (los del
jefe) se encuentren en la Argentina.

parto de la tabla EMPLEADO

jefes que tienen empleados a cargos seria 

jefe (empleados) IN (los del jefe) AND EXISTS (se encuentren en argentina)

*/


SELECT id_jefe, id_empleado
FROM EMPLEADO e
WHERE e.id_departamento IN(
    SELECT d.id_departamento
    FROM DEPARTAMENTO d
    WHERE e.id_departamento = d.id_departamento AND EXISTS (
        SELECT 1
        FROM CIUDAD c
        WHERE d.id_ciudad = c.id_ciudad AND nombre_ciudad = "AR"
    )
)AND e.id_jefe IS NOT NULL;


/*mas resumidad*/
SELECT id_jefe, id_empleado
FROM EMPLEADO e
WHERE e.id_departamento IN(
    SELECT d.id_departamento
    FROM DEPARTAMENTO d
    WHERE EXISTS (
        SELECT 1
        FROM CIUDAD c
        WHERE d.id_ciudad = c.id_ciudad AND nombre_ciudad = "AR"
    )
)AND e.id_jefe IS NOT NULL;


/*1.6. Liste el apellido y nombre de los empleados que pertenecen a aquellos
departamentos de Argentina y donde el jefe de departamento posee una comisión de más
del 10% de la que posee su empleado a cargo.*/

