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
    ON DELETE RESTRICT

;

-- Reference: FK_P5P1E1_CONTIENE_PALABRA (table: P5P1E1_CONTIENE)
-- TABLA CONTIENE , referencia palabra
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
    FOREIGN KEY (idioma, cod_palabra)
    REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
--cada vez que se elimine un registro de la tabla PALABRA , también se eliminen los artículos
--que la referencian en la tabla CONTIENE.
    ON DELETE RESTRICT
;

-- End of file.





--la referenciante es la tabla a la cual se le pide x operacion (borarr, actualizar , etc) y la referencia tiene implementada el borrado o el actualizado de alguna forma
-- y la eliminacion va a deepnder de como lo tengo la referencia 


1-a)
--(table: P5P1E1_CONTIENE)
ALTER TABLE P5P1E1_CONTIENE ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
--cada vez que se elimine un registro de la tabla PALABRA , también se eliminen los artículos
--que la referencian en la tabla CONTIENE.
    ON DELETE CASCADE


1-b)
    /*b) Verifique qué sucede con las palabras contenidas en cada artículo, al eliminar una palabra,
si definen la Acción Referencial para las bajas (ON DELETE) de la RIR correspondiente
como:
ii) Restrict
iii) Es posible para éste ejemplo colocar SET NULL o SET DEFAULT para ON
DELETE y ON UPDATE?*/

la tabla que viene después de REFERENCES es la tabla referenciada, mientras que la tabla que contiene la clave externa es la tabla referenciante.

articulo tabla referenciada y referenciante la tabla PALABRA



Para ON DELETE SET NULL, esto establecería los valores de la clave externa en NULL cuando se elimine el registro relacionado en la tabla referenciada.
 Sin embargo, para que esto funcione, la columna de clave externa debe permitir valores nulos. En este caso, parece que id_articulo en P5P1E1_CONTIENE no permite valores nulos,
  por lo que SET NULL no sería una opción válida aquí.

Para ON DELETE SET DEFAULT, esto establecería los valores de la clave externa en su valor predeterminado cuando se elimine el registro relacionado en la tabla referenciada.
 De manera similar a SET NULL, esto requeriría que la columna de clave externa permita valores predeterminados, lo cual no parece ser el caso en tu esquema actual.

Entonces, en este escenario, ON DELETE RESTRICT es la opción adecuada para mantener la integridad referencial, 
ya que no permite la eliminación de registros en la tabla referenciada si hay registros dependientes en la tabla referenciante.



Sí, si deseas permitir valores predeterminados para las columnas `id_articulo`, `cod_palabra`, e `idioma` en la tabla `P5P1E1_CONTIENE`, 
necesitas definir estos valores predeterminados en la creación de la tabla.

Aquí está cómo podrías hacerlo:

```sql
CREATE TABLE P5P1E1_CONTIENE (
    id_articulo int  DEFAULT valor_por_defecto_id_articulo,
    idioma char(2)  DEFAULT valor_por_defecto_idioma,
    cod_palabra int  DEFAULT valor_por_defecto_cod_palabra,
    CONSTRAINT P5P1E1_CONTIENE_pk PRIMARY KEY (id_articulo,idioma,cod_palabra)
);
```

Donde `valor_por_defecto_id_articulo`, `valor_por_defecto_idioma`, y `valor_por_defecto_cod_palabra` son los valores que deseas establecer como predeterminados para las columnas
 `id_articulo`, `idioma`, y `cod_palabra`, respectivamente.

Con esta definición, si insertas una fila en `P5P1E1_CONTIENE`
 y no proporcionas un valor explícito para alguna de estas columnas, se utilizarán los valores predeterminados que has especificado. Si deseas que alguna de estas columnas no tenga un valor predeterminado, 
 puedes simplemente no incluir la cláusula `DEFAULT` para esa columna en la definición de la tabla.



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
C. Cada palabra clave puede aparecer como máximo en 5 artículos.
--2-b
--i. realiza la modificación si existe el proyecto 64 y el empleado Tipo =E; ,NroE = 5
--cambie valores porque me equivoque al ingresar, pero igualmente no va a proceder ya que hay restrict en las restricciones
-- para que funcione deberiamos cambiar el tipo de restriccion por cascade en cada caso.

update unc_250464.tp5_p1_ej2_auspicio set id_proyecto= 100, nro_empleado = 10
where id_proyecto = 64
and tipo_empleado = 'E'C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.
and nro_empleado = 5;

--realiza la modificación si existe el proyecto 64 sin importar si existe el empleado TipoE ='E' Y NROE= 5
--en la tbla trabaja en procederia pero en auspicio no ya que la restriccion esta definida como restrict
update unc_250464.tp5_p1_ej2_auspicio set id_proyecto= 100, nro_empleado = 10
where id_proyecto = 64;C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.C. Cada palabra clave puede aparecer como máximo en 5 artículos.

--la respuesta correcta seria:
--v. no permite en ningún caso la actualización debido a la modalidad de la restricción entre la tabla empleado y auspicio.


/*
d) Indique cuáles de las siguientes operaciones serán aceptadas/rechazadas, según se considere
para las relaciones AUSPICIO-EMPLEADO y AUSPICIO-PROYECTO match: i) simple, ii)
parcial, o iii) full:
*/
match full: 
a. insert into Auspicio values (1, Dell , B, null); -- RECHAZADA (todos los campos validos o todos null)
b. insert into Auspicio values (2, Oracle, null, null); -- ACEPTADA (son todos los campos referenciantes nulls)
c. insert into Auspicio values (3, Google, A, 3); -- RECHAZADA (todos los campos referenciantes son validos, pero no existe un empleado nro_empleado = 3, Si existiera entonces seria ACEPTADA)C. Cada palabra clave puede aparecer como máximo en 5 artículos.
d. insert into Auspicio values (1, HP, null, 3); --RECHADAZA (un campo valido y el otro null)


mathc partial: 
a. insert into Auspicio values (1, Dell , B, null); -- ACEPTADA (los campos con valores asignados son validos)

--todas las de abajo faltan hacer , solo fue un copie y pegue de la de full
b. insert into Auspicio values (2, Oracle, null, null); -- ACEPTADA (son todos los campos referenciantes nulls)
c. insert into Auspicio values (3, Google, A, 3); -- RECHAZADA (todos los campos referenciantes son validos, pero no existe un empleado nro_empleado = 3, Si existiera entonces seria ACEPTADA)
d. insert into Auspicio values (1, HP, null, 3); --RECHADAZA (un campo valido y el otro null)


match simple:
a. insert into Auspicio values (1, Dell , B, null); -- RECHAZADA (todos los campos validos o todos null)
b. insert into Auspicio values (2, Oracle, null, null); -- ACEPTADA (son todos los campos referenciantes nulls)
c. insert into Auspicio values (3, Google, A, 3); -- RECHAZADA (todos los campos referenciantes son validos, pero no existe un empleado nro_empleado = 3, Si existiera entonces seria ACEPTADA)
d. insert into Auspicio values (1, HP, null, 3); --RECHADAZA (un campo valido y el otro null)
