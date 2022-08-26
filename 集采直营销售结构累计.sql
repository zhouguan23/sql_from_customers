select gather, sum(no_tax_amount), sum(no_tax_amount - no_tax_cost) from DM_SALE_TMP t,   dim_cus f 
where t.CUS_CODE=f.CUS_CODE
and t.AREA_CODE=f.AREA_CODE
and t.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
and f.ATTRIBUTE ='直营'
-- and t.dtp ='否'
-- and t.oto ='否'
and gather <> '地采'
${if(len(area)=0,"","and t.area_code IN ('"+area+"')")}
${if(len(gather)=0,"","and t.gather IN ('"+gather+"')")}
group by gather 

select sum(no_tax_amount), sum(no_tax_amount - no_tax_cost) from DM_MONTHLY_SALE   where  ACCOUNTNAME = '直营常规'
and sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
${if(len(area)=0,"","and  AREA_code IN ('"+area+"')")}

select gather, sum(no_tax_amount), sum(no_tax_amount - no_tax_cost) from DM_SALE_TMP t,   dim_cus f 
where t.CUS_CODE=f.CUS_CODE
and t.AREA_CODE=f.AREA_CODE
and t.sale_date between ADD_MONTHS(TO_DATE('${sale_date1}','YYYY-MM-DD'),-12)  and ADD_MONTHS(TO_DATE('${sale_date2}','YYYY-MM-DD'),-12)
and f.ATTRIBUTE ='直营'
${if(len(area)=0,"","and t.area_code IN ('"+area+"')")}
${if(len(gather)=0,"","and t.gather IN ('"+gather+"')")}
-- and t.dtp ='否'
-- and t.oto ='否'
and gather <> '地采'
group by gather

select sum(no_tax_amount), sum(no_tax_amount - no_tax_cost) from DM_MONTHLY_SALE   where  ACCOUNTNAME = '直营常规'
and sale_date between ADD_MONTHS(TO_DATE('${sale_date1}','YYYY-MM-DD'),-12)  and ADD_MONTHS(TO_DATE('${sale_date2}','YYYY-MM-DD'),-12)
${if(len(area)=0,"","and  AREA_code IN ('"+area+"')")}


SELECT 
COUNT(DISTINCT A.GOODS_CODE),
GATHER
FROM
(
SELECT
	A.AREA_CODE,
	A.GOODS_CODE,
	A.CUS_CODE,
	A.SALE_DATE AS SALE_DATE,
	A.VIP AS VIP,
	NVL(B.NEW_ATTRIBUTE,'地采') AS GATHER,
	DECODE(C.GOODS_CODE,NULL,'否','是') as dtp,
	DECODE(D.OTO,'否','否','是') as oto
FROM
	FACT_SALE A
LEFT JOIN 
	DIM_NET_CATALOGUE_GENERAL_ALL B
ON 
	A.AREA_CODE = B.AREA_CODE
AND 
	A.GOODS_CODE = B.GOODS_CODE 
AND 
	TO_CHAR(A.SALE_DATE,'YYYY-MM') = B.CREATE_MONTH
LEFT JOIN
	DIM_DTP C
ON
	A.AREA_CODE = C.AREA_CODE 
AND 
	A.GOODS_CODE = C.GOODS_CODE 
AND 
	TO_CHAR(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM') =C.CREATE_MONTH
LEFT JOIN 
	DIM_MARKETING D
ON 
	A.MARKETING_CODE = D.MARKETING_CODE
LEFT JOIN 
	DIM_CUS F 
ON 
	A.CUS_CODE=F.CUS_CODE
	and A.AREA_CODE=F.AREA_CODE
WHERE 
	SALE_DATE  between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
	AND F.ATTRIBUTE ='直营'
)A 
WHERE 

 A.gather <> '地采'
GROUP BY GATHER

select 
distinct
area_code,
area_name
from
dim_region  f 

select distinct NEW_ATTRIBUTE  from DIM_NET_CATALOGUE_GENERAL_ALL t

