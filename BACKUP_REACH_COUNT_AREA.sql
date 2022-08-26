select distinct union_area_name from dim_region

select distinct a.union_area_name from DIM_GOODS_KEY_CATALOGUE a 
where 
to_char(a.create_xun,'yyyy-mm')='${Date}'
and 
 1=1
${if(len(attributes)=0,""," and a.key_breed_attributes  in ('"+attributes +"')")} 
and 1=1
${if(len(area)=0,""," and a.union_area_name  in ('"+area +"')")}

--ORDER BY nlssort(a.union_area_name, 'NLS_SORT=SCHINESE_PINYIN_M')
--order by a.union_area_name


select distinct key_breed_attributes from DIM_GOODS_KEY_CATALOGUE

select union_area_name,sum(a)/sum(s) as 门店备货达标率,sum(b)/sum(s) as 陈列备货达标率,sum(c)/sum(s) as 综合备货达标率 from (
--上旬总品种数
select union_area_name,sum(a) s,0 a,0 b,0 c from (
select count(distinct combination_marks)as a,union_area_name  from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'10','yyyy-mm-dd')
and  ASSESS_METHOD='组合'
and  1=1 ${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name
union all
select count(*)as a,union_area_name from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'10','yyyy-mm-dd')
and ASSESS_METHOD!='组合'
and 1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name)
group by union_area_name
union all
--上旬门店备货达标品种数
select union_area_name,0 s,sum(s)as a,0 b,0 c from (
select union_area_name,count(a) as s from(select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as a  
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'10','yyyy-mm-dd')
and c.assess_method='单品'
and 1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_stores)
where a>='${p1}'
group by union_area_name
union all
select union_area_name,count(a) as s from (
select a.union_area_name,a.combination_marks,
(case when b.target_stores=0 then null else (a.cus_num/b.target_stores ) end ) as a 
from 
(select union_area_name,combination_marks,cus_num from ( 
select union_area_name,combination_marks,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'10','yyyy-mm-dd')
group by  c.union_area_name,c.goods_code,c.combination_marks)t1
group by  union_area_name,combination_marks) t2)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'10','yyyy-mm-dd')
and assess_method='组合'
and  1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.union_area_name,a.combination_marks,b.target_stores,a.cus_num)
where a>='${p1}'
group by union_area_name)
group by union_area_name
union all
--上旬陈列备货达标品种数
select union_area_name,0 s,0 a,sum(s) b,0 c from (
select union_area_name,count(b) as s from(select c.union_area_name,c.goods_code,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display) end ) as b   
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'10','yyyy-mm-dd')
and c.assess_method='单品'
and 1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_display)
where b>='${p2}'
group by union_area_name
union all
select union_area_name,count(b) as s from (
select a.union_area_name,a.combination_marks,  
(case when b.target_display=0 then null else (sum(a.stock_qty)/b.target_display) end ) as b  
from 
(select union_area_name,combination_marks,cus_num,stock_qty from ( 
select union_area_name,stock_qty, combination_marks,cus_num, row_number() over(partition by combination_marks order by cus_num desc) rn 
from( 
select union_area_name,combination_marks,stock_qty,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'10','yyyy-mm-dd')
group by  c.goods_code,c.combination_marks,c.union_area_name)t1
group by  combination_marks,stock_qty,union_area_name) t2
 ) t where t.rn <=1)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'10','yyyy-mm-dd')
and assess_method='组合'
and 1=1 ${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.combination_marks,b.target_display,a.union_area_name)
where b>='${p2}'
group by union_area_name)
group by union_area_name
union all
--上旬综合备货达标品种数
select union_area_name,0 s,0 a,0 b,sum(s) c from (
select union_area_name,count(*) as s from(select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as a,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display ) end ) as b   
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'10','yyyy-mm-dd')
and c.assess_method='单品'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_display,target_stores)
where a>='${p1}' and b>='${p2}'
group by union_area_name
union all
select union_area_name,count(*) as s from (
select a.union_area_name,a.combination_marks,
(case when b.target_stores=0 then null else (a.cus_num/b.target_stores ) end ) as a,  
(case when b.target_display=0 then null else (sum(a.stock_qty)/b.target_display) end ) as b  
from 
(select union_area_name,combination_marks,cus_num,stock_qty from ( 
select union_area_name,stock_qty, combination_marks,cus_num, row_number() over(partition by combination_marks order by cus_num desc) rn 
from( 
select union_area_name,combination_marks,stock_qty,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'10','yyyy-mm-dd')
group by  c.goods_code,c.combination_marks,c.union_area_name)t1
group by  combination_marks,stock_qty,union_area_name) t2
 ) t where t.rn <=1)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'10','yyyy-mm-dd')
and assess_method='组合'
and  1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.combination_marks,b.target_stores,b.target_display,a.union_area_name,a.cus_num)
where a>='${p1}' and b>='${p2}'
group by union_area_name)
group by union_area_name)
group by union_area_name

select union_area_name,sum(a)/sum(s) as 门店备货达标率,sum(b)/sum(s) as 陈列备货达标率,sum(c)/sum(s) as 综合备货达标率 from (
--中旬总品种数
select union_area_name,sum(a) s,0 a,0 b,0 c from (
select count(distinct combination_marks)as a,union_area_name  from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'20','yyyy-mm-dd')
and  ASSESS_METHOD='组合'
and  1=1 ${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name
union all
select count(*)as a,union_area_name from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'20','yyyy-mm-dd')
and ASSESS_METHOD!='组合'
and 1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name)
group by union_area_name
union all
--中旬门店备货达标品种数
select union_area_name,0 s,sum(s)as a,0 b,0 c from (
select union_area_name,count(a) as s from(select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as a  
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'20','yyyy-mm-dd')
and c.assess_method='单品'
and 1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_stores)
where a>='${p1}'
group by union_area_name
union all
select union_area_name,count(a) as s from (
select a.union_area_name,a.combination_marks,
(case when b.target_stores=0 then null else (a.cus_num/b.target_stores) end ) as a 
from 
(select union_area_name,combination_marks,cus_num from ( 
select union_area_name,combination_marks,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'20','yyyy-mm-dd')
group by  c.union_area_name,c.goods_code,c.combination_marks)t1
group by  union_area_name,combination_marks) t2)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'20','yyyy-mm-dd')
and assess_method='组合'
and  1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.union_area_name,a.combination_marks,b.target_stores,a.cus_num)
where a>='${p1}'
group by union_area_name)
group by union_area_name
union all
--中旬陈列备货达标品种数
select union_area_name,0 s,0 a,sum(s) b,0 c from (
select union_area_name,count(b) as s from(select c.union_area_name,c.goods_code,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display) end ) as b   
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'20','yyyy-mm-dd')
and c.assess_method='单品'
and 1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_display)
where b>='${p2}'
group by union_area_name
union all
select union_area_name,count(b) as s from (
select a.union_area_name,a.combination_marks,  
(case when b.target_display=0 then null else (sum(a.stock_qty)/b.target_display) end ) as b  
from 
(select union_area_name,combination_marks,cus_num,stock_qty from ( 
select union_area_name,stock_qty, combination_marks,cus_num, row_number() over(partition by combination_marks order by cus_num desc) rn 
from( 
select union_area_name,combination_marks,stock_qty,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'20','yyyy-mm-dd')
group by  c.goods_code,c.combination_marks,c.union_area_name)t1
group by  combination_marks,stock_qty,union_area_name) t2
 ) t where t.rn <=1)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'20','yyyy-mm-dd')
and assess_method='组合'
and 1=1 ${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.combination_marks,b.target_display,a.union_area_name)
where b>='${p2}'
group by union_area_name)
group by union_area_name
union all
--中旬综合备货达标品种数
select union_area_name,0 s,0 a,0 b,sum(s) c from (
select union_area_name,count(*) as s from(select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as a,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display) end ) as b   
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'20','yyyy-mm-dd')
and c.assess_method='单品'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_display,target_stores)
where a>='${p1}' and b>='${p2}'
group by union_area_name
union all
select union_area_name,count(*) as s from (
select a.union_area_name,a.combination_marks,
(case when b.target_stores=0 then null else (a.cus_num/b.target_stores) end ) as a,  
(case when b.target_display=0 then null else (sum(a.stock_qty)/b.target_display) end ) as b  
from 
(select union_area_name,combination_marks,cus_num,stock_qty from ( 
select union_area_name,stock_qty, combination_marks,cus_num, row_number() over(partition by combination_marks order by cus_num desc) rn 
from( 
select union_area_name,combination_marks,stock_qty,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=to_date('${Date}'||-'20','yyyy-mm-dd')
group by  c.goods_code,c.combination_marks,c.union_area_name)t1
group by  combination_marks,stock_qty,union_area_name) t2
 ) t where t.rn <=1)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=to_date('${Date}'||-'20','yyyy-mm-dd')
and assess_method='组合'
and  1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.combination_marks,b.target_stores,b.target_display,a.union_area_name,a.cus_num)
where a>='${p1}' and b>='${p2}'
group by union_area_name)
group by union_area_name)
group by union_area_name

select union_area_name,sum(a)/sum(s) as 门店备货达标率,sum(b)/sum(s) as 陈列备货达标率,sum(c)/sum(s) as 综合备货达标率 from (
--下旬总品种数
select union_area_name,sum(a) s,0 a,0 b,0 c from (
select count(distinct combination_marks)as a,union_area_name  from dim_goods_key_catalogue
where  create_xun=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and  ASSESS_METHOD='组合'
and  1=1 ${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name
union all
select count(*)as a,union_area_name from dim_goods_key_catalogue
where  create_xun=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and ASSESS_METHOD!='组合'
and 1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name)
group by union_area_name
union all
--下旬门店备货达标品种数
select union_area_name,0 s,sum(s)as a,0 b,0 c from (
select union_area_name,count(a) as s from(select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as a  
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and c.assess_method='单品'
and 1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_stores)
where a>='${p1}'
group by union_area_name
union all
select union_area_name,count(a) as s from (
select a.union_area_name,a.combination_marks,
(case when b.target_stores=0 then null else (a.cus_num/b.target_stores) end ) as a 
from 
(select union_area_name,combination_marks,cus_num from ( 
select union_area_name,combination_marks,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
group by  c.union_area_name,c.goods_code,c.combination_marks)t1
group by  union_area_name,combination_marks) t2)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and assess_method='组合'
and  1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.union_area_name,a.combination_marks,b.target_stores,a.cus_num)
where a>='${p1}'
group by union_area_name)
group by union_area_name
union all
--下旬陈列备货达标品种数
select union_area_name,0 s,0 a,sum(s) b,0 c from (
select union_area_name,count(b) as s from(select c.union_area_name,c.goods_code,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display) end ) as b   
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and c.assess_method='单品'
and 1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_display)
where b>='${p2}'
group by union_area_name
union all
select union_area_name,count(b) as s from (
select a.union_area_name,a.combination_marks,  
(case when b.target_display=0 then null else (sum(a.stock_qty)/b.target_display) end ) as b  
from 
(select union_area_name,combination_marks,cus_num,stock_qty from ( 
select union_area_name,stock_qty, combination_marks,cus_num, row_number() over(partition by combination_marks order by cus_num desc) rn 
from( 
select union_area_name,combination_marks,stock_qty,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
group by  c.goods_code,c.combination_marks,c.union_area_name)t1
group by  combination_marks,stock_qty,union_area_name) t2
 ) t where t.rn <=1)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and assess_method='组合'
and 1=1 ${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.combination_marks,b.target_display,a.union_area_name)
where b>='${p2}'
group by union_area_name)
group by union_area_name
union all
--下旬综合备货达标品种数
select union_area_name,0 s,0 a,0 b,sum(s) c from (
select union_area_name,count(*) as s from(select c.union_area_name,c.goods_code,
(case when target_stores=0 then null else (count(distinct a.cus_code)/target_stores) end ) as a,
(case when target_display=0 then null else (sum(a.stock_qty)/target_display) end ) as b   
 from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and c.assess_method='单品'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
group by  c.goods_code,c.union_area_name,target_display,target_stores)
where a>='${p1}' and b>='${p2}'
group by union_area_name
union all
select union_area_name,count(*) as s from (
select a.union_area_name,a.combination_marks,
(case when b.target_stores=0 then null else (a.cus_num/b.target_stores) end ) as a,  
(case when b.target_display=0 then null else (sum(a.stock_qty)/b.target_display) end ) as b  
from 
(select union_area_name,combination_marks,cus_num,stock_qty from ( 
select union_area_name,stock_qty, combination_marks,cus_num, row_number() over(partition by combination_marks order by cus_num desc) rn 
from( 
select union_area_name,combination_marks,stock_qty,max(t1.cus_num) cus_num from
(select c.union_area_name,c.combination_marks,c.goods_code,sum(a.stock_qty)stock_qty,count(distinct a.cus_code)cus_num from fact_stock_shop_new a ,dim_region b,dim_goods_key_catalogue c,dim_cus d
where a.ddate=c.create_xun
and a.area_code=b.area_code
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and d.attribute='直营'
and c.assess_method='组合'
and  1=1${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and a.stock_qty>0
and a.ddate=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
group by  c.goods_code,c.combination_marks,c.union_area_name)t1
group by  combination_marks,stock_qty,union_area_name) t2
 ) t where t.rn <=1)a
left join (
select union_area_name,combination_marks,min(target_stores) as target_stores,min(target_display)as target_display from dim_goods_key_catalogue
where  create_xun=last_day(to_date('${Date}'||-'28','yyyy-mm-dd'))
and assess_method='组合'
and  1=1${if(len(attributes)=0,""," and key_breed_attributes  in ('"+attributes +"')")}
group by union_area_name,combination_marks ) b on a.combination_marks=b.combination_marks
group by a.combination_marks,b.target_stores,b.target_display,a.union_area_name,a.cus_num)
where a>='${p1}' and b>='${p2}'
group by union_area_name)
group by union_area_name)
group by union_area_name

