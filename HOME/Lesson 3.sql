--�������� ������
CREATE TABLE TEST1_product
    ( product_id    NUMBER(6)
    , product       VARCHAR2(30) 
    CONSTRAINT   cn_name  NOT NULL
    , komment      VARCHAR2(30)
    , CONSTRAINT   cn_product_uk  UNIQUE (product)
    ) ;

CREATE TABLE TEST1_price
    ( product_id    NUMBER(6)
    , product       VARCHAR2(30)
    , summa       NUMBER(6,2)    
    ) ;

CREATE TABLE TEST1_managers
    ( man_id    NUMBER(6)
    , managers       VARCHAR2(30)
    , dolgnost       VARCHAR2(30)
    , status        NUMBER(6)
    ) ;

-- ���������� ������

INSERT INTO TEST1_product VALUES (1, '�����', '�����');
INSERT INTO TEST1_product VALUES (2, '��������', '������');
INSERT INTO TEST1_product VALUES (3, '�����', '�������');
INSERT INTO TEST1_product VALUES (4, '�������', '������');
INSERT INTO TEST1_product VALUES (5, '������', '�����');
INSERT INTO TEST1_product VALUES (6, '�������', '�����');

INSERT INTO TEST1_price VALUES (1, '�����', 100);
INSERT INTO TEST1_price VALUES (2, '��������', 50);
INSERT INTO TEST1_price VALUES (3, '�����', 350);
INSERT INTO TEST1_price VALUES (4, '�������', 25.55);
INSERT INTO TEST1_price VALUES (5, '������', 33.33);
INSERT INTO TEST1_price VALUES (6, '�������', 85.5);

INSERT INTO TEST1_managers VALUES (1, '������', '�����������', 2);
INSERT INTO TEST1_managers VALUES (2, '������', '��������', 2);
INSERT INTO TEST1_managers VALUES (3, '�������', '�����������', 2);
INSERT INTO TEST1_managers VALUES (4, '�������', '���������', 1);
INSERT INTO TEST1_managers VALUES (5, '��������', '��������', 2);

-- ���������� �����������

ALTER TABLE TEST1_product add CONSTRAINT  emp_pk PRIMARY KEY (product_id);
ALTER TABLE TEST1_product add CONSTRAINT kom check (komment IS NOT NULL);
ALTER TABLE TEST1_product MODIFY product  NOT NULL;


--���������� �������

CREATE INDEX TEST1_idx1 ON TEST1_product (product_id);


select * from TEST1_product;
select * from TEST1_price;
select * from TEST1_managers;
