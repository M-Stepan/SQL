select * from stepan.svod;
alter table stepan.svod add status number;
create synonym sv for stepan.svod;
update sv set sv.status= (select m.status from man m where sv.managers=m.managers);

select * from sv;
create sequence seq_sv;
alter table stepan.svod add nomer number;
update sv set sv.nomer = seq_sv.nextval;

alter table stepan.svod add dat date;
update sv set sv.dat =  to_date(sysdate-sv.nomer);
update sv set sv.dat =  to_date('30.05.2021') where nomer>24;
rollback;

-- ���������� ������� �� ����� �����

select status, managers, sum(summa) from sv group by status, managers order by status, managers;

-- ���������� ������� �� ����� ����� + ����������� � ������������ �������

select distinct
status,
managers,
sum(summa) over (partition by managers) sum_sale,
min(summa) over (partition by managers) min_sale,
max(summa) over (partition by managers) max_sale
from sv 
order by status, managers;

-- ��� �������������

select distinct
status,
managers,
sum(summa) over () sum_sale,
min(summa) over () min_sale,
max(summa) over () max_sale,
from sv 
order by status, managers;

-- ����� � ����������� ������ �� ���������

select
managers,
product,
sum(summa) over (partition by managers) sum_sale,
sum(summa) over (partition by managers order by product) sum_sale2
from sv 
order by   status, managers, sum_sale2;

-- ����� � ����������� ������ �� ������� ������ (����: �� ������ �� �������, �� ������� �� �����)

select managers, product, sum(summa) over (partition by managers) sum_sale,
sum(summa) over (partition by managers order by product range between unbounded preceding and current row) sum_sale2,
sum(summa) over (partition by managers order by product range between current row and unbounded following) sum_sale3
from sv 
order by  status, managers, sum_sale2;

-- ���� rows � range

select managers, product, dat, sum(summa) over (partition by managers) sum_sale,
sum(summa) over (partition by managers order by dat range between unbounded preceding and current row) sum_range,
sum(summa) over (partition by managers order by dat rows between unbounded preceding and current row) sum_rows
from sv 
order by  status, managers, dat;

-- ������ � ��������� ��������

select product, dat, summa,
first_value(summa) 
over (order by dat 
rows between 2 preceding and current row) first_rows,
last_value(summa)
over (order by dat 
rows between 2 preceding and current row) last_rows,
first_value(summa) 
over (order by dat 
range between 2 preceding and current row) first_range,
last_value(summa)
over (order by dat 
range between 2 preceding and current row) last_range
from sv 
order by dat;

-- ��������� �� ������� (year/month/day/hour/minute/second) numtoyminterval: year, month; numtodsinterval: day, hour, minute, second

select product, dat, summa,
avg(summa) 
over (order by dat 
range between interval '10' day preceding and current row) avg_day
from sv 
order by dat;

select product, dat, summa,
avg(summa) 
over (order by dat 
range between numtoyminterval (1, 'month') preceding and numtodsinterval (5, 'day') following) avg_day
from sv 
order by dat;

-- ������������ 
 
select product, dat, summa, 
row_number() over (order by dat desc) num_up,
row_number() over (order by dat asc) num_down,
rank() over (order by dat) rank_summa,
dense_rank() over (order by dat) d_rank_summa
from sv;
 

-- ������� �����
 
select distinct product, summa, 
count(summa) over (partition by managers, product) count_sale, 
sum(summa) over (partition by managers) sum_sale, 
ratio_to_report(summa) over (partition by managers) dolya 
from sv where managers = '�������';

-- ���� � ������� ��� ������ ������, ��� � "��������":

select product, summa, 
--count(summa) over (partition by managers, product) count_sale, 
--sum(summa) over (partition by managers) sum_sale, 
cume_dist() over (partition by managers order by summa) cume_dist 
from sv where managers = '�������';

---------------------------------
--  ������������� �������
----------------------------------

--  �������� ������� ��� ������������
--  drop table test_tab
create table test_tab(
id     NUMBER,
pid    NUMBER,
name   VARCHAR2(250 CHAR),
coef   NUMBER
);

Insert all
into test_tab(id,pid,name,coef) values(1,null,'������',100)
into test_tab(id,pid,name,coef) values(2,1,'������',80)
into test_tab(id,pid,name,coef) values(3,2,'��� ��������',50)
into test_tab(id,pid,name,coef) values(4,1,'������-��-����',60)
into test_tab(id,pid,name,coef) values(5,1,'���������',60)
into test_tab(id,pid,name,coef) values(6,4,'"��������"',30)
into test_tab(id,pid,name,coef) values(7,3,'����� ����',30)
into test_tab(id,pid,name,coef) values(8,3,'��������',30)
into test_tab(id,pid,name,coef) values(9,7,'"��������"',10)
into test_tab(id,pid,name,coef) values(10,5,'������� �����',10)
into test_tab(id,pid,name,coef) values(11,9,'���',5)
into test_tab(id,pid,name,coef) values(12,6,'��������� "��������"',10)
select * from dual;
commit;

--  ��������, ��� ������ ����

select * from test_tab;

-- 1 ������������� ������ ��� � �����������

SELECT level, id, pid, name
FROM test_tab
START WITH pid is null
CONNECT BY PRIOR  id= pid
ORDER SIBLINGS BY NAME;

-- 1-1 ������������� ������ � �������� �������
SELECT level, id, pid, name
FROM test_tab
START WITH pid= 6
CONNECT BY  id= PRIOR pid
ORDER SIBLINGS BY NAME;

-- 2 ������������� ������ - � ���������
SELECT --level, id, pid, 
       lpad(' ',5*level)||name as TREE
FROM test_tab
START WITH pid is null
CONNECT BY PRIOR  id = pid
ORDER SIBLINGS BY NAME;

-- 3 ������������� ������ - ����� "/" - ��� ��� ���������
SELECT --level, id, pid, 
       sys_connect_by_path(name,'/')as PATH
FROM test_tab
WHERE id=12 -- ������ ������ 1 ��������
START WITH pid is null
CONNECT BY PRIOR id=pid
ORDER SIBLINGS BY NAME;

-- 4 ������������� ������ - ����� �������, "�������" � �������� ��������
SELECT  id, pid, name, level,
       CONNECT_BY_ISLEAF as ISLEAF,
       PRIOR name as PARENT_NAME,
       CONNECT_BY_ROOT name as ROOT_NAME
FROM test_tab
--WHERE id=9
START WITH pid is null
CONNECT BY PRIOR id=pid
ORDER SIBLINGS BY NAME;

-- 5 ������������� ������ - ����� (�����)

---������� �����
update test_tab set pid=12 where id=4;
commit;

SELECT  id, pid, name, 
        CONNECT_BY_ISCYCLE as CYCL
FROM test_tab
START WITH id=4
CONNECT BY NOCYCLE PRIOR id=pid;

----���������� �����
update test_tab set pid=1 where id=4;
commit;


-- 6 - ��������� �������������������
      select
        trunc(sysdate,'dd')-1 + level as calc_dt,
        11 -  (level*1) as calc_n_down,
        0 +  (level*1) as calc_n_up
     from dual
      connect by
        level <= 10;
      

---  �������� WITH 1

WITH  step (id,pid,name,coef) AS(
      SELECT id, pid, name, coef
      FROM test_tab
      WHERE pid is null
            UNION ALL
      SELECT a.id,
             a.pid,
             b.name||'/'||a.name,
             a.coef + b.coef
       FROM test_tab a             
            INNER JOIN 
            step b ON (b.id = a.pid)
      )
SELECT id, pid, name, coef from step            


--- �������� WITH 2 � ������������

WITH  step (id,pid,name,coef) AS(
      SELECT id, pid, name, coef
      FROM test_tab
      WHERE pid is null
            UNION ALL
      SELECT a.id,
             a.pid,
             b.name||'/'||a.name,
             a.coef + b.coef
       FROM test_tab a             
            INNER JOIN 
            step b ON (b.id = a.pid)
      )
      SEARCH DEPTH FIRST BY NAME ASC SET orderv
SELECT id, pid, name, coef, orderv from step            
ORDER BY orderv

---  �������� WITH � ������������� ������

---- �������  ����
update test_tab set pid=12 where id=4;
commit;


WITH  step (id,pid,name,coef) AS(
      SELECT id, pid, name, coef
      FROM test_tab
      WHERE id=4
            UNION ALL
      SELECT a.id,
             a.pid,
             b.name||'/'||a.name,
             a.coef + b.coef
       FROM test_tab a             
            INNER JOIN 
            step b ON (b.id = a.pid)
      )
      SEARCH DEPTH FIRST BY NAME ASC SET orderv
      CYCLE id SET cyclem TO 'X' DEFAULT '-'
SELECT id, pid, name, coef, orderv, cyclem from step            
ORDER BY orderv 

----   ���������� �����, ������� ����

update test_tab set pid=1 where id=4;
commit;

---������ ��� �����
/*      
ERROR:
ORA-32044: cycle detected while executing recursive WITH query
*/


-------------------------------------
--  �������� ������ PIVOT/UNPIVOT
-------------------------------------

--- �������, ��� ������� ����� ������������������

select * from managers;
alter table managers add zp number(5);
update man set zp = 27300, status = 3 where man_id=1;
update man set zp = 44000 where man_id=2;
update man set zp = 28200, status = 3 where man_id=3;
update man set zp = 62000 where man_id=4;
update man set zp = 43600 where man_id=5;
update man set zp = 85000 where man_id=6;

select dolgnost, status, sum(zp) as zp from man group by dolgnost, status;


----  ������� ������� �������� � ���������� CASE

with ssum as(
select dolgnost, status, sum(zp) as zp from man group by dolgnost, status
)
select dolgnost, 
       sum(case when status = 1 then zp else 0 end) as s_1,
       sum(case when status = 2 then zp else 0 end) as s_2,
       sum(case when status = 3 then zp else 0 end) as s_3,
       sum(case when status = 4 then zp else 0 end) as s_4       
    from man group by dolgnost;   

------   ������� � PIVOT

select * FROM
(select dolgnost, status, sum(zp) as zp from man group by dolgnost, status)
pivot (sum(zp) for status in (1,2,3,4));

----   �������� �������� UNPIVOT- �� ������� PIVOT

with p_table as(
     select * FROM
            (select dolgnost, status, sum(zp) as zp from man group by dolgnost, status)
            pivot (sum(zp) for status in (1,2,3))
)
select * from p_table 
unpivot exclude nulls (zp for status in ("1","2","3")); -- � ������: include
