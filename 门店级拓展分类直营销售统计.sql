select
* from
(
--无税新老店
select
1 flag,
b.cus_code,
b.cus_name,
c.area_code,
c.area_name,
c.UNION_AREA_NAME,
case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}' then '新店' 
when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1 then '次新店'
when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1 then '老店'
end as AIM,
sum(nvl(NO_TAX_AMOUNT,0)) as NO_TAX_AMOUNT,
sum(nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0)) as SALE_ML,
sum(case when DTP='否' then nvl(NO_TAX_AMOUNT,0) end) NDTP_NO_TAX_AMOUNT,
sum(case when DTP='否' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) NDTP_NO_SALE_ML,

sum(case when DTP='是' then nvl(NO_TAX_AMOUNT,0) end) DTP_NO_TAX_AMOUNT,
sum(case when DTP='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) DTP_NO_SALE_ML,

sum(case when OTO='是' then nvl(NO_TAX_AMOUNT,0) end) OTO_NO_TAX_AMOUNT,
sum(case when OTO='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) OTO_NO_SALE_ML,

sum(case when a.VIP='是' then nvl(ORIGIN_AMOUNT,0) end) ORIGIN_AMOUNT,
sum(case when a.VIP='是' then nvl(NO_TAX_AMOUNT,0) end) VIP_NO_TAX_AMOUNT,
sum(case when a.VIP='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) VIP_NO_SALE_ML


from dim_cus b,dim_region c ,DM_SALE_TMP a 
left join AGE_STORE d 
on a.area_code=d.area_code and a.cus_code=d.cus_code and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.DATE1   
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营' 
group by b.cus_code,b.cus_name,c.area_code,c.area_name,c.UNION_AREA_NAME,
case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}' then '新店' 
when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1 then '次新店'
when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1 then '老店'
end

union all
--含税新老店
select
0 flag,
b.cus_code,
b.cus_name,
c.area_code,
c.area_name,
c.UNION_AREA_NAME,
case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}' then '新店' 
when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1 then '次新店'
when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1 then '老店'
end as AIM,
sum(nvl(TAX_AMOUNT,0)) as TAX_AMOUNT,
sum(nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)) as SALE_ML,
sum(case when DTP='否' then nvl(TAX_AMOUNT,0) end) NDTP_TAX_AMOUNT,
sum(case when DTP='否' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) NDTP_NO_SALE_ML,

sum(case when DTP='是' then nvl(TAX_AMOUNT,0) end) DTP_TAX_AMOUNT,
sum(case when DTP='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) DTP_NO_SALE_ML,

sum(case when OTO='是' then nvl(TAX_AMOUNT,0) end) OTO_TAX_AMOUNT,
sum(case when OTO='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) OTO_NO_SALE_ML,

sum(case when a.VIP='是' then nvl(ORIGIN_AMOUNT,0) end) ORIGIN_AMOUNT,
sum(case when a.VIP='是' then nvl(TAX_AMOUNT,0) end) VIP_TAX_AMOUNT,
sum(case when a.VIP='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) VIP_NO_SALE_ML


from dim_cus b,dim_region c ,DM_SALE_TMP a 
left join AGE_STORE d 
on a.area_code=d.area_code and a.cus_code=d.cus_code and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.DATE1   
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营' 
group by b.cus_code,b.cus_name,c.area_code,c.area_name,c.UNION_AREA_NAME,
case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}' then '新店' 
when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1 then '次新店'
when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1 then '老店'
end

union all
--含税直营收购
select 
0 flag,
b.cus_code,
b.cus_name,
c.area_code,
c.area_name,
c.UNION_AREA_NAME,
'直营收购' AIM,
sum(nvl(TAX_AMOUNT,0)) as TAX_AMOUNT,
sum(nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)) as SALE_ML,
sum(case when DTP='否' then nvl(TAX_AMOUNT,0) end) NDTP_TAX_AMOUNT,
sum(case when DTP='否' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) NDTP_NO_SALE_ML,

sum(case when DTP='是' then nvl(TAX_AMOUNT,0) end) DTP_TAX_AMOUNT,
sum(case when DTP='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) DTP_NO_SALE_ML,

sum(case when OTO='是' then nvl(TAX_AMOUNT,0) end) OTO_TAX_AMOUNT,
sum(case when OTO='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) OTO_NO_SALE_ML,

sum(case when a.VIP='是' then nvl(ORIGIN_AMOUNT,0) end) ORIGIN_AMOUNT,
sum(case when a.VIP='是' then nvl(TAX_AMOUNT,0) end) VIP_TAX_AMOUNT,
sum(case when a.VIP='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) VIP_NO_SALE_ML

from dim_cus b,dim_region c ,DM_SALE_TMP a 
left join AGE_STORE d 
on a.area_code=d.area_code and a.cus_code=d.cus_code and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.DATE1   
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营' 
and d.AGE_STORE='直营收购' 
group by b.cus_code,b.cus_name,c.area_code,c.area_name,c.UNION_AREA_NAME
 

union all

--无税直营收购
select 
1 flag,
b.cus_code,
b.cus_name,
c.area_code,
c.area_name,
c.UNION_AREA_NAME,
'直营收购' AIM,
sum(nvl(NO_TAX_AMOUNT,0)) as NO_TAX_AMOUNT,
sum(nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0)) as SALE_ML,
sum(case when DTP='否' then nvl(NO_TAX_AMOUNT,0) end) NDTP_NO_TAX_AMOUNT,
sum(case when DTP='否' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) NDTP_NO_SALE_ML,

sum(case when DTP='是' then nvl(NO_TAX_AMOUNT,0) end) DTP_NO_TAX_AMOUNT,
sum(case when DTP='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) DTP_NO_SALE_ML,

sum(case when OTO='是' then nvl(NO_TAX_AMOUNT,0) end) OTO_NO_TAX_AMOUNT,
sum(case when OTO='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) OTO_NO_SALE_ML,

sum(case when a.VIP='是' then nvl(ORIGIN_AMOUNT,0) end) ORIGIN_AMOUNT,
sum(case when a.VIP='是' then nvl(NO_TAX_AMOUNT,0) end) VIP_NO_TAX_AMOUNT,
sum(case when a.VIP='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) VIP_NO_SALE_ML

from dim_cus b,dim_region c ,DM_SALE_TMP a 
left join AGE_STORE d 
on a.area_code=d.area_code and a.cus_code=d.cus_code and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.DATE1   
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营' 
and d.AGE_STORE='直营收购' 
group by b.cus_code,b.cus_name,c.area_code,c.area_name,c.UNION_AREA_NAME

union all 



select 
0 flag,
b.cus_code,
b.cus_name,
c.area_code,
c.area_name,
c.UNION_AREA_NAME,
'直营收购' AIM,
sum(nvl(TAX_AMOUNT,0)) as TAX_AMOUNT,
sum(nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)) as SALE_ML,
sum(case when DTP='否' then nvl(TAX_AMOUNT,0) end) NDTP_TAX_AMOUNT,
sum(case when DTP='否' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) NDTP_NO_SALE_ML,

sum(case when DTP='是' then nvl(TAX_AMOUNT,0) end) DTP_TAX_AMOUNT,
sum(case when DTP='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) DTP_NO_SALE_ML,

sum(case when OTO='是' then nvl(TAX_AMOUNT,0) end) OTO_TAX_AMOUNT,
sum(case when OTO='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) OTO_NO_SALE_ML,

sum(case when a.VIP='是' then nvl(ORIGIN_AMOUNT,0) end) ORIGIN_AMOUNT,
sum(case when a.VIP='是' then nvl(TAX_AMOUNT,0) end) VIP_TAX_AMOUNT,
sum(case when a.VIP='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) VIP_NO_SALE_ML

from dim_cus b,dim_region c ,DM_SALE_TMP a 
left join AGE_STORE d 
on a.area_code=d.area_code and a.cus_code=d.cus_code and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.DATE1   
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营' 
and d.AGE_STORE='直营收购' 
group by b.cus_code,b.cus_name,c.area_code,c.area_name,c.UNION_AREA_NAME
)
where 1=1
${if(len(flag)=0,"","and flag ='"+flag+"'")}
${if(len(AIM)=0,""," and AIM in ('"+AIM+"')")}
${if(len(UNIONAREA)=0,""," and UNION_AREA_NAME in ('"+UNIONAREA+"')")}
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
order by area_code,cus_code

select 
area_code,
cus_code,
sum(TRAN_NUM) TRAN_NUM,
sum(case when IS_VIP='Y' then TRAN_NUM end ) vip_TRAN_NUM
from DM_TRANSACTION
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
group by area_code,
cus_code

select distinct
UNION_AREA_NAME,
area_code,
area_name
from dim_region
where 1=1
${if(len(UNIONAREA)=0,""," and UNION_AREA_NAME in ('"+UNIONAREA+"')")}
order by area_code

select distinct
area_code,
cus_code,
cus_name,
cus_code||'|'||cus_name
from dim_cus
where 1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
order by area_code,cus_code


select 
distinct 
area_code,
cus_code,
OPEN_DATE,
HEALTH_CARE,
SHOP_AREA,
EMPLOYEE_NUMBER
from 
dim_cus

select 
a.area_code,
a.cus_code,
count(distinct goods_code) sku
from fact_sale a ,dim_cus b
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and b.attribute='直营' 
group by a.area_code,
a.cus_code

