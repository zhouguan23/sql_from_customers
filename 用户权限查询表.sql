SELECT

	LEVEL2
FROM
 IT_DIM_DEP  
where LEVEL2 IN ('区域城市公司','珠海华发实业股份有限公司','职能公司')
GROUP BY LEVEL2
ORDER BY LEVEL2

WITH T1 AS 
(select -- erp组织
	a.user_id,	A.USER_NAME ,
	replace(group_concat(concat(concat(a.dept_id,'-'),b.sap_dept_name),"\n"),',','') dept_name
from fr_user_org a
left join fr_org b on a.dept_id=b.sap_dept_id and a.org_type=b.org_type
where a.org_type='组织'
group by a.user_id,A.USER_NAME
),T2 AS (
select -- 营销组织
	a.user_id, 
  a.user_name,
	replace(group_concat(concat(concat(a.dept_id,'-'),a.dept_name),"\n"),',','') mkt_dept_name
from fr_user_org_mkt a
left join finedbv10.fine_user c on a.user_id=c.userName
where a.org_type='组织'
and c.userName is not null
group by 
  a.user_id, a.user_name
),T3 AS (
select user_id,replace(group_concat(name ORDER BY name),',','\n') juese
from (
select distinct
	a.user_id, 
  e.name
from fr_user_org a
left join finedbv10.fine_user c on a.user_id=c.userName
left join finedbv10.fine_user_role_middle d on c.id=d.userid and d.roleType=2 
left join finedbv10.fine_custom_role e on d.roleId=e.id
where a.org_type='组织'
and c.userName is not null
UNION 
select distinct
	a.user_id, 
  e.name
from fr_user_org_mkt a
left join finedbv10.fine_user c on a.user_id=c.userName
left join finedbv10.fine_user_role_middle d on c.id=d.userid and d.roleType=2 
left join finedbv10.fine_custom_role e on d.roleId=e.id
where a.org_type='组织'
and c.userName is not null
UNION 
select distinct
	a.user_id, 
  e.name
from fr_user_org_hr a
left join finedbv10.fine_user c on a.user_id=c.userName
left join finedbv10.fine_user_role_middle d on c.id=d.userid and d.roleType=2 
left join finedbv10.fine_custom_role e on d.roleId=e.id
where c.userName is not null
) a
group by a.user_id
),T5 AS 
(select -- 人力组织
	a.user_id, 
  a.user_name,
	replace(group_concat(concat(concat(a.dept_id,'-'),a.dept_name),"\n"),',','') hr_dept_name
from fr_user_org_hr a
left join finedbv10.fine_user c on a.user_id=c.userName
where c.userName is not null
group by 
  a.user_id, a.user_name
),T4 AS 
(SELECT 
  T1.user_id,	T1.USER_NAME,dept_name,mkt_dept_name,hr_dept_name
FROM T1
LEFT JOIN t2 on t1.user_id=T2.user_id
LEFT JOIN T5 ON T1.user_id=T5.user_id
UNION 
SELECT 
  T2.user_id,	T2.USER_NAME,dept_name,mkt_dept_name,hr_dept_name
FROM T2
LEFT JOIN t1 on t1.user_id=T2.user_id
LEFT JOIN T5 ON T2.user_id=T5.user_id
UNION 
SELECT 
  T5.user_id,	T5.USER_NAME,dept_name,mkt_dept_name,hr_dept_name
FROM T5
LEFT JOIN t1 on t1.user_id=T5.user_id
LEFT JOIN T2 ON T2.user_id=T5.user_id
)SELECT 
 T4.user_id,
 T4.USER_NAME,
 LEVEL2,
 LEVEL3,
 LEVEL4,
 LEVEL5,
 dept_name,mkt_dept_name,hr_dept_name,
 juese
FROM T4 INNER JOIN T3 ON  T4.user_id=T3.user_id
LEFT JOIN 
 (SELECT
  DISTINCT
  A.LOGIN_NAME USERID,
  LEVEL2,
  LEVEL3,
  LEVEL4,
  LEVEL5,
  CONCAT(CONCAT(CONCAT(CONCAT(B.LEVEL2,'-'),CONCAT(B.LEVEL3,'-')),CONCAT(B.LEVEL4,'-')),B.LEVEL5) DEPTNAME
FROM
	it_dim_user A
LEFT JOIN IT_DIM_DEP B ON A.ORG_DEPARTMENT_ID=B.DEP_ID
WHERE LOGIN_NAME IS NOT NULL
AND LEVEL2 IN ('区域城市公司','珠海华发实业股份有限公司','职能公司') 
) T5 ON T4.user_id=T5.USERID
WHERE 1=1
${if(len(userId)==0,"","and T4.user_id='"+userId+"'")}
${if(len(LEVEL2)==0,"","and LEVEL2 in  ('"+LEVEL2+"')")}
${if(len(LEVEL3)==0,"","and LEVEL3 in  ('"+LEVEL3+"')")}
${if(len(LEVEL4)==0,"","and LEVEL4 in  ('"+LEVEL4+"')")}
ORDER BY 
 LEVEL2,
 LEVEL3,
 LEVEL4,
 dept_name,
 LEVEL5,
 mkt_dept_name,
 juese,T4.user_id

SELECT
  
  A.LOGIN_NAME USERID,LEVEL2,LEVEL3,LEVEL4,
  CONCAT(CONCAT(CONCAT(USER_NAME,'-'),CONCAT(B.LEVEL3,'-'),B.LEVEL4)) DEPTNAME
FROM
	it_dim_user A
LEFT JOIN IT_DIM_DEP B ON A.ORG_DEPARTMENT_ID=B.DEP_ID
WHERE LOGIN_NAME IS NOT NULL
AND  LEVEL2 IN ('${LEVEL2}')
GROUP BY A.LOGIN_NAME ,LEVEL2,LEVEL3,LEVEL4,CONCAT(CONCAT(CONCAT(USER_NAME,'-'),CONCAT(B.LEVEL3,'-'),B.LEVEL4))
ORDER BY LEVEL2,LEVEL3,LEVEL4

SELECT
	LEVEL3
FROM
 IT_DIM_DEP  
where LEVEL2 IN ('${LEVEL2}')
AND LEVEL3<>'港澳及海外公司'
GROUP BY LEVEL3
ORDER BY LEVEL3  DESC

SELECT
	LEVEL4
FROM
 IT_DIM_DEP  
where LEVEL2 IN ('${LEVEL2}')
AND LEVEL3 IN ('${LEVEL3}')
AND LEVEL3<>'港澳及海外公司'
GROUP BY LEVEL4
ORDER BY LEVEL4  DESC

