SELECT TYPE_NAME FROM ALL_TYPES WHERE PREDEFINED='YES';

DECLARE
  HI varchar2(10) := 'hello';
BEGIN
  DBMS_Output.Put_Line(Hi);
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE('В десу родилась елочка
В лесу она росла');
END;

DECLARE
  nn varchar2(20) := 'Песенка';
BEGIN
  DBMS_OUTPUT.put_line(nn||CHR(10)||
'   В лесу родилась елочка'||CHR(10)||
'   В лесу она росла');
END;

SELECT * FROM price1;
SELECT * FROM price2;
SELECT * FROM price3;

DECLARE
  x varchar2(30);
  n number;
BEGIN
  SELECT product INTO x FROM price3 WHERE ROWNUM<2;
--  x := 'супер ручка';
  SELECT summa INTO n FROM price3 WHERE ROWNUM<2;
--  n := 500;
  INSERT INTO price2 VALUES (9, x, n*2);
  DBMS_OUTPUT.put_line('Строчка добавлена');
  UPDATE price1 SET price1.summa=price1.summa+n; --WHERE  price1.product_id=3;
  DBMS_OUTPUT.put_line('Строчка обновлена');
END;

ROLLBACK;
