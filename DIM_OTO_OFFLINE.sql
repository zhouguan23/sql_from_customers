select A.*,R.AREA_NAME from OFFLINE_DIM_MARKETING a
LEFT JOIN DIM_REGION R
ON A.AREA_CODE=R.AREA_CODE
where 1=1
${if(len(MARKETING_NAME)==0,"", " and MARKETING_NAME in ('" + MARKETING_NAME + "')")}
AND
1=1
${if(len(OTO)==0,"", " and OTO in ('" + OTO + "')")}
AND
1=1
${if(len(B2C)==0,"", " and B2C in ('" + B2C + "')")}
AND
1=1
${if(len(AREA)==0,"", " and A.AREA_CODE in ('" + AREA + "')")}
AND
1=1
${if(len(LARGE)==0,"", " and LARGE_CATE in ('" + LARGE + "')")}
AND
1=1
${if(len(SMALL)==0,"", " and SMALL_CATE in ('" + SMALL + "')")}
order by marketing_code

select MARKETING_NAME from OFFLINE_DIM_MARKETING


SELECT '是' AS oto FROM DUAL
UNION ALL
SELECT '否' AS oto FROM DUAL

select distinct large_cate ,small_cate from offline_dim_marketing

