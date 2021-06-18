SELECT * FROM svod;
SELECT * FROM svod2;

UPDATE svod2 SET summa = NULL
WHERE managers= '������';

SELECT * FROM svod2
WHERE summa IS NULL;

-- ��������� �������
SELECT
managers "��������",
product "�������",
INITCAP(komment) "������� 1 ���������",
LOWER(product) "������� ������ �������",
UPPER(komment) "������� ������� �������",
TRIM(BOTH '�' FROM komment) "������� ������� '�'",
summa "�����",
nomer "�����",
RPAD(LPAD(20-LENGTH(managers),4,'_'),6,'_') "�����",
RPAD(LOWER(managers),(20-LENGTH(managers)),'.')||nomer as "�������� � ����� ����� �����",
REPLACE(managers, '�', '�') "�������� ������ '�' �� '�'",
INITCAP(TRANSLATE(LOWER(managers),'����','����'))  "�������� � ������� ����",
INSTR(product,'�',1,1) "��������� '�'",
LENGTH(product) "������� � ��������",
LENGTHB(product) "������� � ������",
LTRIM(managers,'�') "�������� ������ '�' �������"
from svod2;

--  ���������� ���������

SELECT
regexp_substr('"26.07.2001","Num":"7656565956","status":"H","', '"Num":"[[:digit:]]{10}"') as reg_substr
,case
when regexp_instr('"26.07.2001","Num":"7656565956","status":"H"', 'ss|tt|Nu')>0
then 'Yes' else 'No' end as reg_instr
,regexp_replace('GFyYTfytt ytYt ythsjf ttddase','h|s|f','W') as reg_repl
FROM dual;

-- �������� �������

SELECT
  FLOOR(-6.8) as floor
 ,GREATEST(1,4,16,9) as grea1
 ,GREATEST('1','4','16','9') as grea2
 ,LEAST(10,5,3,null) as leas1
 ,LEAST('10','5','3','null') as leas2
 ,MOD(2315,2) as no_chet
 ,REGEXP_COUNT('lw Woe dwdeduw dhwei','w',1,'i') as cnt
 ,TO_NUMBER('432343.34','999999.99') as nn
FROM dual;

-- ������� � �����

SELECT 
  ADD_MONTHS('01.02.2000',5) as new_mon
 ,LAST_DAY('05.02.2000') as new_last
 ,NEXT_DAY('05.02.2000','Tuesday') as new_next
 ,MONTHS_BETWEEN('05.02.2021','20.04.2020') as m_betw
 ,TO_DATE('01012020 11:39:44','ddmmyyyy HH:MI:SS') as new_d
 ,CURRENT_DATE
 ,SYSDATE
FROM dual;

------- ������ ����� ----

WITH d AS (
     SELECT sysdate d2
           ,sysdate - 899 d1
     FROM dual
     )
  SELECT FLOOR(MONTHS_BETWEEN(d2,d1)/12) YY  -- ���������� ���
        ,FLOOR(MOD(MONTHS_BETWEEN(d2,d1),12)) MM -- ���������� �������
        ,d2-ADD_MONTHS(d1,FLOOR(MONTHS_BETWEEN(d2,d1))) DD  -- ���������� ����
     FROM d;
     
------- ��������������� ������� ���������

SELECT
   COALESCE(null,2,null,3,4) as col
  ,NULLIF('ds','ds') as nf
  ,nvl(null,'YES') as nvl
  ,nvl2('null','NOT NULL','IS NULL') as nvl2
  ,round(123.45, 1) as round_n
  ,trunc(123.45, 1) as trunc_n
  ,round(sysdate, 'HH') as round_d
  ,trunc(sysdate, 'HH') as trunc_d
  ,round(sysdate, 'MONTH') as round_dm
  ,trunc(sysdate, 'MONTH') as trunc_dm
FROM dual

-------------------------------
--     ��������������� ������ � Oracle
----------------------------

----���������� �� ���������

CREATE TABLE sales_range 
(salesman_id  NUMBER(5), 
salesman_name VARCHAR2(30), 
sales_amount  NUMBER(10), 
sales_date    DATE)
PARTITION BY RANGE(sales_date) 
(
PARTITION sales_jan2000 VALUES LESS THAN(TO_DATE('01/02/2000','DD/MM/YYYY')),
PARTITION sales_feb2000 VALUES LESS THAN(TO_DATE('01/03/2000','DD/MM/YYYY')),
PARTITION sales_mar2000 VALUES LESS THAN(TO_DATE('01/04/2000','DD/MM/YYYY')),
PARTITION sales_apr2000 VALUES LESS THAN(TO_DATE('01/05/2000','DD/MM/YYYY'))
);

-----  ��������� �� ������

CREATE TABLE sales_list
(salesman_id  NUMBER(5), 
salesman_name VARCHAR2(30),
sales_state   VARCHAR2(20),
sales_amount  NUMBER(10), 
sales_date    DATE)
PARTITION BY LIST (sales_state)
(
PARTITION sales_west  VALUES  ('California', 'Hawaii'),
PARTITION sales_east  VALUES  ('New York', 'Virginia', 'Florida'),
PARTITION sales_central   VALUES  ('Texas', 'Illinois'),
PARTITION sales_other   VALUES  (DEFAULT)
);

-------  ���-���������������

CREATE TABLE sales_hash
(salesman_id  NUMBER(5), 
salesman_name VARCHAR2(30), 
sales_amount  NUMBER(10), 
week_no       NUMBER(2)) 
PARTITION BY HASH(salesman_id) 
PARTITIONS 4 
STORE IN (data1, data2, data3, data4);


-------- ��������� ���������������  ���������-���� 

CREATE TABLE sales_composite 
(salesman_id  NUMBER(5), 
 salesman_name VARCHAR2(30), 
 sales_amount  NUMBER(10), 
 sales_date    DATE)
PARTITION BY RANGE(sales_date) 
SUBPARTITION BY HASH(salesman_id)
SUBPARTITION TEMPLATE(
SUBPARTITION sp1 TABLESPACE data1,
SUBPARTITION sp2 TABLESPACE data2,
SUBPARTITION sp3 TABLESPACE data3,
SUBPARTITION sp4 TABLESPACE data4)
  (PARTITION sales_jan2000 VALUES LESS THAN(TO_DATE('01/02/2000','DD/MM/YYYY'))
   PARTITION sales_feb2000 VALUES LESS THAN(TO_DATE('01/03/2000','DD/MM/YYYY'))
   PARTITION sales_mar2000 VALUES LESS THAN(TO_DATE('01/04/2000','DD/MM/YYYY'))
   PARTITION sales_apr2000 VALUES LESS THAN(TO_DATE('01/05/2000','DD/MM/YYYY'))
   PARTITION sales_may2000 VALUES LESS THAN(TO_DATE('01/06/2000','DD/MM/YYYY')));

-------- ��������� ���������������  Range-List 

CREATE TABLE bimonthly_regional_sales
(deptno NUMBER, 
 item_no VARCHAR2(20),
 txn_date DATE, 
 txn_amount NUMBER, 
 state VARCHAR2(2))
PARTITION BY RANGE (txn_date)
SUBPARTITION BY LIST (state)
SUBPARTITION TEMPLATE(
SUBPARTITION east VALUES('NY', 'VA', 'FL') TABLESPACE ts1,
SUBPARTITION west VALUES('CA', 'OR', 'HI') TABLESPACE ts2,
SUBPARTITION central VALUES('IL', 'TX', 'MO') TABLESPACE ts3)
( PARTITION janfeb_2000 VALUES LESS THAN (TO_DATE('1-MAR-2000','DD-MON-YYYY')), 
  PARTITION marapr_2000 VALUES LESS THAN (TO_DATE('1-MAY-2000','DD-MON-YYYY')), 
  PARTITION mayjun_2000 VALUES LESS THAN (TO_DATE('1-JUL-2000','DD-MON-YYYY')) );


-----������ �������� �������: ��������� �������, ������������ ��� ��������
CREATE TABLE employees
(employee_id NUMBER(4) NOT NULL,
 last_name VARCHAR2(10), 
 department_id NUMBER(2))
PARTITION BY RANGE (department_id)
(PARTITION employees_part1 VALUES LESS THAN (11) TABLESPACE part1, 
 PARTITION employees_part2 VALUES LESS THAN (21) TABLESPACE part2, 
 PARTITION employees_part3 VALUES LESS THAN (31) TABLESPACE part3);

-----������ �������� ���������� �������
CREATE INDEX employees_local_idx ON employees (employee_id) LOCAL;

-----������ �������� ����������� �������
CREATE INDEX employees_global_idx ON employees(employee_id);

-----������ �������� ����������� ����������������� �������
CREATE INDEX employees_global_part_idx ON employees(employee_id)
GLOBAL PARTITION BY RANGE(employee_id)
(PARTITION p1 VALUES LESS THAN(5000),
 PARTITION p2 VALUES LESS THAN(MAXVALUE));


------������ �������� ���������������� ���������������������� �������
CREATE TABLE sales_range (
salesman_id   NUMBER(5), 
salesman_name VARCHAR2(30), 
sales_amount  NUMBER(10), 
sales_date    DATE, 
PRIMARY KEY(sales_date, salesman_id)) 
ORGANIZATION INDEX INCLUDING salesman_id 
OVERFLOW TABLESPACE tabsp_overflow 
PARTITION BY RANGE(sales_date)
(PARTITION sales_jan2000 VALUES LESS THAN(TO_DATE('02/01/2000','DD/MM/YYYY'))
 OVERFLOW TABLESPACE p1_overflow, 
 PARTITION sales_feb2000 VALUES LESS THAN(TO_DATE('03/01/2000','DD/MM/YYYY'))
 OVERFLOW TABLESPACE p2_overflow, 
 PARTITION sales_mar2000 VALUES LESS THAN(TO_DATE('04/01/2000','DD/MM/YYYY'))
 OVERFLOW TABLESPACE p3_overflow, 
 PARTITION sales_apr2000 VALUES LESS THAN(TO_DATE('05/01/2000','DD/MM/YYYY'))
 OVERFLOW TABLESPACE p4_overflow);









----------------------------------
---
---------------------------------

---  �������� ����� ������� �� ������ �� ����� �� �������
 CREATE TABLE employees_tmp
     AS SELECT * FROM hr.employees;

select * from employees_tmp;

--===������� ������� ��� ����������
CREATE TABLE employees_tmp1
     AS SELECT * FROM hr.employees
  WHERE 1=0;

select * from employees_tmp1;

CREATE TABLE employees_tmp2
     AS SELECT * FROM hr.employees
  WHERE 1=0;

select * from employees_tmp2;

CREATE TABLE employees_tmp3
     AS SELECT * FROM hr.employees
  WHERE 1=0;

select * from employees_tmp3;

---  �������� ����� ������� �� ������ � ������������� � ������������

CREATE TABLE EMPLOYEES_TMP 
AS SELECT h.employee_id,
          h.first_name,
          h.last_name,
          LOWER(h.email) as email,
          h.phone_number,
          h.hire_date,
          h.job_id,
          h.salary + 500 as salary,
          h.commission_pct,
          h.manager_id,
          CASE WHEN h.department_id=100 
            THEN 200 ELSE
                h.department_id END as department_id
FROM HR.EMPLOYEES h
where h.department_id = 100;


-------  ��������� � ��� �� ��� ������

INSERT INTO EMPLOYEES_tmp
SELECT h.employee_id,
          h.first_name,
          h.last_name,
          LOWER(h.email) as email,
          h.phone_number,
          h.hire_date,
          h.job_id,
          h.salary + 400 as salary,
          h.commission_pct,
          h.manager_id,
          CASE WHEN h.department_id=80 
            THEN 280 ELSE
                h.department_id END as department_id
FROM HR.EMPLOYEES h
WHERE h.department_id = 80;

                

INSERT ALL
   WHEN department_id < 40 THEN
      INTO employees_tmp1
         VALUES(employee_id, first_name, last_name, LOWER(email), phone_number, hire_date,
              job_id, salary + 100, commission_pct, manager_id, department_id)
   WHEN department_id > 40 and department_id < 100 THEN
      INTO employees_tmp2
         VALUES(employee_id, first_name, last_name, LOWER(email), phone_number, hire_date,
              job_id, salary + 300 , commission_pct, manager_id, department_id)   
   ELSE
      into employees_tmp3
 VALUES(employee_id, first_name, last_name, UPPER(email), phone_number, hire_date,
              job_id, salary + 500, commission_pct, manager_id, department_id) 
SELECT employee_id, first_name, last_name, email, phone_number, hire_date,
              job_id, salary, commission_pct, manager_id, department_id
      FROM hr.employees;
