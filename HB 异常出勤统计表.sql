SELECT
isnull((select * from [dbo]A.[f_Split]A(d.[Alias]A, '.')where StrValue like '%部' and StrValue not like '%本部' ),'部门') 部门,
isnull((select * from [dbo]A.[f_Split]A(d.[Alias]A, '.')where StrValue like '%课'),'课')课,
isnull((select * from [dbo]A.[f_Split]A(d.[Alias]A, '.')where StrValue like '%组'),'组') 组,
 b.[Code]A 工号,b.[CnName]A 姓名,c.[Name]A 公司,f.[Name]A 职位,a.[Date]A 日期,g.[Name]A 班次,h.[Name]A 考勤,m.[BeginTime]A 班次开始,
m.[EndTime]A 班次结束,a.[Hours]A 核算量,a.[QuartersHours]A,i.[ScName]A 单位,m.[EmpRankCards]A 有效刷卡,m.[DailyCards]A 所有刷卡
FROM [AttendanceRollcallDetail]A AS a 
LEFT  JOIN [Employee]A AS b ON a.[EmployeeId]A=b.[EmployeeId]A  
LEFT  JOIN [Corporation]A AS c ON b.[CorporationId]A=c.[CorporationId]A  
LEFT  JOIN [Department]A AS d ON b.[DepartmentId]A=d.[DepartmentId]A  
LEFT  JOIN [Department]A AS e ON d.[DirectDeptId]A=e.[DepartmentId]A  
LEFT  JOIN [Job]A AS f ON b.[JobId]A=f.[JobId]A  
LEFT  JOIN [AttendanceRank]A AS g ON a.[AttendanceRankId]A=g.[AttendanceRankId]A  
LEFT  JOIN [AttendanceType]A AS h ON a.[AttendanceTypeId]A=h.[AttendanceTypeId]A  
LEFT  JOIN [CodeInfo]A AS i ON a.[QuartersHoursUnit]A=i.[CodeInfoId]A  
LEFT  JOIN [AttendanceRollcall]A m ON m.EmployeeId=b.EmployeeId and m.Date= a.Date
where 1=1
and a.[Date]A between '${dateEditor0}' and '${dateEditor1}'
--and DATEDIFF(MM,a.[Date]A,'2019-11-01')=0
and h.Name in ('迟到','半天旷工','全天旷工','单次未刷卡','早退','迟到30分钟以上','早退30分钟以上')
and c.[Name]A='松林光电科技（湖北）有限公司'
${if(comboBox0='ALL','',
	if(comboBox0_c='',"and d.FloorCode like '%"+comboBox0+"%'",
	if(comboBox0_c_c='',"and d.FloorCode like '%"+comboBox0_c+"%'","and d.FloorCode like '%"+comboBox0_c_c+"%'")))}
${if(textEditor0='','',"and b.[CnName]A like '%"+textEditor0+"%'")}
ORDER BY 部门,课,组,工号,姓名,日期 Desc

select code,name,alias,deptlevel,levelcode,FloorCode 
from [Department]A where 1=1
and CorporationId='D9F6648F-D0B5-41A7-89D0-A832212B25E8' 
and flag=1 and DeptLevel=2
order by levelcode

select code,name,alias,deptlevel,levelcode,FloorCode 
from [Department]A where 1=1
and CorporationId='D9F6648F-D0B5-41A7-89D0-A832212B25E8' 
and flag=1 and deptlevel=4 
and FloorCode like '${comboBox0}%'
order by levelcode

select code,name,alias,deptlevel,levelcode,FloorCode 
from [Department]A where 1=1
and CorporationId='D9F6648F-D0B5-41A7-89D0-A832212B25E8' 
and flag=1 and deptlevel=5 
and FloorCode like '${comboBox0_c}%'
order by levelcode

