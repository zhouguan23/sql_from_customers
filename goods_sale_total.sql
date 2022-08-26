select a.area_code,
       r.area_name,
       g.goods_code as 商品编码,
       g.goods_name as 商品名称,
       g.specification as 规格,
       g.manufacturer as 生产厂家,
      -- c.cus_name 门店,
       g.unit 单位,
       sum(tax_amount) 含税销售价,
       sum(tax_cost) 含税成本,
       nvl(sum(tax_amount), 0) - nvl(sum(tax_cost),0) 毛利,
       (nvl(sum(tax_amount), 0) - nvl(sum(tax_cost),0))/nullif(sum(tax_amount),0) 毛利率,
       sum(sale_qty) 销售数量
       
  from fact_sale a

   join (select distinct t2.area_code, t2.goods_code,goods_name,specification,manufacturer,unit from dim_goods t1 left join 
  dim_goods_directory t2 on t1.goods_code=t2.goods_code
  where 1=1  ${if(len(type) = 0, "", " and t2.type IN ('" + type + "') ") } 
 ${if(len(AREA) = 0, "", " and t2.AREA_CODE IN ('" + AREA + "') ") }
 ${if(len(GOODS) = 0, "", " and t2.GOODS_CODE IN ('" + GOODS + "') ") }

    ) g
    on a.goods_code = g.goods_code
    and a.area_code=g.area_code
    left join dim_cus c
    on a.cus_code=c.cus_code
    and a.area_code=c.area_code
    left join dim_region r
    on a.area_code=r.area_code
   
 WHERE A.SALE_DATE >= DATE '${start}'
   AND A.SALE_DATE < DATE '${end}'+1
   group by a.area_code,
    r.area_name,
       g.goods_code ,
       g.goods_name ,
       g.specification ,
       g.manufacturer,
        g.unit 
        order by 1,3

SELECT  DISTINCT  
AREA_CODE,
AREA_NAME 
FROM 
DIM_REGION
WHERE  
1=1
${if(len(AREA)=0,"", "AND AREA_CODE IN ('"+AREA+"')")}

SELECT  DISTINCT  
CUS_CODE,
CUS_NAME 
FROM 
DIM_CUS
WHERE  
1=1
${if(len(AREA)=0,"", "AND AREA_CODE IN ('"+AREA+"')")}

${if(len(CUS)=0,"", "AND CUS_CODE IN ('"+CUS+"')")}

SELECT DISTINCT
b.GOODS_CODE, 
b.GOODS_CODE||'|'||b.GOODS_NAME goods_name1,
B.GOODS_NAME,
g.type
FROM
DIM_GOODS B

left join dim_goods_directory g
on b.GOODS_CODE=g.goods_code


order by 1 desc

select a.area_code,g.goods_code,sum(stock_qty_md) stock_qty from dm_stock_goods a

  left join dim_goods g
    on a.goods_code = g.goods_code where  1=1  ${if(len(GOODS) = 0, "", " and g.GOODS_CODE IN ('" + GOODS + "') ") }
${if(len(AREA) = 0, "", " and A.AREA_CODE IN ('" + AREA + "') ") }
and  ddate = add_months(trunc(sysdate-1,'mm'),0)-1

group by a.area_code,g.goods_code

select g.goods_code,sum(stock_qty_DC) stock_qty from dm_stock_goods a
 
  left join dim_goods g
    on a.goods_code = g.goods_code where  1=1  ${if(len(GOODS) = 0, "", " and g.GOODS_CODE IN ('" + GOODS + "') ") }
and  ddate = add_months(trunc(sysdate-1,'mm'),0)-1

group by g.goods_code

 
select
       sum(tax_amount) 含税销售价,
       sum(tax_cost) 含税成本,
       nvl(sum(tax_amount), 0) - nvl(sum(tax_cost),0) 毛利,
       (nvl(sum(tax_amount), 0) - nvl(sum(tax_cost),0))/nullif(sum(tax_amount),0) 毛利率,
       sum(sale_qty) 销售数量       
  from fact_sale a
  left join dim_disable_code b
    on a.goods_code = b.disable_code
   join (select distinct t1.goods_code,goods_name,specification,manufacturer,unit from dim_goods t1 left join 
  dim_goods_directory t2 on t1.goods_code=t2.goods_code where 1=1  ${if(len(type) = 0, "", " and t2.type IN ('" + type + "') ") } )g
    on b.goods_code = g.goods_code
    left join dim_cus c
    on a.cus_code=c.cus_code
    and a.area_code=c.area_code
    left join dim_region r
    on a.area_code=r.area_code
 
 WHERE 1 = 1
 ${if(len(AREA) = 0, "", " and A.AREA_CODE IN ('" + AREA + "') ") }
 ${if(len(GOODS) = 0, "", " and g.GOODS_CODE IN ('" + GOODS + "') ") }

   AND A.SALE_DATE >= DATE '${start}'
   AND A.SALE_DATE < DATE '${end}'+1
   

 
select
       sum(tax_amount) 含税销售价,
       sum(tax_cost) 含税成本,
       nvl(sum(tax_amount), 0) - nvl(sum(tax_cost),0) 毛利,
       (nvl(sum(tax_amount), 0) - nvl(sum(tax_cost),0))/nullif(sum(tax_amount),0) 毛利率,
       sum(sale_qty) 销售数量       
  from fact_sale a
  left join dim_disable_code b
    on a.goods_code = b.disable_code
  left join dim_goods g
    on b.goods_code = g.goods_code
    left join dim_cus c
    on a.cus_code=c.cus_code
    and a.area_code=c.area_code
    left join dim_region r
    on a.area_code=r.area_code
   
 WHERE 1 = 1
 ${if(len(AREA) = 0, "", " and A.AREA_CODE IN ('" + AREA + "') ") }
 ${if(len(GOODS) = 0, "", " and g.GOODS_CODE IN ('" + GOODS + "') ") }

   AND A.SALE_DATE >= DATE '${start}'
   AND A.SALE_DATE < DATE '${end}'+1
   

