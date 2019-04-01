/* 1. 오라클의 OVER 함수는 그룹함수(analytic function)를 포함하는 서브쿼리를 간소화 처리해서 쿼리의 양을 줄여주는 함수이다. 
제공 : http://www.whoispython.com 
*/

/* 1.1. 테이블 생성(삼성전자 냉장고 상품명별 판매량 테이블) */
-- DROP TABLE sell_elec
CREATE TABLE sell_elec (
  s_name NVARCHAR2(20) -- 상품명
  , s_count NUMBER  -- 판매대수
);

SELECT * FROM SELL_ELEC;
/* 1.2. 테이블에 데이터 추가 */
INSERT INTO sell_elec VALUES ('T9000', 3);
INSERT INTO sell_elec VALUES ('T9000', 1);
INSERT INTO sell_elec VALUES ('T9000', 2);
--
INSERT INTO sell_elec VALUES ('T타입빌트인', 10);
INSERT INTO sell_elec VALUES ('T타입빌트인', 5);
INSERT INTO sell_elec VALUES ('T타입빌트인', 3);
--
INSERT INTO sell_elec VALUES ('푸드쇼케이스냉장고', 3);
INSERT INTO sell_elec VALUES ('푸드쇼케이스냉장고', 8);
INSERT INTO sell_elec VALUES ('푸드쇼케이스냉장고', 1);
INSERT INTO sell_elec VALUES ('푸드쇼케이스냉장고', 4);
--
COMMIT;
SELECT * FROM SELL_ELEC;

/* 1.3. 집계합수만 사용한 경우 */
SELECT SUM(S_COUNT) 총합 FROM SELL_ELEC;

/* 1.4. 그룹바이(GROUP BY), 오더바이(ORDER BY)를 함께 사용한 쿼리 */
SELECT S_NAME, SUM(S_COUNT) 그룹별합 FROM sell_elec GROUP BY s_name;

/* 1.5. 총합에서 그룹별합의 비율  */
SELECT  S_NAME, ( 부분합 / (SELECT SUM(S_COUNT) FROM SELL_ELEC) ) * 100 AS 제품별판매점유율 
FROM ( SELECT S_NAME, SUM(S_COUNT) 부분합 FROM sell_elec GROUP BY s_name );

/* 1.6. OVER() 함수로 서브쿼리 간소화 -- 전체판매량과 각각의 판매량 비교 */
SELECT  S_NAME, S_COUNT, SUM(S_COUNT) OVER () AS 전체판매량
FROM sell_elec;

/* 1.7. OVER() 함수로 서브쿼리 간소화 -- 전체판매량과 각각의 판매량 비교 */
SELECT  S_NAME, S_COUNT, S_COUNT / ( SUM(S_COUNT ) OVER ()) * 100 AS 제품별판매점유율 
FROM sell_elec;

/* 1.8. OVER() 함수로 서브쿼리 간소화 --  제품종류별 판매건별 점유율 */
SELECT  S_NAME, SUM(제품별판매점유율) 제품별판매점유율
FROM 
( SELECT  S_NAME, S_COUNT, S_COUNT / ( SUM(S_COUNT) OVER ()) * 100 AS 제품별판매점유율 
FROM sell_elec ) GROUP BY S_NAME;

 
/* 기억하세요! 이게 핵심입니다. 
 OVER 함수는 그룹함수(analytic function)를 포함하는 서브쿼리를 간소화 처리해서 쿼리의 양을 줄여주는 함수이다. 
제공 : http://www.whoispython.com 
*/

