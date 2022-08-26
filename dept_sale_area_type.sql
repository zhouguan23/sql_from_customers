select distinct nvl(sub_category,'空') from dim_goods
 where 1=1 ${if(len(category)=0,"","and  nvl(sub_category,'空') in ('"+category+"')")}


select area_code,area_name,sub_category,busy_type,c_busy_type,result,
case when busy_type='加盟' and c_busy_type='NO_TAX_AMOUNT'  then '加盟配送销售额'
     when busy_type='加盟' and c_busy_type='NO_TAX_ML'  then '加盟配送毛利额' 
     when busy_type='加盟' and c_busy_type='NO_TAX_RATE'  then '加盟配送毛利率'
     when busy_type='加盟' and c_busy_type='NO_TAX_AMOUNT_RATE'  then '加盟配送销售占比'
     when busy_type='直营' and c_busy_type='NO_TAX_AMOUNT'  then '直营销售额'
     when busy_type='直营' and c_busy_type='NO_TAX_ML'  then '直营销售毛利额' 
     when busy_type='直营' and c_busy_type='NO_TAX_RATE'  then '直营销售毛利率'
     when busy_type='直营' and c_busy_type='NO_TAX_AMOUNT_RATE'  then '直营销售占比'
     when busy_type='批发' and c_busy_type='NO_TAX_AMOUNT'  then '批发销售额'
     when busy_type='批发' and c_busy_type='NO_TAX_ML'  then '批发销售毛利额' 
     when busy_type='批发' and c_busy_type='NO_TAX_RATE'  then '批发销售毛利率'
     when busy_type='批发' and c_busy_type='NO_TAX_AMOUNT_RATE'  then '批发销售占比'
     when busy_type='B2C' and c_busy_type='NO_TAX_AMOUNT'  then 'B2C销售额'
     when busy_type='B2C' and c_busy_type='NO_TAX_ML'  then 'B2C销售毛利额' 
     when busy_type='B2C' and c_busy_type='NO_TAX_RATE'  then 'B2C销售毛利率'
     when busy_type='B2C' and c_busy_type='NO_TAX_AMOUNT_RATE'  then 'B2C销售占比'
       end busy_type1 from 
(

select area_code,
       area_name,
       sub_category, 
       busy_type,
       to_char(round(no_tax_amount,2)) no_tax_amount,
       to_char(round(no_tax_ml,2)) no_tax_ml,
       to_char(decode(nvl(no_tax_amount,0),0,'',round(no_tax_ml/no_tax_amount,4)*100),'9999990.00')||'%' no_tax_rate,
       to_char(decode(no_tax_amount,0,0,round((no_tax_amount / (SUM(no_tax_amount) over(PARTITION BY area_code))),4)*100),'9999990.00')||'%'  no_tax_amount_rate

 
 from

(

select fs.area_code,
       dr.area_name,
       nvl(fs.sub_category,'空') sub_category, 
       fs.busy_type,
       
       --decode('无税','含税',sum(fs.tax_amount),sum(fs.no_tax_amount)) no_tax_amount,
       --decode('无税','含税',sum(fs.tax_ml),sum(fs.no_tax_ml)) no_tax_ml
       
       (case when '${is_vat}'='无税' then (case when '${is_gljy}' = '1' then sum(case when is_gljy='1' then no_tax_amount end) when '${is_gljy}' = '0' then sum(case when is_gljy='0' then no_tax_amount end )else sum(no_tax_amount)end) else (case when '${is_gljy}' = '1' then sum(case when is_gljy='1' then tax_amount end) when '${is_gljy}' = '0' then sum(case when is_gljy='0' then tax_amount end )else sum(tax_amount)end)end)  as no_tax_amount,
       (case when '${is_vat}'='无税'  then (case when '${is_gljy}' = '1' then sum(case when is_gljy = '1' then no_tax_ml else null end) else sum(no_tax_ml) end)  ELSE (case when '${is_gljy}' = '1' then sum(case when is_gljy = '1' then tax_ml else null end) else sum(tax_ml) end) end) as no_tax_ml

       
       
  from dw_sale_dept_type fs,dim_region dr,USER_AUTHORITY b

 where fs.area_code=dr.area_code
   --and fs.sale_date between to_date('2020-03-01','yyyy-mm-dd') and to_date('2020-03-31','yyyy-mm-dd')
   --and fs.area_code in(10,00)
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
 group by fs.area_code,dr.area_name,fs.sub_category,fs.busy_type
 
 ) 
 ) unpivot(result for c_busy_type in(no_tax_amount,no_tax_ml,no_tax_rate,no_tax_amount_rate)) order by area_code,busy_type1

select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(region)=0,""," and a.area_code in ('"+region+"')")} 

select * from tab_busy_type

select area_code,area_name,busy_type,c_busy_type,result,
case when busy_type='加盟' and c_busy_type='NO_TAX_AMOUNT'  then '加盟配送销售额'
     when busy_type='加盟' and c_busy_type='NO_TAX_ML'  then '加盟配送毛利额' 
     when busy_type='加盟' and c_busy_type='NO_TAX_RATE'  then '加盟配送毛利率'
     when busy_type='加盟' and c_busy_type='NO_TAX_AMOUNT_RATE'  then '加盟配送销售占比'
     when busy_type='直营' and c_busy_type='NO_TAX_AMOUNT'  then '直营销售额'
     when busy_type='直营' and c_busy_type='NO_TAX_ML'  then '直营销售毛利额' 
     when busy_type='直营' and c_busy_type='NO_TAX_RATE'  then '直营销售毛利率'
     when busy_type='直营' and c_busy_type='NO_TAX_AMOUNT_RATE'  then '直营销售占比'
     when busy_type='批发' and c_busy_type='NO_TAX_AMOUNT'  then '批发销售额'
     when busy_type='批发' and c_busy_type='NO_TAX_ML'  then '批发销售毛利额' 
     when busy_type='批发' and c_busy_type='NO_TAX_RATE'  then '批发销售毛利率'
     when busy_type='批发' and c_busy_type='NO_TAX_AMOUNT_RATE'  then '批发销售占比'
     when busy_type='B2C' and c_busy_type='NO_TAX_AMOUNT'  then 'B2C销售额'
     when busy_type='B2C' and c_busy_type='NO_TAX_ML'  then 'B2C销售毛利额' 
     when busy_type='B2C' and c_busy_type='NO_TAX_RATE'  then 'B2C销售毛利率'
     when busy_type='B2C' and c_busy_type='NO_TAX_AMOUNT_RATE'  then 'B2C销售占比'
       end busy_type1 from 
(

select area_code,
       area_name,
       busy_type,
       to_char(round(no_tax_amount,2)) no_tax_amount,
       to_char(round(no_tax_ml,2)) no_tax_ml,
        to_char(decode(nvl(no_tax_amount,0),0,'',round(no_tax_ml/no_tax_amount,4)*100),'9999990.00')||'%' no_tax_rate,
       to_char(decode(no_tax_amount,0,0,round((no_tax_amount / (SUM(no_tax_amount) over(PARTITION BY area_code))),4)*100),'9999990.00')||'%'  no_tax_amount_rate

 
 from

(

select fs.area_code,
       dr.area_name,
       fs.busy_type,
       
       --decode('无税','含税',sum(fs.tax_amount),sum(fs.no_tax_amount)) no_tax_amount,
       --decode('无税','含税',sum(fs.tax_ml),sum(fs.no_tax_ml)) no_tax_ml
       
       (case when '${is_vat}'='无税' then (case when '${is_gljy}' = '1' then sum(case when is_gljy='1' then no_tax_amount end) when '${is_gljy}' = '0' then sum(case when is_gljy='0' then no_tax_amount end )else sum(no_tax_amount)end) else (case when '${is_gljy}' = '1' then sum(case when is_gljy='1' then tax_amount end) when '${is_gljy}' = '0' then sum(case when is_gljy='0' then tax_amount end )else sum(tax_amount)end)end)  as no_tax_amount,
       (case when '${is_vat}'='无税'  then (case when '${is_gljy}' = '1' then sum(case when is_gljy = '1' then no_tax_ml else null end) else sum(no_tax_ml) end)  ELSE (case when '${is_gljy}' = '1' then sum(case when is_gljy = '1' then tax_ml else null end) else sum(tax_ml) end) end) as no_tax_ml

       
       
  from dw_sale_dept_type fs,dim_region dr

 where fs.area_code=dr.area_code
   --and fs.sale_date between to_date('2020-03-01','yyyy-mm-dd') and to_date('2020-03-31','yyyy-mm-dd')
   --and fs.area_code in(10)
   --and fs.is_gljy='0'
   and fs.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
   and ${if(len(oto) = 0, "1=1", "  fs.oto='" + oto + "'")}   
   and ${if(len(region) = 0, "1=1", "  dr.area_code in ('"+region+"')") }
   and ${if(len(sale_type) = 0, "1=1", "  fs.busy_type in ('"+sale_type+"')") }
   and ${if(len(is_dtp) = 0, "1=1", "  fs.is_dtp='" + is_dtp + "'")}
   and ${if(len(is_jicai) = 0, "1=1", "  fs.is_jicai='" + is_jicai + "'")}
   --and ${if(len(is_gljy) = 0, "1=1", "  fs.is_gljy='" + is_gljy + "'")}
   and 1=1 ${if(len(category)=0,"","and nvl(fs.sub_category,'空') in ('"+category+"')")}
 group by fs.area_code,dr.area_name,fs.busy_type
 
 ) 
 ) unpivot(result for c_busy_type in(no_tax_amount,no_tax_ml,no_tax_rate,no_tax_amount_rate))

