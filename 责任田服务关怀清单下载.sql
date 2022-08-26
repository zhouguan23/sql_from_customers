SELECT * FROM 
(SELECT [PhoneNum]A,[ExtraInfo]A,[DevID]A,[State]A,[Priority]A,[业务区]A,[支局编码]A,[网格编码]A,[客户经理名称]A,[日高危级别]A,[日高危级别说明]A,[DOU分层]A,[全球通尊贵标识]A,[近三个月净ARPU]A,[流量激发模型分层]A,[本月不再推荐标识]A,[携转风险分层]A,流量使用最多的APP名称,流量使用最多的APP使用流量
FROM calllog.dbo.[UploadNumsTable_ALL]A
union all
select [PhoneNum]A,[ExtraInfo]A,[DevID]A,[State]A,[Priority]A,[业务区]A,[支局编码]A,[网格编码]A,'','','','','',null,'','','','',''
from [CallLog]A.[dbo]A.[UploadNumsTable_YS]A) a
WHERE [业务区]A='${业务区}' AND [支局编码]A='${支局编码}' and [网格编码]A LIKE '%${网格编码}%' and [ExtraInfo]A like '%${分配的关键字}%' and [ExtraInfo]A like '%${其他关键字}%'


 select [分局编码]A '支局编码',班组名称 '支局名称' from ylscore.dbo.[映射_业务区与分局班组对应表]A where [分局编码]A in
(SELECT [支局编码]A
FROM calllog.dbo.[UploadNumsTable_ALL]A
WHERE [业务区]A='${业务区}') 

