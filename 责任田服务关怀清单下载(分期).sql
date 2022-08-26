 SELECT  用户号码,业务区,日深度合约活动名称,[支局编码]A,[网格编码]A,[网格经理名称]A,[日高危级别]A,[日高危级别说明]A,[DOU分层]A,[全球通尊贵标识]A,[近三个月ARPU修正]A,[流量激发模型分层]A,[本月不再推荐标识]A,[携转风险分层]A,流量使用最多的APP名称,流量使用最多的APP使用流量
  FROM [ylcmcc]A.[dbo]A.[A存量客户精准画像与分类施策]A
  where  [业务区]A='${业务区}' AND [支局编码]A='${支局编码}' and [网格编码]A LIKE '%${网格编码}%' and 目标库名称  like '%三库价值关怀库%'
  and 日深度合约活动名称 like '手机直降%' 



select 分局编码,班组名称 from [ylscore]A.[dbo]A.[映射_业务区与分局班组对应表]A where 分局编码 in
(SELECT [支局编码]A
FROM calllog.dbo.[UploadNumsTable_ALL]A
WHERE [业务区]A='${业务区}') 

