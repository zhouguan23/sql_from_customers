WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

select DISTINCT
area_org_name,
city_org_name,
proj_name,
stage_name,
t1.CONTRACT_NO, -- 系统编号
CONT_ARCH_ID, -- 归档编号
t1.CONT_NAME,
PROJ_NAME,
CASE WHEN STAT = '01' THEN '已创建' 
     WHEN STAT = '05' THEN '审批中' 
     WHEN STAT = '06' THEN '审批通过' 
		 WHEN STAT = '07' THEN '审批拒绝' 
	   WHEN STAT = '08' THEN '已生效' 
		 WHEN STAT = '13' THEN '审批退回'
		 ELSE NULL END STAT,
CASE WHEN CONT_CLASS1 ='0302' then '施工及材料设备类' else '项目设计类' end CONT_CLASS1,
SETBID_NO, -- 定标编号
case when t2.CONTRACT_NO is not null then '是' else '否' end exp,
 USNAME,   -- 经办人
 concat(left(CREATE_TIME,4),'-',substring(CREATE_TIME,5,2),'-',substring(CREATE_TIME,7,2))CREATE_TIME

from 
f_po_cont_det t1 left join f_po_cont_det_exp t2 on t1.contract_no = t2.contract_no
WHERE STAT IN (01,05,06,07,08,13)
AND CONT_TYPE IN (01,05)
AND CONT_KIND='03'
and PROC_MODE = '04'
and CONT_CLASS1 in (0302,0303)
and proj_code in (select sap_dept_id from user_org where dept_level = 3)
${if(len(sdate)=0,"","and left(create_time,8)>='"+sdate+"'")}
${if(len(edate)=0,"","and left(create_time,8)<='"+edate+"'")}
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_CODE in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_CODE in ('" + STAGE_NAME + "')")}
${IF(LEN(CONT)=0,"","AND T1.contract_NO IN ('"+CONT+"')")}
${IF(LEN(CONT_ID)=0,"","AND T1.contract_NO IN ('"+CONT_ID+"')")}
and period_wid =  DATE_FORMAT(date_add(curdate(), interval -1 day),"%Y-%m")

union
select DISTINCT
area_org_name,
city_org_name,
proj_name,
stage_name,
t1.CONTRACT_NO, -- 系统编号
CONT_ARCH_ID, -- 归档编号
t1.CONT_NAME,
PROJ_NAME,
CASE WHEN STAT = '01' THEN '已创建' 
     WHEN STAT = '05' THEN '审批中' 
     WHEN STAT = '06' THEN '审批通过' 
		 WHEN STAT = '07' THEN '审批拒绝' 
	   WHEN STAT = '08' THEN '已生效' 
		 WHEN STAT = '13' THEN '审批退回'
		 ELSE NULL END STAT,
CASE WHEN CONT_CLASS1 ='0302' then '施工及材料设备类' else '项目设计类' end CONT_CLASS1,
SETBID_NO, -- 定标编号
case when t2.CONTRACT_NO is not null then '是' else '否' end exp,
 USNAME,   -- 经办人
 concat(left(CREATE_TIME,4),'-',substring(CREATE_TIME,5,2),'-',substring(CREATE_TIME,7,2))CREATE_TIME

from 
f_po_cont_det t1 left join f_po_cont_det_exp t2 on t1.contract_no = t2.contract_no
where
STAT IN (01,05,06,07,08,13)
AND CONT_KIND IN (01,02)
and CONT_CLASS1 in (0302,0303)
and proj_code in (select sap_dept_id from user_org where dept_level = 3)
${if(len(sdate)=0,"","and left(create_time,8)>='"+sdate+"'")}
${if(len(edate)=0,"","and left(create_time,8)<='"+edate+"'")}
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_CODE in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_CODE in ('" + STAGE_NAME + "')")}
${IF(LEN(CONT)=0,"","AND T1.contract_NO IN ('"+CONT+"')")}
${IF(LEN(CONT_ID)=0,"","AND T1.contract_NO IN ('"+CONT_ID+"')")}
and period_wid =  DATE_FORMAT(date_add(curdate(), interval -1 day),"%Y-%m")

 order by  CONTRACT_NO 

select max(W_INSERT_DT) from f_po_cont_det

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct CITY_ORG_NAME,CITY_ORG_CODE
FROM f_po_cont_det
where 1=1
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
and city_org_code in (select distinct sap_dept_id from user_org)


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct AREA_ORG_NAME,AREA_ORG_CODE
FROM f_po_cont_det
where 1=1
and city_org_code in (select distinct sap_dept_id from user_org)

SELECT DISTINCT 
CONT_NAME,CONTRACT_NO CONTRACT_ID
FROM f_po_cont_det
WHERE 1=1
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_NAME + "')")}


