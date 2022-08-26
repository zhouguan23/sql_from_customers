select 
distinct
f.union_area_name AREA_NAME
from
dim_region f

select dr.union_area_name,
       --dst.area_code,
       dst.cus_code,
       sum(dst.no_tax_amount)  no_tax_amount     --case when '${is_vat}'='无税' then decode(dc.attribute,'直营',sum(dst.no_tax_amount),'') else decode(dc.attribute,'直营',sum(dst.tax_amount),'') 
       --case when '无税'='无税' then decode(dc.attribute,'直营',sum(dst.no_tax_amount),'') else decode(dc.attribute,'直营',sum(dst.tax_amount),'') 
        

       
  from dm_sale_tmp dst, 
       dim_cus dc,
       dim_region dr
 where dst.area_code = dc.area_code
   and dst.cus_code = dc.cus_code
   and dst.area_code=dr.area_code
   --and ltrim(rtrim(dc.is_adjust_store)) is null
   --and dr.union_area_name='上海零售'
   --and to_char(dst.sale_date,'yyyy') ='2019'
   --and dst.sale_date between date'2020-06-01' and date'2020-08-27'
   --and dc.close_date between date'2020-06-01' and date'2020-08-27'
   
   AND to_char(dc.close_date,'yyyy-mm') between '${month}' and '${month1}'
   --and fsi.month >= to_char(to_number(substr('${month}', 6, 2)))
   --and fsi.month <= to_char(to_number(substr('${month1}', 6, 2)))
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
  -- ${if(len(attr)=0,"","and dc.attribute IN ('"+attr+"')")}
   --and fsi.year=substr('${month}', 1, 4)
   AND to_char(dst.sale_date,'yyyy-mm') between '${month}' and '${month1}'
   and dc.attribute='直营'
   group by 
       dr.union_area_name,
       --dst.area_code,
       dst.cus_code

 select dr.union_area_name,
        sum(fsi.new_value) new_value
   from FACT_SALE_INDEX fsi,
        dim_region dr 
  where fsi.area_code = dr.area_code 
    and fsi.create_month =substr('${month}', 1, 4)
    ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
  group by dr.union_area_name 

select dr.union_area_name,dc.cus_code,dc.cus_name,dc.open_date,to_char(dc.close_date,'yyyy-mm') close_date,dc.attribute
  from dim_cus dc, 
       dim_region dr
       ,USER_AUTHORITY ua
 where dc.area_code = dr.area_code 
   and dc.attribute in('直营','加盟')
    and ltrim(rtrim(dc.is_adjust_store)) is null 
   --and  dr.union_area_name='上海零售'
   --and dc.close_date between date'2020-06-01' and date'2020-08-27'
   and (dr.UNION_AREA_NAME = ua.UNION_AREA_NAME or ua.UNION_AREA_NAME = 'ALL')
   and ${"ua.user_id='"+$fr_username+"'"}
   --AND to_char(dst.sale_date) between '${month}' and '${month1}'
   --AND to_char(dc.close_date) between '${month}' and '${month1}'
   AND to_char(dc.close_date,'yyyy-mm') between '${month}' and '${month1}'
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
   ${if(len(attr)=0,"","and dc.attribute IN ('"+attr+"')")}
   order by dr.sorted,dc.cus_code

select dr.union_area_name,
       --dst.area_code,
       dst.cus_code,
       sum(dst.no_tax_amount) no_tax_amount   --case when '${is_vat}'='无税' then decode(dc.attribute,'直营',sum(dst.no_tax_amount),'') else decode(dc.attribute,'直营',sum(dst.tax_amount),'') 
       --case when '无税'='无税' then decode(dc.attribute,'直营',sum(dst.no_tax_amount),'') else decode(dc.attribute,'直营',sum(dst.tax_amount),'') 


       
  from dm_sale_tmp dst, 
       dim_cus dc,
       dim_region dr
 where dst.area_code = dc.area_code
   and dst.cus_code = dc.cus_code
   and dst.area_code=dr.area_code
   --and ltrim(rtrim(dc.is_adjust_store)) is null
   --and dr.union_area_name='上海零售'
   --and to_char(dst.sale_date,'yyyy') ='2019'
   --and dc.close_date between date'2020-06-01' and date'2020-08-27'
   
   AND to_char(dc.close_date,'yyyy-mm') between '${month}' and '${month1}'
  -- and fsi.month >= to_char(to_number(substr('${month}', 6, 2)))
   --and fsi.month <= to_char(to_number(substr('${month1}', 6, 2)))
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
   --${if(len(attr)=0,"","and dc.attribute IN ('"+attr+"')")}
   and to_char(dst.sale_date,'yyyy')=substr('${month}', 1, 4)-1
   and dc.attribute='直营'
   group by 
       dr.union_area_name,
       --dst.area_code,
       dst.cus_code

select dr.union_area_name,
       --dc.area_code,    
       dc.cus_code,   
       decode(dc.attribute,'直营',sum(fsi.operating_profit),'') operating_profit
       
  from 
       dim_cus dc,
       dim_region dr,
       fact_store_import fsi
 where dc.area_code=dr.area_code
   and dc.area_code = fsi.area_code
   and dc.cus_code = fsi.cus_code
   --and dc.close_date between date'2020-06-01' and date'2020-08-27'
   --and dr.union_area_name='上海零售'
   
   AND to_char(dc.close_date,'yyyy-mm') between '${month}' and '${month1}'
   and fsi.month >= to_char(to_number(substr('${month}', 6, 2)))
   and fsi.month <= to_char(to_number(substr('${month1}', 6, 2)))
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
   --${if(len(attr)=0,"","and dc.attribute IN ('"+attr+"')")}
   and fsi.year=substr('${month}', 1, 4)
   and dc.attribute='直营'
   group by dr.union_area_name,
       --dc.area_code,    
       dc.cus_code,
       dc.attribute

select dr.union_area_name,
       --dc.area_code,    
       dc.cus_code,   
       decode(dc.attribute,'直营',sum(fsi.operating_profit),'') operating_profit
       
  from 
       dim_cus dc,
       dim_region dr,
       fact_store_import fsi
 where dc.area_code=dr.area_code
   and dc.area_code = fsi.area_code
   and dc.cus_code = fsi.cus_code
   --and dc.close_date between date'2020-06-01' and date'2020-08-27'
   --and dr.union_area_name='上海零售'
   --and fsi.year='2019'
   
   AND to_char(dc.close_date,'yyyy-mm') between '${month}' and '${month1}'
   and fsi.month >= to_char(to_number(substr('${month}', 6, 2)))
   and fsi.month <= to_char(to_number(substr('${month1}', 6, 2)))
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
   --${if(len(attr)=0,"","and dc.attribute IN ('"+attr+"')")}
   and fsi.year=substr('${month}', 1, 4)-1
   and dc.attribute='直营'
   group by dr.union_area_name,
       --dc.area_code,    
       dc.cus_code,
       dc.attribute

select dr.union_area_name,
       --dst.area_code,
       dst.cus_code,
       sum(dst.tax_amount)  tax_amount     --case when '${is_vat}'='无税' then decode(dc.attribute,'直营',sum(dst.no_tax_amount),'') else decode(dc.attribute,'直营',sum(dst.tax_amount),'') 
       --case when '无税'='无税' then decode(dc.attribute,'直营',sum(dst.no_tax_amount),'') else decode(dc.attribute,'直营',sum(dst.tax_amount),'') 
        

       
  from dm_sale_tmp dst, 
       dim_cus dc,
       dim_region dr
 where dst.area_code = dc.area_code
   and dst.cus_code = dc.cus_code
   and dst.area_code=dr.area_code
   --and ltrim(rtrim(dc.is_adjust_store)) is null
   --and dr.union_area_name='上海零售'
   --and to_char(dst.sale_date,'yyyy') ='2019'
   --and dst.sale_date between date'2020-06-01' and date'2020-08-27'
   --and dc.close_date between date'2020-06-01' and date'2020-08-27'
   
   AND to_char(dc.close_date,'yyyy-mm') between '${month}' and '${month1}'
   --and fsi.month >= to_char(to_number(substr('${month}', 6, 2)))
   --and fsi.month <= to_char(to_number(substr('${month1}', 6, 2)))
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
   --${if(len(attr)=0,"","and dc.attribute IN ('"+attr+"')")}
   --and fsi.year=substr('${month}', 1, 4)
   AND to_char(dst.sale_date,'yyyy-mm') between '${month}' and '${month1}'
   and dc.attribute='直营'
   group by 
       dr.union_area_name,
       --dst.area_code,
       dst.cus_code

select dr.union_area_name,
       --dst.area_code,
       dst.cus_code,
       sum(dst.tax_amount) tax_amount   --case when '${is_vat}'='无税' then decode(dc.attribute,'直营',sum(dst.no_tax_amount),'') else decode(dc.attribute,'直营',sum(dst.tax_amount),'') 
       --case when '无税'='无税' then decode(dc.attribute,'直营',sum(dst.no_tax_amount),'') else decode(dc.attribute,'直营',sum(dst.tax_amount),'') 


       
  from dm_sale_tmp dst, 
       dim_cus dc,
       dim_region dr
 where dst.area_code = dc.area_code
   and dst.cus_code = dc.cus_code
   and dst.area_code=dr.area_code
   --and ltrim(rtrim(dc.is_adjust_store)) is null
   --and dr.union_area_name='上海零售'
   --and to_char(dst.sale_date,'yyyy') ='2019'
   --and dc.close_date between date'2020-06-01' and date'2020-08-27'
   
   AND to_char(dc.close_date,'yyyy-mm') between '${month}' and '${month1}'
  -- and fsi.month >= to_char(to_number(substr('${month}', 6, 2)))
   --and fsi.month <= to_char(to_number(substr('${month1}', 6, 2)))
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
   --${if(len(attr)=0,"","and dc.attribute IN ('"+attr+"')")}
   and to_char(dst.sale_date,'yyyy')=substr('${month}', 1, 4)-1
   and dc.attribute='直营'
   group by 
       dr.union_area_name,
       --dst.area_code,
       dst.cus_code

