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
SUP_TYPE, -- 采购品类
SUP_TYPE_DESC,  -- 采购品类描述
ORGTYPE,   -- 库类别
ORGTYPE_DESC,   -- 库类别描述
SCOPE,   -- 服务范围
HNAME,   -- 服务范围描述
enddt,    -- 有效结束日期
sum(case when status = '04' then 1 else 0 end) '已入库',
sum(case when status = '01' then 1 else 0 end) '未提交',
sum(case when status = '02' then 1 else 0 end) '入库审批中',
sum(case when status = '03' then 1 else 0 end) '审批拒绝',
sum(case when status = '05' then 1 else 0 end) '暂挂',
sum(case when status = '06' then 1 else 0 end) '已出库'

FROM  F_PO_SUPPLY_STOCK
where 1=1 
and SUP_TYPE is not null
and left(sup_type,4)<>'0205'
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
${if(len(SUP_TYPE_DESC) == 0,"","and SUP_TYPE_DESC in ('" + SUP_TYPE_DESC + "')")}
${if(len(startdt) == 0,"","and enddt >= '" + startdt + "'")}
${if(len(enddt) == 0,"","and enddt <= '" + enddt + "'")}

group by 
SUP_TYPE, -- 采购品类
SUP_TYPE_DESC,  -- 采购品类描述
ORGTYPE,   -- 库类别
ORGTYPE_DESC,   -- 库类别描述
SCOPE,   -- 服务范围
HNAME,   -- 服务范围描述
enddt    -- 有效结束日期

order by 
SUP_TYPE, -- 采购品类
SUP_TYPE_DESC,  -- 采购品类描述
ORGTYPE,   -- 库类别
ORGTYPE_DESC,   -- 库类别描述
SCOPE,   -- 服务范围
HNAME,   -- 服务范围描述
enddt    -- 有效结束日期

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
and SUP_TYPE is not null
and left(sup_type,4)<>'0205'
and SCOPE in (select sap_dept_id from  user_org a)   
or SCOPE in (select 	left(dept_id,5)	from fr_user_org	where user_id='${fine_username}')
or SCOPE in(select b.sap_dept_id from fr_user_org a 
		left join fr_org b on left(a.dept_id,5)=b.sap_parent_id
			where user_id='${fine_username}')
or SCOPE='E01'
#权限：所有人能看到股份范围，能看所属区域范围，能看所属城市范围、区域其它城市公司




SELECT max(W_INSERT_DT) as time FROM F_PO_SUPPLY_STOCK

SELECT distinct
ORGTYPE,ORGTYPE_DESC
FROM  F_PO_SUPPLY_STOCK
where 1=1
AND ORGTYPE IS NOT NULL
and left(sup_type,4)<>'0205'

select distinct SUP_TYPE,SUP_TYPE_DESC FROM  F_PO_SUPPLY_STOCK
where 1=1
and SUP_TYPE is not null
and left(sup_type,4)<>'0205'
AND ORGTYPE IS NOT NULL
order by SUP_TYPE

and (SCOPE in(select dept_id from  fr_user_org where user_id='" +fine_username+ "' and dept_id!='E01')
 or SCOPE in (select SAP_PARENT_ID from fr_org left join fr_user_org 
 on fr_org.SAP_DEPT_ID=fr_user_org.DEPT_ID  where user_id='" +fine_username+ "' and SAP_PARENT_ID!='E01'))

