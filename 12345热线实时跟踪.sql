SELECT 业务区,COUNT(*) '当月总量',sum(CASE WHEN [CNote]A<>'未接' then 1 else 0 end ) '当月接通量',SUM(CASE WHEN [CallerID]A<>'' and LEN([CallerID]A)=11 then 1 else 0 end ) '当月呼入量',SUM(CASE WHEN [CallerID]A<>'' and LEN([CallerID]A)=11 and [CNote]A<>'未接' then 1 else 0 end ) '当月呼入接通量'
from  
(select concat(呼入业务区,呼出业务区) '业务区',[LineID]A,[Chan]A,[AgentID]A,[AgentName]A,[StartDate]A,[StartTime]A,[DuringTime]A,[CallerID]A,[DTMF]A,[WaveFilePath]A,[CNote]A,[CallType]A,[Rings]A ,[VIFlag]A,[BackUpFlag]A,[SeqID]A,[VerID]A,[RingSecs]A,[TestScore]A,[MaxScore]A,[TestGrade]A,[营销结果]A,[一级分类]A,[二级分类]A,[携转风险分层]A
from
(select [LineID]A,[Chan]A,[AgentID]A,[AgentName]A,[StartDate]A,[StartTime]A,[DuringTime]A,c.[CallerID]A,c.业务区 '呼入业务区',d.[DTMF]A,d.业务区 '呼出业务区' ,[WaveFilePath]A,[CNote]A,[CallType]A,[Rings]A ,[VIFlag]A,[BackUpFlag]A,[SeqID]A,[VerID]A,[RingSecs]A,[TestScore]A,[MaxScore]A,[TestGrade]A,[营销结果]A,[一级分类]A,[二级分类]A,[携转风险分层]A
from
(
	SELECT  *
	  FROM [CallLog]A.[dbo]A.[CallLogTable]A
	  
	   )A0
LEFT JOIN

(
	select a.ID,a.CallerID,b.业务区
	from
	(
	SELECT  ID,CallerID
	  FROM [CallLog]A.[dbo]A.[CallLogTable]A
	   where  CallerID is not null
	)a
	left join
	(
	select 用户号码,业务区   FROM [ylcmcc]A.[dbo]A.[A存量客户精准画像与分类施策]A
	)b
	on a.CallerID =b.用户号码
)c
on A0.ID=c.ID
left join
(
	select a.ID,a.DTMF,b.业务区
	from
	(
	SELECT  ID,DTMF
	  FROM [CallLog]A.[dbo]A.[CallLogTable]A
	   where  DTMF is not null
	)a
	left join
	(
	select 用户号码,业务区   FROM [ylcmcc]A.[dbo]A.[A存量客户精准画像与分类施策]A
	)b
	on a.DTMF =b.用户号码
)d
on c.id=d.id
where ([AgentID]A='2312346' or [AgentID]A='2312347' or [AgentID]A='2312345') AND [StartDate]A between DATEADD(ms,-1,DATEADD(mm,DATEDIFF(m,0,'${p_受理日期}'),0)) and CONVERT(date,'${p_受理日期}')) e) f
group by 业务区
order by charindex (业务区,'榆阳神木府谷定边靖边横山绥德米脂佳县吴堡清涧子洲大柳塔市10088省公司市公司合计')

SELECT 业务区,COUNT(*) '当日总量',sum(CASE WHEN [CNote]A<>'未接' then 1 else 0 end ) '当日接通量',SUM(CASE WHEN [CallerID]A<>'' and LEN([CallerID]A)=11 then 1 else 0 end ) '当日呼入量',SUM(CASE WHEN [CallerID]A<>'' and LEN([CallerID]A)=11 and [CNote]A<>'未接' then 1 else 0 end ) '当日呼入接通量'
from  
(select concat(呼入业务区,呼出业务区) '业务区',[LineID]A,[Chan]A,[AgentID]A,[AgentName]A,[StartDate]A,[StartTime]A,[DuringTime]A,[CallerID]A,[DTMF]A,[WaveFilePath]A,[CNote]A,[CallType]A,[Rings]A ,[VIFlag]A,[BackUpFlag]A,[SeqID]A,[VerID]A,[RingSecs]A,[TestScore]A,[MaxScore]A,[TestGrade]A,[营销结果]A,[一级分类]A,[二级分类]A,[携转风险分层]A
from
(select [LineID]A,[Chan]A,[AgentID]A,[AgentName]A,[StartDate]A,[StartTime]A,[DuringTime]A,c.[CallerID]A,c.业务区 '呼入业务区',d.[DTMF]A,d.业务区 '呼出业务区' ,[WaveFilePath]A,[CNote]A,[CallType]A,[Rings]A ,[VIFlag]A,[BackUpFlag]A,[SeqID]A,[VerID]A,[RingSecs]A,[TestScore]A,[MaxScore]A,[TestGrade]A,[营销结果]A,[一级分类]A,[二级分类]A,[携转风险分层]A
from
(
	SELECT  *
	  FROM [CallLog]A.[dbo]A.[CallLogTable]A
	  
	   )A0
LEFT JOIN

(
	select a.ID,a.CallerID,b.业务区
	from
	(
	SELECT  ID,CallerID
	  FROM [CallLog]A.[dbo]A.[CallLogTable]A
	   where  CallerID is not null
	)a
	left join
	(
	select 用户号码,业务区   FROM [ylcmcc]A.[dbo]A.[A存量客户精准画像与分类施策]A
	)b
	on a.CallerID =b.用户号码
)c
on A0.ID=c.ID
left join
(
	select a.ID,a.DTMF,b.业务区
	from
	(
	SELECT  ID,DTMF
	  FROM [CallLog]A.[dbo]A.[CallLogTable]A
	   where  DTMF is not null
	)a
	left join
	(
	select 用户号码,业务区   FROM [ylcmcc]A.[dbo]A.[A存量客户精准画像与分类施策]A
	)b
	on a.DTMF =b.用户号码
)d
on c.id=d.id
where ([AgentID]A='2312346' or [AgentID]A='2312347' or [AgentID]A='2312345') AND [StartDate]A=CONVERT(date,'${p_受理日期}')) e) f
group by 业务区
order by charindex (业务区,'榆阳神木府谷定边靖边横山绥德米脂佳县吴堡清涧子洲大柳塔市10088省公司市公司合计')


