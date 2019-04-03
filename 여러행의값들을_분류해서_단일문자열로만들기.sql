/* 1. START WITH ... CONNECT BY 함수는 
그룹함수(analytic function)를 포함하는 서브쿼리를 간소화 처리해서 
쿼리의 양을 줄여주는 함수이다. 

모든 소스의 설명은 
-- http://www.whoispython.com 의 상단 강좌 메뉴 참고
-- https://www.youtube.com/channel/UCEYd78gT_f-G9aD6y1cFUtw 의 동영상 강의 참조
(동영상은 현재 제작중일 수 있습니다. )

제공 : 
http://www.whoispython.com/ 
https://www.youtube.com/channel/UCEYd78gT_f-G9aD6y1cFUtw / 
*/

/* 1. 계층적구조 용어 정리 */
-- http://www.whoispython.com 의 상단 강좌 메뉴 참고
-- https://www.youtube.com/channel/UCEYd78gT_f-G9aD6y1cFUtw 의 동영상 강의 참조

/* 2. 테이블 생성(회사별 냉장고) 
삼성 : 지펠푸드쇼케이스, 지펠T9000
엘지 : 디오스S831S30, 디오스F871SS11, 디오스F871SS12
대우 : 대우FR-B183SW
*/
-- DROP TABLE t_fridge;
CREATE TABLE t_fridge (
  f_id NUMBER PRIMARY KEY
  , f_com NVARCHAR2(20) -- 회사명
  , f_prod NVARCHAR2(20) -- 상품명
);
-- DROP SEQUENCE seq_t_fridge;
CREATE SEQUENCE seq_t_fridge START WITH 1 INCREMENT BY 1 NOCACHE;

/* 3. 테이블에 데이터 추가 */
-- 삼성
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '삼성', '지펠푸드쇼케이스');
-- 삼성
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '삼성', '지펠T9000');
-- 엘지
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '엘지', '디오스S831S30');
-- 엘지
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '엘지', '디오스F871SS11');
SELECT * FROM t_refriger;
-- 엘지
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '엘지', '디오스F871SS12');
-- 대우
INSERT INTO t_fridge (f_id, f_com, f_prod) 
VALUES (seq_t_fridge.NEXTVAL, '대우', '대우FR-B183SW');

COMMIT;
SELECT * FROM t_fridge;

/* 4. START WITH ... CONNECT BY : 
START WITH ... CONNECT BY 절로 테이블의 계층화를 위한 행의 반복을 실행함

START WITH BOOLEAN값 : 행의 반복 실행시 시작노드이 조건임을 의미함.
-- START WITH r_parent IS NULL : 이것은 r_parent의 값이 NULL 인 행이 시작노드임을 의미함.
-- START WITH r_id = 2 : r_id의 값이 2인 행이 시작노드임을 의미함.
CONNECT BY PRIOR PRIOR 열1 = 열2 : 행의 반복 실행시 해당번의 반복을 중지하는 조건임을 의미함.
-- PRIOR : 반복을 하다 보면 같은 이름이지만 이전값 이후값이 발생한다. 
-- 거기에서 이전값을 지정하는 PRIOR가 사용됨
-- CONNECT BY PRIOR PRIOR 열1 = 열2; 열1이 이전값임을 의미함
*/
select f_com  
from (SELECT f_id, f_com, F_PROD, 
ROW_NUMBER() OVER (PARTITION BY f_com ORDER BY f_id) RNUM
FROM t_fridge)
START WITH RNUM=1
CONNECT BY PRIOR RNUM=RNUM-1 AND PRIOR f_com=f_com
GROUP BY f_com ;

/* 4. LEVEL  : 
LEVEL 값으로 현재의 행이 계층형구조의 몇번째 층인지를 확인할 수 있다.
*/
select f_com, LEVEL  
from (SELECT f_id, f_com, F_PROD, 
ROW_NUMBER() OVER (PARTITION BY f_com ORDER BY f_id) RNUM
FROM t_fridge)
START WITH RNUM=1
CONNECT BY PRIOR RNUM=RNUM-1 AND PRIOR f_com=f_com;

/* 5. SYS_CONNECT_BY_PATH 함수 활용 :  
SYS_CONNECT_BY_PATH ('값', '구분자') 
: START WITH 와 CONNECT BY 의 반복에서 반복마다 실행하며 구분자로 문자연결을 하는 함수
*/
select f_com, RNUM, SYS_CONNECT_BY_PATH(F_PROD, ',') vals 
from (SELECT f_id, f_com, F_PROD, 
ROW_NUMBER() OVER (PARTITION BY f_com ORDER BY f_id) RNUM
FROM t_fridge)
START WITH RNUM=1
CONNECT BY PRIOR RNUM=RNUM-1 AND PRIOR f_com=f_com;

/* 6. 행을 열의 하나의 값으로 변환하는 쿼리1 
(SYS_CONNECT_BY_PATH 함수 활용, 오라클 9i부터 지원함)
아래의 5번쿼리에서 완성한 쿼리에 GROUP BY와 MAX 함수를 사용하여 전자회사이름이 
반복되는 행중에서 한개만 표시되도록 처리함.
*/
select f_com, MAX(SYS_CONNECT_BY_PATH(F_PROD, ',')) vals 
from (SELECT f_id, f_com, F_PROD, 
ROW_NUMBER() OVER (PARTITION BY f_com ORDER BY f_id) RNUM
FROM t_fridge)
START WITH RNUM=1
CONNECT BY PRIOR RNUM=RNUM-1 AND PRIOR f_com=f_com
GROUP BY f_com;

/* 7. 행을 열의 하나의 값으로 변환하는 쿼리2 
(SYS_CONNECT_BY_PATH 함수 활용, 오라클 11g부터 지원함)
아래의 5번쿼리에서 완성한 쿼리에 GROUP BY와 MAX 함수를 사용하여 전자회사이름이 
반복되는 행중에서 한개만 표시되도록 처리함.

SELECT  열이름, LISTAGG(하나의문자열이될 열이름, '하나의문자열이될 경우 구분자') 
WITHIN GROUP (ORDER BY 열이름) AS 별칭
FROM  테이블이름 group by 열이름;
*/
SELECT  f_com, LISTAGG(F_PROD, ',') WITHIN GROUP (ORDER BY f_com) AS vals
FROM  t_fridge group by f_com;


/* 모든 소스의 설명은 
-- http://www.whoispython.com 의 상단 강좌 메뉴 참고
-- https://www.youtube.com/channel/UCEYd78gT_f-G9aD6y1cFUtw 의 동영상 강의 참조
(동영상은 현재 제작중일 수 있습니다. )
*/




