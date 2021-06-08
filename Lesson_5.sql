
select * from STEPAN.MANAGERS;
select * from stepan.man;
select * from stepan.product;
select * from stepan.price;

create table stepan.prod3
as
select product_id ,product , komment 
from stepan.product where product_id > 3;

ALTER TABLE stepan.prod3 add CONSTRAINT  key_id PRIMARY KEY (product_id);
ALTER TABLE stepan.product add CONSTRAINT key2_id PRIMARY KEY (product_id);

select * from stepan.prod3;

delete from stepan.product t where product_id = 4;


merge into stepan.product pr1
using stepan.prod3 pr2
on (pr1.product_id=pr2.product_id)
when matched then update
  set pr1.product=pr2.product
  ,pr1.komment=pr2.komment
  delete where pr1.product_id=7
when not matched then insert
  (pr1.product_id, pr1.product, pr1.komment)
  values (pr2.product_id, pr2.product, pr2.komment);

rollback;

update stepan.prod3
set product = 'штрих'
, komment ='белый'
where product_id = 6;

select listagg(komment, '|') from stepan.product;


select p.product_id
, upper(p.product)
, p.summa 
from stepan.price p;

select pr.product_id
, upper(pr.product)
, lower(pr.komment)
, p.summa 
from stepan.price p 
right join stepan.product pr
on p.product_id=pr.product_id
order by pr.product;

select
status
,count(*)
from man
where 1=1
group by status;

create table stepan.sales
(
man_id number (6)
, sales_id number (6)
);

insert into stepan.sales values (1,1);
insert into stepan.sales values (2,2);
insert into stepan.sales values (1,3);
insert into stepan.sales values (3,4);
insert into stepan.sales values (3,5);
insert into stepan.sales values (1,6);
insert into stepan.sales values (4,1);
insert into stepan.sales values (4,2);
insert into stepan.sales values (4,3);
insert into stepan.sales values (4,4);
insert into stepan.sales values (1,5);
insert into stepan.sales values (5,6);
insert into stepan.sales values (5,1);
insert into stepan.sales values (5,2);
insert into stepan.sales values (3,3);
insert into stepan.sales values (3,4);
insert into stepan.sales values (1,5);
insert into stepan.sales values (3,6);
insert into stepan.sales values (1,1);
insert into stepan.sales values (3,2);

insert all
into stepan.sales values (4,1)
into stepan.sales values (4,2)
into stepan.sales values (4,3)
into stepan.sales values (4,4)
into stepan.sales values (4,5)
into stepan.sales values (4,6)
select * from dual;

select *
from stepan.sales;

select 
--s.man_id
--,s.sales_id
m.managers
, upper(pr.product)
, lower(pr.komment)
, p.summa
from stepan.sales s 
inner join stepan.product pr
on s.sales_id=pr.product_id
inner join stepan.price p
on s.sales_id=p.product_id
inner join stepan.man m
on s.man_id=m.man_id
order by m.man_id;

create table stepan.svod
as
(select 
m.managers as managers
, upper(pr.product) as product
, lower(pr.komment) as komment
, p.summa as summa
from stepan.sales s 
inner join stepan.product pr
on s.sales_id=pr.product_id
inner join stepan.price p
on s.sales_id=p.product_id
inner join stepan.man m
on s.man_id=m.man_id);


select * from stepan.svod;
drop table stepan.svod;

select 
sv.managers as "Сотрудник"
,count(sv.product) "Колличество продаж"
,sum(sv.summa) "Общая сумма продаж"
from stepan.svod sv
where 1=1
group by sv.managers
order by sum(sv.summa) desc;

truncate table managers;
truncate table price;
truncate table product;
