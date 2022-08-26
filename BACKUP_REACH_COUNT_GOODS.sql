select distinct union_area_name from dim_region



select distinct goods_code as goods_code,
goods_code||'|'||goods_name as goods_name  from DIM_GOODS_KEY_CATALOGUE 
order by goods_code

select distinct a.goods_code,
a.combination_marks,
a.key_breed_attributes,
a.union_area_name,
a.status, 
a.goods_name, 
a.specification, 
a.manufacturer, 
a.backup_level, 
a.approval_type, 
a.target_stores, 
a.TARGET_DISPLAY,
--a.assess_method,
a.combination_marks
from DIM_GOODS_KEY_CATALOGUE a
where 
 to_char(a.create_xun,'yyyy-mm')='${Date}'
and 
 1=1
${if(len(attributes)=0,""," and a.key_breed_attributes  in ('"+attributes +"')")} 
and 1=1
${if(len(area)=0,""," and a.union_area_name  in ('"+area +"')")}
--and a.assess_method !='不考核备货'


and 1=1
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
ORDER BY nlssort(a.union_area_name, 'NLS_SORT=SCHINESE_PINYIN_M'),a.goods_code
--order by a.union_area_name


--上旬实际有库存直营门店数 & 实际直营门店库存量
select c.union_area_name,c.goods_code,c.assess_method,sum(a.stock_qty),count(distinct a.cus_code) from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||'-10','yyyy-mm-dd')
and 
 1=1
${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")} 
and 1=1
${if(len(area)=0,""," and c.union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}
group by  c.goods_code,c.union_area_name,c.assess_method


--中旬实际有库存直营门店数 & 实际直营门店库存量
select c.union_area_name,c.goods_code,c.assess_method,sum(a.stock_qty),count(distinct a.cus_code) from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||'-20','yyyy-mm-dd')
and 
 1=1
${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")} 
and 1=1
${if(len(area)=0,""," and c.union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}
group by  c.goods_code,c.union_area_name,c.assess_method


SELECT DISTINCT CATEGORY
FROM DIM_GOODS a,DIM_GOODS_KEY_CATALOGUE b
where a.goods_code=b.goods_code
union 
select '空' from dual

SELECT DISTINCT 
SUB_CATEGORY 
FROM DIM_GOODS a,DIM_GOODS_KEY_CATALOGUE b
WHERE 
a.goods_code=b.goods_code
 and 1=1
${if(len(CATEGORY)=0, "" ,"and CATEGORY in ('"+CATEGORY+"')")}
union 
select '空' from dual

SELECT DISTINCT 
COMPOSITION
FROM DIM_GOODS a,DIM_GOODS_KEY_CATALOGUE b
WHERE 
a.goods_code=b.goods_code
and 1=1
${if(len(CATEGORY)=0, "" ,"and CATEGORY in ('"+CATEGORY+"')")}
AND 
1=1
${if(len(SUB_CATEGORY)=0, "" ,"and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
union 
select '空' from dual


select distinct key_breed_attributes from DIM_GOODS_KEY_CATALOGUE

--下旬实际有库存直营门店数 & 实际直营门店库存量
select c.union_area_name,c.goods_code,c.assess_method,sum(a.stock_qty),count(distinct a.cus_code) from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and 
 1=1
${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")} 
and 1=1
${if(len(area)=0,""," and c.union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}
group by  c.goods_code,c.union_area_name,c.assess_method

--上旬备货达成率
select union_area_name,goods_code,备货门店数达成率,备货陈列量达成率,
(case when 备货门店数达成率>${p1} then '是'else '否'end)门店备货是否达成,
(case when 备货陈列量达成率>${p2} then '是'else '否'end)陈列备货是否达成 from(
select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as 备货门店数达成率,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display) end ) as 备货陈列量达成率
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='单品'
and c.assess_backup='是'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||'-10','yyyy-mm-dd')
group by  c.goods_code,c.union_area_name,target_stores,target_display
union all
select  b.union_area_name,b.goods_code,
(case when target_stores=0 then null else (cus_num/target_stores) end ) as 备货门店数达成率,
(case when target_display=0 then null else (stock_qty/target_display) end ) as 备货陈列量达成率  
from (select combination_marks,max(stock_qty)stock_qty,cus_num from ( 
select combination_marks,cus_num, stock_qty,  rank() over(partition by combination_marks order by cus_num desc) rn 
from( 
select c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num 
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and c.assess_backup='是'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||'-10','yyyy-mm-dd')
and c.combination_marks is not null
group by  c.goods_code,c.combination_marks)t1
 ) t where t.rn <2
group by combination_marks,cus_num)a,dim_goods_key_catalogue b
where a.combination_marks=b.combination_marks
and b.create_xun=to_date('${Date}'||'-10','yyyy-mm-dd')
--and b.assess_method!='不考核备货'
and b.assess_backup='是'
)
where 1=1
${if(len(area)=0,""," and union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and goods_code in ('"+gcode+"')")}

--中旬备货达成率
select union_area_name,goods_code,备货门店数达成率,备货陈列量达成率,
(case when 备货门店数达成率>${p1} then '是'else '否'end)门店备货是否达成,
(case when 备货陈列量达成率>${p2} then '是'else '否'end)陈列备货是否达成 from(
select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as 备货门店数达成率,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display) end ) as 备货陈列量达成率
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='单品'
and c.assess_backup='是'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||'-20','yyyy-mm-dd')
group by  c.goods_code,c.union_area_name,target_stores,target_display
union all
select  b.union_area_name,b.goods_code,
(case when target_stores=0 then null else (cus_num/target_stores) end ) as 备货门店数达成率,
(case when target_display=0 then null else (stock_qty/target_display) end ) as 备货陈列量达成率  
from （select combination_marks,max(stock_qty)stock_qty,cus_num from ( 
select combination_marks,cus_num, stock_qty,  rank() over(partition by combination_marks order by cus_num desc) rn 
from( 
select c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num 
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and c.assess_backup='是'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||'-20','yyyy-mm-dd')
and c.combination_marks is not null
group by  c.goods_code,c.combination_marks)t1
 ) t where t.rn <2
group by combination_marks,cus_num）a,dim_goods_key_catalogue b
where a.combination_marks=b.combination_marks
and b.create_xun=to_date('${Date}'||'-20','yyyy-mm-dd')
and b.assess_backup='是'
)
where 1=1
${if(len(area)=0,""," and union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and goods_code in ('"+gcode+"')")}

--下旬备货达成率
select union_area_name,goods_code,备货门店数达成率,备货陈列量达成率,
(case when 备货门店数达成率>${p1} then '是'else '否'end)门店备货是否达成,
(case when 备货陈列量达成率>${p2} then '是'else '否'end)陈列备货是否达成 from(
select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as 备货门店数达成率,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display) end ) as 备货陈列量达成率
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='单品'
and c.assess_backup='是'
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
group by  c.goods_code,c.union_area_name,target_stores,target_display
union all
select  b.union_area_name,b.goods_code,
(case when target_stores=0 then null else (cus_num/target_stores) end ) as 备货门店数达成率,
(case when target_display=0 then null else (stock_qty/target_display) end ) as 备货陈列量达成率  
from （select combination_marks,max(stock_qty)stock_qty,cus_num from ( 
select combination_marks,cus_num, stock_qty,  rank() over(partition by combination_marks order by cus_num desc) rn 
from( 
select c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num 
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and c.assess_backup='是'
and a.stock_qty>0
--a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and c.combination_marks is not null
group by  c.goods_code,c.combination_marks)t1
 ) t where t.rn <2
group by combination_marks,cus_num）a,dim_goods_key_catalogue b
where a.combination_marks=b.combination_marks
and b.create_xun=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and b.assess_backup='是'
)
where 1=1
${if(len(area)=0,""," and union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and goods_code in ('"+gcode+"')")}

--组合达标率 
select combination_marks,
(case when 备货门店数达成率>${p1} then '是'else '否'end),
(case when 备货陈列量达成率>${p2} then '是'else '否'end)
from(
select combination_marks,
max(a)备货门店数达成率,max(b)备货陈列量达成率
from (
select combination_marks,goods_code,(case when target_stores=0 then null else (cus_num/target_stores) end ) as a,
(case when target_display=0 then null else (stock_qty/target_display) end ) as b
from (
select c.combination_marks,c.goods_code,c.target_stores,c.target_display,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num 
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||'-10','yyyy-mm-dd')
and c.combination_marks is not null
group by  c.goods_code,c.combination_marks,c.target_stores,c.target_display))
group by combination_marks)

--组合达标率 
select combination_marks,
(case when a>${p1} then '是'else '否'end),
(case when b>${p2} then '是'else '否'end)
from(
select combination_marks,
max(a)a,max(b)b
from (
select combination_marks,goods_code,
(case when target_stores=0 then null else (cus_num/target_stores) end ) as a,
(case when target_display=0 then null else (stock_qty/target_display) end ) as b
from (
select c.combination_marks,c.goods_code,c.target_stores,c.target_display,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num 
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
--and combination_marks='安徽家庭健康退热贴'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||'-20','yyyy-mm-dd')
and c.combination_marks is not null
group by  c.goods_code,c.combination_marks,c.target_stores,c.target_display))
group by combination_marks)


--组合达标率 
select combination_marks,
(case when a>${p1} then '是'else '否'end),
(case when b>${p2} then '是'else '否'end)
from(
select combination_marks,
max(a)a,max(b)b
from (
select combination_marks,goods_code,
(case when target_stores=0 then null else (cus_num/target_stores) end ) as a,
(case when target_display=0 then null else (stock_qty/target_display) end ) as b
from (
select c.combination_marks,c.goods_code,c.target_stores,c.target_display,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num 
from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
--and combination_marks='安徽家庭健康退热贴'
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and c.combination_marks is not null
group by  c.goods_code,c.combination_marks,c.target_stores,c.target_display))
group by combination_marks)


select c.union_area_name,c.goods_code,c.assess_method from dim_goods_key_catalogue c
where c.create_xun=to_date('${Date}'||'-10','yyyy-mm-dd')
and 
 1=1
${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and 1=1
${if(len(area)=0,""," and c.union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}

select c.union_area_name,c.goods_code,c.assess_method 
from dim_goods_key_catalogue c
where c.create_xun=to_date('${Date}'||'-20','yyyy-mm-dd')
and 
 1=1
${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and 1=1
${if(len(area)=0,""," and c.union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}

select c.union_area_name,c.goods_code,c.assess_method from dim_goods_key_catalogue c
where c.create_xun=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and 
 1=1
${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and 1=1
${if(len(area)=0,""," and c.union_area_name  in ('"+area +"')")}
and 1=1
${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}

