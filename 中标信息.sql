
SELECT
OBJECT_NAME,
CITY_ORG_NAME,
VENDOR_NAME,
CONTACT_NAME,
CONTACT_PHONE,
SETBID_PRICE,
CURR,
SETBID_APPROVAL_TIME,
OPERATOE_NAME,
OPERATOE_PHONE,
OBJECT_NO,
SETBID_NO,
SETBID_ITEM_NO
from
(
select * FROM f_po_setbid_price main_tab
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_CODE in ('" + PROJ_NAME + "')")}
${if(len(OBJECT_NAME)==0,""," and OBJECT_NO in('"+OBJECT_NAME+"')")}
${if(len(SETBID_APPROVAL_TIME1)==0,""," and SETBID_APPROVAL_TIME>'"+ SETBID_APPROVAL_TIME1 +"'")}
${if(len(SETBID_APPROVAL_TIME2)==0,""," and SETBID_APPROVAL_TIME>'"+ SETBID_APPROVAL_TIME2 +"'")}

)maintab



SELECT distinct
	AREA_ORG_NAME,AREA_ORG_CODE
FROM f_po_setbid_price




SELECT 
distinct CITY_ORG_NAME,CITY_ORG_CODE
FROM f_po_setbid_price
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}



SELECT 
distinct PROJ_CODE,PROJ_NAME
FROM f_po_setbid_price
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}


SELECT max(W_INSERT_DT) as time FROM f_cost_tar_cost

SELECT 
distinct	STAGE_CODE,STAGE_NAME
FROM f_po_setbid_price
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_CODE in ('" + PROJ_NAME + "')")}

select distinct STAT,STAT_DESC from f_cost_tar_cost


select OBJECT_NO,OBJECT_NAME from f_po_setbid_price
where 1=1
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_CODE in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_CODE in ('" + STAGE_NAME + "')")}

