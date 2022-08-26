SELECT 
* FROM 
DM_CUS_CUS
WHERE 
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
${if(len(CUS)=0,""," and CUS_CODE in ('"+CUS+"')")}
${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
AND 
DDATE = '${YEAR}'
order by area_code,cus_code

SELECT DISTINCT
AREA_CODE ,
AREA_NAME 
FROM
DM_CUS_CUS

SELECT  DISTINCT 
DDATE 
FROM 
DM_CUS_CUS
ORDER BY 
DDATE

SELECT 
DISTINCT  
CUS_CODE,
CUS_NAME 
FROM 
DM_CUS_CUS 
WHERE  
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}

select count(1),AREA_CODE,CUS_CODE   from DIM_VIP 
WHERE 
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}

${if(len(CUS)=0,""," and CUS_CODE in ('"+CUS+"')")}
AND
CREDATE < ADD_MONTHS(TO_DATE('${YEAR}'||'-01'，'YYYY-MM-DD'),1)
GROUP  bY
AREA_CODE,CUS_CODE

