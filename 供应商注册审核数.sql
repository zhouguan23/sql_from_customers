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
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","STATUS_DESC," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SOURCE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","DATUM," ) }
count(LIFNR_NAME),'' as aa
FROM (select distinct CATEGORY_DESC,LIFNR_TYPE_DESC,CATEGORY,LIFNR_TYPE,STATUS_DESC,SOURCE_DESC,LIFNR_NAME,DATUM from F_PO_SUPPLY_RG_CHACK)a
where 1=1 and CATEGORY_DESC is not null
and CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='供应商专业分类' )
${if(len(CATEGORY) == 0,"","and CATEGORY in ('" + CATEGORY + "')")}
${if(len(LIFNR_TYPE) == 0,"","and LIFNR_TYPE in ('" + LIFNR_TYPE + "')")}
${if(len(STATUS_DESC) == 0,"","and STATUS_DESC in ('" + STATUS_DESC + "')")}
${if(len(SOURCE_DESC) == 0,"","and SOURCE_DESC in ('" + SOURCE_DESC + "')")}
${if(len(LIFNR_NAME) == 0,"","and LIFNR_NAME in ('" + LIFNR_NAME + "')")}

${if(len(AEDAT1) == 0,"","and DATUM >='" + AEDAT1 + "'")}
${if(len(AEDAT2) == 0,"","and DATUM <= '" + AEDAT2 + "'")}
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","STATUS_DESC," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SOURCE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","DATUM," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","STATUS_DESC," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SOURCE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","DATUM," ) }
aa

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)SELECT distinct
CATEGORY,CATEGORY_DESC
FROM  F_PO_SUPPLY_RG_CHACK
where CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='供应商专业分类' )

SELECT distinct
LIFNR_TYPE,LIFNR_TYPE_DESC
FROM  F_PO_SUPPLY_RG_CHACK

SELECT max(W_INSERT_DT) as time FROM F_PO_SUPPLY_RG_CHACK

SELECT distinct
SOURCE_DESC
FROM  F_PO_SUPPLY_RG_CHACK

SELECT distinct
STATUS_DESC
FROM  F_PO_SUPPLY_RG_CHACK

SELECT distinct
LIFNR_NAME
FROM  F_PO_SUPPLY_RG_CHACK
where 1=1
${if(len(CATEGORY) == 0,"","and CATEGORY in ('" + CATEGORY + "')")}
${if(len(LIFNR_TYPE) == 0,"","and LIFNR_TYPE in ('" + LIFNR_TYPE + "')")}
${if(len(STATUS_DESC) == 0,"","and STATUS_DESC in ('" + STATUS_DESC + "')")}
${if(len(SOURCE_DESC) == 0,"","and SOURCE_DESC in ('" + SOURCE_DESC + "')")}


SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","STATUS_DESC," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SOURCE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","DATUM," ) }
count(LIFNR_NAME),'' as aa
FROM (select CATEGORY_DESC,LIFNR_TYPE_DESC,CATEGORY,LIFNR_TYPE,STATUS_DESC,SOURCE_DESC,LIFNR_NAME,DATUM from F_PO_SUPPLY_RG_CHACK)a
where 1=1 and CATEGORY_DESC is not null
${if(len(CATEGORY) == 0,"","and CATEGORY in ('" + CATEGORY + "')")}
${if(len(LIFNR_TYPE) == 0,"","and LIFNR_TYPE in ('" + LIFNR_TYPE + "')")}
${if(len(STATUS_DESC) == 0,"","and STATUS_DESC in ('" + STATUS_DESC + "')")}
${if(len(SOURCE_DESC) == 0,"","and SOURCE_DESC in ('" + SOURCE_DESC + "')")}
${if(len(LIFNR_NAME) == 0,"","and LIFNR_NAME in ('" + LIFNR_NAME + "')")}

${if(len(AEDAT1) == 0,"","and DATUM >='" + AEDAT1 + "'")}
${if(len(AEDAT2) == 0,"","and DATUM <= '" + AEDAT2 + "'")}
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","STATUS_DESC," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SOURCE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","DATUM," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","LIFNR_TYPE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","STATUS_DESC," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","SOURCE_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","DATUM," ) }
aa

