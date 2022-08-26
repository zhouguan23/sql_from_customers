select crph.supplier_site_id,
       substr(crph.supplier_site_id,1,6) sup,
       sa.sup_name,
       ddc.goods_code,
       dg.goods_name,
       dg.specification,
       dg.manufacturer,
       sum(crpd.payment_qty) payment_qty,
       sum(crpd.payment_amt) payment_amt

  from cmx_reim_payment_head   crph,
       cmx_reim_payment_detail crpd,
       sup_attribute           sa,
       dim_goods               dg,
       zux_region_ou           zro,
       dim_region              dr,
       dim_disable_code        ddc
 where crph.header_id = crpd.header_id
   and crph.supplier_site_id = sa.supplier
   and crpd.item = dg.goods_code
   and crph.org_unit_id=zro.org_unit_id
   and zro.brancode=dr.area_code
   and crpd.item=ddc.disable_code(+)
   --and crph.header_id=61829
   and  to_char(crpd.tran_date,'yyyy-mm') between '${date_from}' and '${date_to}'
   AND 1=1 ${if(len(store)=0,""," and supplier_site_id = '"+store+"'")}
   AND 1=1 ${if(len(item)=0,""," and ddc.goods_code in ('"+item+"')")}
   and dr.area_code=00
   --and to_char(crph.payment_date,'yyyy-mm')='2019-09'
   group by 
      crph.supplier_site_id,
       sa.sup_name,
       ddc.goods_code,
       dg.goods_name,
       dg.specification,
       dg.manufacturer
  ORDER BY crph.supplier_site_id,ddc.goods_code

select * from dim_region dr where ${if(len(region)=0, "1=1",  " dr.area_code in ('"+regiog+"')")}

select distinct sub_category from dim_goods

select distinct b.goods_code,b.goods_code||'|'||c.goods_name goods_name
from cmx_reim_payment_head d join cmx_reim_payment_detail A on d.header_id=a.header_id left join dim_disable_code B on a.item=b.disable_code
left join dim_goods C on B.goods_code=c.goods_Code
where to_char(a.tran_date,'yyyy-mm') between '${date_from}' and '${date_to}'
--AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
--AND 1=1 ${if(len(store)=0,""," and dtp = '"+store+"'")}
--AND 1=1 ${if(len(item)=0,""," and gather in ('"+item+"')")}
and rownum<5000
order by 1

select distinct ssr.wf_customer_id,ssr.store_name from STOCK_SEND_RECEIVE ssr

select --dpr.region,
       --dpr.region_name,
       dpr.supplier,
       ddc.goods_code item,
       sum(dpr.units) units,
       sum(dpr.no_vat_amount) no_vat_amount
  from DW_PURCHASE_RETURN dpr,
       dim_region    dr,
       dim_disable_code        ddc
 where dpr.order_type = '采购'
   and dpr.region=dr.area_code
   and dpr.item=ddc.disable_code(+)
   and dr.area_code=00
   and to_char(dpr.written_date,'yyyy-mm') between '${date_from}' and '${date_to}'
   AND 1=1 ${if(len(store)=0,""," and supplier = '"+store+"'")}
   AND 1=1 ${if(len(item)=0,""," and ddc.goods_code in ('"+item+"')")}
   group by dpr.supplier,ddc.goods_code

   select ddc.goods_code,
       sum(dpss.pfps_qty) pfps_qty, 
       sum(dpss.pfps_amount) pfps_amount,
       sum(dpss.zyps_qty) zyps_qty,
       sum(dpss.zyps_amount) zyps_amount,
       sum(dpss.jmps_qty) jmps_qty,
       sum(dpss.jmps_amount) jmps_amount,
       sum(dpss.zyxs_qty) zyxs_qty,
       sum(dpss.zyxs_amount) zyxs_amount,
       sum(dpss.jmxs_qty) jmxs_qty,
       sum(dpss.jmxs_amount) jmxs_amount
  from dm_purchase_sale_stock_goods dpss,dim_disable_code ddc
 where dpss.goods_code=ddc.disable_code(+)
   and dpss.area_code <> '00'
   --and dpss.goods_code = '2057276'
   --and dpss.goods_code in('2193732','2117018','2072982')
   --and dpss.date1='2019-09'
   and dpss.date1  between '${date_from}' and '${date_to}'
   AND 1=1 ${if(len(item)=0,""," and ddc.goods_code in ('"+item+"')")}
   group by ddc.goods_code

select ddc.goods_code,
       sum(dpss.gljyps_qty) gljyps_qty, 
       sum(dpss.gljyps_amount) pfps_amount
  from dm_purchase_sale_stock_goods dpss,dim_disable_code ddc
 where dpss.goods_code=ddc.disable_code(+)
   and dpss.area_code = '00'
   --and dpss.goods_code = '2057276'
   --and dpss.date1='2019-09'
   and dpss.date1  between '${date_from}' and '${date_to}'
   AND 1=1 ${if(len(item)=0,""," and ddc.goods_code in ('"+item+"')")}
   group by ddc.goods_code

select --dpr.region,
       --dpr.region_name,
       --dpr.supplier,
       ddc.goods_code item,
       sum(dpr.units) units,
       sum(dpr.no_vat_amount) no_vat_amount
  from DW_PURCHASE_RETURN dpr,
       dim_region    dr,
       dim_disable_code        ddc
 where dpr.order_type = '采购'
   and dpr.region=dr.area_code
   and dpr.item=ddc.disable_code(+)
   and dr.area_code<>00
   and to_char(dpr.written_date,'yyyy-mm') between '${date_from}' and '${date_to}'
   AND 1=1 ${if(len(store)=0,""," and supplier = '"+store+"'")}
   AND 1=1 ${if(len(item)=0,""," and ddc.goods_code in ('"+item+"')")}
   group by ddc.goods_code

