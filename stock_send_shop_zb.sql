select 
       fd.cus_code,
       dc.cus_name,
       fd.goods_code,
       dg.goods_name,
       fd.sale_date,
       fd.delivery_qty,
       fd.no_tax_amount,
       fd.no_tax_cost,
       (fd.no_tax_amount-fd.no_tax_cost) no_tax_maoli,
       decode(fd.delivery_qty,0,0,round(fd.tax_amount/fd.delivery_qty,4)) tax_price,
       fd.tax_amount,
       dg.specification,
       dg.manufacturer/*,
       trunc(sysdate) flash_date*/
       
  from (select  fdd.area_code,fdd.cus_code,ddc.goods_code, fdd.sale_date, sum(fdd.delivery_qty) delivery_qty,
   sum(fdd.no_tax_amount) no_tax_amount,sum(fdd.no_tax_cost) no_tax_cost,
   sum(fdd.no_tax_amount-fdd.no_tax_cost) no_tax_maoli, sum(fdd.tax_amount) tax_amount
     from fact_delivery fdd, dim_disable_code ddc,dim_cus dc
    where fdd.goods_code = ddc.disable_code
      and fdd.area_code=dc.area_code
   and fdd.cus_code=dc.cus_code
   and fdd.delivery_type in('批发')
   and fdd.area_code='00'
   and dc.related_party_trnsaction='是'
   --and fdd.sale_date>trunc(sysdate-30)
   and ${if(len(item) = 0, "1=1","  ddc.goods_code in ('"+item+"')") }
   and ${if(len(store) = 0, "1=1","  substr(fdd.cus_code,1,6) in ('"+store+"')") }
   and fdd.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
    group by  fdd.area_code,fdd.cus_code,ddc.goods_code, fdd.sale_date) fd, 
       dim_region dr,
       dim_goods dg,
       dim_cus dc
 where fd.area_code = dr.area_code
   and fd.goods_code=dg.goods_code
   and fd.area_code=dc.area_code
   and fd.cus_code=dc.cus_code
   and dc.area_code='00'
   and dc.related_party_trnsaction='是'
  order by dc.cus_code,fd.sale_date,fd.goods_code

select * from dim_region dr where ${if(len(region)=0, "1=1",  " dr.area_code in ('"+regiog+"')")}

select distinct sub_category from dim_goods

select distinct
       ddc.goods_code,
       ddc.goods_code||'|'||dg.goods_name goods_name
  from fact_delivery fd,dim_disable_code ddc,dim_goods dg,dim_cus dc
 where  
       fd.goods_code=ddc.disable_code
   and ddc.disable_code=dg.goods_code
   and fd.area_code=dc.area_code
   and fd.cus_code=dc.cus_code
   and fd.delivery_type in('批发')
   and fd.area_code='00'
   and dc.related_party_trnsaction='是'
   and  ${if(len(region) = 0, "1=1", "  fd.area_code in ('"+region+"')") }
   and  fd.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   order by 1

select wc.wf_customer_id,
       　wc.wf_customer_id||'|'||wc.wf_customer_name　wf_customer_name from dim_cus dc,wf_customer wc
        where dc.related_party_trnsaction='是'　
   　　　　and substr(dc.cus_code,1,6)=to_char(wc.wf_customer_id)
   order by 1

