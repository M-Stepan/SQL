select /*test plan*/ *
from sv s, managers m
where (s.managers = 'Иванов' or m.dolgnost = 'начальник')
and s.managers=m.managers;

select * from v$sql vs where vs.SQL_FULLTEXT like 'select /*test plan*/ *%';
--8famug897rxrz

EXPLAIN PLAN FOR
  SELECT s.managers, s.product, s.summa, m.dolgnost
  FROM   sv s, managers m
  WHERE  s.summa >= 100
  AND    s.managers=m.managers
  ORDER BY s.summa DESC;
  
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(format => 'ALL'));



select * from table (dbms_xplan.display_cursor('&sqlid',0));
select * from table (dbms_xplan.display_cursor('8famug897rxrz',0));

select * from table (dbms_xplan.display_awr('&sqlid'));


SELECT sql_id, child_number, plan_hash_value
  FROM gv$sql
 WHERE sql_id = '&sqlid';
 
select * from v$sql_plan_statistics_all;
 
SELECT /*+ PARALLEL(8) */ *
from sv s, managers m
where (s.managers = 'Иванов' or m.dolgnost = 'начальник')
and s.managers=m.managers;


SELECT PARTITION_NAME, STALE_STATS
FROM   DBA_TAB_STATISTICS
WHERE  TABLE_NAME = 'MANAGERS'
AND    OWNER = 'STEPAN'
ORDER BY PARTITION_NAME;
 

-- Статистика для таблицы

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS (  
    ownname => 'STEPAN'
,   tabname => 'MANAGERS'
,   degree  => 2
,   estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE  
);
END;
/

-- Статистика для схемы
EXEC DBMS_STATS.GATHER_SCHEMA_STATS('STEPAN'); --(в окне команд)

select owner, table_name, partition_name, stale_stats
from dba_tab_statistics
where owner = 'STEPAN'
order by partition_name;


-- Статистика для системных объектов
BEGIN
  DBMS_STATS.GATHER_FIXED_OBJECTS_STATS;
END;
/

-- Удаление статистики
BEGIN
  DBMS_STATS.DELETE_TABLE_STATS('STEPAN','MANAGERS');
END;
/

-- Блокировка статистики
BEGIN
  DBMS_STATS.LOCK_TABLE_STATS('STEPAN','MANAGERS');
END;
/
