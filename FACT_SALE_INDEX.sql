SELECT 
b.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
a.CREATE_MONTH AS 月份,
a.VALUE AS 指标值,
a.NEW_VALUE,
a.OLD_VALUE,
a.SECOND_NEW_VALUE,
a.DTP,
a.OTO,
a.MEM,

a.BATCH,
a.SECOND_NEW_DTP,
a.Direct_stores_Num ,
a.Direct_stores_Non_hospital    ,
a.Direct_stores_hospital,
a.Franchised_store_num,
a.Net_increase ，
second_new_gpb，
second_new_pb,
a.jcgm
FROM 
FACT_SALE_INDEX a
right JOIN 
DIM_REGION b
ON 
a.AREA_CODE = b.AREA_CODE
and   
a.CREATE_MONTH = '${CREATE_MONTH}'
order by 1

