
WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
a.完成节点数,a.按时完成数,a.完成数,b.*
from
(SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME  as pron1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE_DESC," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE_DESC," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","NODE_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","TXFL," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","sum(DELAY_DAY) as DELAY_DAY," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","NODE_STATUS," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","COVERAGE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","project as proid1,stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","KEY_NODE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SUP_TYPE_DESC," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","IS_COMPLETE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","OBJECT_CLASSI_DESC," ) }
'' as aa,
count(NODE_NAME) as 完成节点数,
count(case when IS_COMPLETE='Y' and DELAY_DAY<=0 then NODE_NAME else null end) as 按时完成数,
count(case when IS_COMPLETE='Y' then NODE_NAME else null end) as 完成数
FROM  f_po_node main_tab
left join 
( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   
union select distinct a.sap_dept_id from user_org a) area_tab
on main_tab.AREA_CODE=area_tab.AREA_ORG_CODE
left join 
( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
union select distinct a.sap_dept_id from user_org a) city_tab
on main_tab.CITY_CODE=city_tab.CITY_ORG_CODE
left join 
(select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
union select distinct a.sap_dept_id from user_org a) proj_tab
on main_tab.project=proj_tab.PROJ_CODE
left join (select distinct sap_dept_id from user_org where ORG_TYPE='立项分类') cat_tab
on main_tab.OBJECT_CLASSI=cat_tab.sap_dept_id
where 1=1 and IS_COMPLETE='Y' and KEY_NODE='0050' and TXFL='成本' 
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and (ifnull(proj_tab.PROJ_CODE,'')!='' or project = '' )
and ifnull(cat_tab.sap_dept_id,'')!=''
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(city_name) == 0,"","and CITY_CODE in ('" + city_name + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(PROC_MODE_DESC) == 0,"","and PROC_MODE_DESC in ('" + PROC_MODE_DESC + "')")}
${if(len(PROC_TYPE) == 0,"","and PROC_TYPE in ('" + PROC_TYPE + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(OBJECT_CLASSI_DESC) == 0,"","and OBJECT_CLASSI_DESC in ('" + OBJECT_CLASSI_DESC + "')")}

${if(len(TXFL) == 0,"","and TXFL in ('" + TXFL + "')")}
${if(len(NODE_NAME) == 0,"","and NODE_NAME in ('" + NODE_NAME + "')")}
${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}
${if(len(COVERAGE) == 0,"","and PROC_ITEM_NAME in ('" + COVERAGE + "')")}
${if(len(SUP_TYPE_DESC) == 0,"","and SUP_TYPE_DESC in ('" + SUP_TYPE_DESC + "')")}

${if(len(AEDAT1) == 0,"","and AEDAT >='" + AEDAT1 + "'")}
${if(len(AEDAT2) == 0,"","and AEDAT <= '" + AEDAT2 + "'")}

${if( len(DELAY_DAY)=0,"","and NODE_STATUS in ('" + DELAY_DAY +"')")}

group by

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE_DESC," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE_DESC," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","NODE_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","TXFL," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","NODE_STATUS," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","COVERAGE," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","project,stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","KEY_NODE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SUP_TYPE_DESC," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","IS_COMPLETE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","OBJECT_CLASSI_DESC," ) }
aa

) as a

right join

(SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME  as pron4,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE_DESC," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE_DESC," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","NODE_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","TXFL," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","NODE_STATUS," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","sum(DELAY_DAY) as DELAY_DAY," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","COVERAGE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","project as proid2,stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","KEY_NODE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SUP_TYPE_DESC," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","IS_COMPLETE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","OBJECT_CLASSI_DESC," ) }
'' as aa,

count(NODE_NAME) as 节点数
FROM  f_po_node main_tab
left join 
( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   
union select distinct a.sap_dept_id from user_org a) area_tab
on main_tab.AREA_CODE=area_tab.AREA_ORG_CODE
left join 
( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
union select distinct a.sap_dept_id from user_org a) city_tab
on main_tab.CITY_CODE=city_tab.CITY_ORG_CODE
left join 
(select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
union select distinct a.sap_dept_id from user_org a) proj_tab
on main_tab.project=proj_tab.PROJ_CODE
left join (select distinct sap_dept_id from user_org where ORG_TYPE='立项分类') cat_tab
on main_tab.OBJECT_CLASSI=cat_tab.sap_dept_id
where 1=1 and KEY_NODE='0050' and TXFL='成本' 
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and (ifnull(proj_tab.PROJ_CODE,'')!='' or project = '' )
and ifnull(cat_tab.sap_dept_id,'')!=''
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(city_name) == 0,"","and CITY_CODE in ('" + city_name + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(PROC_MODE_DESC) == 0,"","and PROC_MODE_DESC in ('" + PROC_MODE_DESC + "')")}
${if(len(PROC_TYPE_DESC) == 0,"","and PROC_TYPE_DESC in ('" + PROC_TYPE_DESC + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(OBJECT_CLASSI_DESC) == 0,"","and OBJECT_CLASSI_DESC in ('" + OBJECT_CLASSI_DESC + "')")}

${if(len(TXFL) == 0,"","and TXFL in ('" + TXFL + "')")}
${if(len(NODE_NAME) == 0,"","and NODE_NAME in ('" + NODE_NAME + "')")}
${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}
${if(len(COVERAGE) == 0,"","and COVERAGE in ('" + COVERAGE + "')")}
${if(len(SUP_TYPE_DESC) == 0,"","and SUP_TYPE_DESC in ('" + SUP_TYPE_DESC + "')")}
${if(len(IS_COMPLETE) == 0,"","and IS_COMPLETE in ('" + IS_COMPLETE + "')")}
${if(len(AEDAT1) == 0,"","and AEDAT >='" + AEDAT1 + "'")}
${if(len(AEDAT2) == 0,"","and AEDAT <= '" + AEDAT2 + "'")}

${if( len(DELAY_DAY)=0,"","and NODE_STATUS in ('" + DELAY_DAY +"')")}

group by

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE_DESC," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE_DESC," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","NODE_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","TXFL," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","NODE_STATUS," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","COVERAGE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","project,stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","KEY_NODE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SUP_TYPE_DESC," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","IS_COMPLETE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","OBJECT_CLASSI_DESC," ) }
aa
) as b
on 1=1 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and a.AREA_NAME=b.AREA_NAME" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and a.CITY_NAME=b.CITY_NAME" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and ifnull(a.PROJ_NAME,'0000')=ifnull(b.PROJ_NAME,'0000')" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and ifnull(a.STAGE_NAME,'0000')=ifnull(b.STAGE_NAME,'0000') and ifnull(a.pron1,'0000')=ifnull(b.pron4,'0000')" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and a.PROC_MODE_DESC=b.PROC_MODE_DESC" ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","and a.PROC_TYPE_DESC=b.PROC_TYPE_DESC" ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","and a.CATEGORY_DESC=b.CATEGORY_DESC" ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","and a.NODE_NAME=b.NODE_NAME" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","and a.TXFL=b.TXFL" ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and a.NODE_STATUS=b.NODE_STATUS" ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","and a.PROC_ITEM_NAME=b.PROC_ITEM_NAME" ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","and a.COVERAGE=b.COVERAGE" ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","and a.PL_EDATE=b.PL_EDATE" ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","and a.AC_EDATE=b.AC_EDATE" ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","and a.SUP_TYPE_DESC=b.SUP_TYPE_DESC" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and a.IS_COMPLETE=b.IS_COMPLETE" ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","and a.OBJECT_CLASSI_DESC=b.OBJECT_CLASSI_DESC" ) }

order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","KEY_NODE," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","find_in_set(a.NODE_STATUS,'正在进行中_已超期,正在进行中_未超期,提前或按时完成,1-3天,4-7天,8-15天,16-30天,大于30天')," ) }
2


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT distinct
	AREA_NAME,area_code
FROM f_po_node
where area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT 
distinct	CITY_NAME,city_code
FROM f_po_node
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
and area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT 
distinct	PROJ_NAME,PROJECT
FROM f_po_node
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
and area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)

and PROJECT in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)


SELECT distinct
PROC_MODE_DESC
FROM  f_po_node
where 1 = 1 


SELECT max(W_INSERT_DT) as time FROM f_po_node

SELECT distinct
PROC_TYPE_DESC,PROC_TYPE
FROM  f_po_node
where 1 = 1

SELECT distinct
CATEGORY_DESC
FROM  f_po_node
where 1=1


SELECT distinct
TXFL
FROM  f_po_node
where 1=1


SELECT distinct
NODE_NAME,KEY_NODE
FROM  f_po_node
where 1=1

order by key_node

select distinct PROC_ITEM_NAME from f_po_node
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PPROJECT in ('" + PROJ_NAME + "')")}

select distinct COVERAGE from f_po_node

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
a.完成节点数,b.*
from
(SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE_DESC," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE_DESC," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 

${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","sum(DELAY_DAY) as DELAY_DAY," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 

'' as aa,NODE_NAME,TXFL,count(NODE_NAME) as 完成节点数
FROM  f_po_node
where 1=1 and IS_COMPLETE='Y' and KEY_NODE='0050' and TXFL='成本'
${if(len(AREA_NAME) == 0,"and AREA_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"and CITY_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJECT in( select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code )","and PROJ_NAME in ('" + PROJ_NAME + "')")}


${if(len(PROC_MODE_DESC) == 0,"","and PROC_MODE_DESC in ('" + PROC_MODE_DESC + "')")}
${if(len(PROC_TYPE_DESC) == 0,"","and PROC_TYPE_DESC in ('" + PROC_TYPE_DESC + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(IS_COMPLETE) == 0,"","and IS_COMPLETE in ('" + IS_COMPLETE + "')")}

${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}

${if(len(AEDAT1) == 0,"","and AEDAT >='" + AEDAT1 + "'")}
${if(len(AEDAT2) == 0,"","and AEDAT <= '" + AEDAT2 + "'")}

${if( len(DELAY_DAY)=0,"","
and (1=2 
"+ if(INARRAY("0", DELAY_DAY) = 0,""," or (datediff(now(),DATE(aedat))>0 and IS_COMPLETE='N')" )+  
 if(INARRAY("1", DELAY_DAY) = 0,""," or DELAY_DAY<=0" )+ 
 if(INARRAY("2", DELAY_DAY) = 0,""," or DELAY_DAY in('1','2','3')" )+ 
 if(INARRAY("3", DELAY_DAY) = 0,""," or DELAY_DAY in('4','5','6','7')" )+ 
 if(INARRAY("4", DELAY_DAY) = 0,""," or DELAY_DAY in('8','9','10','11','12','13','14','15')" )+ 
 if(INARRAY("5", DELAY_DAY) = 0,""," or DELAY_DAY in('16','17','18','19','20','21','22','23','24','25','26','27','28','29','30')" )+ 
 if(INARRAY("6", DELAY_DAY) = 0,""," or DELAY_DAY>30" ) +
")")}
${if(len(minday1) == 0,"","and DELAY_DAY >='" + minday1 + "'")}
${if(len(maxday2) == 0,"","and DELAY_DAY <= '" + maxday2 + "'")}


group by

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE_DESC," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE_DESC," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 

${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) } 
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 

aa,NODE_NAME,TXFL

) as a

right join

(SELECT 

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE_DESC," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE_DESC," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 

${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","sum(DELAY_DAY) as DELAY_DAY," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 

'' as aa,NODE_NAME,TXFL,count(NODE_NAME) as 节点数
FROM  f_po_node
where 1=1 
and KEY_NODE='0050' and TXFL='成本'
${if(len(AREA_NAME) == 0,"and AREA_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"and CITY_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJECT in( select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code )","and PROJ_NAME in ('" + PROJ_NAME + "')")}

${if(len(PROC_MODE_DESC) == 0,"","and PROC_MODE_DESC in ('" + PROC_MODE_DESC + "')")}
${if(len(PROC_TYPE_DESC) == 0,"","and PROC_TYPE_DESC in ('" + PROC_TYPE_DESC + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}
${if(len(AEDAT1) == 0,"","and AEDAT >='" + AEDAT1 + "'")}
${if(len(AEDAT2) == 0,"","and AEDAT <= '" + AEDAT2 + "'")}
${if(len(IS_COMPLETE) == 0,"","and IS_COMPLETE in ('" + IS_COMPLETE + "')")}
${if( len(DELAY_DAY)=0,"","
and (1=2 
" + if(INARRAY("0", DELAY_DAY) = 0,""," or (datediff(now(),DATE(aedat))>0 and IS_COMPLETE='N')" )+ 
 if(INARRAY("1", DELAY_DAY) = 0,""," or DELAY_DAY<=0" )+ 
 if(INARRAY("2", DELAY_DAY) = 0,""," or DELAY_DAY in('1','2','3')" )+ 
 if(INARRAY("3", DELAY_DAY) = 0,""," or DELAY_DAY in('4','5','6','7')" )+ 
 if(INARRAY("4", DELAY_DAY) = 0,""," or DELAY_DAY in('8','9','10','11','12','13','14','15')" )+ 
 if(INARRAY("5", DELAY_DAY) = 0,""," or DELAY_DAY in('16','17','18','19','20','21','22','23','24','25','26','27','28','29','30')" )+ 
 if(INARRAY("6", DELAY_DAY) = 0,""," or DELAY_DAY>30" ) +
")")}
${if(len(minday1) == 0,"","and DELAY_DAY >='" + minday1 + "'")}
${if(len(maxday2) == 0,"","and DELAY_DAY <= '" + maxday2 + "'")}

group by

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE_DESC," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE_DESC," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 

aa,NODE_NAME,TXFL
) as b
on 1=1 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and a.AREA_NAME=b.AREA_NAME" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and a.CITY_NAME=b.CITY_NAME" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and a.PROJ_NAME=b.PROJ_NAME" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and a.STAGE_NAME=b.STAGE_NAME" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and a.PROC_MODE_DESC=b.PROC_MODE_DESC" ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","and a.PROC_TYPE_DESC=b.PROC_TYPE_DESC" ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","and a.CATEGORY_DESC=b.CATEGORY_DESC" ) } 

${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","and a.PROC_ITEM_NAME=b.PROC_ITEM_NAME" ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","and a.PL_EDATE=b.PL_EDATE" ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","and a.AC_EDATE=b.AC_EDATE" ) }

order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","project," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","stage," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_MODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_TYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CATEGORY," ) } 
2

select distinct NODE_STATUS from f_po_NODE a
order by 
find_in_set(a.NODE_STATUS,'正在进行中_已超期,正在进行中_未超期,提前或按时完成,1-3天,4-7天,8-15天,16-30天,大于30天')

