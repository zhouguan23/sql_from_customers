select
distinct fine_user.userName ,
fine_custom_role.name as names
,realName
from  fanruan.fine_user_role_middle 
left join fanruan.fine_user on fine_user.id=fine_user_role_middle.userId
left join fanruan.fine_custom_role on fine_custom_role.id=fine_user_role_middle.roleId
where fine_user_role_middle.roleType='2'
and userName not in('admin','chenpeng','DITeam','icamtest','jing.sun1','jinhongtest_ICAM','jinhongtest_ICAM_Zhangyu','jinhongtest_ICAM1','jinhongtest_ICAM3','jinhongtest_RSM','jinhongtest_RSM2','jinhongtest_RSM3','jinhongtest_SGM','jinhongtest_SGM_Liulin','jinhongtest1','jinhongtest2','jinhongtest3','jinhongtest4','jinhongtest5','kelly','liaocan','machao','rentianqi','rsmtest','test','test_temp','testsso','tianyitan','xiajiayin','xujinjie','xulizhu','yongquandu','zhou.hu','hakan@finebi.com','eee')
${if(len(role)=0,"","and fine_custom_role.name in('"+role+"')")}
${if(len(Name)=0,"","and realName  in(N'"+Name+"')")}
order by names

select
distinct fine_custom_role.name
from  fine_user_role_middle 
left join fine_user on fine_user.id=fine_user_role_middle.userId
left join fine_custom_role on fine_custom_role.id=fine_user_role_middle.roleId
where fine_user_role_middle.roleType='2'
and userName not in('admin','chenpeng','DITeam','icamtest','jing.sun1','jinhongtest_ICAM','jinhongtest_ICAM_Zhangyu','jinhongtest_ICAM1','jinhongtest_ICAM3','jinhongtest_RSM','jinhongtest_RSM2','jinhongtest_RSM3','jinhongtest_SGM','jinhongtest_SGM_Liulin','jinhongtest1','jinhongtest2','jinhongtest3','jinhongtest4','jinhongtest5','kelly','liaocan','machao','rentianqi','rsmtest','test','test_temp','testsso','tianyitan','xiajiayin','xujinjie','xulizhu','yongquandu','zhou.hu')

select
distinct realName
from  fine_user_role_middle 
left join fine_user on fine_user.id=fine_user_role_middle.userId
left join fine_custom_role on fine_custom_role.id=fine_user_role_middle.roleId
where fine_user_role_middle.roleType='2'
and userName not in('admin','chenpeng','DITeam','icamtest','jing.sun1','jinhongtest_ICAM','jinhongtest_ICAM_Zhangyu','jinhongtest_ICAM1','jinhongtest_ICAM3','jinhongtest_RSM','jinhongtest_RSM2','jinhongtest_RSM3','jinhongtest_SGM','jinhongtest_SGM_Liulin','jinhongtest1','jinhongtest2','jinhongtest3','jinhongtest4','jinhongtest5','kelly','liaocan','machao','rentianqi','rsmtest','test','test_temp','testsso','tianyitan','xiajiayin','xujinjie','xulizhu','yongquandu','zhou.hu')


select * from fine_record_execute_log_mapping

SELECT * FROM fanruan.[fine_record_execute_log_mapping]A

