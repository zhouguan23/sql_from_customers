

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
 from dim_goods dg,
      (
       select a.area_code,a.goods_code disable_code,C.goods_code,date1,dtp,jcsx,a.goods_name,a.manufacturer,a.specification,
SUM(a.zyxs_qty) as zyxs_qty,
SUM(CG_QTY) as CG_QTY,
(case when '${Tax}'='无税' then sum(CG_AMOUNT) ELSE sum(CG_TAX_AMOUNT) end) as CG_AMOUNT,
(case when '${Tax}'='无税' then sum(ZYXS_AMOUNT) ELSE sum(ZYXS_TAX_AMOUNT) end) as ZYXS_AMOUNT,
(case when '${Tax}'='无税' then sum(ZYXS_COST) ELSE sum(ZYXS_TAX_COST) end) as ZYXS_COST,
sum(JMXS_QTY) as JMXS_QTY,
(case when '${Tax}'='无税' then sum(JMXS_AMOUNT) ELSE sum(JMXS_TAX_AMOUNT) end) as JMXS_AMOUNT,
(case when '${Tax}'='无税' then sum(JMXS_COST) ELSE sum(JMXS_TAX_COST) end) as JMXS_COST,
sum(ZYPS_QTY) AS ZYPS_QTY,
(case when '${Tax}'='无税' then sum(ZYPS_AMOUNT) ELSE sum(ZYPS_TAX_AMOUNT) end) as ZYPS_AMOUNT,
(case when '${Tax}'='无税' then sum(ZYPS_COST) ELSE sum(ZYPS_TAX_COST) end) as ZYPS_COST,
SUM(JMPS_QTY) AS JMPS_QTY,
(case when '${Tax}'='无税' then sum(JMPS_AMOUNT) ELSE sum(JMPS_TAX_AMOUNT) end) as JMPS_AMOUNT,
(case when '${Tax}'='无税' then sum(JMPS_COST) ELSE sum(JMPS_TAX_COST) end) as JMPS_COST,
sum(PFPS_QTY) as PFPS_QTY,
(case when '${Tax}'='无税' then sum(PFPS_AMOUNT) ELSE sum(PFPS_TAX_AMOUNT) end) as PFPS_AMOUNT,
(case when '${Tax}'='无税' then sum(PFPS_COST) ELSE sum(PFPS_TAX_COST) end) as PFPS_COST,
sum(GLJYPS_QTY) as GLJYPS_QTY,
(case when '${Tax}'='无税' then sum(GLJYPS_AMOUNT) ELSE sum(GLJYPS_TAX_AMOUNT) end) as GLJYPS_AMOUNT,
(case when '${Tax}'='无税' then sum(GLJYPS_COST) ELSE sum(GLJYPS_TAX_COST) end) as GLJYPS_COST,
sum(DCKC_QTY) as DCKC_QTY,
SUM(DCKC_AMOUNT) AS DCKC_AMOUNT,
SUM(ZYKC_QTY) AS ZYKC_QTY,
sum(ZYKC_AMOUNT) as ZYKC_AMOUNT,
SUM(JMKC_QTY) AS JMKC_QTY,
SUM(JMKC_AMOUNT) AS JMKC_AMOUNT,
b.CATEGORY,b.SUB_CATEGORY 
from dm_purchase_sale_stock_goods A left join DIM_GOODS B on A.goods_code=b.goods_code LEFT JOIN DIM_DISABLE_CODE C on A.goods_code = C.disable_code

where 1=1
${if(len(acode)=0,""," and area_code in ('"+acode+"')")} and
1=1 
${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}
and date1='${date}'
and 1=1
${if(len(dtp)=0,""," and dtp = '"+dtp+"'")} and 1=1
${if(len(gather)=0,""," and jcsx in ('"+gather+"')")}
group by a.area_code,a.goods_code,C.goods_code,date1,dtp,jcsx,a.goods_name,a.manufacturer,a.specification,b.CATEGORY,b.SUB_CATEGORY 
      )sale_data
where sale_data.disable_code=dg.goods_code(+)

select distinct jcsx from dim_goods_month where date1='${date}'

select area_code,area_name from dim_region
order by 1

select distinct b.goods_code,b.goods_code||'|'||b.goods_name goods_name from  dim_goods b  left join dim_disable_code C on b.goods_code=c.disable_code
order by 1


