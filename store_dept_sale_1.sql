select distinct nvl(sub_category,'空') from dim_goods
 --where 1=1 ${if(len(category)=0,"","and  sub_CATEGORY in ('"+category+"')")}

select dr.union_area_name,
       fs.area_code,
       dr.area_name,
       ds.cus_code,
       ds.cus_name,
       nvl(fs.sub_category,'空') sub_category,
       sum(fs.no_tax_amount) no_tax_amount,
       sum(fs.no_tax_ml) no_tax_ml,
       round(decode(sum(fs.no_tax_amount),0,0,(sum(fs.no_tax_ml))/sum(fs.no_tax_amount)),2) no_mll_rate
  from dw_store_dept_sale fs,dim_region dr,dim_cus ds

 where fs.area_code=dr.area_code
   and fs.cus_code=ds.cus_code
   and fs.area_code=ds.area_code
   and fs.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
   and ${if(len(oto) = 0, "1=1", "  fs.oto='" + oto + "'")}
   and ${if(len(region) = 0, "1=1", "  dr.area_code in ('"+region+"')") }
   and ${if(len(union_area) = 0, "1=1", "  dr.union_area_name in ('"+union_area+"')") }
   and ${if(len(is_dtp) = 0, "1=1", "  fs.is_dtp='" + is_dtp + "'")}
   and ${if(len(is_jicai) = 0, "1=1", "  fs.is_jicai='" + is_jicai + "'")}
   and ${if(len(age_store) = 0, "1=1", "  fs.age_store in ('" + age_store + "')")}
   and ${if(len(cus_code) = 0, "1=1", "  ds.cus_code in ('"+cus_code+"')") }
   --and ${if(len(cus_name) = 0, "1=1", "  ds.cus_name in ('"+cus_name+"')") }
   and 1=1 ${if(len(category)=0,"","and nvl(fs.sub_category,'空') in ('"+category+"')")}
 group by dr.union_area_name,fs.area_code,dr.area_name,ds.cus_code,ds.cus_name,fs.sub_category
 order by fs.area_code,ds.cus_code,fs.sub_category

select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
--${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1

select distinct age_store from gygd_bi.age_store

select fs.area_code,
       dr.area_name,
       ds.cus_code,
       ds.cus_name,
       sum(fs.no_tax_amount) no_tax_amount,
       sum(fs.no_tax_ml) no_tax_ml,
       round(decode(sum(fs.no_tax_amount),0,0,(sum(fs.no_tax_ml))/sum(fs.no_tax_amount)),2)*100||'%' no_mll_rate
  from dw_store_dept_sale fs,dim_region dr,dim_cus ds

 where fs.area_code=dr.area_code
   and fs.cus_code=ds.cus_code
   and fs.area_code=ds.area_code
   and fs.sale_date >= to_date('${sale_date1}', 'yyyy-mm-dd') and fs.sale_date<= to_date('${sale_date2}', 'yyyy-mm-dd')
   and ${if(len(oto) = 0, "1=1", "  fs.oto='" + oto + "'")}
   and ${if(len(region) = 0, "1=1", "  dr.area_code in ('"+region+"')") }
   and ${if(len(is_dtp) = 0, "1=1", "  fs.is_dtp='" + is_dtp + "'")}
   and ${if(len(is_jicai) = 0, "1=1", "  fs.is_jicai='" + is_jicai + "'")}
   and ${if(len(age_store) = 0, "1=1", "  fs.age_store in ('" + age_store + "')")}
 group by fs.area_code,dr.area_name,ds.cus_code,ds.cus_name

select distinct cus_code,cus_name from dim_cus
where ${if(len(region) = 0, "1=1", "  area_code in ('"+region+"')") }

select fs.area_code,
       dr.area_name,
       ds.cus_code,
       ds.cus_name,
       nvl(fs.sub_category,'空') sub_category,
       sum(fs.no_tax_amount) no_tax_amount,
       sum(fs.no_tax_ml) no_tax_ml,
       round(decode(sum(fs.no_tax_amount),0,0,(sum(fs.no_tax_ml))/sum(fs.no_tax_amount)),2) no_mll_rate
  from dw_store_dept_sale fs,dim_region dr,dim_cus ds

 where fs.area_code=dr.area_code
   and fs.cus_code=ds.cus_code
   and fs.area_code=ds.area_code
   --and fs.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
   and fs.sale_date between add_months(to_date('${sale_date1}', 'yyyy-mm-dd'),-12) and add_months(to_date('${sale_date2}', 'yyyy-mm-dd'),-12)
   --and fs.sale_date between to_date('${com_date1}', 'yyyy-mm-dd') and to_date('${com_date2}', 'yyyy-mm-dd')
   and ${if(len(oto) = 0, "1=1", "  fs.oto='" + oto + "'")}
   and ${if(len(region) = 0, "1=1", "  dr.area_code in ('"+region+"')") }
   and ${if(len(union_area) = 0, "1=1", "  dr.union_area_name in ('"+union_area+"')") }
   and ${if(len(is_dtp) = 0, "1=1", "  fs.is_dtp='" + is_dtp + "'")}
   and ${if(len(is_jicai) = 0, "1=1", "  fs.is_jicai='" + is_jicai + "'")}
   and ${if(len(age_store) = 0, "1=1", "  fs.age_store in ('" + age_store + "')")}
   and ${if(len(cus_code) = 0, "1=1", "  ds.cus_code in ('"+cus_code+"')") }
   --and ${if(len(cus_name) = 0, "1=1", "  ds.cus_name in ('"+cus_name+"')") }
   and 1=1 ${if(len(category)=0,"","and nvl(fs.sub_category,'空') in ('"+category+"')")}
 group by fs.area_code,dr.area_name,ds.cus_code,ds.cus_name,fs.sub_category
 order by fs.area_code,ds.cus_code,fs.sub_category

select fs.area_code,
       dr.area_name,
       ds.cus_code,
       ds.cus_name,
       nvl(fs.sub_category,'空') sub_category,
       sum(fs.no_tax_amount) no_tax_amount,
       sum(fs.no_tax_ml) no_tax_ml,
       round(decode(sum(fs.no_tax_amount),0,0,(sum(fs.no_tax_ml))/sum(fs.no_tax_amount)),2) no_mll_rate
  from dw_store_dept_sale fs,dim_region dr,dim_cus ds

 where fs.area_code=dr.area_code
   and fs.cus_code=ds.cus_code
   and fs.area_code=ds.area_code
   --and fs.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
   --and fs.sale_date between add_months(to_date('${sale_date1}', 'yyyy-mm-dd'),-12) and add_months(to_date('${sale_date2}', 'yyyy-mm-dd'),-12)
   and fs.sale_date between to_date('${com_date1}', 'yyyy-mm-dd') and to_date('${com_date2}', 'yyyy-mm-dd')
   and ${if(len(oto) = 0, "1=1", "  fs.oto='" + oto + "'")}
   and ${if(len(region) = 0, "1=1", "  dr.area_code in ('"+region+"')") }
   and ${if(len(union_area) = 0, "1=1", "  dr.union_area_name in ('"+union_area+"')") }
   and ${if(len(is_dtp) = 0, "1=1", "  fs.is_dtp='" + is_dtp + "'")}
   and ${if(len(is_jicai) = 0, "1=1", "  fs.is_jicai='" + is_jicai + "'")}
   and ${if(len(age_store) = 0, "1=1", "  fs.age_store in ('" + age_store + "')")}
   and ${if(len(cus_code) = 0, "1=1", "  ds.cus_code in ('"+cus_code+"')") }
   --and ${if(len(cus_name) = 0, "1=1", "  ds.cus_name in ('"+cus_name+"')") }
   and 1=1 ${if(len(category)=0,"","and nvl(fs.sub_category,'空') in ('"+category+"')")}
 group by fs.area_code,dr.area_name,ds.cus_code,ds.cus_name,fs.sub_category
 order by fs.area_code,ds.cus_code,fs.sub_category

select date'${sale_date1}'-1 end_date,
date'${sale_date1}'-1-(date'${sale_date2}'-date'${sale_date1}') start_date
from dual

select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}

order by 1

select distinct a.union_area_name,a.area_name,a.area_code,a.trans_party_relation from dim_region a,(select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}

and 1=1 ${if(len(region)=0, "", " and a.area_code in ('" + region + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by a.area_code

