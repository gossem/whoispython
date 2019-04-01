/* 1. OVER �Լ��� ������������ �׷��Լ�(analytic function)�� ����ȭ ó���ؼ� ������ ���� �ٿ��ִ� �Լ��̴�. */

/* 1.1. ���̺� ����(�Ｚ���� ����� ��ǰ�� �Ǹŷ� ���̺�) */
-- DROP TABLE sell_elec
CREATE TABLE sell_elec (
  s_name NVARCHAR2(20) -- ��ǰ��
  , s_count NUMBER  -- �ǸŴ��
);

SELECT * FROM SELL_ELEC;
/* 1.2. ���̺� ������ �߰� */
INSERT INTO sell_elec VALUES ('T9000', 3);
INSERT INTO sell_elec VALUES ('T9000', 1);
INSERT INTO sell_elec VALUES ('T9000', 2);
--
INSERT INTO sell_elec VALUES ('TŸ�Ժ�Ʈ��', 10);
INSERT INTO sell_elec VALUES ('TŸ�Ժ�Ʈ��', 5);
INSERT INTO sell_elec VALUES ('TŸ�Ժ�Ʈ��', 3);
--
INSERT INTO sell_elec VALUES ('Ǫ������̽������', 3);
INSERT INTO sell_elec VALUES ('Ǫ������̽������', 8);
INSERT INTO sell_elec VALUES ('Ǫ������̽������', 1);
INSERT INTO sell_elec VALUES ('Ǫ������̽������', 4);
--
COMMIT;
SELECT * FROM SELL_ELEC;

/* 1.3. �����ռ��� ����� ��� */
SELECT SUM(S_COUNT) ���� FROM SELL_ELEC;

/* 1.4. �׷����(GROUP BY), ��������(ORDER BY)�� �Բ� ����� ���� */
SELECT S_NAME, SUM(S_COUNT) �׷캰�� FROM sell_elec GROUP BY s_name;

/* 1.5. ���տ��� �׷캰���� ����  */
SELECT  S_NAME, ( �κ��� / (SELECT SUM(S_COUNT) FROM SELL_ELEC) ) * 100 AS ��ǰ���Ǹ������� 
FROM ( SELECT S_NAME, SUM(S_COUNT) �κ��� FROM sell_elec GROUP BY s_name );

/* 1.6. OVER() �Լ��� �������� ����ȭ -- ��ü�Ǹŷ��� ������ �Ǹŷ� �� */
SELECT  S_NAME, S_COUNT, SUM(S_COUNT) OVER () AS ��ü�Ǹŷ�
FROM sell_elec;

/* 1.7. OVER() �Լ��� �������� ����ȭ -- ��ü�Ǹŷ��� ������ �Ǹŷ� �� */
SELECT  S_NAME, S_COUNT, S_COUNT / ( SUM(S_COUNT ) OVER ()) * 100 AS ��ǰ���Ǹ������� 
FROM sell_elec;

/* 1.8. OVER() �Լ��� �������� ����ȭ --  ��ǰ������ �ǸŰǺ� ������ */
SELECT  S_NAME, SUM(��ǰ���Ǹ�������) ��ǰ���Ǹ�������
FROM 
( SELECT  S_NAME, S_COUNT, S_COUNT / ( SUM(S_COUNT) OVER ()) * 100 AS ��ǰ���Ǹ������� 
FROM sell_elec ) GROUP BY S_NAME;





SELECT  S_NAME, ( �κ��� / SUM(�κ���) OVER () ) * 100 AS ��ǰ���Ǹ������� 
FROM ( SELECT S_NAME, SUM(S_COUNT) �κ��� FROM sell_elec GROUP BY s_name );


SELECT S_NAME, S_COUNT OVER(ORDER BY S_NAME) S_COUNT  FROM sell_elec;

