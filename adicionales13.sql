use geografia_dam;

/*3. Se sabe que esta base de datos es muy estática. Los únicos cambios que se producen son de dos
tipos: cambios en las poblaciones de las localidades, que normalmente se llevan a cabo al final
de cada año a partir de los datos que proporciona el INE (Instituto Nacional de Estadística) y
muy de vez en cuando se producen o bien, inserciones de nuevas localidades que surgen por
escisión de localidades existentes o bien por desaparición de algunas localidades por su anexión
a otras. Pues bien, queremos tener constancia de estos últimos hechos: la creación de nuevas localidades
por escisión de otras y la eliminación de localidades por su anexión a otras.
Para reflejar estos hechos se va a usar una nueva tabla, que se debe crear con la siguiente
instrucción:
create table LocalidadesDinamicas(
id_localidad int unsigned primary key,
nombre varchar(50) not null,
poblacion int unsigned,
n_provincia int unsigned not null,
fecha_creacion date,
fecha_desaparicion date,
foreign key (n_provincia) references Provincias (n_provincia) on delete cascade);

Pues bien, se deben crear dos triggers:
 AñadirLocalidad, que se ejecutará cada vez que se lleve a cabo la inserción de una nueva localidad en la tabla Localidades. Se deben entonces añadir todos los datos de la nueva
localidad en la tabla LocalidadesDinamicas asignando al atributo fecha_creacion la fecha del día de hoy (current_date) y al atributo fecha_desaparicion un valor nulo.
 EliminarLocalidad, que se ejecutará cada vez que se realice el borrado de una localidad de
la tabla Localidades. En este caso, se deberá llevar a cabo lo siguiente:
1) Se comprobará si la localidad que se está eliminando se encuentra ya en la tabla LocalidadesDinamicas. Si es el caso, se asignará a esa localidad en la tabla
LocalidadesDinamicas el valor del día de hoy al atributo fecha_desaparicion.
2) En caso de que la localidad no esté en la tabla LocalidadesDinamicas, se añadirá una fila a dicha tabla incluyendo todos los datos de la localidad que se elimina y asignando
al atributo fecha_creacion valor nulo y al atributo fecha_desaparicion la fecha del día de hoy.*/

create table localidadesDinamicas(
id_localidad int unsigned primary key,
nombre varchar(50) not null,
poblacion int unsigned,
n_provincia int not null,
fecha_creacion date,
fecha_desaparicion date,
constraint fk_n_provincia foreign key (n_provincia) references provincias(n_provincia) on delete cascade);

delimiter //
create trigger anadirLocalidad
after insert on localidades for each row
begin
insert into localidadesDinamicas
values (new.id_localidad, new.nombre, new.poblacion, new.n_provincia, current_date, null);
end;//

delimiter //
create trigger eliminarLocalidad
before delete on localidades for each row
begin

if exists
		(select *
		from localidadesDinamicas
        where id_localidad= old.id_localidad)
	then
		update localidadesDinamicas
		set fecha_desaparicion = current_date
        where id_localidad = old.id_localidad;
else 
	insert into localidadesDinamicas
    values (old.id_localidad, old.nombre, old.poblacion, old.n_provincia, null, current_date);
end if;
end;//
delimiter ;

drop trigger eliminarLocalidad;

insert into localidades values 
('2840', 'Oviedo', '25000', '6'),
('2841', 'Toledo', '35000', '10');

delete from localidades
where nombre = 'Oviedo';

select * 
from localidades 
where nombre = 'Oviedo';