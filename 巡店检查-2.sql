SELECT * FROM "KLFR"."CHECK_SHOP"

select b.*,
a.BRAND_NAME,a.SUB_COMPANY_NAME,a.MANAGE_REGION_NAME
from DIM_SHOP a,CHECK_SHOP_S b
where a.ORG_CODE=b.ORG_CODE
${if(len(BRAND_NAME)==0,"","AND a.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)==0,"","AND a.SUB_COMPANY_NAME in('"+SUB_COMPANY_NAME+"')")}
${if(len(ATTRI_MANAGE_REGION)==0,"","AND a.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)==0,"","AND a.ORG_CODE in('"+ORG_CODE+"')")}



--SELECT DISTINCT BRAND_NAME FROM VBI_BRAND
select distinct 
  b.BRAND_NAME  BRAND_NAME 
from 
(
  select 
    BRAND_NAME 
  from 
    FILL_USER_BRAND  a,
    FR_T_USER  b
  where 
  a.USER_ID=TO_CHAR(b.id) 
  ${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )          a, 
VBI_BRAND  b
where 
a.BRAND_NAME=b.BRAND_NAME 

-- 品牌维度

select DISTINCT SUB_COMPANY_NAME from DIM_SHOP 
WHERE SUB_COMPANY_NAME NOT LIKE '%电商%'
${if(len(BRAND_NAME)==0,""," AND BRAND_NAME ='"+BRAND_NAME+"'")}
and SUB_COMPANY_NAME in (
select SUB_COMPANY_NAME from FILL_USER_BRAND  a,FR_T_USER  b
where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)


SELECT DISTINCT ATTRI_MANAGE_REGION,MANAGE_REGION_NAME FROM DIM_S_SHOP
WHERE SUB_COMPANY_NAME in  ('${SUB_COMPANY_NAME}')
AND BRAND_NAME = '${BRAND_NAME}'

select ORG_CODE,ORG_NAME,concat(ORG_CODE,ORG_NAME) as name 
from DIM_SHOP where BRAND_NAME='${BRAND_NAME}' 

and SUB_COMPANY_NAME='${SUB_COMPANY_NAME}'
${IF(LEN(ATTRI_MANAGE_REGION)=0,"","and ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')")}

select ORG_CODE,ORG_NAME,concat(ORG_CODE,ORG_NAME) as name 
from DIM_SHOP 
where 
--BRAND_NAME='${BRAND_NAME}' 
--and ATTRI_MANAGE_REGION in ('${ATTRI_MANAGE_REGION}') 
--and SUB_COMPANY_NAME='${SUB_COMPANY_NAME}'
ORG_CODE='${ORG_CODE}'

--select DISTINCT  LARGE_REGULAR_NAME  from DIM_REGULAR
SELECT DISTINCT a.BRAND_NAME,b.LARGE_REGULAR_NAME
FROM DIM_ITEM_INFO_ALL a,dim_regular b
where a.regular_code=b.regular_code
and a.BRAND_NAME='${BRAND_NAME}' 



select concat(USERNAME,REALNAME) as name from FR_T_USER
where username='${fr_username}'

