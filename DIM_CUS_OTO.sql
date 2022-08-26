SELECT a.*,b.CUS_NAME,r.area_name FROM DIM_OTO_CUS a,DIM_CUS b,dim_region r
WHERE 
1=1
${if(len(CUS_CODE)==0,"", " and a.CUS_CODE in ('" + CUS_CODE + "')")}
and a.CUS_CODE=b.CUS_CODE
and b.area_code=r.area_code
--and ONLINE_FLAG='1' 
and ADD_FLAG is null

SELECT DISTINCT a.CUS_CODE,a.cus_code||'|'||b.cus_name cus_name FROM 
DIM_OTO_CUS a,dim_cus b
where a.cus_code=b.cus_code
order by 1

SeLECT '1' AS a FROM DUAL

UNION
SeLECT '2' AS a FROM DUAL

