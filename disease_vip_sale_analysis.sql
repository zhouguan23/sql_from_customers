select * from 
(
select aa.area_code
      ,aa.area_name
      ,aa.union_area_name
      ,aa.cus_code
      ,aa.cus_name
      ,aa.GOODS_CODE
      ,aa.goods_name
      ,aa.manufacturer
      ,aa.ill_type
      ,aa.is_core
      ,aa.is_contact
      ,aa.SALE_QTY
      ,aa.NO_TAX_AMOUNT
      ,aa.NO_TAX_ML
      ,bb.NOVIP_SALE_QTY
      ,bb.NOVIP_NO_TAX_AMOUNT
      ,bb.NOVIP_NO_TAX_ML
  from 
       



(select dr.area_code
      ,dr.area_name
      ,dr.union_area_name
      ,dc.cus_code
      ,dc.cus_name
      ,fs.GOODS_CODE
      ,dg.goods_name
      ,dg.manufacturer
      ,dic.ill_type
       ,dic.is_core
       ,dic.is_contact
      ,sum(fs.SALE_QTY) SALE_QTY
      ,sum(fs.NO_TAX_AMOUNT) NO_TAX_AMOUNT
      ,sum(fs.NO_TAX_AMOUNT-fs.NO_TAX_COST) NO_TAX_ml
      
  from fact_sale fs,
       dim_region dr,
       dim_cus dc,
       dim_goods dg,
       DIM_ILLNESS_CATALOGUE dic
 where fs.AREA_CODE=dr.area_code
   and fs.AREA_CODE=dc.area_code
   and fs.CUS_CODE=dc.cus_code
   --and dc.attribute='直营'
   and fs.GOODS_CODE=dg.goods_code
   and fs.GOODS_CODE=dic.goods_code
   and fs.VIP='是'
   /*and fs.sale_date between to_date('2019-08-01','yyyy-mm-dd') and to_date('2019-08-31','yyyy-mm-dd')
   and fs.area_code=60
   and fs.GOODS_CODE='1115772'*/
   and fs.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(region) = 0, "1=1", "  fs.AREA_CODE in ('"+region+"')") }
   and ${if(len(item) = 0, "1=1", "  dic.goods_code in ('"+item+"')") }
   and ${if(len(store) = 0, "1=1", "  fs.CUS_CODE in ('"+store+"')") }
   and ${if(len(store_attr) = 0, "1=1", "  dc.attribute in ('"+store_attr+"')") }
   and ${if(len(item_type) = 0, "1=1", "  dic.ill_type in ('"+item_type+"')") }
   and ${if(len(attr9) = 0, "1=1", "  dg.manufacturer in ('"+attr9+"')") }
   and ${if(len(UAREA)=0, "1=1" ,"  dr.union_area_name in ('"+UAREA+"')")}
 group by dr.area_code
      ,dr.area_name
      ,dr.union_area_name
      ,dc.cus_code
      ,dc.cus_name
      ,fs.GOODS_CODE
      ,dg.goods_name
      ,dg.manufacturer
      ,dic.ill_type
       ,dic.is_core
       ,dic.is_contact
)aa,
(
select fs.area_code
      ,dc.cus_code
      ,fs.GOODS_CODE
      ,dic.ill_type
      ,sum(fs.SALE_QTY) NOVIP_SALE_QTY
      ,sum(fs.NO_TAX_AMOUNT) NOVIP_NO_TAX_AMOUNT
      ,sum(fs.NO_TAX_AMOUNT-fs.NO_TAX_COST) NOVIP_NO_TAX_ML
      
  from fact_sale fs,
       dim_cus dc,
       DIM_ILLNESS_CATALOGUE dic,
       dim_goods dg,
       dim_region dr
 where fs.AREA_CODE=dc.area_code
   and fs.CUS_CODE=dc.cus_code
   --and dc.attribute='直营'
   and fs.GOODS_CODE=dic.goods_code
   and fs.VIP='否'
   and dic.goods_code=dg.goods_code
   and fs.AREA_CODE=dr.area_code
   and fs.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(region) = 0, "1=1", "  fs.AREA_CODE in ('"+region+"')") }
   and ${if(len(item) = 0, "1=1", "  dic.goods_code in ('"+item+"')") }
   and ${if(len(store) = 0, "1=1", "  fs.CUS_CODE in ('"+store+"')") }
   and ${if(len(store_attr) = 0, "1=1", "  dc.attribute in ('"+store_attr+"')") }
   and ${if(len(item_type) = 0, "1=1", "  dic.ill_type in ('"+item_type+"')") }
   and ${if(len(attr9) = 0, "1=1", "  dg.manufacturer like ('"+attr9+"')") }
   and ${if(len(UAREA)=0, "1=1" ,"  dr.union_area_name in ('"+UAREA+"')")}
   /*and fs.sale_date between to_date('2019-08-01','yyyy-mm-dd') and to_date('2019-08-31','yyyy-mm-dd')
   and fs.area_code=60
   and dic.goods_code='1115772'*/
 group by fs.area_code
      ,dc.cus_code
      ,fs.GOODS_CODE
      ,dic.ill_type
)bb
where aa.area_code=bb.area_code(+)
  and aa.cus_code=bb.cus_code(+)
  and aa.GOODS_CODE=bb.GOODS_CODE(+)
  and aa.ill_type=bb.ill_type(+)
  --and aa.ill_type='糖尿病'

union all

select dr.area_code
      ,dr.area_name
      ,dr.union_area_name
      ,dc.cus_code
      ,dc.cus_name
      ,fs.GOODS_CODE
      ,dg.goods_name
      ,dg.manufacturer
      ,dic.ill_type
       ,dic.is_core
       ,dic.is_contact
      ,0 SALE_QTY
      ,0 NO_TAX_AMOUNT
      ,0 NO_TAX_ML
      ,sum(fs.SALE_QTY) NOVIP_SALE_QTY
      ,sum(fs.NO_TAX_AMOUNT) NOVIP_NO_TAX_AMOUNT
      ,sum(fs.NO_TAX_AMOUNT-fs.NO_TAX_COST) NOVIP_NO_TAX_ML
      
  from fact_sale fs,
       dim_region dr,
       dim_cus dc,
       dim_goods dg,
       DIM_ILLNESS_CATALOGUE dic
 where fs.AREA_CODE=dr.area_code
   and fs.AREA_CODE=dc.area_code
   and fs.CUS_CODE=dc.cus_code
   --and dc.attribute='直营'
   and fs.GOODS_CODE=dg.goods_code
   and fs.GOODS_CODE=dic.goods_code
   and fs.VIP='否'
   /*and fs.sale_date between to_date('2019-08-01','yyyy-mm-dd') and to_date('2019-08-31','yyyy-mm-dd')
   and fs.area_code=60
   and fs.GOODS_CODE='1115772'
   and dic.ill_type='糖尿病'*/
   and fs.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(region) = 0, "1=1", "  fs.AREA_CODE in ('"+region+"')") }
   and ${if(len(item) = 0, "1=1", "  dic.goods_code in ('"+item+"')") }
   and ${if(len(store) = 0, "1=1", "  fs.CUS_CODE in ('"+store+"')") }
   and ${if(len(store_attr) = 0, "1=1", "  dc.attribute in ('"+store_attr+"')") }
   and ${if(len(item_type) = 0, "1=1", "  dic.ill_type in ('"+item_type+"')") }
   and ${if(len(attr9) = 0, "1=1", "  dg.manufacturer in ('"+attr9+"')") }
   and ${if(len(UAREA)=0, "1=1" ," dr.union_area_name in ('"+UAREA+"')")}
   and  (fs.AREA_CODE,fs.CUS_CODE,fs.GOODS_CODE) not in (select fs1.AREA_CODE,fs1.CUS_CODE,fs1.GOODS_CODE
                     from fact_sale fs1,DIM_ILLNESS_CATALOGUE dic1,dim_region dr
                    where fs1.GOODS_CODE=dic1.goods_code
                      and fs.area_code=fs1.area_code
                      and fs.cus_code=fs1.cus_code
                      and fs.GOODS_CODE=fs1.GOODS_CODE
                      and dic.ill_type=dic1.ill_type
                      and fs1.VIP='是'
                      and fs1.AREA_CODE=dr.area_code
                      /*and fs1.sale_date between to_date('2019-08-01','yyyy-mm-dd') and to_date('2019-08-31','yyyy-mm-dd')
                      and fs1.area_code=60
                      and fs1.GOODS_CODE='1115772'*/
                      and ${if(len(UAREA)=0, "1=1" ," dr.union_area_name in ('"+UAREA+"')")}
                      and fs1.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
                        and ${if(len(region) = 0, "1=1", "  fs1.AREA_CODE in ('"+region+"')") }
                        and ${if(len(item) = 0, "1=1", "  fs1.goods_code in ('"+item+"')") }
                      )
 group by dr.area_code
      ,dr.area_name
      ,dr.union_area_name
      ,dc.cus_code
      ,dc.cus_name
      ,fs.GOODS_CODE
      ,dg.goods_name
      ,dg.manufacturer
      ,dic.ill_type
       ,dic.is_core
       ,dic.is_contact
 )
       order by area_code,cus_code,GOODS_CODE

select distinct area_code,area_name from dim_region  
--where ${if(len(uarea)==0,""," and union_area_name in ('"+uarea+"')")}
where ${if(len(UAREA)=0, "1=1" ," union_area_name in ('"+UAREA+"')")}

select fs.area_code
      ,dc.cus_code
      ,fs.GOODS_CODE
      ,dic.ill_type
      ,sum(fs.SALE_QTY) SALE_QTY
      ,sum(fs.NO_TAX_AMOUNT) NO_TAX_AMOUNT
      ,sum(fs.NO_TAX_AMOUNT-fs.NO_TAX_COST) NO_TAX_ml
      
  from fact_sale fs,
       dim_cus dc,
       DIM_ILLNESS_CATALOGUE dic,
       dim_goods dg
 where fs.AREA_CODE=dc.area_code
   and fs.CUS_CODE=dc.cus_code
   --and dc.attribute='直营'
   and fs.GOODS_CODE=dic.goods_code
   and fs.VIP='否'
   and dic.goods_code=dg.goods_code
   and fs.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(region) = 0, "1=1", "  fs.AREA_CODE in ('"+region+"')") }
   and ${if(len(item) = 0, "1=1", "  dic.goods_code in ('"+item+"')") }
   and ${if(len(store) = 0, "1=1", "  fs.CUS_CODE in ('"+store+"')") }
   and ${if(len(store_attr) = 0, "1=1", "  dc.attribute in ('"+store_attr+"')") }
   and ${if(len(item_type) = 0, "1=1", "  dic.ill_type in ('"+item_type+"')") }
   and ${if(len(attr9) = 0, "1=1", "  dg.manufacturer like ('"+attr9+"')") }
   --and fs.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-02','yyyy-mm-dd')
   --and fs.area_code=10
 group by fs.area_code
      ,dc.cus_code
      ,fs.GOODS_CODE
      ,dic.ill_type

select fsv.area_code,
       ddc.goods_code,
       fsv.cus_code,
       sum(fsv.sale_qty) sale_qty,
       sum(fsv.no_tax_amount) no_tax_amount,
       sum(fsv.no_tax_amount-fsv.no_tax_cost) NO_TAX_ml
  from fact_sale_vip fsv, dim_disable_code ddc,dim_region dr,DIM_ILLNESS_CATALOGUE dic
 where fsv.goods_code = ddc.disable_code
   and fsv.area_code=dr.area_code
   and fsv.goods_code=dic.goods_code   /*and fsv.sale_date between to_date('2019-11-01','yyyy-mm-dd') and to_date('2019-11-30','yyyy-mm-dd')
      and fsv.area_code=60
      and ddc.GOODS_CODE='1115772'*/
   and fsv.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(region) = 0, "1=1", "  fsv.AREA_CODE in ('" + region + "')")}
   and ${if(len(item) = 0, "1=1", "  ddc.goods_code in ('" + item + "')")}
   and ${if(len(store) = 0, "1=1", "  fsv.CUS_CODE in ('" + store + "')") }
   and ${if(len(UAREA)=0, "1=1" ,"  dr.union_area_name in ('"+UAREA+"')")}
   and ${if(len(item_type) = 0, "1=1", "  dic.ill_type in ('"+item_type+"')") }
   /*and exists (select dvcd.insiderid
          from dm_vip_chronic_detail dvcd
         where dvcd.area_code = fsv.area_code
           and dvcd.insiderid = fsv.insiderid
           and dvcd.cus_code = fsv.cus_code)*/
 group by fsv.area_code, ddc.goods_code, fsv.cus_code

select dg.goods_code,dg.goods_code||'|'||dg.goods_name goods_name
         from DIM_ILLNESS_CATALOGUE dic,
              fact_sale fs,
              dim_goods dg
       where dic.goods_code=fs.GOODS_CODE
         and fs.GOODS_CODE=dg.goods_code
         and fs.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
         and ${if(len(region) = 0, "1=1", "  fs.AREA_CODE in ('"+region+"')") }

select distinct dc.cus_code,dc.cus_code||'|'||dc.cus_name cus_name
         from DIM_ILLNESS_CATALOGUE dic,
              fact_sale fs,
              dim_cus dc
       where dic.goods_code=fs.GOODS_CODE
         and fs.AREA_CODE=dc.area_code
         and fs.CUS_CODE=dc.cus_code
         and fs.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
         and ${if(len(region) = 0, "1=1", "  fs.AREA_CODE in ('"+region+"')") }
         order by 1

select distinct dic.ill_type from DIM_ILLNESS_CATALOGUE dic

select distinct dg.manufacturer from dim_goods dg,fact_sale fs where fs.GOODS_CODE=dg.goods_code
and fs.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')

select distinct  union_area_name from dim_region

