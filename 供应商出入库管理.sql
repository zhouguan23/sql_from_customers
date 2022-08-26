WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NO," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE_DESC," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","GRADE_DESC," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE_DESC," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","HNAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","RK_DATE," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CK_DATE," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NO," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SCOPE," ) } 
'' as aa,STATUS_DESC,
count(LIFNR_NAME) as LIFNR_CONT

FROM  F_PO_SUPPLY_STOCK
where 1=1 
and SUP_TYPE is not null
and CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='采购品类')
${if(len(SCOPE) == 0,"
and (SCOPE in (select sap_dept_id from  user_org a)
or SCOPE in (select left(dept_id,5) from fr_user_org	
where user_id='" + fine_username + "')
or SCOPE in(select b.sap_dept_id from fr_user_org a 
		left join fr_org b on left(a.dept_id,5)=b.sap_parent_id
			where user_id='" + fine_username + "')
or SCOPE='E01') ","and SCOPE in ('" + SCOPE + "')")}
${if(len(ORGTYPE) == 0,"","and ORGTYPE in ('" + ORGTYPE + "')")}
${if(len(LIFNR_TYPE) == 0,"","and LIFNR_TYPE in ('" + LIFNR_TYPE + "')")}
${if(len(LIFNR_NAME) == 0,"","and LIFNR_NAME in ('" + LIFNR_NAME + "')")}
${if(len(STATUS) == 0,"","and STATUS in ('" + STATUS + "')")}
${if(len(SUP_TYPE_DESC) == 0,"","and SUP_TYPE_DESC in ('" + SUP_TYPE_DESC + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}

-- ${if(len(AEDAT1) == 0,"","and AEDAT >='" + AEDAT1 + "'")}
-- ${if(len(AEDAT2) == 0,"","and AEDAT <= '" + AEDAT2 + "'")}
${if(len(RK_DATE1) == 0,"","and RK_DATE >='" + RK_DATE1 + "'")}
${if(len(RK_DATE2) == 0,"","and RK_DATE <= '" + RK_DATE2 + "'")}
${if(len(CK_DATE1) == 0,"","and CK_DATE >='" + CK_DATE1 + "'")}
${if(len(CK_DATE2) == 0,"","and CK_DATE <= '" + CK_DATE2 + "'")}

group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE_DESC," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","GRADE_DESC," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE_DESC," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","HNAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","RK_DATE," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CK_DATE," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NO," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SCOPE," ) } 
STATUS_DESC,aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NO," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SCOPE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
aa

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct
HNAME,SCOPE
FROM  F_PO_SUPPLY_STOCK
where 1=1
and SCOPE in (select sap_dept_id from  user_org a)   
or SCOPE in (select 	left(dept_id,5)	from fr_user_org	where user_id='${fine_username}')
or SCOPE in(select b.sap_dept_id from fr_user_org a 
		left join fr_org b on left(a.dept_id,5)=b.sap_parent_id
			where user_id='${fine_username}')
or SCOPE='E01'
#权限：所有人能看到股份范围，能看所属区域范围，能看所属城市范围




SELECT distinct
LIFNR_NAME
FROM  F_PO_SUPPLY_STOCK where lifnr_name is not null
${if(len(LIFNR_TYPE) == 0,"","and LIFNR_TYPE in ('" + LIFNR_TYPE + "')")}
${if(len(ORGTYPE) == 0,"","and ORGTYPE in ('" + ORGTYPE + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(STATUS) == 0,"","and STATUS in ('" + STATUS + "')")}
${if(len(SCOPE) == 0,"","and SCOPE in ('" + SCOPE + "')")}
${if(len(LSUP_TYPE_DESC) == 0,"","and SUP_TYPE_DESC in ('" + SUP_TYPE_DESC + "')")}

SELECT distinct
STATUS,STATUS_DESC
FROM  F_PO_SUPPLY_STOCK
where 1=1

SELECT distinct
LIFNR_TYPE,LIFNR_TYPE_DESC
FROM  F_PO_SUPPLY_STOCK
where 1=1


SELECT max(W_INSERT_DT) as time FROM F_PO_SUPPLY_STOCK

SELECT distinct
ORGTYPE,ORGTYPE_DESC
FROM  F_PO_SUPPLY_STOCK
where 1=1
and orgtype is not null

select distinct SUP_TYPE,SUP_TYPE_DESC FROM  F_PO_SUPPLY_STOCK
where 1=1

order by SUP_TYPE


WITH RECURSIVE user_org as
	(
		select * from fr_org where sap_dept_id in (
			select dept_id from fr_user_org
				where user_id='${fine_username}')
		UNION ALL
		select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
	)
	select distinct CATEGORY_DESC FROM  F_PO_SUPPLY_STOCK
where CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='采购品类'
)


SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE_DESC," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","GRADE_DESC," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE_DESC," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","HNAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","AEDAT," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NO," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SCOPE," ) } 
'' as aa,STATUS_DESC,
count(LIFNR_NAME) as LIFNR_CONT

FROM  F_PO_SUPPLY_STOCK
where 1=1 and LIFNR_NAME is not null 
and SUP_TYPE is not null
${if(len(SCOPE) == 0,"","and SCOPE in ('" + SCOPE + "')")}
${if(len(ORGTYPE) == 0,"","and ORGTYPE in ('" + ORGTYPE + "')")}
${if(len(LIFNR_TYPE) == 0,"","and LIFNR_TYPE in ('" + LIFNR_TYPE + "')")}
${if(len(LIFNR_NAME) == 0,"","and LIFNR_NAME in ('" + LIFNR_NAME + "')")}
${if(len(STATUS) == 0,"","and STATUS in ('" + STATUS + "')")}
${if(len(SUP_TYPE_DESC) == 0,"","and SUP_TYPE_DESC in ('" + SUP_TYPE_DESC + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}

${if(len(AEDAT1) == 0,"","and AEDAT >='" + AEDAT1 + "'")}
${if(len(AEDAT2) == 0,"","and AEDAT <= '" + AEDAT2 + "'")}

group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE_DESC," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","GRADE_DESC," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE_DESC," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","HNAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","AEDAT," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NO," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SCOPE," ) } 
STATUS_DESC,aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","LIFNR_NO," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SUP_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","ORGTYPE," ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SCOPE," ) } 
1

and (SCOPE in(select dept_id from  fr_user_org where user_id='" +fine_username+ "' and dept_id!='E01')
 or SCOPE in (select SAP_PARENT_ID from fr_org left join fr_user_org 
 on fr_org.SAP_DEPT_ID=fr_user_org.DEPT_ID  where user_id='" +fine_username+ "' and SAP_PARENT_ID!='E01'))

