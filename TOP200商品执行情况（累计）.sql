select union_area_name,count(distinct goods_code) goods_num from (
select r.union_area_name,a.cus_code,a.goods_code from fact_sale a left join DIM_NET_CATALOGUE_GENERAL_ALL D
ON A.AREA_CODE=D.AREA_CODE and A.GOODS_CODE=D.GOODS_CODE
 and to_char(A.SALE_DATE,'YYYY-MM')=D.CREATE_MONTH
 left join dim_region r
 on a.area_code=r.area_code
  join dim_goods_area_top200 t
 on a.goods_code=t.goods_code
 and r.union_area_name=t.union_area_name
  and t.sale_month=case when to_char(a.sale_date,'yyyymm')<'201908' then '201908' else to_char(a.sale_date,'yyyymm') end 
  left join dim_cus c
 on a.area_code=c.area_code
 and a.cus_code=c.cus_code
 where  1=1 ${if(len(GATH)=0,"","and nvl(d.new_attribute,'地采') IN ('"+GATH+"')")}
  and   a.sale_date >=date'${start}'
    and 
    a.sale_date<trunc(date'${end}'+1)
     and c.attribute='直营'
    
union 
select r.union_area_name,a.cus_code,a.goods_code from DM_STOCK_SHOP_DETAIL a
left join dim_region r
 on a.area_code=r.area_code
  join dim_goods_area_top200 t
 on a.goods_code=t.goods_code
 and r.union_area_name=t.union_area_name
  and t.sale_month=case when to_char(a.ddate,'yyyymm')<'201908' then '201908' else to_char(a.ddate,'yyyymm') end 
 left join dim_cus c
 on a.area_code=c.area_code
 and a.cus_code=c.cus_code
where ddate=date'${end}'
and  1=1 ${if(len(GATH)=0,"","and a.gather IN ('"+GATH+"')")}
and c.attribute='直营'
 )
 
  group by union_area_name

select union_area_name ,avg(goods_num) goods_num from (
select union_area_name,cus_code,count(distinct goods_code) goods_num from (
select r.union_area_name,a.cus_code,a.goods_code from fact_sale a left join DIM_NET_CATALOGUE_GENERAL_ALL D
ON A.AREA_CODE=D.AREA_CODE and A.GOODS_CODE=D.GOODS_CODE
 and to_char(A.SALE_DATE,'YYYY-MM')=D.CREATE_MONTH
 left join dim_region r
 on a.area_code=r.area_code
 join dim_goods_area_top200 t
 on a.goods_code=t.goods_code
 and r.union_area_name=t.union_area_name
  and t.sale_month=case when to_char(a.sale_date,'yyyymm')<'201908' then '201908' else to_char(a.sale_date,'yyyymm') end 
  left join dim_cus c
 on a.area_code=c.area_code
 and a.cus_code=c.cus_code
 where  1=1 ${if(len(GATH)=0,"","and nvl(d.new_attribute,'地采') IN ('"+GATH+"')")}
  and   a.sale_date >=date'${start}'
    and 
    a.sale_date<trunc(date'${end}'+1)
   and c.attribute='直营'
union 
select r.union_area_name,a.cus_code,a.goods_code from DM_STOCK_SHOP_DETAIL a
left join dim_region r
 on a.area_code=r.area_code
 join dim_goods_area_top200 t
 on a.goods_code=t.goods_code
 and r.union_area_name=t.union_area_name
  and t.sale_month=case when to_char(a.ddate,'yyyymm')<'201908' then '201908' else to_char(a.ddate,'yyyymm') end 
  left join dim_cus c
 on a.area_code=c.area_code
 and a.cus_code=c.cus_code
where ddate=date'${end}'
and  1=1 ${if(len(GATH)=0,"","and a.gather IN ('"+GATH+"')")}
and c.attribute='直营'
)
  group by union_area_name,cus_code)
  group by union_area_name

select distinct union_area_name from dim_region

SELECT r.union_area_name,
       count(distinct a.goods_code) goods_num,    
       SUM(a.NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(a.NO_TAX_COST) as NO_TAX_COST,
         SUM(a.NO_TAX_AMOUNT)- SUM(a.NO_TAX_COST) NO_TAX_profit,
       sum(a.TAX_AMOUNT) as TAX_AMOUNT,
       sum(a.TAX_COST) as TAX_COST
  FROM  DIM_CUS B,FACT_SALE A
   left join dim_region r
   on a.area_code=r.area_code
   join dim_goods_area_top200 t
 on a.goods_code=t.goods_code
 and r.union_area_name=t.union_area_name
 and t.sale_month=case when to_char(a.sale_date,'yyyymm')<'201908' then '201908' else to_char(a.sale_date,'yyyymm') end 
 WHERE 
  A.AREA_CODE=B.AREA_CODE 
  and A.CUS_CODE=B.CUS_CODE
and     b.ATTRIBUTE = '直营'
--and  nvl(d.new_attribute,'地采') IN  ('集采贴牌','集采高毛','集采品牌高毛','集采专销')
  and   a.sale_date >=date'${start}'
  
   and a.sale_date<trunc(date'${end}'+1)

 GROUP BY r.union_area_name

SELECT r.union_area_name,
       count(distinct a.goods_code) goods_num,    
       SUM(a.NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(a.NO_TAX_COST) as NO_TAX_COST,
         SUM(a.NO_TAX_AMOUNT)- SUM(a.NO_TAX_COST) NO_TAX_profit,
       sum(a.TAX_AMOUNT) as TAX_AMOUNT,
       sum(a.TAX_COST) as TAX_COST
  FROM  DIM_CUS B,FACT_SALE A
   left join dim_region r
   on a.area_code=r.area_code
   join dim_goods_area_top200 t
 on a.goods_code=t.goods_code
 and r.union_area_name=t.union_area_name
  and t.sale_month=case when to_char(a.sale_date,'yyyymm')<'201908' then '201908' else to_char(a.sale_date,'yyyymm') end 
 WHERE 
  A.AREA_CODE=B.AREA_CODE 
  and A.CUS_CODE=B.CUS_CODE
and     b.ATTRIBUTE = '直营'
--and  nvl(d.new_attribute,'地采') IN  ('集采贴牌','集采高毛','集采品牌高毛','集采专销')
  and   a.sale_date >=add_months(date'${start}',-12)
  
   and a.sale_date<add_months(trunc(date'${end}'+1),-12)

 GROUP BY r.union_area_name

SELECT r.union_area_name,
       count(distinct a.goods_code) goods_num,    
       SUM(a.NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(a.NO_TAX_COST) as NO_TAX_COST,
         SUM(a.NO_TAX_AMOUNT)- SUM(a.NO_TAX_COST) NO_TAX_profit,
       sum(a.TAX_AMOUNT) as TAX_AMOUNT,
       sum(a.TAX_COST) as TAX_COST
  FROM  DIM_CUS B,FACT_SALE A
   left join dim_region r
   on a.area_code=r.area_code
   join dim_goods_area_top200 t
 on a.goods_code=t.goods_code
 and r.union_area_name=t.union_area_name
  and t.sale_month=case when to_char(a.sale_date,'yyyymm')<'201908' then '201908' else to_char(a.sale_date,'yyyymm') end 
 WHERE 
  A.AREA_CODE=B.AREA_CODE 
  and A.CUS_CODE=B.CUS_CODE
and     b.ATTRIBUTE = '直营'
--and  nvl(d.new_attribute,'地采') IN  ('集采贴牌','集采高毛','集采品牌高毛','集采专销')
  and   a.sale_date >=add_months(date'${start}',-1)
  
   and a.sale_date<add_months(trunc(date'${end}'+1),-1)

 GROUP BY r.union_area_name

select r.union_area_name,sum(no_tax_amount) no_tax_amount from dm_sale_tmp a
left join dim_cus b
on a.cus_code=b.cus_code
and a.area_code=b.area_code
left join dim_region r
on a.area_code=r.area_code 
where sale_date>=date'${start}' 
and sale_date<trunc(date'${end}'+1)
and b.attribute='直营'

and oto='否'
and dtp='否'
group by r.union_area_name

select r.union_area_name,sum(no_tax_amount) no_tax_amount from dm_sale_tmp a
left join dim_cus b
on a.cus_code=b.cus_code
and a.area_code=b.area_code
left join dim_region r
on a.area_code=r.area_code 
where  sale_date>=add_months(date'${start}' ,-12)
and sale_date<add_months(trunc(date'${end}'+1),-12)
and b.attribute='直营'

and oto='否'
and dtp='否'
group by r.union_area_name

select r.union_area_name,sum(no_tax_amount) no_tax_amount from dm_sale_tmp a
left join dim_cus b
on a.cus_code=b.cus_code
and a.area_code=b.area_code
left join dim_region r
on a.area_code=r.area_code 
where  sale_date>=add_months(date'${start}' ,-1)
and sale_date<add_months(trunc(date'${end}'+1),-1)
and b.attribute='直营'

and oto='否'
and dtp='否'
group by r.union_area_name

select distinct gather from dm_sale_tmp

