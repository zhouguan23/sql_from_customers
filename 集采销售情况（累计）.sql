SELECT r.union_area_name,
       count(distinct a.goods_code) goods_num,    
       SUM(a.NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(a.NO_TAX_COST) as NO_TAX_COST,
       sum(a.TAX_AMOUNT) as TAX_AMOUNT,
       sum(a.TAX_COST) as TAX_COST
  FROM  DIM_CUS B,FACT_SALE A
left join DIM_DTP C
on A.AREA_CODE=C.AREA_CODE and A.GOODS_CODE=C.GOODS_CODE
 and to_char(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM')=C.CREATE_MONTH
left join DIM_NET_CATALOGUE_GENERAL_ALL D
ON A.AREA_CODE=D.AREA_CODE and A.GOODS_CODE=D.GOODS_CODE
 and to_char(A.SALE_DATE,'YYYY-MM')=D.CREATE_MONTH
   left join dim_region r
   on a.area_code=r.area_code
 WHERE 
  A.AREA_CODE=B.AREA_CODE 
  and A.CUS_CODE=B.CUS_CODE
and     b.ATTRIBUTE = '直营'
 AND 1=1 ${if(len(GATH)=0,"","and nvl(d.new_attribute,'地采') IN ('"+GATH+"')")}
  and   a.sale_date >=date'${start}'
    and 
    a.sale_date<trunc(date'${end}'+1)

 GROUP BY r.union_area_name



SELECT 
      count(distinct a.goods_code) goods_num  
      
  FROM  DIM_CUS B,FACT_SALE A
left join DIM_DTP C
on A.AREA_CODE=C.AREA_CODE and A.GOODS_CODE=C.GOODS_CODE
 and to_char(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM')=C.CREATE_MONTH
left join DIM_NET_CATALOGUE_GENERAL_ALL D
ON A.AREA_CODE=D.AREA_CODE and A.GOODS_CODE=D.GOODS_CODE
 and to_char(A.SALE_DATE,'YYYY-MM')=D.CREATE_MONTH
   left join dim_region r
   on a.area_code=r.area_code
 WHERE A.AREA_CODE=B.AREA_CODE 
  and A.CUS_CODE=B.CUS_CODE
and   b.ATTRIBUTE = '直营'
  AND 1=1 ${if(len(GATH)=0,"","and nvl(d.new_attribute,'地采') IN ('"+GATH+"')")}
  and   sale_date >=date'${start}'
    and 
    sale_date<trunc(date'${end}'+1)


SELECT 
      count(distinct a.goods_code) goods_num  
      
  FROM  DIM_CUS B,FACT_SALE_new A
left join DIM_DTP C
on A.AREA_CODE=C.AREA_CODE and A.GOODS_CODE=C.GOODS_CODE
 and to_char(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM')=C.CREATE_MONTH
left join DIM_NET_CATALOGUE_GENERAL_ALL D
ON A.AREA_CODE=D.AREA_CODE and A.GOODS_CODE=D.GOODS_CODE
 and to_char(A.SALE_DATE,'YYYY-MM')=D.CREATE_MONTH
   left join dim_region r
   on a.area_code=r.area_code
 WHERE A.AREA_CODE=B.AREA_CODE 
  and A.CUS_CODE=B.CUS_CODE
and   b.ATTRIBUTE = '直营'
  AND 1=1 ${if(len(GATH)=0,"","and nvl(d.new_attribute,'地采') IN ('"+GATH+"')")} 
  and   sale_date >=add_months(date'${start}',-12)
  and 
    sale_date<add_months(trunc(date'${end}'+1),-12)


SELECT r.union_area_name,
       
       SUM(a.NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(a.NO_TAX_COST) as NO_TAX_COST,
       sum(a.TAX_AMOUNT) as TAX_AMOUNT,
       sum(a.TAX_COST) as TAX_COST
  FROM dm_sale_tmp a
  left join dim_cus b
  on a.area_code=b.area_code
  and a.cus_code=b.cus_code
   left join dim_region r
   on a.area_code=r.area_code
 WHERE b.ATTRIBUTE = '直营'
  and   sale_date >=date'${start}'
    and 
    sale_date<trunc(date'${end}'+1)
    and oto='否'
    and dtp='否'

 GROUP BY r.union_area_name



SELECT r.union_area_name,
       
       SUM(a.NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(a.NO_TAX_COST) as NO_TAX_COST,
       sum(a.TAX_AMOUNT) as TAX_AMOUNT,
       sum(a.TAX_COST) as TAX_COST
  FROM dm_sale_tmp a
  left join dim_cus b
  on a.area_code=b.area_code
  and a.cus_code=b.cus_code
   left join dim_region r
   on a.area_code=r.area_code
 WHERE b.ATTRIBUTE = '直营'
  and   sale_date >=add_months(date'${start}',-12)
    and 
    sale_date<add_months(trunc(date'${end}'+1),-12)
and oto='否'
    and dtp='否'
 GROUP BY r.union_area_name



select r.union_area_name, sum(no_tax_amount) no_tax_amount, count(distinct a.goods_code) goods_num,
sum(no_tax_cost) no_tax_cost
  from fact_sale a
  left join dim_cus b
    on a.area_code = b.area_code
    and a.cus_code=b.cus_code
  left join DIM_NET_CATALOGUE_GENERAL_ALL D
    ON A.AREA_CODE = D.AREA_CODE
   and A.GOODS_CODE = D.GOODS_CODE
   and to_char(A.SALE_DATE, 'YYYY-MM') = D.CREATE_MONTH
  left join dim_region r
    on a.area_code = r.area_code
 where   b.ATTRIBUTE = '直营'
 AND 1=1 ${if(len(GATH)=0,"","and nvl(d.new_attribute,'地采') IN ('"+GATH+"')")}
  and   a.sale_date >=add_months(date'${start}',-12)
    and 
    a.sale_date<add_months(trunc(date'${end}'+1),-12)
 group by r.union_area_name


select distinct union_area_name from dim_region where 1=1
and area_code!='00'

select distinct gather from dm_sale_tmp
where sale_date >=date'${start}'
    and 
    sale_date<trunc(date'${end}'+1)

