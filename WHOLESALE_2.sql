SELECT 
a.AREA_CODE,
--ATTRIBUTE,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN 
SUM(NO_TAX_COST) = 0 
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/ SUM(NO_TAX_AMOUNT) 
END AS 毛利率,
SUM(NO_TAX_COST) AS 无税成本
FROM 
DM_MONTHLY_COMPANY a 
WHERE 

1=1


${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
${if(len(oto)=0,"","and a.oto ='"+oto+"'")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(ATTRIBUTE)=0,"","and a.ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
AND 
SALE_DATE >= date'${BEFORE1}'
AND 
SALE_DATE <= date'${BEFORE2}'
AND
a.ATTRIBUTE IN ('加盟','批发')
GROUP BY
--ATTRIBUTE,
a.AREA_CODE
ORDER BY 
a.AREA_CODE

SELECT 
a.AREA_CODE,
--ATTRIBUTE,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN 
SUM(NO_TAX_COST) = 0 
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/ SUM(NO_TAX_AMOUNT) 
END
AS 毛利率,

SUM(NO_TAX_COST) AS 无税成本
FROM 
DM_MONTHLY_COMPANY a 
WHERE 
1=1
${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
${if(len(oto)=0,"","and a.oto ='"+oto+"'")}
${if(len(ATTRIBUTE)=0,"","and a.ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
AND 
SALE_DATE >= date'${AFTER1}'
AND 
SALE_DATE <= date'${AFTER2}'
AND
a.ATTRIBUTE IN ('加盟','批发')
GROUP BY 
a.AREA_CODE
--ATTRIBUTE
ORDER BY 
a.AREA_CODE

SELECT DISTINCT 
AREA_CODE,
AREA_NAME,
union_area_name
FROM 
DIM_REGION a
where 1=1
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
ORDER BY 
AREA_CODE

SELECT 
a.AREA_CODE,
--ATTRIBUTE,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN 
SUM(NO_TAX_COST) = 0 
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/ SUM(NO_TAX_AMOUNT) 
END AS 毛利率,
SUM(NO_TAX_COST) AS 无税成本
FROM 
DM_MONTHLY_COMPANY a 
WHERE 

1=1


${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
${if(len(oto)=0,"","and a.oto ='"+oto+"'")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(ATTRIBUTE)=0,"","and a.ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
AND 
SALE_DATE >= date'${BEFORE1}'
AND 
SALE_DATE <= date'${BEFORE2}'
AND
a.ATTRIBUTE IN ('加盟','批发')
${if(len(RELATED_PARTY_TRNSACTION)=0,"","and a.RELATED_PARTY_TRNSACTION IN ('"+RELATED_PARTY_TRNSACTION+"')")}
GROUP BY
--ATTRIBUTE,
a.AREA_CODE
ORDER BY 
a.AREA_CODE

SELECT 
a.AREA_CODE,
--ATTRIBUTE,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN 
SUM(NO_TAX_COST) = 0 
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/ SUM(NO_TAX_AMOUNT) 
END
AS 毛利率,

SUM(NO_TAX_COST) AS 无税成本
FROM 
DM_MONTHLY_COMPANY a 
WHERE 

1=1

${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
${if(len(oto)=0,"","and a.oto ='"+oto+"'")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(ATTRIBUTE)=0,"","and a.ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
AND 
SALE_DATE >= date'${AFTER1}'
AND 
SALE_DATE <= date'${AFTER2}'
AND
a.ATTRIBUTE IN ('加盟','批发')

${if(len(RELATED_PARTY_TRNSACTION)=0,"","and a.RELATED_PARTY_TRNSACTION IN ('"+RELATED_PARTY_TRNSACTION+"')")}
GROUP BY 
a.AREA_CODE
--ATTRIBUTE
ORDER BY 
a.AREA_CODE

SELECT 
a.AREA_CODE,
wmsys.wm_concat(distinct(a.attribute)) as attribute
FROM 
DM_MONTHLY_COMPANY a
WHERE 


1=1
${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
${if(len(oto)=0,"","and a.oto ='"+oto+"'")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(ATTRIBUTE)=0,"","and a.ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
AND 
((SALE_DATE >= date'${AFTER1}'
AND 
SALE_DATE <= date'${AFTER2}')
or 
(SALE_DATE >= date'${BEFORE1}'
AND 
SALE_DATE <= date'${BEFORE2}')

)
AND
a.ATTRIBUTE IN ('加盟','批发')
GROUP BY 
a.AREA_CODE


