select *  from
(
select
  dr.area_code
 , ORDER_TYPE 
, to_char(ORDER_NO) ORDER_NO
, dr.AREA_NAME 
, STATUS 
, ddc.goods_code ITEM 
, SHORT_DESC 
, ATTR7 
, ATTR9 
, LOT 
, PRO_DATE 
, EFF_DATE 
, to_char(SUPPLIER) SUPPLIER 
, SUP_NAME 
, cwrr.USER_NAME 
, UNITS 
, WRITTEN_DATE 
, TAXRATE 
, UNIT_COST 
, NO_VAT_AMOUNT 
, VAT_COST 
, VAT_AMOUNT 
, dg.sub_composition
, cwrr.supp_pack_size
from cmx_wh_req_retrun cwrr,
     zux_region_ou zro,
     dim_region dr,USER_AUTHORITY  ua,
     dim_disable_code ddc,
     dim_goods dg
     
where cwrr.region=zro.region
  and zro.brancode=dr.area_code
  and (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
  and ${"ua.user_id='"+$fr_username+"'"}
  and cwrr.item=ddc.disable_code(+)
  and ddc.disable_code=dg.goods_code
  AND cwrr.written_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(region) = 0, "1=1", "  dr.area_code in ('"+region+"')") }
   and ${if(len(item) = 0, "1=1", "  cwrr.item in ('"+item+"')") }
   and ${if(len(busy_type) = 0, "1=1", "  cwrr.order_type in ('"+busy_type+"')") }
   --and ${if(len(category) = 0, "1=1", "  dg.sub_category in ('"+category+"')") }
  
  union all
  
select 
  dr.area_code
,  ORDER_TYPE 
, ORDER_NO 
, dr.AREA_NAME 
, STATUS 
, ITEM 
, SHORT_DESC 
, ATTR7 
, ATTR9 
, LOT 
, dpr.prd_date PRO_DATE 
, EFF_DATE 
, SUPPLIER
, SUP_NAME 
, dpr.USER_NAME 
, UNITS 
, WRITTEN_DATE 
, TAXRATE 
, UNIT_COST 
, NO_VAT_AMOUNT 
, VAT_COST 
, VAT_AMOUNT
, dg.sub_composition
,'' supp_pack_size
 from DW_PURCHASE_RETURN dpr,DIM_REGION DR,USER_AUTHORITY  ua,
     dim_disable_code ddc,
     dim_goods dg
where DPR.REGION=DR.AREA_CODE 
  and (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
  and ${"ua.user_id='"+$fr_username+"'"}
  and dpr.item=ddc.disable_code(+)
  and ddc.disable_code=dg.goods_code
  and dr.type='OFFLINE'
   --and dpr.written_date between to_date('2020-01-01','yyyy-mm-dd') and to_date('2020-03-29','yyyy-mm-dd')
   AND dpr.written_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(region) = 0, "1=1", "  dpr.region in ('"+region+"')") }
   and ${if(len(item) = 0, "1=1", "  dpr.item in ('"+item+"')") }
   and ${if(len(busy_type) = 0, "1=1", "  dpr.order_type in ('"+busy_type+"')") }
   --and ${if(len(category) = 0, "1=1", "  dg.sub_category in ('"+category+"')") }
  ) ORDER BY AREA_code,ORDER_TYPE,ORDER_NO,ITEM

select * from dim_region zro where ${if(len(region) = 0, "1=1", "  zro.area_code in ('"+region+"')") }

select distinct dpr.item,dpr.item||'|'||dpr.short_desc short_desc  from DW_PURCHASE_RETURN dpr where dpr.written_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
and ${if(len(region) = 0, "1=1", "  dpr.region in ('"+region+"')") }
order by 1

select distinct nvl(sub_category,'空') from dim_goods
 where 1=1 ${if(len(category)=0,"","and  nvl(sub_category,'空') in ('"+category+"')")}

