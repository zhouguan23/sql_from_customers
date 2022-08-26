
select distinct a.union_area_name,a.area_name,a.area_code,a.trans_party_relation from dim_region a,(select * from USER_AUTHORITY) b,
(select distinct area_code from dm_monthly_company 
where  sale_date>=to_date('${month}','YYYY-MM')
and sale_date<add_months(to_date('${month}','YYYY-MM'),1) and attribute='直营') c
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in ('"+UNION_AREA+"')")} 

and a.area_code=c.area_code

order by a.area_code



select union_area_name,to_char(wm_concat(area_code)) from dim_region
--where  trans_party_relation='Y'
group by union_area_name


select a.area_code,b.area_name,max(to_char(sale_date,'dd')) sale_date,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 销售毛利,
sum(sale_qty)销售数量,
SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
SUM(TAX_AMOUNT) TAX_AMOUNT,
count(distinct a.goods_code) goods_num
from fact_sale a,dim_region b,dim_cus c,age_store s,dim_dtp d
where a.area_code=b.area_code
and a.area_code=c.area_code
and a.cus_code=c.cus_code
and c.attribute='直营'
and A.CUS_CODE = s.CUS_CODE(+)
AND A.AREA_CODE = s.AREA_CODE(+)
AND   to_char(a.sale_date,'YYYY-MM')=s.DATE1(+)
and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH(+)
and a.AREA_CODE=d.AREA_CODE(+) and a.GOODS_CODE=d.GOODS_CODE(+)

--and nvl(a.is_b2c,'否')!='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(dtp)=0, "", " and case when d.goods_code is not null then '是' else '否' end  in ('" + dtp + "')")}
and 1=1 ${if(len(oto)=0, "", " and decode(a.marketing_code,'29058','是','否') in ('" + oto + "')")}

and 1=1 ${if(len(age)=0, "", " and s.age_store in ('" + age + "')")}
and 1=1 ${if(len(b2c)=0, "", " and a.is_b2c in ('" + b2c + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")} 
and sale_date>=to_date('${month}','YYYY-MM')
and sale_date<add_months(to_date('${month}','YYYY-MM'),1)

group by a.area_code,b.area_name
order by a.area_code


select nvl(b.union_area_name,'合计') union_area_name,
count(distinct a.goods_code) goods_num
from fact_sale a,dim_region b,dim_cus c,age_store s,dim_dtp d
where a.area_code=b.area_code
and a.area_code=c.area_code
and a.cus_code=c.cus_code
and c.attribute='直营'
and A.CUS_CODE = s.CUS_CODE(+)
AND A.AREA_CODE = s.AREA_CODE(+)
AND   to_char(a.sale_date,'YYYY-MM')=s.DATE1(+)
and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH(+)
and a.AREA_CODE=d.AREA_CODE(+) and a.GOODS_CODE=d.GOODS_CODE(+)
--and nvl(a.is_b2c,'否')!='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(dtp)=0, "", " and case when d.goods_code is not null then '是' else '否' end  in ('" + dtp + "')")}
and 1=1 ${if(len(oto)=0, "", " and decode(a.marketing_code,'29058','是','否') in ('" + oto + "')")}

and 1=1 ${if(len(age)=0, "", " and s.age_store in ('" + age + "')")}
and 1=1 ${if(len(b2c)=0, "", " and a.is_b2c in ('" + b2c + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")} 
and sale_date>=to_date('${month}','YYYY-MM')
and sale_date<add_months(to_date('${month}','YYYY-MM'),1)

group by rollup(b.union_area_name)

select area_code,sum(NO_tax_cost) no_tax_cost_dc from dm_stock_general
where to_char(ddate,'yyyy-mm')='${month}'
and to_char(ddate+1,'dd')='01'
group by area_code


   select b.area_code,count(distinct a.CUS_CODE) cus_num from dim_cus a
  left join dim_region b
    on a.area_code = b.area_code
 where a.attribute in ('直营')
 --and (VIRTUAL_SHOP is null or VIRTUAL_SHOP='否')
AND
 to_char(open_date,'YYYY-MM')<='${month}'
AND
(
CLOSE_DATE IS NULL
OR
to_char(CLOSE_date,'YYYY-MM' )> '${month}'
)
group by b.area_code

select a.area_code,sum(operating_profit) operating_profit,sum(employee_remuneration) employee_remuneration,sum(rental_fee) rental_fee from fact_store_import a,age_store s,dim_cus c
where a.area_code=c.area_code
and a.cus_code=c.cus_code
and A.CUS_CODE = s.CUS_CODE
AND A.AREA_CODE = s.AREA_CODE
AND s.DATE1='${month}'
and c.attribute='直营'
and a.year ||'-'|| trim(to_char(a.month, '00'))='${month}'
and 1=1 ${if(len(age)=0, "", " and s.age_store in ('" + age + "')")}
group by a.area_code

select a.area_code,sum(tran_num) tran_num from dm_transaction a,age_store s,dim_cus c
where a.area_code=c.area_code
and a.cus_code=c.cus_code
and A.CUS_CODE = s.CUS_CODE
AND A.AREA_CODE = s.AREA_CODE
AND s.DATE1='${month}'
and c.attribute='直营'
and to_char(a.sale_date,'YYYY-MM')='${month}'
group by a.area_code

select a.area_code,sum(NO_tax_cost) NO_tax_cost_md from dm_stock_shop_shop a,dim_cus c,age_store s
where a.area_code=c.area_code
and a.cus_code=c.cus_code
and A.CUS_CODE = s.CUS_CODE
AND A.AREA_CODE = s.AREA_CODE
AND s.DATE1='${month}'
and c.attribute='直营'
and to_char(ddate,'yyyy-mm')='${month}'
and to_char(ddate+1,'dd')='01'
and 1=1 ${if(len(age)=0, "", " and s.age_store in ('" + age + "')")}
group by a.area_code

select * from age_store a,dim_cus c
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and  DATE1='${month}'
and a.area_code=c.area_code
and a.cus_code=c.cus_code
and c.attribute='直营'



select AREA_CODE,

(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as dczzts,


(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
(sum(nvl(dckc,0))+sum(nvl(zykc,0)))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as zzzts,

(case when sum(nvl(zycb,0))=0 then null else
sum(nvl(zykc,0))/sum(nvl(zycb,0))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as zyzzts



from DM_TURNOVER_ALL
where date1='${month}'
and 1=1
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}


group by area_code



select r.union_area_name,

(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as dczzts,


(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
(sum(nvl(dckc,0))+sum(nvl(zykc,0)))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as zzzts,

(case when sum(nvl(zycb,0))=0 then null else
sum(nvl(zykc,0))/sum(nvl(zycb,0))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as zyzzts



from DM_TURNOVER_ALL a,dim_region r
where date1='${month}'
and a.area_code=r.area_code
and 1=1
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}

group by r.union_area_name
union all
select  '全国'  as union_area_name,

(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0)))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as dczzts,


(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0)))=0 then null else
(sum(nvl(dckc,0))+sum(nvl(zykc,0)))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0)))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as zzzts,

(case when sum(nvl(zycb,0))=0 then null else
sum(nvl(zykc,0))/sum(nvl(zycb,0))*(max(to_char(add_months(to_date(date1,'yyyy-mm'),1)-1,'dd'))) end) as zyzzts



from DM_TURNOVER_ALL 
where date1='${month}'
and 1=1
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}


select * from dim_region
order by 2

