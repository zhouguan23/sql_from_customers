SELECT 
A.AREA_NAME,
A.门店数,
A.含税销售额,
A.含税毛利额,
A.无税销售额,
A.无税毛利额,
D.TRAN_NUM AS 交易笔数
from
(
select 
d.AREA_NAME,a.area_code,
count(distinct a.CUS_CODE) as 门店数,
sum(a.TAX_AMOUNT) as 含税销售额,
sum(a.TAX_AMOUNT-a.TAX_COST) as 含税毛利额,
sum(a.NO_TAX_AMOUNT) as 无税销售额,
sum(a.NO_TAX_AMOUNT-a.NO_TAX_COST) as 无税毛利额 
from 
DM_SALE_TMP a 
left join 
DIM_CUS b 
on a.AREA_CODE=b.AREA_CODE and a.CUS_CODE=b.CUS_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) c 
on a.AREA_CODE=c.AREA_CODE and a.CUS_CODE=c.CUS_CODE
left join DIM_REGION d on a.AREA_CODE=d.AREA_CODE

where a.SALE_DATE between date'${date1}' and date'${date2}'
${if(len(time)=0,"","and c.age_store IN ('"+time+"')")}
--and c.time not in ('新店','次新店') 
and b.attribute='直营'
 and 1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
 and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")} 
 and 1=1 ${if(len(area)=0,""," and d.AREA_NAME in('"+area+"') ")}
 ${if(len(union_area)=0,"","and d.union_area_name IN ('"+union_area+"')")}
group by d.AREA_NAME,a.area_code
order by a.area_code
)A 
LEFT JOIN
(select d.AREA_NAME,sum(TRAN_NUM) TRAN_NUM from DM_TRANSACTION a 
left join 
DIM_CUS b 
on a.AREA_CODE=b.AREA_CODE and to_char(a.CUS_CODE)=b.CUS_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) c 
on a.AREA_CODE=c.AREA_CODE and to_char(a.CUS_CODE)=c.CUS_CODE
left join DIM_REGION d on a.AREA_CODE=d.AREA_CODE
where 
SALE_DATE between date'${date1}' and date'${date2}'
${if(len(time)=0,"","and c.age_store IN ('"+time+"')")}
 ${if(len(union_area)=0,"","and d.union_area_name IN ('"+union_area+"')")}
--and c.time not in ('新店','次新店') 
and b.attribute='直营'
group by d.AREA_NAME) d
ON A.AREA_NAME=D.AREA_NAME



select 
area_name,
count(goods_code) xdb
from
(
select
b.area_name,
a.goods_code,
DECODE(C.GOODS_CODE,NULL,'否','是') as dtp, -- dtp
DECODE(D.OTO,'否','否','是') as oto -- oto
from
fact_sale a 
left join dim_cus b 
on a.AREA_CODE=b.AREA_CODE and a.CUS_CODE=b.CUS_CODE
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
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and a.CUS_CODE=e.CUS_CODE
where a.SALE_DATE between date'${date1}' and date'${date2}'
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
--and b.attribute='直营'
--and e.time not in ('新店','次新店') 
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
group by area_name

select distinct age_store as time from AGE_STORE

select 
distinct
area_name,union_area_name 
from
DIM_REGION
where 1=1 
${if(len(union_area)=0,"","and union_area_name IN ('"+union_area+"')")}
${if(len(area)=0,""," and AREA_NAME in('"+area+"') ")}
order by union_area_name


select a.cnt,b.area_name from (
select A.AREA_CODE, count(1) as cnt FROM dm_shop A inner join dim_cus B on A.CUS_CODE=B.CUS_CODE 
and a.area_code=b.area_code  
and (b.VIRTUAL_SHOP is null or b.VIRTUAL_SHOP='否') 
where  b.attribute='直营' and a.dimension=substr('${date1}',1,4) 
and  
(( b.CLOSE_DATE IS NULL  or b.close_date > to_date('${date2}','YYYY-MM-DD') ) AND b.OPEN_DATE  <= to_date('${date2}','YYYY-MM-DD')) 
GROUP BY A.AREA_CODE 
union

select '0' as area_code, count(1) as cnt FROM dm_shop A inner join dim_cus B on A.CUS_CODE=B.CUS_CODE   
and a.area_code=b.area_code  
and (b.VIRTUAL_SHOP is null or b.VIRTUAL_SHOP='否') 
where  b.attribute='直营' and a.dimension=substr('${date1}',1,4) 
and  
(( b.CLOSE_DATE IS NULL  or b.close_date > to_date('${date2}','YYYY-MM-DD') ) AND b.OPEN_DATE  <= to_date('${date2}','YYYY-MM-DD'))  
GROUP BY '0' 
) a 
left join DIM_REGION  b on a.AREA_CODE=b.AREA_CODE
order by a.AREA_CODE 

select distinct 
union_area_name
from dim_region

