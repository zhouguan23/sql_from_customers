select 
	PL_MANAGECOM2V as 2级管理机构编码,
	PL_MANAGECOMNAME2V as 2级管理机构名称,
	PL_MANAGECOM3V as 3级管理机构编码,
	PL_MANAGECOMNAME3V as 3级管理机构名称,
	PREM_CON,
	SALECHNLNAME,
	SELLTYPENAME,
	AGENTTYPENAME,
	2LVLPLTTYPE,
	2LVLPLTTYPENAME,
	PERFORMANCEGROUPNAME,
	CONTNO,
	PROPOSALCONTNO,
	APPFLAGNAME,
	AMNT,
	SCALE_PREM,
	STANDPREM,
	FYC,
	RISKCODE,
	RISKNAME,
	KINDCODENAME,
	SUBRISKFLAGNAME,
	INSUYEAR as 保险期限,
	PAYTYPE,
	CASE 
         WHEN PAYINTV=0 THEN '趸缴'
         WHEN PAYYEARS=1000 THEN '趸缴'
         WHEN PAYYEARS=100 THEN '趸缴'
         WHEN PAYYEARS=0 THEN '趸缴'
         ELSE CONCAT(PAYYEARS,'年') 
     END '缴费年期',
	CASE
		WHEN PAYINTV=0 THEN '趸交'
		WHEN PAYINTV=1 THEN '月交'
		WHEN PAYINTV=3 THEN '季交'
		WHEN PAYINTV=6 THEN '半年交'
		WHEN PAYINTV=12 THEN '年交'
	END '缴费间隔',
	APPNTNAME,
	Reasonsforfailure,
	VISITDATE,
	ApprovalofNuclearGuarantee,
	UWFLAG,
	CONCAT(SUBSTR(app_homeaddress,1,6),'**********') as app_homeaddress,
	app_IDEXPDATE,
	app_occupationcode,
	app_OCCUPATIONTYPENAME,
	CONCAT(SUBSTR(INS_homeaddress,1,6),'**********') as INS_homeaddress,
	INS_idexpdate,	
	INS_occupationcode,	
	INS_code_name,
	APPNTSEXNAME,
	APPNTAGEAT,
	APPNTIDTYPENAME,
	CONCAT('**************',RIGHT(APPNTIDNO,4)) AS APPNTIDNO,
	INSUREDNAME,
	INSUREDSEXNAME,
	INSUREDAPPAGE,
	INSUREDIDTYPENAME,
	CONCAT('**************',RIGHT(INSUREDIDNO,4)) AS INSUREDIDNO,
	NAME,
	SEX,
	AGE,
	IDTYPE,
	CONCAT('**************',RIGHT(IDNO,4)) AS IDNO,
	PL_MANAGECOMNAME,
	PL_UPCOMCODE,
	AGENTCODE,
	AGENTNAME,
	AGENTGROUP,
	BGP_NAME,
	BGP_NAME2V,
	left(MAKEDATE, 10) MAKEDATE,
	left(POLAPPLYDATE,10) as POLAPPLYDATE,
	left(SCANTIME,10) as SCANTIME,
	left(PAYTOTIME,10) as PAYTOTIME,
	left(SIGNDATE,10) as SIGNDATE,
	left(SIGNTIME,10) as SIGNTIME,
	left(CVALIDATE,10) as CVALIDATE,
	left(CUSTOMGETPOLDATE,10) as CUSTOMGETPOLDATE,
	left(HESITATEEND,10) as HESITATEEND,
	left(CORTNDATE,10) as CORTNDATE,
	left(CACELDATE,10) as CACELDATE,
	left(HESITATE_CANCELDATE,10) as HESITATE_CANCELDATE,
	TBSTATE,
	TBSTATENAME,
	TBMDATE,
	EDORNO,
	ZJAgentcode,
	CONCAT(left(newbankname,4),'**************') as newbankname,
	CONCAT('**************',RIGHT(newbankcode,4)) as newbankcode,
	ag_name,
	BankAgentName,
	TB_MONEY,
	CONCAT(left(APP_mobile,3),'****',RIGHT(APP_mobile,4)) as APP_mobile
from da_20000004
where 1=1
	${IF(OR(PERFORMANCEGROUP="",PERFORMANCEGROUP="全部"),"","and PERFORMANCEGROUP in ('"+PERFORMANCEGROUP+"') ")}
	${IF(OR(MANAGECOMNAME2V="",MANAGECOMNAME2V="全部"),"","and PL_MANAGECOM2V in ('"+MANAGECOMNAME2V+"') ")}
	${IF(OR(MANAGECOMNAME3V="",MANAGECOMNAME3V="全部"),"","and PL_MANAGECOM3V in ('"+MANAGECOMNAME3V+"') ")}
	${IF(OR(MANAGECOMNAME4V="",MANAGECOMNAME4V="全部"),"","and PL_MANAGECOM4V in ('"+MANAGECOMNAME4V+"') ")}
	${IF(OR(MANAGECOMNAME5V="",MANAGECOMNAME5V="全部"),"","and PL_MANAGECOM5V in ('"+MANAGECOMNAME5V+"') ")}
	${IF(OR(RISK="",RISK="全部"),"","and RISKCODE in ('"+RISK+"') ")}
	${IF(OR(CONTTYPE="",CONTTYPE="全部"),"","and CONTTYPE in ('"+CONTTYPE+"') ")}
	${IF(OR(SALECHNL="",SALECHNL="全部"),"","and SALECHNL in ('"+SALECHNL+"') ")}
	${IF(OR(SELLTYPE="",SELLTYPE="全部"),"","and SELLTYPE in ('"+SELLTYPE+"') ")}
	${IF(OR(AGENTTYPE="",AGENTTYPE="全部"),"","and AGENTTYPE in ('"+AGENTTYPE+"') ")}
	${if(Rdate="","","and MAKEDATE>='"+Rdate+"-01 00:00:00' and MAKEDATE<=CONCAT(last_day('"+Rdate+"-01'),' 23:59:59')")}
	${if(Sdate="","","and SCANTIME>='"+Sdate+"-01 00:00:00' and SCANTIME<=CONCAT(last_day('"+Sdate+"-01'),' 23:59:59')")}
	${if(Tdate="","","and POLAPPLYDATE>='"+Tdate+"-01 00:00:00' and POLAPPLYDATE<=CONCAT(last_day('"+Tdate+"-01'),' 23:59:59')")}
	${if(Cdate="","","and SIGNDATE>='"+Cdate+"-01 00:00:00' and SIGNDATE<=CONCAT(last_day('"+Cdate+"-01'),' 23:59:59')")}

select 
comcode 管理机构代码,
name 管理机构名称,
comgrade 管理机构层级,
upcomcode 上级管理机构代码
from DWCHN_COM 管理机构
where 
comgrade='03'

select 
comcode 管理机构代码,
name 管理机构名称,
comgrade 管理机构层级,
upcomcode 上级管理机构代码
from DWCHN_COM 管理机构
where 
comgrade='04' and
upcomcode in ('${MANAGECOMNAME3V}')

select code,codename from DWGEN_CODE  where codetype='BankSubChannel'

select * from DW_GEN_DICT 通用数据字典 where table_ename='KINDCODE'

select riskcode,riskname,kindcode 
from DWPRD_RISK 
order by riskname

SELECT
	CODE,
	CASE
		WHEN CODE=0201 THEN '个人业务员'
		WHEN CODE=0405 THEN '个人代理'
		WHEN CODE=0506 THEN '个人代理 '
		WHEN CODE=0102 THEN '个单业务'
		WHEN CODE=0103 THEN '保险专业代理'
		WHEN CODE=0404 THEN '保险专业代理 '
		WHEN CODE=0504 THEN '保险专业代理  '
		WHEN CODE=0401 THEN '保险经纪业务'
		WHEN CODE=0501 THEN '保险经纪业务 '
		WHEN CODE=0101 THEN '公司直销'
		WHEN CODE=0303 THEN '公司直销 '
		WHEN CODE=0505 THEN '公司直销  '
		WHEN CODE=0105 THEN '其他'
		WHEN CODE=0403 THEN '其他兼业代理'
		WHEN CODE=0503 THEN '其他兼业代理 '
		WHEN CODE=0302 THEN '手工单'
		WHEN CODE=0104 THEN '综合开拓'
		WHEN CODE=0308 THEN '银保通'
		WHEN CODE=0402 THEN '银行邮政代理'
		WHEN CODE=0502 THEN '银行邮政代理 '
	END 'code_name'
FROM DW_GEN_DICT 
WHERE table_ename='SELLTYPE'

select * from DW_GEN_DICT 通用数据字典 where table_ename='PERFORMANCEGROUP'

SELECT code_name,CODE FROM DW_GEN_DICT WHERE table_ename='SALECHNL'

