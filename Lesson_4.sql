create synonym tload for stepan.prod2;


select * from stepan.prod2;
select * from tload;

truncate table stepan.prod2;

create sequence seq0;
create sequence seq1
start with 10
increment by 2
maxvalue 20
minvalue 10
cycle
order
cache 2;

select seq0.nextval, seq1.nextval, t.* from tload t;
select seq0.currval, seq1.currval from dual;

insert all
into stepan.sales values (4,1)
into stepan.sales values (4,2)
into stepan.sales values (4,3)
into stepan.sales values (4,4)
into stepan.sales values (4,5)
into stepan.sales values (4,6)
select * from dual;


create table stepan.svod2
as
select * from stepan.svod;
alter table stepan.svod2 add nomer number;

update stepan.svod2
set nomer = seq0.nextval
where nomer is null;

ALTER SEQUENCE seq0 INCREMENT BY -55;
SELECT seq0.NEXTVAL FROM dual;
ALTER SEQUENCE seq0 INCREMENT BY 1;
SELECT seq0.currval FROM dual;

select * from stepan.svod2;
drop table stepan.svod2;

select sv.* from stepan.svod sv;


select seq0.currval, seq1.nextval,sv.* from stepan.svod sv;

rollback;

