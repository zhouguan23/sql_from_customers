select a.* FROM DIM_CUS a,dim_region dr where a.area_code=dr.area_code and 1=1
${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(union_area)=0,""," and dr.union_area_name IN ('"+union_area+"') ")}
and 1=1
${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
${if(len(cus_name)=0,""," a.and cus_name in ('"+cus_name+"')")}

${if(len(attribute)=0,""," and a.attribute in ('"+attribute+"')")}
${if(len(small_scale)=0,""," and nvl(a.small_scale,'否') in ('"+small_scale+"')")}
and length(a.AREA_CODE)=2

${if(len(RELATED_PARTY_TRNSACTION)=0,""," and nvl(a.RELATED_PARTY_TRNSACTION,'否') in ('"+RELATED_PARTY_TRNSACTION+"')")}

${if(len(rpti)=0,""," and nvl(a.RELATED_PARTY_TRNSACTION_IN,'否') in ('"+rpti+"')")}

${if(len(VIP)=0,""," and a.VIP in ('"+VIP+"')")}

${if(len(VIRTUAL_SHOP)=0,""," and VIRTUAL_SHOP in ('"+VIRTUAL_SHOP+"')")}

${if(len(StartOpen)=0,""," and to_char(open_date,'yyyy/mm/dd') >= '"+StartOpen+"'")}
${if(len(EndOpen)=0,""," and to_char(close_date,'yyyy/mm/dd') >= '"+EndOpen+"'")}
${if(len(EndClose)=0,""," and to_char(close_date,'yyyy/mm/dd') <= '"+EndClose+"'")}
${if(len(StartClose)=0,""," and to_char(open_date,'yyyy/mm/dd') <= '"+StartClose+"'")}

order by a.area_code,a.cus_code,NVL(length(replace(CUS_NAME,'NONE','')),0) asc 

select distinct area_name,area_code from DIM_REGION
 where 1=1 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} order by 1

select distinct cus_code,cus_name from dim_cus where 1=1
${if(len(area)=0,""," and area_code in ('"+area+"')")}

SELECT '直营' AS a FROM DUAL
UNION ALL
SELECT '加盟' AS a FROM DUAL
UNION ALL 
SELECT '批发' AS a FROM DUAL

SELECT '是' AS a FROM DUAL
UNION ALL
SELECT '否' AS a FROM DUAL

select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a order by 1

