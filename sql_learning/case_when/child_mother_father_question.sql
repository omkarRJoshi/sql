create table person(id int, name varchar(50), gender varchar(1));
create table relation(cid int, pid int);

insert into person values
(101,'Riya','F'),
(566,'Aman','M'),
(202,'Rakesh','M'),
(875,'lucky','M'),
(202, 'Reena','F'),
(322,'Raina','F'),
(345,'Rohit','M'),
(322,'Mohit','M'),
(345,'Meena','F');

insert into relation values 
(101,	202),
(566,	322),
(875,	345);

select cid, p1.name as child_name, pid, p2.name as parent_name, p2.gender as parent_gender
from 
relation as r
inner join person as p1 on r.cid = p1.id
inner join person as p2 on r.pid = p2.id;

select p1.name as child,
max(case when p2.gender = 'F' then p2.name end) as mother,
max(case when p2.gender = 'M' then p2.name end) as father
from 
relation as r
inner join person as p1 on r.cid = p1.id
inner join person as p2 on r.pid = p2.id
group by child;
