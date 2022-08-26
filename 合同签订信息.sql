SELECT
OBJECT_NAME,
CONT_ARCH_ID,
CONT_NAME,
PARTY_A_NAME,
PARTY_B_NAME,
CONTACT_NAME,
CONTACT_PHONE,
CURR_CONT_AMT,
OPERATOE_NAME,
OPERATOE_PHONE
from f_po_con_sign_amt
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_CODE in ('" + PROJ_NAME + "')")}
${if(len(OBJECT_NAME)==0,""," and OBJECT_NO in('"+OBJECT_NAME+"')")}
${if(len(CONT_ARCH_ID)==0,""," and CONT_ARCH_ID in('"+CONT_ARCH_ID+"')")}
${if(len(CONT_NAME)==0,""," and CONT_NAME in('"+CONT_NAME+"')")}
${if(len(PARTY_A_NAME)==0,""," and PARTY_A_NAME in('"+PARTY_A_NAME+"')")}
${if(len(PARTY_B_NAME)==0,""," and PARTY_B_NAME in('"+PARTY_B_NAME+"')")}
${if(len(DATUM1)==0,""," and DATUM>'"+ DATUM1 +"'")}
${if(len(DATUM2)==0,""," and DATUM<'"+ DATUM2 +"'")}
${if(len(PASS_DAT1)==0,""," and PASS_DAT>'"+ PASS_DAT1 +"'")}
${if(len(PASS_DAT2)==0,""," and PASS_DAT<'"+ PASS_DAT2 +"'")}





SELECT distinct
	AREA_ORG_NAME,AREA_ORG_CODE
FROM f_po_con_sign_amt



SELECT 
distinct CITY_ORG_NAME,CITY_ORG_CODE
FROM f_po_con_sign_amt
where 1=1 

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}



SELECT 
distinct PROJ_CODE,PROJ_NAME
FROM f_po_con_sign_amt
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}


SELECT max(W_INSERT_DT) as time FROM f_cost_tar_cost

SELECT 
distinct	STAGE_CODE,STAGE_NAME
FROM f_po_con_sign_amt
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_CODE in ('" + PROJ_NAME + "')")}

select distinct STAT,STAT_DESC from f_cost_tar_cost


select OBJECT_NO,OBJECT_NAME from f_po_con_sign_amt
where 1=1
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_CODE in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_CODE in ('" + STAGE_NAME + "')")}

SELECT
distinct 
CONT_ARCH_ID,
CONT_NAME  from f_po_con_sign_amt

SELECT
distinct
PARTY_A_NAME,
PARTY_B_NAME
from f_po_con_sign_amt

