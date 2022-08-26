select distinct reverse(left(reverse(displayName),
case when charindex('/',reverse(displayName))-1 > 0 then charindex('/',reverse(displayName))-1
when charindex('/',reverse(displayName))-1 < 0 then len(reverse(displayName))
else 0 end
))  as displayName
 , tname 
from fanruan.fine_record_execute
where username not in ('rentianqi(rentianqi)','xulizhu(xulizhu)','kelly(kelly)','yongquandu(yongquandu)','admin(admin)','杜永泉(yongquandu)','machao(machao)','xiajiayin(xiajiayin)','孙静(jing.sun1)','席红康(hakan@finebi.com)','RSM测试账号(rsmtest)','rsm测试账号(rsmtest)','陈鹏(chenpeng)','胡舟(zhou.hu)','张皓(rsmtest)','刘琳(SGM_TEST)','测试单点登录(testsso)','范胜乾(jinhongtest_ICAM)','孙凯(jinhongtest_SGM)','廖灿(liaocan)','ICAM测试账号(icamtest)','11(testsso1)','TEST(SGM_TEST)','test(test_temp)','温冰(rsmtest)','Data&Intelligence(DITeam)','谈添怡(tianyitan)','王金宏(jin-hong.wang@shell.com)','杭一凡(yi-fan.hang@shell.com)')
and username ! = ''
and displayName ! = ''
and tname ! = ''
and displayName not like N'%测试%'
and tname not like '%/r/%'
and tname not like '%/ceshi/%'
and tname not like '%age/B2C_100%'
and tname not like '%/DU%'
and tname not like N'%onepage/徐%'
and tname not like '%onepage/Kelly%'
and tname not like '%onepage/yqs%'
and tname not like '%DEV%'

select   distinct
reverse(left(reverse(displayName),
case when charindex('/',reverse(displayName))-1 > 0 then charindex('/',reverse(displayName))-1
when charindex('/',reverse(displayName))-1 < 0 then len(reverse(displayName))
else 0 end
))  as displayName 
from dbo.fine_record_execute
where username not in ('rentianqi(rentianqi)','xulizhu(xulizhu)','kelly(kelly)','yongquandu(yongquandu)','admin(admin)','杜永泉(yongquandu)','machao(machao)','xiajiayin(xiajiayin)','孙静(jing.sun1)','席红康(hakan@finebi.com)','RSM测试账号(rsmtest)','rsm测试账号(rsmtest)','陈鹏(chenpeng)','胡舟(zhou.hu)','张皓(rsmtest)','刘琳(SGM_TEST)','测试单点登录(testsso)','范胜乾(jinhongtest_ICAM)','孙凯(jinhongtest_SGM)','廖灿(liaocan)','ICAM测试账号(icamtest)','11(testsso1)','TEST(SGM_TEST)','test(test_temp)','温冰(rsmtest)','Data&Intelligence(DITeam)','谈添怡(tianyitan)','王金宏(jin-hong.wang@shell.com)','杭一凡(yi-fan.hang@shell.com)')
and username ! = ''
and displayName ! = ''
and tname ! = ''
and displayName not like '%测试%'
and tname not like '%/r%'
and tname not like '%/DU%'
and tname not like '%/徐%'


select
distinct  displayName

from fine_authority_object



 SELECT  a.displayName , b.tname
 from fanruan.fine_record_execute_mapping a  
left join fanruan.fine_record_execute b on a.tname = b.tname

select distinct  displayName from fine_authority_object
where displayName not in(
select displayName  from fine_authority_object
where parentId=(
SELECT id from fine_authority_object
where   displayName='BI测试')
)

