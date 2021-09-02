set search_path to config;

insert into lookup(name) values('one');
insert into lookup_value(name, lookup_id) 
select 'a', id 
  from lookup where name = 'one';