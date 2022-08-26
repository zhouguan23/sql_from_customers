select distinct nvl(sub_category,'空') from dim_goods
 --where 1=1 ${if(len(category)=0,"","and  sub_CATEGORY in ('"+category+"')")}

select aa.area_code,
       aa.area_name,
       aa.cus_code,
       aa.cus_name,
       aa.sub_category,
       aa.no_tax_amount,
       aa.no_tax_ml,
       aa.no_mll_rate,
       CASE WHEN 
 bb.no_tax_amount = 0
then 0 
ELSE
aa.no_tax_amount /bb.no_tax_amount 
END
as rate_sale,
   CASE WHEN 
 bb.no_tax_ml = 0
then 0 
ELSE
aa.no_tax_ml /bb.no_tax_ml 
END
as  rate_ml

 from
(
select fs.area_code,
       dr.area_name,
       ds.cus_code,
       ds.cus_name,
       nvl(fs.sub_category,'空') sub_category,
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
   and ${if(len(cus_code) = 0, "1=1", "  ds.cus_code in ('"+cus_code+"')") }
   --and ${if(len(cus_name) = 0, "1=1", "  ds.cus_name in ('"+cus_name+"')") }
   and 1=1 ${if(len(category)=0,"","and nvl(fs.sub_category,'空') in ('"+category+"')")}
 group by fs.area_code,dr.area_name,ds.cus_code,ds.cus_name,fs.sub_category
 ) aa,
 (
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
   and ${if(len(cus_code) = 0, "1=1", "  ds.cus_code in ('"+cus_code+"')") }
   --and ${if(len(cus_name) = 0, "1=1", "  ds.cus_name in ('"+cus_name+"')") }
 group by fs.area_code,dr.area_name,ds.cus_code,ds.cus_name
 ) bb
 where aa.area_code=bb.area_code and aa.cus_code=bb.cus_code
 order by aa.area_code,aa.cus_code

select * from DIM_REGION dr where ${if(len(region) = 0, "1=1", "  dr.area_code in ('"+region+"')") }

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

