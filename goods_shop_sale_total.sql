select --a.sale_date as 日期,
       a.area_code ,
       r.area_name ,
       r.union_area_name,
       a.goods_code as 商品编码,
       g.goods_name as 商品名称,
       g.specification as 规格,
       g.manufacturer as 生产厂家,
       a.cus_code 门店编码,
       c.cus_name 门店,
      -- g.unit 单位,
       g.big_cate 大分类,
       g.category 品类,
             g.sub_category 细分品类,
             g.function 功能主治,
             g.composition 成分,
             g.sub_composition 细分成分,
             g.dosage_form 剂型,
             g.finishing_specification 整理规格,
             g.content 含量,
             g.load 装量,
             g.unit 单位,
             g.finishing_manufacturer 整理厂家,
              g.brand_definition 品牌定义,
              case when d.goods_code is not null then '是' else '否' end 是否DTP,
              nvl(dncg.new_attribute,'地采') 集采属性,
       case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end 含税销售价,
       case when '${Tax}'='无税' then SUM(NO_TAX_COST) ELSE SUM(TAX_COST) end 含税成本,
       nvl(case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end, 0) - nvl(case when '${Tax}'='无税' then SUM(NO_TAX_COST) ELSE SUM(TAX_COST) end,0) 毛利,
      
       sum(sale_qty) 销售数量
       
  from fact_sale a
 
   join (select distinct t2.area_code,t1.goods_code,t1.specification,t1.manufacturer,t1.goods_name,t1.big_cate ,
       t1.category ,
             t1.sub_category ,
             t1.function ,
             t1.composition ,
             t1.sub_composition ,
             t1.dosage_form ,
             t1.finishing_specification ,
             t1.content ,
             t1.load ,
             t1.unit ,
             t1.finishing_manufacturer ,
              t1.brand_definition from dim_goods t1  left join 
  dim_goods_directory t2 on t1.goods_code=t2.goods_code where 1=1  ${if(len(type) = 0, "", " and t2.type IN ('" + type + "') ") } 

 ${if(len(AREA) = 0, "", " and t2.AREA_CODE IN ('" + AREA + "') ") }

 ${if(len(GOODS) = 0, "", " and t2.GOODS_CODE IN ('" + GOODS + "') ") }
   and 1=1 ${if(len(cate)=0,""," and big_cate in ('"+cate+"')")}
  and 1=1 ${if(len(scategory)=0,""," and sub_category in ('"+scategory+"')")}
  and 1=1 ${if(len(fun)=0,""," and function in ('"+fun+"')")}
  and 1=1 ${if(len(composition)=0,""," and composition in ('"+composition+"')")}
and 1=1 ${if(len(form)=0,""," and dosage_form in ('"+form+"')")}
and 1=1 ${if(len(manufacturer)=0,""," and finishing_manufacturer in ('"+manufacturer+"')")}
   ) g
    on a.goods_code = g.goods_code
    and a.area_code=g.area_code
    left join dim_cus c
    on a.cus_code=c.cus_code
    and a.area_code=c.area_code
    left join dim_region r
    on a.area_code=r.area_code
    left join DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_net_catalogue_general_all dncg on a.area_code=dncg.area_code and a.goods_code=dncg.goods_code and to_char(a.sale_date,'yyyy-mm')=dncg.create_month
 WHERE  1=1
  ${if(len(CUS) = 0, "", " and A.CUS_CODE IN ('" + CUS + "') ") }
   ${if(len(union) = 0, "", " and r.union_area_name IN ('" + union + "') ") }
    ${if(len(cgsx) = 0, "", " and nvl(dncg.new_attribute,'地采') IN ('" + cgsx + "') ") }
      ${if(len(dtp) = 0, "", " and case when d.goods_code is not null then '是' else '否' end IN ('" + dtp + "') ") }
  and A.SALE_DATE >= DATE '${start}'
   AND A.SALE_DATE < DATE '${end}'+1
   group by  a.area_code ,
       r.area_name ,
        r.union_area_name,
       a.goods_code ,
       g.goods_name ,
       g.specification ,
       g.manufacturer,
        a.cus_code ,
        c.cus_name,
       g.big_cate ,
       g.category ,
             g.sub_category ,
             g.function ,
             g.composition ,
             g.sub_composition ,
             g.dosage_form ,
             g.finishing_specification ,
             g.content ,
             g.load ,
             g.unit ,
             g.finishing_manufacturer ,
              g.brand_definition,
               case when d.goods_code is not null then '是' else '否' end ,
             nvl(dncg.new_attribute,'地采')
        order by decode(a.area_code,'00','AA',r.union_area_name),a.area_code,a.goods_code 

SELECT  DISTINCT  
AREA_CODE,
AREA_NAME ,
union_area_name
FROM 
DIM_REGION


SELECT  DISTINCT  
CUS_CODE,
CUS_NAME 
FROM 
DIM_CUS
WHERE  
1=1
${if(len(AREA)=0,"", "AND AREA_CODE IN ('"+AREA+"')")}


SELECT DISTINCT
b.GOODS_CODE, 
b.goods_code||'|'||b.goods_name goods_name1,
B.GOODS_NAME,
g.type goods_type,
b.big_cate ,
       b.category ,
             b.sub_category ,
             b.function ,
             b.composition ,
             b.sub_composition ,
              b.finishing_manufacturer,
             b.dosage_form 
FROM
DIM_GOODS B left join dim_goods_directory g
on b.GOODS_CODE=g.goods_code
order by 1 

select a.area_code,a.cus_code,g.goods_code,sum(stock_qty) as stock_qty
from dm_Stock_shop_detail a

  left join dim_goods g
    on a.goods_code = g.goods_code
where   ddate = add_months(trunc(sysdate-1,'mm'),0)-1

AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
 ${if(len(GOODS) = 0, "", " and g.GOODS_CODE IN ('" + GOODS + "') ") }
group by a.area_code,a.cus_code,g.goods_code



select g.goods_code,sum(stock_qty_md) stock_qty from dm_stock_goods a
 
  left join dim_goods g
    on a.goods_code = g.goods_code where  1=1  ${if(len(GOODS) = 0, "", " and g.GOODS_CODE IN ('" + GOODS + "') ") }
${if(len(area)=0,""," and area_code in ('"+area+"')")}  and  ddate = add_months(trunc(sysdate-1,'mm'),0)-1
group by g.goods_code

select distinct type from dim_goods_directory

select distinct new_attribute from dim_net_catalogue_general_all
where create_month=to_char(date'${end}','yyyy-mm')

