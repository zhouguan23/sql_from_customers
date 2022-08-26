
--全部点名
select (case when 计薪方式='计时' and 类型='a计件在编人数' then '计时' 
			   when 计薪方式='计件' and 类型='a计时在编人数' then '计件' else 计薪方式 end ) 计薪方式2 ,* from (
select 
部门,课,组, day(日期) 日期,计薪方式,
cast(count(distinct case when 计薪方式='计时' then 工号 end) as numeric(10,2))  a计时在编人数,
cast(sum(case when 计薪方式='计时' and 假勤='正常' then 假勤时间/核算时间/60 end) as numeric(10,2)) b计时人数,
cast(sum(case when 计薪方式='计时' and (假勤='事假' or 假勤='调休' or 假勤='婚假' or 假勤='年假' or 假勤='产假'or 假勤='陪产假'or 假勤='病假') then 假勤时间/核算时间/60 end) as numeric(10,2))  c计时请假人数,
cast(sum(case when 计薪方式='计时' and (假勤='出差登记' or 假勤='国际出差')  then   假勤时间/核算时间/60 end) as numeric(10,2))  d计时出差人数 ,
cast(sum(case when 计薪方式='计时' and (假勤='全天旷工'or 假勤='半天旷工'or 假勤='单次未刷卡') then (核算时间*60-(假勤时间+考勤时间))/核算时间/60 end) as numeric(10,2))  e计时旷工人数,
cast(sum(case when 计薪方式='计时' and 假勤 is null then 1 end) as numeric(10,2)) f计时休息人数,
cast(sum(case when 计薪方式='计时' and (假勤='平日加班' or 假勤='假日加班' or 假勤='节日加班')  then   假勤时间 end) as numeric(10,2))  g计时加班 ,
cast(sum(case when 计薪方式='计时' and 假勤='正常'then 考勤时间/60 
              when 计薪方式='计时' and (假勤='平日加班' or 假勤='假日加班' or 假勤='节日加班')  then   假勤时间 end) as numeric(10,2))  h计时出勤,

cast(count(distinct case when 计薪方式='计件' then 工号 end) as numeric(10,2))  a计件在编人数,
cast(sum(case when 计薪方式='计件' and 假勤='正常' then 假勤时间/核算时间/60 end) as numeric(10,2))  b计件人数,
cast(sum(case when 计薪方式='计件' and (假勤='事假' or 假勤='调休' or 假勤='婚假' or 假勤='年假' or 假勤='产假'or 假勤='陪产假'or 假勤='病假') then 假勤时间/核算时间/60 end) as numeric(10,2))  c计件请假人数,
cast(sum(case when 计薪方式='计件' and (假勤='出差登记' or 假勤='国际出差')  then 假勤时间/核算时间/60  end) as numeric(10,2))  d计件出差人数,
cast(sum(case when 计薪方式='计件' and (假勤='全天旷工'or 假勤='半天旷工'or 假勤='单次未刷卡') then (假勤时间+考勤时间)/核算时间/60 end) as numeric(10,2))  e计件旷工人数,
cast(sum(case when 计薪方式='计件' and 假勤 is null then 1 end) as numeric(10,2))  f计件休息人数,
cast(sum(case when 计薪方式='计件' and (假勤='平日加班' or 假勤='假日加班' or 假勤='节日加班')  then   假勤时间 end) as numeric(10,2))  g计件加班,
cast(sum(case when 计薪方式='计件' and 假勤='正常'then 考勤时间/60 
			  when 计薪方式='计件' and (假勤='平日加班' or 假勤='假日加班' or 假勤='节日加班')  then   假勤时间 end) as numeric(10,2))  h计件出勤

from ( SELECT 
b.[Code]A 工号 ,b.[CnName]A 姓名,c.[ScName]A 计薪方式,d.[Name]A 公司,e.FloorCode ,
--e.[Alias]A 部门,
isnull((select * from [dbo]A.[f_Split]A([Alias]A, '.')where StrValue like '%部' and StrValue not like '%本部' ),'部门') 部门,
isnull((select * from [dbo]A.[f_Split]A([Alias]A, '.')where StrValue like '%课'),'课')课,
isnull((select * from [dbo]A.[f_Split]A([Alias]A, '.')where StrValue like '%组'),'组') 组,
datediff(DD,LastWorkDate,a.Date) 离职天差,
datediff(DD,JobDate,a.Date) 入职现天差,
b.JobDate 入司日期,b.LastWorkDate 离职日期,
a.[Date]A 日期,h.[Name]A 班次,i.[Name]A 实际班次,
a.[QuartersHours]A 考勤时间,h.[WorkHours]A 核算时间,sum( m.[Hours]A)假勤时间,m.[Name]A 假勤,a.[Hours]A
FROM [AttendanceRollcall]A AS a 
LEFT  JOIN [Employee]A AS b ON a.[EmployeeId]A=b.[EmployeeId]A 
LEFT  JOIN [CodeInfo]A AS c ON b.[ExtraField1]A=c.[CodeInfoId]A  
LEFT  JOIN [Corporation]A AS d ON b.[CorporationId]A=d.[CorporationId]A  
LEFT  JOIN [Department]A AS e ON b.[DepartmentId]A=e.[DepartmentId]A   
LEFT  JOIN [AttendanceRank]A AS h ON a.[AttendanceRankId]A=h.[AttendanceRankId]A  
LEFT  JOIN [AttendanceType]A AS i ON a.[AttendanceTypeId]A=i.[AttendanceTypeId]A 
LEFT  JOIN (select b.[Code]A ,b.[CnName]A ,a.[Date]A ,sum(case when a.RestName='就餐班' and m.[Name]A='正常' then 0 else a.[Hours]A end ) [Hours]A ,m.[Name]A--,a.AttendanceRollcallDetailId 
from [AttendanceRollcallDetail]A a LEFT  JOIN [Employee]A AS b ON a.[EmployeeId]A=b.[EmployeeId]A 


LEFT  JOIN [AttendanceType]A AS m ON a.[AttendanceTypeId]A=m.[AttendanceTypeId]A 
where 1=1 and DATEDIFF(MM,a.[Date]A,'${dateEditor0}-01')=0 
and datediff(DD,JobDate,a.Date)>=0
and b.IsAuthorized !='TrueFalse_002'
----and a.[Date]A='2019-04-19'
--and m.[Name]A ='单次未刷卡'
--and b.[CnName]A='李臣刚'
--and (a.[Hours]A>119  or a.[Hours]A=1)
group by b.[Code]A ,b.[CnName]A ,a.[Date]A  ,m.[Name]A ) m ON m.[Code]A=b.[Code]A and a.[Date]A=m.[Date]A

where 1=1 
and DATEDIFF(MM,a.[Date]A,'${dateEditor0}-01')=0 
--and a.[Date]A='2019-04-19'
and d.[Name]A='天活松林光学（广州）有限公司'  
--and e.FloorCode like '%1.1.1.11.1.6%'
${if(comboBox0='ALL','',
	if(comboBox0_c='',"and e.FloorCode like '%"+comboBox0+"%'",
	if(comboBox0_c_c='',"and e.FloorCode like '%"+comboBox0_c+"%'","and e.FloorCode like '%"+comboBox0_c_c+"%'")))}
--and i.[Name]A not like '%休息%'
--and m.[Hours]A>=120 
--and c.[ScName]A='计件' 
--and a.[Date]A='2019-04-04'
--and m.[Name]A like '%加班%'
--and b.[CnName]A='甘利明'
group by b.[Code]A  ,b.[CnName]A ,c.[ScName]A ,d.[Name]A ,e.[Alias]A ,
a.[Date]A ,h.[Name]A ,i.[Name]A ,a.[QuartersHours]A ,h.[WorkHours]A ,m.[Name]A 
,b.[JobDate]A,b.[LastWorkDate]A,e.FloorCode ,a.[Hours]A
--order by b.[Code]A,a.[Date]A
) s
group by 部门,课,组,计薪方式, 日期) as s1
unpivot (数据 for 类型 in (a计时在编人数,b计时人数,c计时请假人数,d计时出差人数,e计时旷工人数,f计时休息人数,g计时加班,h计时出勤,
						   a计件在编人数,b计件人数, c计件请假人数,d计件出差人数,e计件旷工人数,f计件休息人数,g计件加班,h计件出勤)) as t2
pivot (sum(数据) for 日期 in([1]A,[2]A,[3]A,[4]A,[5]A,[6]A,[7]A,[8]A,[9]A,[10]A,[11]A,[12]A,[13]A,[14]A,[15]A,[16]A,[17]A,[18]A,[19]A,[20]A,[21]A,[22]A,[23]A,[24]A,[25]A,[26]A,[27]A,[28]A,[29]A,[30]A,[31]A)) as t3
order by 部门,课,组,计薪方式,类型


select code,name,alias,deptlevel,levelcode,FloorCode 
from [Department]A where 1=1
and CorporationId='ACEF2919-0927-47B9-8A54-A83118EA05F1' 
and flag=1 and DeptLevel=2
order by levelcode

select code,name,alias,deptlevel,levelcode,FloorCode 
from [Department]A where 1=1
and CorporationId='ACEF2919-0927-47B9-8A54-A83118EA05F1' 
and flag=1 and deptlevel=4 
and FloorCode like '${comboBox0}%'
order by levelcode

select code,name,alias,deptlevel,levelcode,FloorCode 
from [Department]A where 1=1
and CorporationId='ACEF2919-0927-47B9-8A54-A83118EA05F1' 
and flag=1 and deptlevel=5 
and FloorCode like '${comboBox0_c}%'
order by levelcode

