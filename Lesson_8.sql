SELECT * FROM svod;
SELECT * FROM svod2;

UPDATE svod2 SET summa = NULL
WHERE managers= 'Иванов';

SELECT * FROM svod2
WHERE summa IS NULL;

-- строковые функции
SELECT
managers "Менеджер",
product "Продукт",
INITCAP(komment) "Коммент 1 заглавная",
LOWER(product) "Продукт нижний регистр",
UPPER(komment) "Коммент верхний регистр",
TRIM(BOTH 'я' FROM komment) "Коммент обрезка 'я'",
summa "Сумма",
nomer "Номер",
RPAD(LPAD(20-LENGTH(managers),4,'_'),6,'_') "Точки",
RPAD(LOWER(managers),(20-LENGTH(managers)),'.')||nomer as "Менеджер и номер через точки",
REPLACE(managers, 'в', 'В') "Менеджер замена 'в' на 'В'",
INITCAP(TRANSLATE(LOWER(managers),'аоеи','оаие'))  "Менеджер с заменой букв",
INSTR(product,'Е',1,1) "Вхождение 'Е'",
LENGTH(product) "Продукт в символах",
LENGTHB(product) "Продукт в байтах",
LTRIM(managers,'В') "Менеджер убрали 'В' спереди"
from svod2;

--  регулярные выражения

SELECT
regexp_substr('"26.07.2001","Num":"7656565956","status":"H","', '"Num":"[[:digit:]]{10}"') as reg_substr
,case
when regexp_instr('"26.07.2001","Num":"7656565956","status":"H"', 'ss|tt|Nu')>0
then 'Yes' else 'No' end as reg_instr
,regexp_replace('GFyYTfytt ytYt ythsjf ttddase','h|s|f','W') as reg_repl
FROM dual;

-- числовые функции

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

-- функции с датой

SELECT 
  ADD_MONTHS('01.02.2000',5) as new_mon
 ,LAST_DAY('05.02.2000') as new_last
 ,NEXT_DAY('05.02.2000','Tuesday') as new_next
 ,MONTHS_BETWEEN('05.02.2021','20.04.2020') as m_betw
 ,TO_DATE('01012020 11:39:44','ddmmyyyy HH:MI:SS') as new_d
 ,CURRENT_DATE
 ,SYSDATE
FROM dual;

------- расчет стажа ----

WITH d AS (
     SELECT sysdate d2
           ,to_date('13.02.2012') d1
     FROM dual
     )
  SELECT FLOOR(MONTHS_BETWEEN(d2,d1)/12) YY  -- количество лет
        ,FLOOR(MOD(MONTHS_BETWEEN(d2,d1),12)) MM -- количество месяцев
        ,TRUNC(d2-ADD_MONTHS(d1,FLOOR(MONTHS_BETWEEN(d2,d1))),0) DD  -- количество дней
     FROM d;
     
------- вспомогательные функции сравнения

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
--     Секционирование таблиц в Oracle
----------------------------

----разделение по диапазону

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

-----  разбиение по списку

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

-------  хэш-секционирование

CREATE TABLE sales_hash
(salesman_id  NUMBER(5), 
salesman_name VARCHAR2(30), 
sales_amount  NUMBER(10), 
week_no       NUMBER(2)) 
PARTITION BY HASH(salesman_id) 
PARTITIONS 4 
STORE IN (data1, data2, data3, data4);


-------- составное секционирование  диапазона-хэша 

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

-------- составное секционирование  Range-List 

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


-----Пример создания индекса: Стартовая таблица, используемая для примеров
CREATE TABLE employees
(employee_id NUMBER(4) NOT NULL,
 last_name VARCHAR2(10), 
 department_id NUMBER(2))
PARTITION BY RANGE (department_id)
(PARTITION employees_part1 VALUES LESS THAN (11) TABLESPACE part1, 
 PARTITION employees_part2 VALUES LESS THAN (21) TABLESPACE part2, 
 PARTITION employees_part3 VALUES LESS THAN (31) TABLESPACE part3);

-----Пример создания локального индекса
CREATE INDEX employees_local_idx ON employees (employee_id) LOCAL;

-----Пример создания глобального индекса
CREATE INDEX employees_global_idx ON employees(employee_id);

-----Пример создания глобального секционированного индекса
CREATE INDEX employees_global_part_idx ON employees(employee_id)
GLOBAL PARTITION BY RANGE(employee_id)
(PARTITION p1 VALUES LESS THAN(5000),
 PARTITION p2 VALUES LESS THAN(MAXVALUE));


------Пример создания секционированной индексноорганизованной таблицы
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

-- создание таблицы полное копирование

CREATE TABLE price1
AS SELECT * FROM price
WHERE 1=1;

select * from price1;

-- создание таблицы пустой

CREATE TABLE price2
AS SELECT * FROM price
WHERE 1=0;

select * from price2;

CREATE TABLE price3
AS SELECT * FROM price
WHERE 1=0;

select * from price3;

-- заполнение таблицы

INSERT FIRST
       WHEN summa >100 THEN
         INTO price2 VALUES (product_id, UPPER(product), summa*2)
       WHEN summa >99 THEN
         INTO price3 VALUES (product_id, LOWER(product), summa*3)
     SELECT * FROM price;
     
select p2.*,'price2' as tabl from price2 p2
UNION ALL
select p3.*, 'price3' from price3 p3;


TRUNCATE TABLE price2;
TRUNCATE TABLE price3;

-- заполнение таблицы 2

INSERT ALL
       WHEN summa >100 THEN
         INTO price2 VALUES (product_id, UPPER(product), summa*2)
       WHEN summa >99 THEN
         INTO price3 VALUES (product_id, LOWER(product), summa*3)
     SELECT * FROM price;
     
select p2.*,'price2' as tabl from price2 p2
UNION ALL
select p3.*, 'price3' from price3 p3;
