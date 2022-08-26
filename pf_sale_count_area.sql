select a.area_code,
       b.area_name,
       sum(no_tax_amount)                                       批发销售额,
       nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)        毛利
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='批发'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(rpt)=0,"","and a.related_party_trnsaction  ='"+rpt+"'")}
group by a.area_code,b.area_name

--批发销售同比
select a.area_code,
       b.area_name,
       sum(no_tax_amount)                                       批发销售同比,
       nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)        毛利同比
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='批发'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(rpt)=0,"","and a.related_party_trnsaction  ='"+rpt+"'")}
group by a.area_code,b.area_name


--批发销售环比
select a.area_code,
       b.area_name,
       sum(no_tax_amount)                                       批发销售环比,
       nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)        毛利环比
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='批发'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-1) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-1)
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(rpt)=0,"","and a.related_party_trnsaction  ='"+rpt+"'")}
group by a.area_code,b.area_name


select distinct area_code,area_name from dim_region 
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
order by area_code

select a.area_code,
       b.area_name,
       sum(no_tax_amount)                                       批发销售额,
       nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)        毛利
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='批发'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(rpt)=0,"","and a.related_party_trnsaction  ='"+rpt+"'")}
group by a.area_code,b.area_name
order by 1

--批发销售环比
select a.area_code,
       b.area_name,
       sum(no_tax_amount)                                       批发销售环比,
       nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)        毛利环比
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='批发'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-1) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-1)
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by a.area_code,b.area_name


--批发销售同比
select a.area_code,
       b.area_name,
       sum(no_tax_amount)                                       批发销售同比,
       nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)        毛利同比
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='批发'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}

group by a.area_code,b.area_name


