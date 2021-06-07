--�������� ������
CREATE TABLE product
    ( product_id    NUMBER(6)
    , product       VARCHAR2(30) 
    CONSTRAINT   cn_name  NOT NULL
    , komment      VARCHAR2(30)
    , CONSTRAINT   cn_product_uk  UNIQUE (product)
    ) ;

CREATE TABLE price
    ( product_id    NUMBER(6)
    , product       VARCHAR2(30)
    , summa       NUMBER(6,2)    
    ) ;

CREATE TABLE managers
    ( man_id    NUMBER(6)
    , managers       VARCHAR2(30)
    , dolgnost       VARCHAR2(30)
    , status        NUMBER(6)
    ) ;

-- ���������� ������

INSERT INTO product VALUES (1, '�����', '�����');
INSERT INTO product VALUES (2, '��������', '������');
INSERT INTO product VALUES (3, '�����', '�������');
INSERT INTO product VALUES (4, '�������', '������');
INSERT INTO product VALUES (5, '������', '�����');
INSERT INTO product VALUES (6, '�������', '�����');
INSERT INTO product VALUES (7, '�������', '������');

INSERT INTO price VALUES (1, '�����', 100);
INSERT INTO price VALUES (2, '��������', 50);
INSERT INTO price VALUES (3, '�����', 350);
INSERT INTO price VALUES (4, '�������', 25.55);
INSERT INTO price VALUES (5, '������', 33.33);
INSERT INTO price VALUES (6, '�������', 85.5);

INSERT INTO managers VALUES (1, '������', '�����������', 2);
INSERT INTO managers VALUES (2, '������', '��������', 2);
INSERT INTO managers VALUES (3, '�������', '�����������', 2);
INSERT INTO managers VALUES (4, '�������', '���������', 1);
INSERT INTO managers VALUES (5, '��������', '��������', 2);

-- ���������� �����������

ALTER TABLE price add CONSTRAINT  c_id PRIMARY KEY (product_id);
ALTER TABLE price add CONSTRAINT c_summ check (summa IS NOT NULL);
ALTER TABLE price MODIFY product  NOT NULL;


--���������� �������

CREATE INDEX idx1 ON product (product_id);


select * from product;
select * from price;
select * from managers;
