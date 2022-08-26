select distinct a.union_area_name,a.area_code,a.area_name,b.cus_code,b.cus_name from dim_region a
left join dim_cus b
on a.area_code=b.area_code
join dim_member_day_pre c
on a.area_code=c.area_code
and b.cus_code=c.cus_code
where ${if(len(area_code)==0,"1=1","A.area_code in ('"+area_code+"')")}
and ${if(len(union_area)==0,"1=1","A.union_area_name in ('"+union_area+"')")}
and ${if(len(attribute)==0,"1=1","b.attribute in ('"+attribute+"')")}
and c.day_type is not null

select A.area_code,d.cus_code,sum(A.tax_amount) as tax_amount,sum(tax_amount)-sum(A.tax_cost) as tax_profit,sum(origin_amount) origin_amount,count(distinct sale_date) sale_date
from dm_sale_tmp A
left join dim_cus D on A.area_code=D.area_code and A.cus_code=D.cus_code
left join dim_member_day m
on a.sale_date=m.ddate
and a.area_code=m.area_code
and a.cus_code=m.cus_code
where A.sale_date between date'${start}' and date'${end}'
and m.ddate is not null 
and ${if(len(sale_date)==0,"1=1","A.sale_date not  in ('"+sale_date+"')")} 
and 
${if(len(area_code)==0,"1=1","A.area_code in ('"+area_code+"')")} 
and ${if(len(dtp)==0,"1=1","A.dtp in ('"+dtp+"')")} 
and ${if(len(oto)==0,"1=1","A.oto in ('"+oto+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by A.area_code,d.cus_code

select A.area_code,d.cus_code,sum(A.tax_amount) as tax_amount,sum(tax_amount)-sum(A.tax_cost) as tax_profit,sum(origin_amount) origin_amount,count(distinct sale_date) sale_date
from dm_sale_tmp A
left join dim_cus D on A.area_code=D.area_code and A.cus_code=D.cus_code
left join dim_member_day m
on a.sale_date=m.ddate
and a.area_code=m.area_code
and a.cus_code=m.cus_code
left join (select distinct area_code,cus_code from dim_member_day) m1
on  a.area_code=m1.area_code
and a.cus_code=m1.cus_code
where A.sale_date between date'${start}' and date'${end}'
and m.ddate is  null 
and m1.cus_code is not null 
and ${if(len(sale_date)==0,"1=1","A.sale_date not  in ('"+sale_date+"')")} 
and 
${if(len(area_code)==0,"1=1","A.area_code in ('"+area_code+"')")} 
and ${if(len(dtp)==0,"1=1","A.dtp in ('"+dtp+"')")} 
and ${if(len(oto)==0,"1=1","A.oto in ('"+oto+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by A.area_code,d.cus_code

select A.area_code,d.cus_code,sum(A.tax_amount) as tax_amount,sum(tax_amount)-sum(A.tax_cost) as tax_profit,sum(origin_amount) origin_amount,count(distinct sale_date) sale_date
from dm_sale_tmp A
left join dim_cus D on A.area_code=D.area_code and A.cus_code=D.cus_code
left join dim_member_day m
on a.sale_date=m.ddate
and a.area_code=m.area_code
and a.cus_code=m.cus_code
where A.sale_date between date'${start}' and date'${end}'
and m.ddate is not null 
and a.vip='是'
and ${if(len(sale_date)==0,"1=1","A.sale_date not  in ('"+sale_date+"')")} 
and 
${if(len(area_code)==0,"1=1","A.area_code in ('"+area_code+"')")} 
and ${if(len(dtp)==0,"1=1","A.dtp in ('"+dtp+"')")} 
and ${if(len(oto)==0,"1=1","A.oto in ('"+oto+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by A.area_code,d.cus_code

select A.area_code,d.cus_code,sum(A.tax_amount) as tax_amount,sum(tax_amount)-sum(A.tax_cost) as tax_profit,sum(origin_amount) origin_amount,count(distinct sale_date) sale_date
from dm_sale_tmp A
left join dim_cus D on A.area_code=D.area_code and A.cus_code=D.cus_code
left join dim_member_day m
on a.sale_date=m.ddate
and a.area_code=m.area_code
and a.cus_code=m.cus_code
left join (select distinct area_code,cus_code from dim_member_day) m1
on  a.area_code=m1.area_code
and a.cus_code=m1.cus_code
where A.sale_date between date'${start}' and date'${end}'
and m.ddate is  null 
and m1.cus_code is not null 
and a.vip='是'
and ${if(len(sale_date)==0,"1=1","A.sale_date not  in ('"+sale_date+"')")} 
and 
${if(len(area_code)==0,"1=1","A.area_code in ('"+area_code+"')")} 
and ${if(len(dtp)==0,"1=1","A.dtp in ('"+dtp+"')")} 
and ${if(len(oto)==0,"1=1","A.oto in ('"+oto+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by A.area_code,d.cus_code

select t.area_code,t.cus_code,sum(t.tran_num) tran_num from dm_transaction t
left join dim_member_day m
on t.sale_date=m.ddate
and t.area_code=m.area_code
and t.cus_code=m.cus_code
left join dim_cus d
on t.area_code=d.area_code
and t.cus_code=d.cus_code
 where t.sale_date between date'${start}' and date'${end}'
 and m.ddate is not null 
and ${if(len(sale_date)==0,"1=1","t.sale_date not  in ('"+sale_date+"')")} 
and 
${if(len(area_code)==0,"1=1","t.area_code in ('"+area_code+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by t.area_code,t.cus_code

select t.area_code,t.cus_code,sum(t.tran_num) tran_num from dm_transaction t
left join dim_member_day m
on t.sale_date=m.ddate
and t.area_code=m.area_code
and t.cus_code=m.cus_code
left join dim_cus d
on t.area_code=d.area_code
and t.cus_code=d.cus_code
 where t.sale_date between date'${start}' and date'${end}'
 and m.ddate is  null 
and ${if(len(sale_date)==0,"1=1","t.sale_date not  in ('"+sale_date+"')")} 
and 
${if(len(area_code)==0,"1=1","t.area_code in ('"+area_code+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by t.area_code,t.cus_code

select t.area_code,t.cus_code,sum(t.tran_num) tran_num from dm_transaction t
left join dim_member_day m
on t.sale_date=m.ddate
and t.area_code=m.area_code
and t.cus_code=m.cus_code
left join (select distinct area_code,cus_code from dim_member_day) m1
on  t.area_code=m1.area_code
and t.cus_code=m1.cus_code
left join dim_cus d
on t.area_code=d.area_code
and t.cus_code=d.cus_code
 where t.sale_date between date'${start}' and date'${end}'
 and m.ddate is not  null 
and m1.cus_code is not null 
and t.is_vip='Y'
and ${if(len(sale_date)==0,"1=1","t.sale_date not  in ('"+sale_date+"')")} 
and 
${if(len(area_code)==0,"1=1","t.area_code in ('"+area_code+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by t.area_code,t.cus_code

select t.area_code,t.cus_code,sum(t.tran_num) tran_num from dm_transaction t
left join dim_member_day m
on t.sale_date=m.ddate
and t.area_code=m.area_code
and t.cus_code=m.cus_code
left join (select distinct area_code,cus_code from dim_member_day) m1
on  t.area_code=m1.area_code
and t.cus_code=m1.cus_code
left join dim_cus d
on t.area_code=d.area_code
and t.cus_code=d.cus_code
 where t.sale_date between date'${start}' and date'${end}'
 and m.ddate is   null 
and m1.cus_code is not null 
and t.is_vip='Y'
and ${if(len(sale_date)==0,"1=1","t.sale_date not  in ('"+sale_date+"')")} 
and 
${if(len(area_code)==0,"1=1","t.area_code in ('"+area_code+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by t.area_code,t.cus_code

SELECT DISTINCT union_area_name,area_code,AREA_NAME
FROM  
DIM_REGION 
where 

 ${if(len(union_area)==0,"1=1","union_area_name in ('"+union_area+"')")}



select distinct area_code,cus_code, listagg(to_char(ddate,'mm-dd'),',')  within group(order by area_code, cus_code) member_day from dim_member_day 
where ddate between date'${start}' and date'${end}'
group by area_code,cus_code

select area_code,cus_code,count(*) day_cnt from dim_member_day

where ddate between date'${start}' and date'${end}'
group by area_code,cus_code


select 
area_code,
cus_code,
count(goods_code) xdb
from
(
select
a.area_code,
a.cus_code,
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
left join dim_member_day m
on a.area_code=m.area_code
and a.cus_code=m.cus_code
and a.sale_date=m.ddate
where a.SALE_DATE between date'${start}' and date'${end}'
and m.ddate is not null 
and ${if(len(sale_date)==0,"1=1","A.sale_date not  in ('"+sale_date+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
group by area_code,cus_code


select 
area_code,
cus_code,
count(goods_code) xdb
from
(
select
a.area_code,
a.cus_code,
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
left join dim_member_day m
on a.area_code=m.area_code
and a.cus_code=m.cus_code
and a.sale_date=m.ddate
left join (select distinct area_code,cus_code from dim_member_day) m1
on  a.area_code=m1.area_code
and a.cus_code=m1.cus_code
where a.SALE_DATE between date'${start}' and date'${end}'
and m.ddate is  null 
and m1.cus_code is not null
and ${if(len(sale_date)==0,"1=1","A.sale_date not  in ('"+sale_date+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
group by area_code,cus_code


select 
area_code,
cus_code,
count(goods_code) xdb
from
(
select
a.area_code,
a.cus_code,
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
left join dim_member_day m
on a.area_code=m.area_code
and a.cus_code=m.cus_code
and a.sale_date=m.ddate
where a.SALE_DATE between date'${start}' and date'${end}'
and m.ddate is not null 
AND A.VIP='是'
and ${if(len(sale_date)==0,"1=1","A.sale_date not  in ('"+sale_date+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
group by area_code,cus_code


select 
area_code,
cus_code,
count(goods_code) xdb
from
(
select
a.area_code,
a.cus_code,
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
left join dim_member_day m
on a.area_code=m.area_code
and a.cus_code=m.cus_code
and a.sale_date=m.ddate
left join (select distinct area_code,cus_code from dim_member_day) m1
on  a.area_code=m1.area_code
and a.cus_code=m1.cus_code
where a.SALE_DATE between date'${start}' and date'${end}'
and m.ddate is  null
and m1.cus_code is not null 
AND A.VIP='是'
and ${if(len(sale_date)==0,"1=1","A.sale_date not  in ('"+sale_date+"')")} 
and ${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
group by area_code,cus_code

select trunc(ddate) ddate,to_char(ddate,'YYYY-MM-DD') DDATE_CHAR from dim_day
where ddate between date'${start}' and date'${end}'

