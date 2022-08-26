select * from view_analysis_caliber where 1=1 ${if(len(area) == 0,"","and 区域 like '%" + area + "%'")} ${if(len(model) == 0,"","and 规格型号 like '%" + model + "%'")} and 业务公司 = '${busOrgName}' and 会计年月 >= '${yearMonthBegin}'
and 会计年月 <= '${yearMonthEnd}'

select name as 业务公司 from sa_oporg t where t.org_kind_id = 'ogn' and t.full_code like '/1005/%' and t.status = '1' and t.is_virtual = '0'

select to_char(sysdate,'yyyy') ||'-01' as 首月,to_char(sysdate,'yyyy-mm') as 当前月 from dual

