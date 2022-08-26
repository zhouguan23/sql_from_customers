select
area_org_name,
city_org_name,
PROJ_NAME,
CONTRACT_NO, -- 系统编号
CONT_NAME
from f_po_cont_det
where
SETBID_NO is  null or  SETBID_NO <>'' 

SELECT DISTINCT 
AREA_ORG_CODE,
AREA_ORG_NAME
FROM f_po_cont_det
ORDER BY AREA_ORG_CODE

SELECT DISTINCT 
CITY_ORG_CODE,
CITY_ORG_NAME
FROM f_po_cont_det
WHERE 1=1
${IF(LEN(AREA)=0,"","AND AREA_ORG_CODE IN ('"+AREA+"')")}


select 
area_org_name, city_org_name,t1.contract_no,t1.cont_name
from f_po_cont_det_exp t1 
left join(
select distinct area_org_name,area_org_code,city_org_name,city_org_code,contract_no,cont_name,CONTRACT_ID
from f_po_cont_det) t2 on t1.contract_no = t2.contract_no
where 1=1
${IF(LEN(AREA)=0,"","AND AREA_ORG_CODE IN ('"+AREA+"')")}
${IF(LEN(CITY)=0,"","AND CITY_ORG_CODE IN ('"+CITY+"')")}
${IF(LEN(CONT)=0,"","AND CONTRACT_id IN ('"+CONT+"')")}
${IF(LEN(CONT_ID)=0,"","AND CONTRACT_id IN ('"+CONT_ID+"')")}
order by area_org_name, city_org_name,t2.contract_no

SELECT DISTINCT 
CONT_NAME,CONTRACT_ID,CONTRACT_NO
FROM f_po_cont_det
WHERE 1=1
${IF(LEN(AREA)=0,"","AND AREA_ORG_CODE IN ('"+AREA+"')")}
${IF(LEN(CITY)=0,"","AND CITY_ORG_CODE IN ('"+CITY+"')")}


