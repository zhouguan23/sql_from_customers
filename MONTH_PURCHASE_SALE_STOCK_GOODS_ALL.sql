select jxc_data.*,
       --decode(ciaa.business_status,1,'正常',2,'停用',3,'淘汰',4,'质量停销',5,'禁止门店请货','') business_status
      --,ciaa.sale_price 
      '' business_status,
      0 sale_price,
      dgd.type
 from 

(

select sale_data.*
       ,dg.big_cate --大分类
      --,dg.category --品类
      --,dg.sub_category--细分品类
      ,dg.function --功能主治
      ,dg.composition --成分
      ,dg.sub_composition --细分成分
      ,dg.dosage_form --剂型
      ,dg.finishing_specification --规格
      ,dg.content  --含量
      ,dg.load  --装量
      ,dg.unit  --单位
      ,dg.finishing_manufacturer --整理厂家
      ,dg.commodity_attribute --商品属性
      ,dg.drug_property --药品属性
      ,dg.exclusive_ingredient --独家成分
      ,dg.crowd  --人群
      ,dg.health_food_classification --保健食品
      ,dg.program_manager --规划经理
      ,dg.key_word  --关键字
      ,dg.brand_definition --品牌定义
      ,dg.operating_province  --经营省区数
      ,dg.season_attribute  --季节
      ,pur_desc.tax_price
      ,pur_desc.supplier_name
      ,pur_desc.order_date
      ,zy_md.zy_md_num
      ,zy_kc.zy_kc_num

 from dim_goods dg,
      (
select a.* ,(ZYKC_AMOUNT/(ZYXS_AMOUNT+0.00001))*b.DAYS as ZYZZ ,
(DCKC_AMOUNT/(ZYXS_AMOUNT+JMPS_AMOUNT+PFPS_AMOUNT+0.00001))*b.DAYS as DCZY,
((DCKC_AMOUNT+ZYKC_AMOUNT)/(ZYXS_AMOUNT+JMPS_AMOUNT+PFPS_AMOUNT+0.00001))*b.DAYS as ZZY
from (
select a.area_code,a.goods_code as goods_code,/*date1,*/(case when d.goods_code is null then '否' else '是' end) as dtp,case when nc.new_attribute is null then '地采' else nc.new_attribute end as JCSX,b.goods_name,b.manufacturer,b.specification,
SUM(a.zyxs_qty) as zyxs_qty,
SUM(CG_QTY) as CG_QTY,
(case when '${Tax}'='0' then SUM(CG_AMOUNT) ELSE  SUM(CG_TAX_AMOUNT) end) as CG_AMOUNT,
(case when '${Tax}'='0' then sum(ZYXS_AMOUNT) ELSE sum(ZYXS_TAX_AMOUNT) end) as ZYXS_AMOUNT,
(case when '${Tax}'='0' then sum(ZYXS_COST) ELSE sum(ZYXS_TAX_COST) end) as ZYXS_COST,
sum(JMXS_QTY) as JMXS_QTY,
(case when '${Tax}'='0' then sum(JMXS_AMOUNT) ELSE sum(JMXS_TAX_AMOUNT) end) as JMXS_AMOUNT,
(case when '${Tax}'='0' then sum(JMXS_COST) ELSE sum(JMXS_TAX_COST) end) as JMXS_COST,
sum(ZYPS_QTY) AS ZYPS_QTY,
(case when '${Tax}'='0' then sum(ZYPS_AMOUNT) ELSE sum(ZYPS_TAX_AMOUNT) end) as ZYPS_AMOUNT,
(case when '${Tax}'='0' then sum(ZYPS_COST) ELSE sum(ZYPS_TAX_COST) end) as ZYPS_COST,
SUM(JMPS_QTY) AS JMPS_QTY,
(case when '${Tax}'='0' then sum(JMPS_AMOUNT) ELSE sum(JMPS_TAX_AMOUNT) end) as JMPS_AMOUNT,
(case when '${Tax}'='0' then sum(JMPS_COST) ELSE sum(JMPS_TAX_COST) end) as JMPS_COST,
sum(PFPS_QTY) as PFPS_QTY,
(case when '${Tax}'='0' then sum(PFPS_AMOUNT) ELSE sum(PFPS_TAX_AMOUNT) end) as PFPS_AMOUNT,
(case when '${Tax}'='0' then sum(PFPS_COST) ELSE sum(PFPS_TAX_COST) end) as PFPS_COST,
sum(GLJYPS_QTY) as GLJYPS_QTY,
(case when '${Tax}'='0' then sum(GLJYPS_AMOUNT) ELSE sum(GLJYPS_TAX_AMOUNT) end) as GLJYPS_AMOUNT,
(case when '${Tax}'='0' then sum(GLJYPS_COST) ELSE sum(GLJYPS_TAX_COST) end) as GLJYPS_COST,
sum(case when date1='${date1}' then DCKC_QTY else 0 end ) as DCKC_QTY,
SUM(case when date1='${date1}' then DCKC_AMOUNT else 0 end ) AS DCKC_AMOUNT,
SUM(case when date1='${date1}' then ZYKC_QTY else 0 end ) AS ZYKC_QTY,
sum(case when date1='${date1}' then ZYKC_AMOUNT else 0 end ) as ZYKC_AMOUNT,
SUM(case when date1='${date1}' then JMKC_QTY else 0 end ) AS JMKC_QTY,
SUM(case when date1='${date1}' then JMKC_AMOUNT else 0end ) AS JMKC_AMOUNT,
b.CATEGORY,b.SUB_CATEGORY 
from dm_purchase_sale_stock_goods A  LEFT JOIN DIM_DISABLE_CODE C on A.goods_code = C.disable_code
left join DIM_GOODS B on a.goods_code=b.goods_code
left join 
DIM_DTP d 
on a.date1=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_net_catalogue_general_all nc on a.area_code=nc.area_code and a.goods_code=nc.goods_code and nc.create_month='${date1}'
where 1=1
${if(len(acode)=0,""," and a.area_code in ('"+acode+"')")} and
1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
--and date1='${date}'
and date1 BETWEEN '${date}' and '${date1}'
and 1=1
${if(len(dtp)=0,""," and (case when d.goods_code is null then '否' else '是' end) = '"+dtp+"'")} and 1=1
${if(len(gather)=0,""," and case when c.new_attribute is null then '地采' else c.new_attribute end  in ('"+gather+"')")}
group by a.area_code,a.goods_code,/*date1,*/(case when d.goods_code is null then '否' else '是' end),(case when nc.new_attribute is null then '地采' else nc.new_attribute end) ,b.goods_name,b.manufacturer,b.specification,b.CATEGORY,b.SUB_CATEGORY ) a,
(select count(1) as DAYS from DIM_DAY where MONTH_ID BETWEEN '${date}' and '${date1}') b
      )sale_data,   
(select * from 
 (
select t.*,c.goods_code goods_code1,ROW_NUMBER() OVER(partition by AREA_CODE,c.GOODS_CODE order by order_date desc nulls last) rn
 from FACT_PURCHASE t 
 LEFT JOIN DIM_DISABLE_CODE C on t.goods_code = C.disable_code
where t.procurement_type='采进' 
and no_tax_price>0.01
and order_date>=trunc(add_months(sysdate,-6),'mm')
  ${if(len(acode)=0,""," and t.area_code in ('"+acode+"')")} 
  ${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}
  --and t.area_code=25 
  --and t.goods_code='1602076'
 )rn_desc where rn_desc.rn=1) pur_desc,
 
 (select fs.AREA_CODE,fs.GOODS_CODE,count(distinct cus_code) zy_md_num
from
(
select fs.AREA_CODE,c.GOODS_CODE,fs.CUS_CODE from fact_sale fs LEFT JOIN DIM_DISABLE_CODE C on fs.goods_code = C.disable_code,dim_cus dc

where fs.AREA_CODE=dc.area_code
  and fs.CUS_CODE=dc.cus_code
  and dc.attribute='直营'
  ${if(len(acode)=0,""," and fs.area_code in ('"+acode+"')")} 
  ${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}
 and sale_date>=to_date('${date1}','YYYY-MM')
and sale_date<add_months(to_date('${date1}','YYYY-MM'),1)
and no_tax_amount>0
  --and fs.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
  --group by fs.AREA_CODE,fs.GOODS_CODE,fs.CUS_CODE
) fs group by fs.AREA_CODE,fs.GOODS_CODE
) zy_md,

(
  select fs.AREA_CODE,fs.GOODS_CODE,count(distinct cus_code) zy_kc_num
from
(
select fs.AREA_CODE,c.GOODS_CODE,fs.CUS_CODE from dm_Stock_shop_detail fs
LEFT JOIN DIM_DISABLE_CODE C on fs.goods_code = C.disable_code,dim_cus dc

where fs.AREA_CODE=dc.area_code
  and fs.CUS_CODE=dc.cus_code
  and dc.attribute='直营'
  ${if(len(acode)=0,""," and fs.area_code in ('"+acode+"')")} 
  ${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}
  and to_char(fs.ddate,'yyyy-mm')  = '${date1}'
  --and fs.AREA_CODE=10
  --and fs.ddate between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
 -- group by fs.AREA_CODE,fs.GOODS_CODE,fs.CUS_CODE
) fs group by fs.AREA_CODE,fs.GOODS_CODE
) zy_kc
      
 where sale_data.goods_code=dg.goods_code(+)
   and sale_data.area_code=pur_desc.area_code(+)
   and sale_data.goods_code=pur_desc.goods_code1(+)
   and sale_data.area_code=zy_md.area_code(+)
   and sale_data.goods_code=zy_md.goods_code(+)
   and sale_data.area_code=zy_kc.area_code(+)
   and sale_data.goods_code=zy_kc.goods_code(+)

   ) jxc_data
          left join (select goods_code, area_code, to_char(wm_concat(type)) type
               from dim_goods_directory
              group by goods_code, area_code) dgd
    on jxc_data.area_code = dgd.area_code
   and jxc_data.goods_code = dgd.goods_code
 where 1=1 ${if(len(cate)=0,""," and big_cate in ('"+cate+"')")}
  and 1=1 ${if(len(scategory)=0,""," and sub_category in ('"+scategory+"')")}
  and 1=1 ${if(len(fun)=0,""," and function in ('"+fun+"')")}
  and 1=1 ${if(len(composition)=0,""," and composition in ('"+composition+"')")}
and 1=1 ${if(len(form)=0,""," and dosage_form in ('"+form+"')")}
and 1=1 ${if(len(manufacturer)=0,""," and finishing_manufacturer in ('"+manufacturer+"')")}
   /*and jxc_data.area_code=ciaa.brancode(+)
   and jxc_data.goods_code=ciaa.item(+)*/
   order by jxc_data.area_code,jxc_data.goods_code

select distinct jcsx from DM_PURCHASE_SALE_STOCK_GOODS

select area_code,area_name from dim_region

select distinct c.disable_code as goods_code,c.goods_code||'|'||b.goods_name goods_name,big_cate,sub_category,function,composition,dosage_form,finishing_manufacturer from  dim_goods b   left join dim_disable_code C on b.goods_code=c.disable_code
order by 1

