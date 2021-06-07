alter session set "_ORACLE_SCRIPT"=true;
CREATE USER Stepan identified by "Stepan";
grant create session to Stepan;
grant create table to Stepan;
grant create procedure to Stepan;
grant create trigger to Stepan;
grant create view to Stepan;
grant create sequence to Stepan;
grant alter any table to Stepan;
grant alter any procedure to Stepan;
grant alter any trigger to Stepan;
grant alter profile to Stepan;
grant delete any table to Stepan;
grant drop any table to Stepan;
grant drop any procedure to Stepan;
grant drop any trigger to Stepan;
grant drop any view to Stepan;
grant drop profile to Stepan;

grant select on sys.v_$session to Stepan;
grant select on sys.v_$sesstat to Stepan;
grant select on sys.v_$statname to Stepan;
grant SELECT ANY DICTIONARY to Stepan;

ALTER USER Stepan quota unlimited on users;