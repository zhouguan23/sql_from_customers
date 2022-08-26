select 
	FR_DEPT_ID as 帆软平台部门ID,
	DEPT_ID as 部门ID,
	DEPT_NAME as 部门名称,
	PARENT_ID as 父级部门ID,
	PARENT_NAME as 父级部门名称,
	DEPT_TYPE as 部门类型,--(1:职能部门 2:业务部门)
	DEPT_TYPE_NAME as 部门类型名称,
	USERNAME as 登录名,
	REALNAME as 姓名,
	USERCODE as 员工编码,
	ROLE_NAME as 角色名称,
	ROLE_LV as 角色等级,
	DEPT_LV as 部门层级,
	FULLPATH as 部门路径,
	FULLPATH_NAME as 部门路径名称
from "FR_DEPT_ROLE_USER_copy1"
order by nlssort(REALNAME,'NLS_SORT=SCHINESE_PINYIN_M')

