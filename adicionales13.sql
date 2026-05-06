use geografia_dam;

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
values (new.id_localidad, new.nombre, new.poblacion, new.provincia, current_date, null);
end;//

delimiter //
create trigger eliminarLocalidad
after delete on localidades for each row
begin
declare lastLoc int;
select id_localidad
into lastLoc
from localidadesDinamicas;
if lastLoc = old.id_localidad then
	insert into localidadesDinamicas
	set fecha_desaparicion = current_date;
else 
	insert into localidadesDinamicas
    values (old.id_localidad, old.nombre, old.poblacion, old.provincia, null, current_date);
end if;
end;//


