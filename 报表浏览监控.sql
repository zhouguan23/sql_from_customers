SELECT 
todate(time)  , /* 时间*/
displayName , /*报表名*/
tname,
type, /*访问方式*/
ip,
username,
consume   , /* 执行总耗时*/
memory, /*占用内存*/
complete /* 是否计算完成,若因宕机等情况计算中断，记录为0,若计算完成，记录为1*/
FROM fine_record_execute
where username != 'huafa(huafa)' and username !='莫超杰(mochaojie)'  and username!='报表测试a(report01)' and username!= '仲华龙(zhonghualong)' /*排除管理员*/
and todate(time) >= '${a}' and todate(time)<= '${b}'
order by  time desc

