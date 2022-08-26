SELECT * FROM LIMITED_LIUXIANG

select distinct categorycode,catn,prodcode,prdn from product
order by catn,prodcode

SELECT
*
FROM
	FLOW_DETAIL
WHERE 1=1

/*
${IF(find('全国数据',fine_role)>0||find('superusers',fine_role)>0,"",IF(find('省份数据',fine_role)>0,"and (REGIONNAME1 in (SELECT PROV FROM USER_MANAGE WHERE USERID='"+fine_username+"') or REGIONNAME2 in (SELECT PROV FROM USER_MANAGE WHERE USERID='"+fine_username+"'))",IF(find('省份产品',fine_role)>0,"and (REGIONNAME1 in (SELECT PROV FROM USER_MANAGE WHERE USERID='"+fine_username+"') or REGIONNAME2 in (SELECT PROV FROM USER_MANAGE WHERE USERID='"+fine_username+"')) AND CATN IN (SELECT PROD FROM USER_MANAGE WHERE USERID='"+fine_username+"')","AND 1=0")))}

*/

${IF(LEN(orgout)=0,"","AND ORGCODE1 IN ('"+orgout+"')")}
${IF(LEN(typeout)=0,"","AND VALUENAME IN ('"+typeout+"')")}
${IF(LEN(provinceout)=0,"","AND REGIONNAME1='"+provinceout+"'")}
${IF(LEN(cityout)=0,"","AND CITYNAME1 IN ('"+cityout+"')")}

${IF(LEN(orgin)=0,"","AND ORGCODE2 IN ('"+orgin+"')")}
${IF(LEN(typein)=0,"","AND BAKCHAR03ATTR IN ('"+typein+"')")}
${IF(LEN(provincein)=0,"","AND REGIONNAME2='"+provincein+"'")}
${IF(LEN(cityin)=0,"","AND CITYNAME2 IN ('"+cityin+"')")}

${IF(LEN(sdate1)=0,"","AND SALESDATE>=TO_DATE('"+sdate1+"','YYYY-MM-DD')")}
${IF(LEN(sdate2)=0,"","AND SALESDATE<=TO_DATE('"+sdate2+"','YYYY-MM-DD')")}
${IF(LEN(gdate1)=0,"","AND POSTDATE>=TO_DATE('"+gdate1+"','YYYY-MM-DD')")}
${IF(LEN(gdate2)=0,"","AND POSTDATE<=TO_DATE('"+gdate2+"','YYYY-MM-DD')")}
${IF(LEN(prod)=0,"","AND PRODCODE IN ('"+SUBSTITUTE(prod,",","','")+"')")}
${IF(LEN(id)=0,"","AND ID IN ('"+id+"')")}


SELECT DISTINCT ORGCODE1,ORGCODE1||'-'||ORGNAME1 ORGNAME1 FROM FLOW_DETAIL

SELECT DISTINCT ORGCODE2,ORGCODE2||'-'||ORGNAME2 ORGNAME2 FROM FLOW_DETAIL

SELECT DISTINCT VALUENAME FROM FLOW_DETAIL

SELECT DISTINCT BAKCHAR03ATTR FROM FLOW_DETAIL

SELECT REGIONNAME FROM REGION
ORDER BY REGIONCODE

select distinct cityname1 from flow_detail
where regionname1='${provinceout}'

select distinct cityname1 from flow_detail
where regionname1='${provincein}'

