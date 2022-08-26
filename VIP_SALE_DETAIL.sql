select A.area_code,A.cus_code,B.CUS_NAME,f.goods_code,lot,C.BIG_CATE,C.GOODS_NAME,
C.SPECIFICATION,C.MANUFACTURER,sum(delivery_qty) as delivery_qty ,sum(no_tax_amount) as no_tax_amount,sum(no_tax_Cost) as no_tax_Cost ,sum(tax_amount) as tax_amount,sum(tax_cost) as tax_cost
from dm_vip_shop A 
left join dim_cus b on a.area_code=b.area_code and a.cus_code=b.cus_code
LEFT JOIN DIM_GOODS C on a.goods_code=c.goods_code
LEFT JOIN DIM_dtp D on a.area_code=d.area_code and a.goods_code=d.goods_code and
D.create_month=to_char(add_months(A.sale_date,-1),'yyyy-mm')
LEFT JOIN dim_net_catalogue_general_all E on a.area_code=e.area_code and a.goods_code=E.goods_code and
E.create_month=to_char(A.sale_date,'yyyy-mm')
left join dim_disable_code F  on a.goods_code=f.disable_code
where 
B.VIP = '是'
AND 
sale_date >= to_date('${StartDate}','yyyy/mm/dd') and sale_date <= to_date('${EndDate}','yyyy/mm/dd') and
${if(len(area_code)==0,"1=1","A.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","A.cus_code in ('"+cus_code+"')")} and
${if(len(goods_code)==0,"1=1","f.goods_code in ('"+goods_code+"')")} and
${if(len(DTP)==0,"1=1","(case when D.goods_code is null then '否' Else '是' end) in ('"+DTP+"')")} and
${if(len(gather)==0,"1=1","(case when E.new_attribute is null then '地采' else e.new_attribute end)
in ('"+gather+"')")}
group by A.area_code,A.cus_code,B.CUS_NAME,f.goods_code,lot,C.BIG_CATE,C.GOODS_NAME,
C.SPECIFICATION,C.MANUFACTURER
order by 1,2,4

select distinct A.area_code,F.area_name
from dm_vip_shop A 
LEFT JOIN dim_region F on a.area_code=f.area_code
where sale_date >= to_date('${StartDate}','yyyy/mm/dd') and sale_date <= to_date('${EndDate}','yyyy/mm/dd')
order by 1

select distinct cus_code,cus_code || '|' ||cus_name as cus_name from dim_cus where 1=1
${if(len(area_code)==0,"","and area_code in ('"+area_code+"')")}
AND     
VIP = '是'
order by 1

select distinct f.goods_code,C.GOODS_NAME
from dm_vip_shop A 
left join dim_cus b on a.area_code=b.area_code and a.cus_code=b.cus_code
LEFT JOIN DIM_GOODS C on a.goods_code=c.goods_code
LEFT JOIN DIM_dtp D on a.area_code=d.area_code and a.goods_code=d.goods_code and
D.create_month=to_char(add_months(A.sale_date,-1),'yyyy-mm')
LEFT JOIN dim_net_catalogue_general_all E on a.area_code=e.area_code and a.goods_code=E.goods_code 
AND
E.create_month=to_char(A.sale_date,'yyyy-mm')
left join dim_disable_code F on a.goods_code=f.disable_code
where 
B.VIP = '是'
AND
sale_date >= to_date('${StartDate}','yyyy/mm/dd') and sale_date <= to_date('${EndDate}','yyyy/mm/dd') and
${if(len(area_code)==0,"1=1","A.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","A.cus_code in ('"+cus_code+"')")} and
${if(len(DTP)==0,"1=1","(case when D.area_code is null then '是' Else '否' end) in ('"+DTP+"')")} and
${if(len(gather)==0,"1=1","(case when E.new_attribute is null then '地采' else e.new_attribute end)
in ('"+gather+"')")}
AND  ROWNUM <= 5000

select distinct new_attribute from dim_net_catalogue_general_all
union
select '地采' as new_attribute from dual

SELECT DISTINCT AREA_NAME
FROM  
DIM_REGION 
WHERE  
AREA_CODE IN ('${area_code}')

SELECT DISTINCT CUS_NAME
FROM  
DIM_CUS 
WHERE  
AREA_CODE IN ('${area_code}') and
CUS_CODE IN ('${cus_code}')


