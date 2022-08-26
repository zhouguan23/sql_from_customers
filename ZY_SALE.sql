select
area_code as 区域代码,
STORE_TYPE as 门店类型,
sum(no_tax_amount) as 销售额,
sum(no_tax_amount) - sum(no_tax_cost) as 毛利额
from DM_ZY_SALE

where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and
1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")} and 

(sale_date between to_date('${LatStartDate}','yyyy-mm-dd') and to_date('${LatEndDate}','yyyy-mm-dd')) and 1=1
${if(len(stype)=0,"","and store_type in('"+stype+"')")}  
and 1=1 ${if(len(region)=0,"","and area_code in('"+region+"')")}
group by area_code,store_type

union

select
'0'       as 区域代码,
STORE_TYPE as 门店类型,
sum(no_tax_amount) as 销售额,
sum(no_tax_amount) - sum(no_tax_cost) as 毛利额
from DM_ZY_SALE,dual
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and
1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")} and 

(sale_date between to_date('${LatStartDate}','yyyy-mm-dd') and to_date('${LatEndDate}','yyyy-mm-dd')) and 1=1
${if(len(stype)=0,"","and store_type in('"+stype+"')")}  
and 1=1 ${if(len(region)=0,"","and area_code in('"+region+"')")}
group by store_type,'0'


select
area_code as 区域代码,
STORE_TYPE as 门店类型,
sum(no_tax_amount) as 销售额,
sum(no_tax_amount) - sum(no_tax_cost) as 毛利额
from DM_ZY_SALE

where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and
1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")} and 

(sale_date between to_date('${ForStartDate}','yyyy-mm-dd') and to_date('${ForEndDate}','yyyy-mm-dd')) and 1=1
${if(len(stype)=0,"","and store_type in('"+stype+"')")}  
and 1=1 ${if(len(region)=0,"","and area_code in('"+region+"')")}
group by area_code,store_type

union

select
'0'       as 区域代码,
STORE_TYPE as 门店类型,
sum(no_tax_amount) as 销售额,
sum(no_tax_amount) - sum(no_tax_cost) as 毛利额
from DM_ZY_SALE,dual
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and
1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")} and 

(sale_date between to_date('${ForStartDate}','yyyy-mm-dd') and to_date('${ForEndDate}','yyyy-mm-dd')) and 1=1
${if(len(stype)=0,"","and store_type in('"+stype+"')")}  
and 1=1 ${if(len(region)=0,"","and area_code in('"+region+"')")}
group by store_type,'0'  




select * from
(select distinct time from 
(select distinct time from DM_SHOP
union select '关店' as time from dual) a
where 1=1
 ${if(len(stype)=0,"","and time in('"+stype+"')")}
)

order by decode(time,'关店',0,'新店',1,'次新店',2,'第三年店',3,'第四年店',4,'第五年以上店',5)

Select area_code,area_name from DIM_REGION 
where  1=1 ${if(len(region)=0,"","and area_code in('"+region+"')")}
union
select '0' as area_code, '合计' as area_name from dual 

ORDER BY AREA_CODE ASC



select distinct time from dm_shop
where 1=1  ${if(len(stype)=0,"","and time in('"+stype+"')")}  

order by decode(time,'新店',1,'次新店',2,'第三年店',3,'第四年店',4,'第五年以上店',5) 

Select area_code,area_name from DIM_REGION 
WHERE 
1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME IN ('"+UNION_AREA+"') ")}

ORDER BY AREA_CODE ASC



select
area_code as 区域代码,
STORE_TYPE as 门店类型,
sum(no_tax_amount) as 销售额,
sum(no_tax_amount) - sum(no_tax_cost) as 毛利额
from DM_ZY_SALE

where 
oto=0
and
dtp=0 and 

(sale_date between to_date('${LatStartDate}','yyyy-mm-dd') and to_date('${LatEndDate}','yyyy-mm-dd')) and 1=1
${if(len(stype)=0,"","and store_type in('"+stype+"')")}  
and 1=1 ${if(len(region)=0,"","and area_code in('"+region+"')")}
group by area_code,store_type

select * from (select A.AREA_CODE,A.time,count(1) FROM dm_shop A inner join dim_cus B on A.CUS_CODE=B.CUS_CODE 
and a.area_code=b.area_code  
and (b.VIRTUAL_SHOP is null or b.VIRTUAL_SHOP='否') 
where  b.attribute='直营' and a.dimension=substr('${LatStartDate}',1,4) 
and  
(( b.CLOSE_DATE IS NULL  or b.close_date > to_date('${LatEndDate}','YYYY-MM-DD') ) AND b.OPEN_DATE  <= to_date('${LatEndDate}','YYYY-MM-DD')) and 1=1 ${if(len(region)=0,"","and A.area_code in('"+region+"')")} 
GROUP BY A.AREA_CODE,A.time
union

select '0' as area_code,A.time,count(1) FROM dm_shop A inner join dim_cus B on A.CUS_CODE=B.CUS_CODE   
and a.area_code=b.area_code  
and (b.VIRTUAL_SHOP is null or b.VIRTUAL_SHOP='否') 
where  b.attribute='直营' and a.dimension=substr('${LatStartDate}',1,4) 
and  
(( b.CLOSE_DATE IS NULL  or b.close_date > to_date('${LatEndDate}','YYYY-MM-DD') ) AND b.OPEN_DATE  <= to_date('${LatEndDate}','YYYY-MM-DD')) and 1=1 ${if(len(region)=0,"","and A.area_code in('"+region+"')")} 
GROUP BY '0',A.time
)
order by AREA_CODE,decode(time,'新店',1,'次新店',2,'第三年店',3,'第四年店',4,'第五年以上店',5)

select a.area_code,a.time,sum(tran_num) from DM_SHOP A JOIN DM_TRANSACTION B ON A.CUS_CODE=to_char(B.CUS_CODE) and a.area_code=b.area_code AND A.DIMENSION=substr('${LatStartDate}',1,4)
where to_char(b.sale_date,'yyyy-mm-dd') between '${LatStartDate}' and '${LatEndDate}'
and 1=1 ${if(len(region)=0,"","and A.area_code in('"+region+"')")}
group by a.area_code,a.time
UNION

select '0' AS area_code,a.time,sum(tran_num) from DM_SHOP A JOIN DM_TRANSACTION B ON A.CUS_CODE=to_char(B.CUS_CODE) and a.area_code=b.area_code AND A.DIMENSION=substr('${LatStartDate}',1,4)
where to_char(b.sale_date,'yyyy-mm-dd') between '${LatStartDate}' and '${LatEndDate}' 
and 1=1 ${if(len(region)=0,"","and A.area_code in('"+region+"')")}
group by '0',a.time

SELECT  
DISTINCT 
UNION_AREA_NAME
FROM 
DIM_REGION

