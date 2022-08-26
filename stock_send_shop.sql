--create table dim_stock_send_shop as
select fd.area_code,
       dr.area_name,
       fd.cus_code,
       dc.cus_name,
       fd.goods_code,
       fd.delivery_type,
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
       
  from (
   select fdd.area_code, fdd.cus_code,ddc.goods_code,fdd.delivery_type, fdd.sale_date, sum(fdd.delivery_qty) delivery_qty,
   sum(fdd.no_tax_amount) no_tax_amount,sum(fdd.no_tax_cost) no_tax_cost,
   sum(fdd.no_tax_amount-fdd.no_tax_cost) no_tax_maoli, sum(fdd.tax_amount) tax_amount
     from fact_delivery fdd, dim_disable_code ddc
    where fdd.goods_code = ddc.disable_code
      and fdd.delivery_type in('直营','加盟')
      and ${if(len(item) = 0, "1=1","  ddc.goods_code in ('"+item+"')") }
      and ${if(len(store_attri) = 0, "1=1","  fdd.delivery_type in ('"+store_attri+"')") }
      and fdd.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
      and ${if(len(region) = 0, "1=1", "  fdd.area_code in ('"+region+"')") }
      and ${if(len(store) = 0, "1=1","  fdd.cus_code in ('"+store+"')") }
      --and fdd.goods_code='11111111111'
    group by fdd.area_code, fdd.cus_code,ddc.goods_code,fdd.delivery_type, fdd.sale_date
    ) fd, dim_region dr,dim_goods dg,dim_cus dc
 where fd.area_code = dr.area_code
   and fd.goods_code=dg.goods_code
   and fd.area_code=dc.area_code
   and fd.cus_code=dc.cus_code
   order by dr.area_code,dc.cus_code,fd.sale_date,fd.goods_code

select * from dim_region dr where ${if(len(region)=0, "1=1",  " dr.area_code in ('"+regiog+"')")}

select distinct sub_category from dim_goods

select distinct
       ddc.goods_code,
       ddc.goods_code||'|'||dg.goods_name goods_name
  from fact_delivery fd,dim_disable_code ddc,dim_goods dg
 where  
       fd.goods_code=ddc.disable_code
   and ddc.disable_code=dg.goods_code
   and  ${if(len(region) = 0, "1=1", "  fd.area_code in ('"+region+"')") }
   and  fd.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
ORDER BY 1


select distinct
       dc.cus_code,dc.cus_code||'|'||dc.cus_name cus_name
       
  from fact_delivery fd,dim_cus dc
 where 
        fd.delivery_type in('直营','加盟')
   and fd.area_code=dc.area_code
   and fd.cus_code=dc.cus_code
   and ${if(len(region) = 0, "1=1", "  fd.area_code in ('"+region+"')") }
   and fd.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   order by 1

