SELECT

CASE WHEN
a.月份 >= '01'
AND 
a.月份 < '10'
THEN 
CONCAT(SUBSTR(a.月份,2,1),'月')
ELSE
CONCAT(a.月份,'月')
END
AS 月份,
a.天数 
FROM 
(
SELECT  DISTINCT
TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'YYYY') AS 年份,
TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM') AS 月份,
TO_CHAR(LAST_DAY(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD')),'DD') AS 天数
FROM 
DM_TURNOVER_ALL
WHERE
SUBSTR(DATE1,1,4) = SUBSTR('${year}',1,4)
AND
DATE1<TO_CHAR(SYSDATE,'YYYY-MM')
ORDER BY
TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM')
) a


SELECT DISTINCT AREA_CODE,AREA_NAME 
FROM DIM_REGION 
WHERE 
1=1

${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME in ('"+UNION_AREA+"')")}

SELECT * FROM DM_TURNOVER_ALL

      
            SELECT 
--AREA_CODE AS 区域编码,
CASE WHEN
TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM') >= '01'
AND 
TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM') < '10'
THEN 
CONCAT(SUBSTR(TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM'),2,1),'月')
ELSE
CONCAT(TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM'),'月')
END
AS 月份,
GATHER AS 集采,
SUM(ZYCB) AS 直营成本,
SUM(JMCB) AS 加盟成本,
CASE WHEN 
'${RELATION}' = '包含'
THEN
SUM(PFCB) + SUM(GLCB)
ELSE
SUM(PFCB)
END
AS 批发成本,
SUM(ZYKC) AS 直营库存,
SUM(DCKC) AS 大仓库存,
SUM(PFCB) AS 批发成本1
FROM DM_TURNOVER_ALL
WHERE 
1=1 
${if(len(AREA_CODE)=0,""," and AREA_CODE in ('"+AREA_CODE+"')")}
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(category)=0,""," and DECODE(sUb_category,'阿胶','阿胶','非阿胶') in ('"+category+"')")}

AND
SUBSTR(DATE1,1,4) = SUBSTR('${year}',1,4)
AND 
DATE1 < TO_CHAR(SYSDATE,'YYYY-MM')
GROUP BY 
--AREA_CODE,

GATHER ,
CASE WHEN
TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM') >= '01'
AND 
TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM') < '10'
THEN 
CONCAT(SUBSTR(TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM'),2,1),'月')
ELSE
CONCAT(TO_CHAR(TO_DATE(CONCAT(DATE1,'-01'),'YYYY-MM-DD'),'MM'),'月')
END

 

select bus_type,sum(sum_amount) qckc,sum(dckc_amount) dckc,sum(zykc_amount) zykc from dw_sum_cost_area_type
  where 1=1 ${if(len(category)=0,""," and  DECODE(sUb_category,'阿胶','阿胶','非阿胶') in ('"+category+"')")} 
    and date1= '${year}'-1||'-12'
     ${if(len(AREA_CODE)=0,""," and AREA_CODE in ('"+AREA_CODE+"')")}
     ${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
    --and da.date1= '2019'-1||'-12'
    group by bus_type
    

 
select bus_type,sum(sum_amount) qmkc,sum(dckc_amount) dckc,sum(zykc_amount) zykc from dw_sum_cost_area_type
  where 1=1 ${if(len(category)=0,""," and  DECODE(sUb_category,'阿胶','阿胶','非阿胶') in ('"+category+"')")} 
    and date1= decode('${year}',to_char(sysdate,'yyyy'),to_char(add_months(sysdate,-1),'yyyy-mm'),'${year}'||'-12')
     ${if(len(AREA_CODE)=0,""," and AREA_CODE in ('"+AREA_CODE+"')")}
     ${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
    --and da.date1= '2019'-1||'-12'
    group by bus_type
    
   

select gather,(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0))) sum_cb,
       (sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0))) dc_cb,
       sum(nvl(zycb,0)) zy_cb
from DM_TURNOVER_ALL
where  1=1 ${if(len(category)=0,""," and  DECODE(sUb_category,'阿胶','阿胶','非阿胶') in ('"+category+"')")} 
   
    ${if(len(AREA_CODE)=0,""," and AREA_CODE in ('"+AREA_CODE+"')")}
    ${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
    and substr(date1,1,4)='${year}' 
    and date1 < to_char(sysdate,'yyyy-mm')
    group by gather

SELECT 
DISTINCT
SUBSTR(DATE1,1,4) AS 年，
SUBSTR(DATE1,1,4)||'年' AS 年份
FROM
DM_TURNOVER_ALL
ORDER BY 1,2


SELECT DISTINCT UNION_AREA_NAME
FROM DIM_REGION

select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

select count(*)  as days from DIM_DAY
where to_char(DDATE,'YYYY')=SUBSTR('${YEAR}',1,4)
and ddate<sysdate

select distinct gather  from DM_TURNOVER_ALL
where gather !='集采DTP'

