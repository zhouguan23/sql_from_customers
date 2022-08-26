select distinct nvl(sub_category,'空') from dim_goods
 where 1=1 ${if(len(category)=0,"","and  nvl(sub_category,'空') in ('"+category+"')")}


select aa.area_code,
       aa.area_name,
       aa.sub_category,
       aa.no_tax_amount,
       aa.no_tax_ml,
       aa.no_mll_rate,
       decode(aa.no_tax_amount,0,0,(aa.no_tax_amount / (SUM(aa.no_tax_amount) over(PARTITION BY aa.area_code)))) sum_no_tax_amount,
       decode(aa.no_tax_ml,0,0,(aa.no_tax_ml /(SUM(aa.no_tax_ml) over(PARTITION BY aa.area_code))))  sum_no_tax_ml
 from
(

select area_code,
       area_name,
       sub_category,
       no_tax_amount,
       no_tax_ml,
       decode(no_tax_amount,0,0,no_tax_ml/no_tax_amount) no_mll_rate

from (
select fs.area_code,
       dr.area_name,
       nvl(fs.sub_category,'空') sub_category, 
       --decode('${is_vat}','含税',sum(fs.tax_amount),sum(fs.no_tax_amount)) no_tax_amount,
       --decode('${is_vat}','含税',sum(fs.tax_ml),sum(fs.no_tax_ml)) no_tax_ml,
       (case when '${is_vat}'='无税' then (case when '${is_gljy}' = '1' then sum(case when is_gljy='1' then no_tax_amount end) when '${is_gljy}' = '0' then sum(case when is_gljy='0' then no_tax_amount end )else sum(no_tax_amount)end) else (case when '${is_gljy}' = '1' then sum(case when is_gljy='1' then tax_amount end) when '${is_gljy}' = '0' then sum(case when is_gljy='0' then tax_amount end )else sum(tax_amount)end)end)  as no_tax_amount,
       (case when '${is_vat}'='无税'  then (case when '${is_gljy}' = '1' then sum(case when is_gljy = '1' then no_tax_ml else null end) else sum(no_tax_ml) end)  ELSE (case when '${is_gljy}' = '1' then sum(case when is_gljy = '1' then tax_ml else null end) else sum(tax_ml) end) end) as no_tax_ml

       
       
  from dw_sale_dept_type fs,dim_region dr
  ,USER_AUTHORITY b

 where fs.area_code=dr.area_code
   --and fs.sale_date between to_date('2020-03-01','yyyy-mm-dd') and to_date('2020-03-31','yyyy-mm-dd')
   --and fs.is_gljy='0'
   and (dr.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
   and ${"b.user_id='"+$fr_username+"'"}
   and fs.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
   and ${if(len(oto) = 0, "1=1", "  fs.oto='" + oto + "'")}   
   and ${if(len(region) = 0, "1=1", "  dr.area_code in ('"+region+"')") }
   and ${if(len(sale_type) = 0, "1=1", "  fs.busy_type in ('"+sale_type+"')") }
   and ${if(len(is_dtp) = 0, "1=1", "  fs.is_dtp='" + is_dtp + "'")}
   and ${if(len(is_jicai) = 0, "1=1", "  fs.is_jicai='" + is_jicai + "'")}
   --and ${if(len(is_gljy) = 0, "1=1", "  fs.is_gljy='" + is_gljy + "'")}
   and 1=1 ${if(len(category)=0,"","and nvl(fs.sub_category,'空') in ('"+category+"')")}
 group by fs.area_code,dr.area_name,fs.sub_category
 )
 ) aa order by area_code,sub_category

select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(region)=0,""," and a.area_code in ('"+region+"')")} 

