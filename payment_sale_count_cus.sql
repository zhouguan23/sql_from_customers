select 
a.cus_code 门店编码,
b.cus_name 门店名称,
a.area_code 区域编码,
       c.area_name 区域名称,
       a.marketing_code 收款方式编码,
       d.marketing_name 收款方式名称,
       sum(tax_amount) 直营销售额
from dm_payment a,dim_cus b,dim_region c,dim_marketing_all d   
where a.area_code=b.area_code
and a.cus_code=b.cus_code
and b.attribute='直营'
and a.area_code=c.area_code
and a.area_code=d.area_code
and a.marketing_code=d.marketing_code
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(marketing)=0, "", " and a.marketing_code in ('" + marketing + "')")}
and 1=1 ${if(len(cus)=0,"","and  a.cus_code ='"+cus+"'")}
and 1=1 ${if(len(oto)=0,"","and  nvl(d.oto,'N') ='"+oto+"'")}
and 1=1 ${if(len(b2c)=0,"","and  nvl(d.b2c,'N') ='"+b2c+"'")}
group by a.area_code,c.area_name,a.marketing_code,d.marketing_name,a.cus_code,
b.cus_name
order by a.area_code,a.cus_code,a.marketing_code

--直营销售同比
select 
a.cus_code 门店编码,
a.area_code 区域编码,
       a.marketing_code 收款方式编码,
       sum(tax_amount) 直营销售同比
from dm_payment a,dim_cus b,dim_region c,dim_marketing_all d   
where a.area_code=b.area_code
and a.cus_code=b.cus_code
and b.attribute='直营'
and a.area_code=c.area_code
and a.area_code=d.area_code
and a.marketing_code=d.marketing_code
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(marketing)=0, "", " and a.marketing_code in ('" + marketing + "')")}
and 1=1 ${if(len(cus)=0,"","and  a.cus_code ='"+cus+"'")}
and 1=1 ${if(len(oto)=0,"","and  nvl(d.oto,'N') ='"+oto+"'")}
and 1=1 ${if(len(b2c)=0,"","and  nvl(d.b2c,'N') ='"+b2c+"'")}
group by a.area_code,c.area_name,a.marketing_code,d.marketing_name,a.cus_code
order by a.area_code,a.marketing_code

--直营销售环比
select 
a.cus_code 门店编码,
a.area_code 区域编码,
       a.marketing_code 收款方式编码,
       sum(tax_amount) 直营销售环比
from dm_payment a,dim_cus b,dim_region c,dim_marketing_all d   
where a.area_code=b.area_code
and a.cus_code=b.cus_code
and b.attribute='直营'
and a.area_code=c.area_code
and a.area_code=d.area_code
and a.marketing_code=d.marketing_code
and a.sale_date between date'${start_date1}' and date'${end_date1}'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(marketing)=0, "", " and a.marketing_code in ('" + marketing + "')")}
and 1=1 ${if(len(cus)=0,"","and  a.cus_code ='"+cus+"'")}
and 1=1 ${if(len(oto)=0,"","and  nvl(d.oto,'N') ='"+oto+"'")}
and 1=1 ${if(len(b2c)=0,"","and  nvl(d.b2c,'N') ='"+b2c+"'")}
group by a.area_code,c.area_name,a.marketing_code,d.marketing_name,a.cus_code
order by a.area_code,a.marketing_code

select distinct marketing_code,marketing_code||'|'||marketing_name as marketing_name from dim_marketing_all
order by 1

