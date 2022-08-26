select A.AREA_CODE,
       C.GOODS_CODE,
       A.DTP,
       A.GATHER NEW_ATTRIBUTE,
       C.GOODS_NAME,
       C.SPECIFICATION,
       C.MANUFACTURER,
       SUM(a.dc_qty) as STOCK_QTY_DC,
       SUM(a.zy_qty) as STOCK_QTY_MD,
       SUM(a.dc_cost) as NO_TAX_COST_DC,
       SUM(a.zy_cost) as NO_TAX_COST_MD
  from DAY_DM_STOCK_PERIOD_ALL   A,
       dim_region       dr,
       USER_AUTHORITY   ua,
       DIM_DISABLE_CODE B,
       DIM_GOODS        C
 where a.area_code = dr.area_code
   and (dr.UNION_AREA_NAME = ua.UNION_AREA_NAME or
       ua.UNION_AREA_NAME = 'ALL')
   and ${"ua.user_id='" + $fr_username + "'"}
   and A.goods_code = B.disable_code(+)
   and 1 = 1 ${if(len(region) = 0, "", "and a.Area_code in ('" + region + "')")}
   --and to_char(ddate, 'yyyy-mm') = '${Date}'
   and 1 = 1 ${if(len(DTP) = 0, "", "and DTP in ('" + DTP + "')") }
   AND 1 = 1 ${if(len(JC) = 0, "", "and NEW_ATTRIBUTE in ('" + JC + "')") }
   AND 1 = 1 ${if(len(GCODE) = 0, "", "and B.GOODS_CODE in ('" + GCODE + "')")}
   --and dr.area_code=50
   --and to_char(ddate, 'yyyy-mm')='2020-05'
   and  B.GOODS_CODE = C.GOODS_CODE(+)
 GROUP BY C.GOODS_CODE,
          A.DTP,
          A.Gather,
          C.GOODS_NAME,
          C.SPECIFICATION,
          C.MANUFACTURER,
          A.AREA_CODE
 order by A.AREA_CODE, C.GOODS_CODE

select distinct C.goods_code||'|'||C.goods_name goods_name,C.goods_code from DM_STOCK_GOODS A,DIM_DISABLE_CODE B,DIM_GOODS C where
1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}
and A.GOODS_CODE=B.DISABLE_CODE and B.GOODS_CODE=C.GOODS_CODE
and to_char(ddate,'yyyy-mm')='${Date}'  
--and rownum<5000
order by 2

select area_code,area_name from dim_region

select distinct NEW_ATTRIBUTE from DIM_NET_CATALOGUE_GENERAL_ALL where CREATE_MONTH='${Date}' 
union select '地采' from  dual

