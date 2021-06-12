--Создание таблиц
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

-- Заполнение таблиц

INSERT INTO product VALUES (1, 'ручка', 'новая');
INSERT INTO product VALUES (2, 'карандаш', 'старый');
INSERT INTO product VALUES (3, 'пенал', 'большой');
INSERT INTO product VALUES (4, 'линейка', 'дерево');
INSERT INTO product VALUES (5, 'стерка', 'новая');
INSERT INTO product VALUES (6, 'замазка', 'белая');
INSERT INTO product VALUES (7, 'циркуль', 'металл');

INSERT INTO price VALUES (1, 'ручка', 100);
INSERT INTO price VALUES (2, 'карандаш', 50);
INSERT INTO price VALUES (3, 'пенал', 350);
INSERT INTO price VALUES (4, 'линейка', 25.55);
INSERT INTO price VALUES (5, 'стерка', 33.33);
INSERT INTO price VALUES (6, 'замазка', 85.5);

INSERT INTO managers VALUES (1, 'Иванов', 'консультант', 2);
INSERT INTO managers VALUES (2, 'Петров', 'продавец', 2);
INSERT INTO managers VALUES (3, 'Сидоров', 'консультант', 2);
INSERT INTO managers VALUES (4, 'Михалев', 'начальник', 1);
INSERT INTO managers VALUES (5, 'Васильев', 'продавец', 2);

-- Добавление ограничений

ALTER TABLE price add CONSTRAINT  c_id PRIMARY KEY (product_id);
ALTER TABLE price add CONSTRAINT c_summ check (summa IS NOT NULL);
ALTER TABLE price MODIFY product  NOT NULL;


--Добавление индекса

CREATE INDEX idx1 ON product (product_id);


select * from managers;
select * from price;
select * from product;

create synonym man for managers;
select * from man;

truncate table managers;
truncate table price;
truncate table product;
