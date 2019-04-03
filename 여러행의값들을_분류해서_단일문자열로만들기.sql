/* 1. START WITH ... CONNECT BY �Լ��� 
�׷��Լ�(analytic function)�� �����ϴ� ���������� ����ȭ ó���ؼ� 
������ ���� �ٿ��ִ� �Լ��̴�. 

��� �ҽ��� ������ 
-- http://www.whoispython.com �� ��� ���� �޴� ����
-- https://www.youtube.com/channel/UCEYd78gT_f-G9aD6y1cFUtw �� ������ ���� ����
(�������� ���� �������� �� �ֽ��ϴ�. )

���� : 
http://www.whoispython.com/ 
https://www.youtube.com/channel/UCEYd78gT_f-G9aD6y1cFUtw / 
*/

/* 1. ���������� ��� ���� */
-- http://www.whoispython.com �� ��� ���� �޴� ����
-- https://www.youtube.com/channel/UCEYd78gT_f-G9aD6y1cFUtw �� ������ ���� ����

/* 2. ���̺� ����(ȸ�纰 �����) 
�Ｚ : ����Ǫ������̽�, ����T9000
���� : �����S831S30, �����F871SS11, �����F871SS12
��� : ���FR-B183SW
*/
-- DROP TABLE t_fridge;
CREATE TABLE t_fridge (
  f_id NUMBER PRIMARY KEY
  , f_com NVARCHAR2(20) -- ȸ���
  , f_prod NVARCHAR2(20) -- ��ǰ��
);
-- DROP SEQUENCE seq_t_fridge;
CREATE SEQUENCE seq_t_fridge START WITH 1 INCREMENT BY 1 NOCACHE;

/* 3. ���̺� ������ �߰� */
-- �Ｚ
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '�Ｚ', '����Ǫ������̽�');
-- �Ｚ
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '�Ｚ', '����T9000');
-- ����
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '����', '�����S831S30');
-- ����
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '����', '�����F871SS11');
SELECT * FROM t_refriger;
-- ����
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '����', '�����F871SS12');
-- ���
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '���', '���FR-B183SW');

COMMIT;
SELECT * FROM t_fridge;

/* 4. START WITH ... CONNECT BY : 
START WITH ... CONNECT BY ���� ���̺��� ����ȭ�� ���� ���� �ݺ��� ������

START WITH BOOLEAN�� : ���� �ݺ� ����� ���۳���� �������� �ǹ���.
-- START WITH r_parent IS NULL : �̰��� r_parent�� ���� NULL �� ���� ���۳������ �ǹ���.
-- START WITH r_id = 2 : r_id�� ���� 2�� ���� ���۳������ �ǹ���.
CONNECT BY PRIOR PRIOR ��1 = ��2 : ���� �ݺ� ����� �ش���� �ݺ��� �����ϴ� �������� �ǹ���.
-- PRIOR : �ݺ��� �ϴ� ���� ���� �̸������� ������ ���İ��� �߻��Ѵ�. 
-- �ű⿡�� �������� �����ϴ� PRIOR�� ����
-- CONNECT BY PRIOR PRIOR ��1 = ��2; ��1�� ���������� �ǹ���
*/
select f_com  
from (SELECT f_id, f_com, F_PROD, 
ROW_NUMBER() OVER (PARTITION BY f_com ORDER BY f_id) RNUM
FROM t_fridge)
START WITH RNUM=1
CONNECT BY PRIOR RNUM=RNUM-1 AND PRIOR f_com=f_com
GROUP BY f_com ;

/* 4. LEVEL  : 
LEVEL ������ ������ ���� ������������ ���° �������� Ȯ���� �� �ִ�.
*/
select f_com, LEVEL  
from (SELECT f_id, f_com, F_PROD, 
ROW_NUMBER() OVER (PARTITION BY f_com ORDER BY f_id) RNUM
FROM t_fridge)
START WITH RNUM=1
CONNECT BY PRIOR RNUM=RNUM-1 AND PRIOR f_com=f_com;

/* 5. SYS_CONNECT_BY_PATH �Լ� Ȱ�� :  
SYS_CONNECT_BY_PATH ('��', '������') 
: START WITH �� CONNECT BY �� �ݺ����� �ݺ����� �����ϸ� �����ڷ� ���ڿ����� �ϴ� �Լ�
*/
select f_com, RNUM, SYS_CONNECT_BY_PATH(F_PROD, ',') vals 
from (SELECT f_id, f_com, F_PROD, 
ROW_NUMBER() OVER (PARTITION BY f_com ORDER BY f_id) RNUM
FROM t_fridge)
START WITH RNUM=1
CONNECT BY PRIOR RNUM=RNUM-1 AND PRIOR f_com=f_com;

/* 6. ���� ���� �ϳ��� ������ ��ȯ�ϴ� ����1 
(SYS_CONNECT_BY_PATH �Լ� Ȱ��, ����Ŭ 9i���� ������)
�Ʒ��� 5���������� �ϼ��� ������ GROUP BY�� MAX �Լ��� ����Ͽ� ����ȸ���̸��� 
�ݺ��Ǵ� ���߿��� �Ѱ��� ǥ�õǵ��� ó����.
*/
select f_com, MAX(SYS_CONNECT_BY_PATH(F_PROD, ',')) vals 
from (SELECT f_id, f_com, F_PROD, 
ROW_NUMBER() OVER (PARTITION BY f_com ORDER BY f_id) RNUM
FROM t_fridge)
START WITH RNUM=1
CONNECT BY PRIOR RNUM=RNUM-1 AND PRIOR f_com=f_com
GROUP BY f_com;

/* 7. ���� ���� �ϳ��� ������ ��ȯ�ϴ� ����2 
(SYS_CONNECT_BY_PATH �Լ� Ȱ��, ����Ŭ 11g���� ������)
�Ʒ��� 5���������� �ϼ��� ������ GROUP BY�� MAX �Լ��� ����Ͽ� ����ȸ���̸��� 
�ݺ��Ǵ� ���߿��� �Ѱ��� ǥ�õǵ��� ó����.

SELECT  ���̸�, LISTAGG(�ϳ��ǹ��ڿ��̵� ���̸�, '�ϳ��ǹ��ڿ��̵� ��� ������') 
WITHIN GROUP (ORDER BY ���̸�) AS ��Ī
FROM  ���̺��̸� group by ���̸�;
*/
SELECT  f_com, LISTAGG(F_PROD, ',') WITHIN GROUP (ORDER BY f_com) AS vals
FROM  t_fridge group by f_com;


/* ��� �ҽ��� ������ 
-- http://www.whoispython.com �� ��� ���� �޴� ����
-- https://www.youtube.com/channel/UCEYd78gT_f-G9aD6y1cFUtw �� ������ ���� ����
(�������� ���� �������� �� �ֽ��ϴ�. )
*/




