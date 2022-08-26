SELECT 
DATE1 AS 年月,
AGE_STORE AS 店龄,
a.AREA_CODE AS 区域编码,
a.CUS_CODE AS 客户编码,
a.AREA_NAME,
a.CUS_NAME,
a.CUS_CODE||a.AREA_CODE as UNIONALL

FROM DIM_CUS a left join AGE_STORE b
on a.AREA_CODE=b.AREA_CODE
 join dim_region dr on b.area_code=dr.area_code
and a.CUS_CODE=b.CUS_CODE
and
 DATE1='${DATE1}'
where a.ATTRIBUTE in ('直营','加盟')
AND 
1=1
${if(len(AREA)=0,""," and A.AREA_CODE IN ('"+AREA+"') ")}
${if(len(CUS)=0,""," and A.CUS_CODE IN ('"+CUS+"') ")}
${if(len(union_area)=0,""," and dr.union_area_name IN ('"+union_area+"') ")}
ORDER BY A.AREA_CODE,a.cus_code

SELECT DISTINCT
a.AREA_CODE AS 区域编码,
a.AREA_NAME

FROM dim_region a
 where 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 

SELECT DISTINCT
a.CUS_CODE ,
a.CUS_NAME

FROM DIM_CUS a
left join 
AGE_STORE b
on a.AREA_CODE=b.AREA_CODE
and a.CUS_CODE=b.CUS_CODE

and a.ATTRIBUTE in ('直营','加盟')

select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a order by 1


