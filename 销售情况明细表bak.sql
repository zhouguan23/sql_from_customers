SELECT DISTINCT
	T2.CITY_ID,
  T1.PROJECT_ID,
	T1.SALE_ORG_ID,
	T2.CITY_NAME + T1.SALE_ORG_NAME AS SALE_ORG_NAME
FROM
	CUX_FND_MKT_PER_PROJ_V T1
LEFT JOIN (
	SELECT DISTINCT
		PROJECT_ID,
		CITY_ID,
		CITY_NAME
	FROM
		MKT_PRO_CITY_AREA_RELATION
	WHERE
		DEL_FLAG = 0
) T2 ON T2.PROJECT_ID = T1.PROJECT_ID
WHERE
	1 = 1
AND t2.PROJECT_ID IS NOT NULL
AND T1.USER_ID = 'WEBSYS'
${if(len(CITY_ID)=0,""," AND T2.CITY_ID IN ('"+CITY_ID+"')")}
 --and sale_org_id in ('${sale_org}')
${if(fine_username = 'huafa',"","and sale_org_id in ('"+sale_org+"')")}
ORDER BY
	T2.CITY_ID, T1.PROJECT_ID,
	T1.SALE_ORG_ID 

SELECT 
distinct
T38.CITY_NAME,--城市
T20.PROJECT_NAME AS PROJECT_NAME, --项目名称
T20.PERIOD_NAME, --分期
T1.BUILDING_NAME, --楼栋
CASE WHEN T11.is_show_unit = '0' THEN '-' ELSE T1.UNIT END as house_unit, --单元
len(T1.SALE_FLOOR_ROOM_NAME),
T1.SALE_FLOOR_ROOM_NAME, --房源名称
PARKING_SPACE_HOUSE, --车位对应房源
T11.PRODUCT_NAME, --业态
T1.DECORATE_ID, --装修类型
TA1.STAFF1_NAME,
TA1.STAFF2_NAME,
T2.CUSTOMER_NAME, --客户名称
T16.TELPHONE,--手机号
T39.CERT_NUMBER,--证件号码
T16.VISIT_CHANNEL_NAME,--来访渠道
t1.PLAN_BUILD_AREA, --预测建筑面积
t1.PLAN_SPACE_AREA, --预测套内面积
CASE WHEN (T1.ACTUAL_BUILD_AREA IS NULL OR T1.ACTUAL_BUILD_AREA = '') THEN '0' ELSE T1.ACTUAL_BUILD_AREA END as actual_building_area,-- 实测建筑面积
T1.ACTUAL_SPACE_AREA, --实测套内面积
T1.HOUSE_FACE_PRICE, --表单价
T1.HOUSE_SUM_FACE_PRICE AS face_tatal_price,  --表总价
T5.IS_LOAN AS order_is_loan, --认购付款方式类型
T5.PAYMENT_METHOD_NAME as payment_mehthod1,--认购付款方式
T8.IS_LOAN AS contract_is_loan, --签约付款方式类型
T8.PAYMENT_METHOD_NAME, --签约付款方式
T9.MORTGAGE_BANK, --按揭银行
CONVERT(varchar(10), T9.ACTUAL_FINISH_DATE, 23) as actral_finish_date,-- 按揭手续办理日期
T9.COUNT_AMOUNT, --过单金额
T1.SALE_STATE, --房源状态
CASE WHEN T6.CONTRACT_TOTAL_PRICE IS NOT NULL THEN T6.CONTRACT_TOTAL_PRICE ELSE (CASE WHEN T2.ORDER_TOTAL_PRICE IS NOT NULL THEN T2.ORDER_TOTAL_PRICE ELSE T1.HOUSE_SUM_FACE_PRICE END) END as total_amount,--总资源
CONVERT(varchar(10), T2.SIGNING_DATE, 23) as siging_date, --认购日期
CONVERT(varchar(12) , T2.CREATE_DATE, 108 ) as order_create_date, --认购时间
CONVERT(varchar(10), T2.ACHIEVE_COUNT_DATE, 23) as achieve_count_date,--业绩统计日期
CASE WHEN T2.SIGN_ORDER_AGREEMENT IS NULL THEN '' ELSE (CASE WHEN T2.SIGN_ORDER_AGREEMENT = 0 THEN '否' ELSE '是' END) END AS signOrderAgreement,-- 是否已签认购协议
T2.ORDER_STATUS,-- 定单状态
CONVERT(varchar(10), T2.AUDIT_DATE, 23) as auditDate, --定单审核日期
CONVERT(varchar(10), T2.PREPARED_SIGNING_DATE, 23) as prepared_signing_date,-- 拟定签约日期
CONVERT(varchar(10), T36.TEMP_DATE_COMPLETION, 23) as temp_date_completion, --销售进程计划表签约日期
T2.SALES_AREA, --销售面积
T2.ORDER_UNIT_PRICE, --认购单价
T2.ORDER_TOTAL_PRICE, --认购总价
T6.FORMAL_CONTRACT_ID, --网签合同号
t6.CONTRACT_STATE as contract_state,--合同状态
CONVERT(varchar(10),t6.INITIAL_CONTRACT_DATE, 23) as initial_contract_date,--草签日期
CASE WHEN t6.CONTRACT_STATE='10' THEN '' ELSE CONVERT(varchar(10), T6.CONTRACT_DATE, 23) END as contract_date, --签约日期
T6.CONTRACT_PRICE, ---签约单价
T6.CONTRACT_TOTAL_PRICE, --签约总价
-- fin_receipt_sum,--回款金额
-- mkt_receipt_sum,--营销回款金额
T21.CONTRACT_FILING, --合同备案状态
T22.REGISTRA_STATE, --权属办理状态
T23.SENDER_AREA, --补差面积
T23.SENDER_SUM, --面积补差金额
T25.CHARGE_SUM as transfer_sum,--已收面积补差款
CASE WHEN T6.APPOINT_DELIVERY_DATE IS NOT NULL THEN CONVERT(varchar(10), T6.APPOINT_DELIVERY_DATE, 23) ELSE CONVERT(varchar(10), T2.APPOINT_DELIVERY_DATE, 23) END as plan_repos, --合同约定交楼日期
 T99.as_handover_date as as_handover_date, --视同交楼日期
CONVERT(varchar(10), T2.ADMISSION_NOTICE_DATE, 23) as admission_notice_date,-- 入伙通知日期
T99.SALES_DATE as sales_date, --实际交房日期
case when T6.APPOINT_DELIVERY_DATE IS NOT NULL or T2.APPOINT_DELIVERY_DATE is not null then '01'
when T6.APPOINT_DELIVERY_DATE IS  NULL and T2.APPOINT_DELIVERY_DATE is  null and  T99.as_handover_date is not null then '02' else '03' end hand_status, -- 交房状态
T2.CUSTOMER_ADDRESS, --认购通讯地址
T6.CONTRACT_ADDRESS,  --签约通讯地址
T18.NAME AS PropertyConsultant, --置业顾问
T19.NAME AS TogerPropertyConsultant, --共同跟进置业顾问
T16.AGENT_NAME,--报备人姓名
ISNULL(T16.CHANNEL_NAME,T17.CHANNEL_NAME) 中介公司,--中介公司
t26.NAME as orderTypeName,--定单类型
CONVERT(varchar(10),t11.ACTUAL_PRESALE_CERT_DATE, 23) as actualPresaleCertDate,--实际取得预售证日期
t2.CUSTOMER_PHONE_NUM as orderTelphone1,--认购手机号码1
t2.CUSTOMER_PHONE_NUM2 as orderTelphone2,--认购手机号码2
t2.CUSTOMER_PHONE_NUM3 as orderTelphone3,--认购手机号码3
t6.CUSTOMER_PHONE_NUM as contractTelphone1,--签约手机号码1
t6.CUSTOMER_PHONE_NUM2 as contractTelphone2,--签约手机号码2
t6.CUSTOMER_PHONE_NUM3 as contractTelphone3,--签约手机号码3
CASE WHEN (T1.SALE_STATE = '3' OR T1.SALE_STATE = '4' OR T1.SALE_STATE = '5') THEN T2.BASE_UNIT_PRICE ELSE T1.HOUSE_INSIDE_PRICE END AS baseUnitPrice, --底单价
CASE WHEN (T1.SALE_STATE = '3' OR T1.SALE_STATE = '4' OR T1.SALE_STATE = '5') THEN T2.BASE_TOTAL_PRICE ELSE T1.HOUSE_SUM_INSIDE_PRICE END AS baseSumPrice, --底总价
T1.HOUSE_TYPE_NAME as houseTypeName, --户型名称
T27.COMPOSITION as composition, --户型构成
CASE WHEN T1.SALE_STATE = '3' THEN T28.WORKFLOW_STATUS ELSE (CASE WHEN T1.SALE_STATE = '3' THEN T29.WORKFLOW_STATUS ELSE '0' END) END AS workflowStatus, --退定/退房OA审批状态
CONVERT(varchar(10), T11.PUSH_DATE, 23) as PUSH_DATE, --推盘日期
T9.provident_fund_amount, --公积金贷款金额
T9.commercial_amount, --商业贷款金额
T37.name as reserveReason, --预留原因
CONVERT(varchar(10), T2.FIRST_ACHIEVE_COUNT_DATE, 23) as firstAchieveCountDate, --收齐定金日期
CONVERT(varchar(10), T2.SIGEN_ORDER_AGREEMENT_DATE, 23) as signOrderAgreementDate, --签署认购协议日期
T2.COMMISSION_TYPE, --佣金特殊业务类型
T2.AS_NETSIGN_DATE, --视同网签日期
T18.CHANNEL_NAME + (CASE WHEN T19.CHANNEL_NAME IS NOT NULL AND T19.CHANNEL_NAME <> T18.CHANNEL_NAME THEN (',' + T19.CHANNEL_NAME) ELSE '' END) as agencyCompany,
CASE WHEN (T16.ONLINE_AGENT_STATUS='50' AND T16.ONLINE_AGENT_NAME IS NOT NULL) THEN '是' ELSE '否' END as expandingCustomerAgent,

T2.CUSTOMER_NUMBER,
T1.HOUSE_SUM_FACE_PRICE AS face_tatal_price, 
T12.CUSTOMER_NUMBER AS ORDER_CUSTOMER_NUMBER, --
T13.CUSTOMER_NUMBER AS CONTRACT_CUSTOMER_NUMBER, --
--T16.NAME AS ORDER_CUSTOMER_NAME, --
--T17.NAME AS CONTRACT_CUSTOMER_NAME, --
T11.IS_SHOW_UNIT, --
T20.IS_SHOW_PERIOD, --
T25.PAYMENT_TYPE_ID as transfer_type,
T6.SALES_AREA contract_sale_area,T1.BUILDING_ID as buildingId,--
T1.ID as houseId,--
t1.SALE_ORG_ID as saleOrgId,--
t1.org_id as org_id,
t1.project_Id,
CONVERT(varchar(10), T6.APPOINT_DELIVERY_DATE, 23) as plan_repos2,
T2.UNIT_PRICE, --
T2.TOTAL_PRICE, --
T11.MAIN_BUILDING_ID as main_building_id, --
T1.period_id + t11.product_id as outSystemValue ,
T2.ID ORDER_ID, --
T6.ID AS CONTRACT_ID,
provider.name  provider_name

FROM 
MKT_HOUSE_RESOURCE T1 
LEFT JOIN MKT_BUILDING T11 ON T1.BUILDING_ID = T11.ID 
LEFT JOIN (SELECT ID,ROOM_CODE,CUSTOMER_NAME,CUSTOMER_NUMBER,PAYMENT_NUMBER,ORDER_TOTAL_PRICE,SIGNING_DATE,SALES_AREA,PREFERENTIALED_UNIT_PRICE,CREATE_DATE,FOLLOW_PROPERTY_CONSULTANT,TOGETHER_FOLLOW_CONSULTANT,SALE_ORG_ID,ORDER_UNIT_PRICE,CUSTOMER_ADDRESS,ACHIEVE_COUNT_DATE,ORDER_TYPE_ID,CUSTOMER_PHONE_NUM,CUSTOMER_PHONE_NUM2,CUSTOMER_PHONE_NUM3,APPOINT_DELIVERY_DATE,ADMISSION_NOTICE_DATE,AUDIT_DATE,UNIT_PRICE,TOTAL_PRICE,BASE_UNIT_PRICE,BASE_TOTAL_PRICE,PREPARED_SIGNING_DATE,ORDER_STATUS,SIGN_ORDER_AGREEMENT,FIRST_ACHIEVE_COUNT_DATE,SIGEN_ORDER_AGREEMENT_DATE,COMMISSION_TYPE,AS_NETSIGN_DATE,PARKING_SPACE_HOUSE FROM MKT_ORDER where ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND  (ORDER_STATUS = '10' OR ORDER_STATUS = '20' OR ORDER_STATUS = '50') AND DEL_FLAG='0')T2 ON T1.ID = T2.ROOM_CODE 
LEFT JOIN (SELECT order_ID,STAFF1_NAME,STAFF2_NAME FROM MKT_ORDER_STAFF_RELATION WHERE RELATION_TYPE=1)TA1 ON TA1.order_ID=T2.ID
left join (select distinct code,name from MKT_PLANNING_PROVIDER where del_flag = 0) provider on provider.code = t2.id
LEFT JOIN MKT_CONFIG_PAYMENT_METHOD T5 ON T2.PAYMENT_NUMBER = T5.ID 
LEFT JOIN MKT_CONTRACT T6 ON T2.ID = T6.ORDER_NUMBER  AND t6.CONTRACT_STATE IN ('10', '20', '50') AND T6.DEL_FLAG = 0 
LEFT JOIN (select SALES_DATE,min(as_handover_date) as_handover_date,contract_id from MKT_TRANFER_HOUSE_RECORDS where del_flag='0' group by SALES_DATE,contract_id) T99 ON T6.ID = T99.CONTRACT_ID 
LEFT JOIN (SELECT ID,PAYMENT_METHOD_NAME,IS_LOAN FROM MKT_CONFIG_PAYMENT_METHOD where ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  )  ) T8 ON T8.ID = T6.PAY_TYPE AND T8.ID IS NOT NULL 
LEFT JOIN (SELECT HOUSE_ID,MAX(CREATE_DATE) as CREATE_DATE FROM MKT_MORTGAGE WHERE DEL_FLAG=0 AND STATE = '20' GROUP BY HOUSE_ID) t33 ON t33.HOUSE_ID = T1.ID 
-- LEFT JOIN MKT_MORTGAGE T9 on T9.HOUSE_ID = T33.HOUSE_ID AND T9.CREATE_DATE = t33.CREATE_DATE AND T9.STATE = '20' AND T9.DEL_FLAG=0 AND T1.sale_state != '1' 
LEFT JOIN MKT_MORTGAGE T9 on T9.HOUSE_ID = T1.ID AND T9.STATE = '20' AND T9.DEL_FLAG = 0 AND T1.SALE_STATE <> '1'
LEFT JOIN (SELECT CUSTOMER_NUMBER,CUSTOMER_NAME,TICKET_NUMBER FROM MKT_ORDER_CON_CUS where ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND  CUSTOMER_TYPE_NUM = '10' AND DEL_FLAG='0')T12 ON T12.TICKET_NUMBER = T2.ID 
LEFT JOIN (SELECT CUSTOMER_NUMBER,CUSTOMER_NAME,TICKET_NUMBER FROM MKT_ORDER_CON_CUS where ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND  CUSTOMER_TYPE_NUM = '10' AND DEL_FLAG='0')T13 ON T13.TICKET_NUMBER = T6.ID 
LEFT JOIN (SELECT * FROM MKT_CUSTOMER where  SALE_ORG_ID IN ( '${SALE_ORG_ID}')    ) T16 ON T16.ID = T12.CUSTOMER_NUMBER 
LEFT JOIN (SELECT * FROM MKT_CUSTOMER where  SALE_ORG_ID IN ( '${SALE_ORG_ID}')    ) T17 ON T17.ID = T13.CUSTOMER_NUMBER 
LEFT JOIN (SELECT NAME,USER_KEY,SALE_ORG_ID,CHANNEL_ID,CHANNEL_NAME FROM MKT_SALE_CONSULTANT where  SALE_ORG_ID IN ( '${SALE_ORG_ID}')   ) T18 ON T18.USER_KEY = T2.FOLLOW_PROPERTY_CONSULTANT AND T18.SALE_ORG_ID = T2.SALE_ORG_ID  
LEFT JOIN (SELECT NAME,USER_KEY,SALE_ORG_ID,CHANNEL_NAME FROM MKT_SALE_CONSULTANT where  SALE_ORG_ID IN ( '${SALE_ORG_ID}')   ) T19 ON T19.USER_KEY = T2.TOGETHER_FOLLOW_CONSULTANT AND T19.SALE_ORG_ID = T2.SALE_ORG_ID  
LEFT JOIN (SELECT DISTINCT project_name,period_id,period_name,IS_SHOW_PERIOD FROM cux_cst_mkt_proj_v) T20 ON T20.period_id = T1.period_id 
LEFT JOIN (SELECT HOUSE_ID,MAX(CREATE_DATE) AS CREATE_DATE FROM MKT_CONTRACT_FILING WHERE DEL_FLAG = '0' GROUP BY HOUSE_ID) t32 ON T32.HOUSE_ID = T1.ID
LEFT JOIN MKT_CONTRACT_FILING T21 on T21.HOUSE_ID = t32.HOUSE_ID AND T21.CREATE_DATE = t32.CREATE_DATE AND T21.del_flag = '0' 
LEFT JOIN (SELECT HOUSE_ID,MAX(CREATE_DATE) as CREATE_DATE FROM MKT_REGISTRATION_TITLEHOOD WHERE DEL_FLAG = 0 GROUP BY HOUSE_ID) t34 ON t34.HOUSE_ID = T1.ID
LEFT JOIN MKT_REGISTRATION_TITLEHOOD T22 on T22.HOUSE_ID = T34.HOUSE_ID AND T22.CREATE_DATE = t34.CREATE_DATE  AND T22.del_flag = '0' 
LEFT JOIN MKT_CONTRACT_AREA_SENDER T23 on T23.SYSTEM_CONTRACT_ID = T6.CONTRACT_ID AND T23.del_flag = '0'  
LEFT JOIN (SELECT DISTINCT ID,CHARGE_SUM,RELATE_RAISE_ID,BUSINESS_TYPE_ID,PAYMENT_TYPE_ID FROM MKT_COLLECTION_PLAN WHERE  SALE_ORG_ID IN ( '${SALE_ORG_ID}')    and del_flag = 0 and check_State_Num='20') T25 ON T25.RELATE_RAISE_ID = T6.ID AND T25.BUSINESS_TYPE_ID = '1054003' 
LEFT JOIN MKT_DICT T26 on T26.ID = T2.ORDER_TYPE_ID AND T1.SALE_ORG_ID = T26.SALE_ORG_ID AND T1.PROJECT_ID = T26.PROJECT_ID 
LEFT JOIN (SELECT DISTINCT ID,COMPOSITION FROM MKT_HOUSE_TYPE where del_flag=0 )T27 ON T27.ID =T1.HOUSE_TYPE_ID 
LEFT JOIN(SELECT ORDER_NUMBER,MAX(CREATE_DATE) AS CREATE_DATE FROM MKT_ORDER_TAKE_DOWN WHERE ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND DEL_FLAG=0 GROUP BY ORDER_NUMBER) T30 ON T30.ORDER_NUMBER = T2.ID 
LEFT JOIN (SELECT DISTINCT ID,ORDER_NUMBER,WORKFLOW_STATUS,CREATE_DATE FROM MKT_ORDER_TAKE_DOWN WHERE ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND DEL_FLAG=0) T28 ON T28.ORDER_NUMBER = T2.ID AND T28.CREATE_DATE=T30.CREATE_DATE 
LEFT JOIN(SELECT CONTRACT_ID,MAX(CREATE_DATE) AS CREATE_DATE FROM MKT_CONTRACT_REFUND WHERE ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND DEL_FLAG=0 GROUP BY CONTRACT_ID) T31 ON T31.CONTRACT_ID = T6.ID 
LEFT JOIN (SELECT DISTINCT ID,CONTRACT_ID,WORKFLOW_STATUS,CREATE_DATE FROM MKT_CONTRACT_REFUND WHERE ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND DEL_FLAG=0) T29 ON T29.CONTRACT_ID = T6.ID AND T29.CREATE_DATE=T31.CREATE_DATE 
LEFT JOIN (SELECT HOUSE_ID,MAX(CREATE_DATE) AS CREATE_DATE FROM MKT_HOUSE_SALES_PROCESS_INFO WHERE ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND DEL_FLAG = '0' AND FOLLOW_UP_NODE = '02' GROUP BY HOUSE_ID) T35 ON T35.HOUSE_ID = T1.ID 
LEFT JOIN (SELECT ID,HOUSE_ID,FOLLOW_UP_NODE,TEMP_DATE_COMPLETION,CREATE_DATE FROM MKT_HOUSE_SALES_PROCESS_INFO WHERE ( SALE_ORG_ID IN ( '${SALE_ORG_ID}')  ) AND DEL_FLAG = '0' AND FOLLOW_UP_NODE = '02') T36 ON T35.HOUSE_ID = T36.HOUSE_ID AND T35.CREATE_DATE=T36.CREATE_DATE 
LEFT JOIN (SELECT aa.ROOM_CODE, bb.NAME FROM MKT_HOUSE_RESERVE aa, MKT_DICT bb WHERE aa.RESERVE_REASON=bb.ID AND aa.SALE_ORG_ID=bb.SALE_ORG_ID AND aa.PROJECT_ID=bb.PROJECT_ID AND aa.DEL_FLAG=0) T37 ON T37.ROOM_CODE=t1.ID AND t1.SALE_STATE='2' 
LEFT JOIN (SELECT DISTINCT PROJECT_ID,CITY_ID,CITY_NAME,AREA_ID,AREA_NAME FROM MKT_PRO_CITY_AREA_RELATION) T38 ON T38.PROJECT_ID=T1.PROJECT_ID
LEFT JOIN MKT_CUSTOMER_CERT T39 ON T39.CUSTOMER_ID=T2.CUSTOMER_NUMBER
left join (select distinct HOUSE_NUMBER from MKT_RECEIPTS where 1=1
${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), receipt_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), receipt_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'","and CONVERT(varchar(10), receipt_date, 23) between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)} 
)t100  on t1.id = t100.house_number
/*
left join (
SELECT tt1.HOUSE_NUMBER,tt1.[财务回款]A as fin_receipt_sum ,tt2.[营销回款]A as mkt_receipt_sum FROM (
SELECT t1.HOUSE_NUMBER,t1.receiptMoney-ISNULL(t2.refundMoney, 0)-ISNULL(t3.penaltyDue, 0) AS '财务回款' FROM 
(SELECT SUM(RECEIPT_SUM) AS receiptMoney,HOUSE_NUMBER FROM MKT_RECEIPTS WHERE PAYMENT_TYPE_ID='1053001' and STATUS='COMPLETED' AND PAYMENT_NAME_ID!='1092013'  AND DEL_FLAG='0' AND SALE_ORG_ID IN  ('${SALE_ORG_ID}') ${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), receipt_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), receipt_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'","and receipt_date between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)}  GROUP BY HOUSE_NUMBER) t1
LEFT JOIN (SELECT SUM(RECEIPT_SUM) AS refundMoney,HOUSE_NUMBER FROM MKT_RECEIPTS WHERE PAYMENT_TYPE_ID='1053002' and STATUS='COMPLETED' AND PAYMENT_NAME_ID!='1092013'  AND DEL_FLAG='0' AND SALE_ORG_ID IN  ('${SALE_ORG_ID}') ${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), receipt_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), receipt_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'","and receipt_date between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)}  GROUP BY HOUSE_NUMBER) t2 
ON t2.HOUSE_NUMBER=t1.HOUSE_NUMBER
LEFT JOIN (SELECT ROOM_ID,sum(CUSTOMER_PENALTY_DUE) AS penaltyDue FROM MKT_PENALTY WHERE CUSTOMER_PENALTY_DUE is not NULL AND SALE_ORG_ID IN  ('${SALE_ORG_ID}') ${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), handle_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), handle_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'","and handle_date between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)}  GROUP BY ROOM_ID) t3 on t3.ROOM_ID=t1.HOUSE_NUMBER
) tt1
LEFT JOIN
(
SELECT t1.HOUSE_NUMBER,t1.receiptMoney-ISNULL(t2.refundMoney, 0)-ISNULL(t3.penaltyDue, 0) AS '营销回款' FROM 
(SELECT SUM(CHARGE_SUM) AS receiptMoney,HOUSE_NUMBER FROM MKT_COLLECTION_PLAN WHERE DEL_FLAG = 0 AND CHECK_STATE_NUM = '20' AND HOUSE_NUMBER is not NULL AND PAYMENT_NAME_ID != '1092013' AND PAYMENT_TYPE_ID='1053001' AND SALE_ORG_ID IN  ('${SALE_ORG_ID}')  GROUP BY HOUSE_NUMBER) t1
LEFT JOIN (SELECT SUM(CHARGE_SUM) AS refundMoney,HOUSE_NUMBER FROM MKT_COLLECTION_PLAN WHERE DEL_FLAG = 0 AND CHECK_STATE_NUM = '20' AND HOUSE_NUMBER is not NULL AND PAYMENT_NAME_ID != '1092013' AND PAYMENT_TYPE_ID='1053002' AND SALE_ORG_ID IN  ('${SALE_ORG_ID}')  GROUP BY HOUSE_NUMBER) t2 
ON t2.HOUSE_NUMBER=t1.HOUSE_NUMBER
LEFT JOIN (SELECT ROOM_ID,sum(CUSTOMER_PENALTY_DUE) AS penaltyDue FROM MKT_PENALTY WHERE  CUSTOMER_PENALTY_DUE is not NULL  AND SALE_ORG_ID IN  ('${SALE_ORG_ID}') ${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), handle_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), handle_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'","and handle_date between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)} GROUP BY ROOM_ID) t3 on t3.ROOM_ID=t1.HOUSE_NUMBER
) tt2 on tt2.HOUSE_NUMBER=tt1.HOUSE_NUMBER
)  t100 
on t1.id = t100.house_number
*/

WHERE  T1.DEL_FLAG = '0'  
${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"","AND T100.house_number IS NOT NULL")}
AND T1.SALE_ORG_ID IN  ('${SALE_ORG_ID}')
${if(len(BUILDING_ID)==0,""," AND T1.BUILDING_ID IN ("+"'"+treelayer(BUILDING_ID,true,"\',\'")+"'"+")")}
${if(len(SALE_STATE)=0,""," AND T1.SALE_STATE in ( '"+SALE_STATE+"')")}
${if(len(HOUSENAME)=0,""," AND T1.SALE_FLOOR_ROOM_NAME ='"+HOUSENAME+"'")}
${if(len(ISSIGN)=0,"","AND T2.ID is not null AND T2.SIGN_ORDER_AGREEMENT ='"+ISSIGN+"'")}
${if(len(PRODUCT_ID)=0,"","AND T11.PRODUCT_ID in ('"+PRODUCT_ID+"')")}
${IF(LEN(contract_state)=0,"","AND t6.CONTRACT_STATE in ('"+contract_state+"')")}


${if(len(CUSTOMERNAME)=0,"","AND ((T2.ID is not null AND T12.CUSTOMER_NAME LIKE '%"+CUSTOMERNAME+"%') or (T6.ID is not null AND T13.CUSTOMER_NAME LIKE '%"+CUSTOMERNAME+"%'))")}
${IF(LEN(sign_sdate)=0&&LEN(sign_edate)=0,"", 
if(LEN(sign_sdate)=0&&LEN(sign_edate)<>0,"AND T2.ID is not null and CONVERT(varchar(10), T2.SIGNING_DATE, 23) between '1900-01-01' and '"+sign_edate+"'",
if(LEN(sign_sdate)<>0&&LEN(sign_edate)=0,"AND T2.ID is not null and CONVERT(varchar(10), T2.SIGNING_DATE, 23) between '"+sign_sdate+"' and '2099-12-31'","AND T2.ID is not null and CONVERT(varchar(10), T2.SIGNING_DATE, 23) between '"+sign_sdate+"' and '"+sign_edate+"'"))
)}
 ${IF(LEN(contract_sdate)=0&&LEN(contract_edate)=0,"", 
if(LEN(contract_sdate)=0&&LEN(contract_edate)<>0,"and  CONVERT(varchar(10), T6.CONTRACT_DATE, 23) between '1900-01-01' and '"+contract_edate+"'",
if(LEN(contract_sdate)<>0&&LEN(contract_edate)=0,"and CONVERT(varchar(10), T6.CONTRACT_DATE, 23) between '"+contract_sdate+"' and '2099-12-31'","and CONVERT(varchar(10), T6.CONTRACT_DATE, 23) between '"+contract_sdate+"' and '"+contract_edate+"'"))
)}

 
 ${IF(LEN(achieve_sdate)=0&&LEN(achieve_edate)=0,"",
if(LEN(achieve_sdate)=0&&LEN(achieve_edate)<>0,"AND T2.ID is not null and CONVERT(varchar(10), T2.ACHIEVE_COUNT_DATE, 23)  between '1900-01-01' and '"+achieve_edate+"'",
if(LEN(achieve_sdate)<>0&&LEN(achieve_edate)=0,"AND T2.ID is not null and CONVERT(varchar(10), T2.ACHIEVE_COUNT_DATE, 23)  between '"+achieve_sdate+"' and '2099-12-31'","AND T2.ID is not null and CONVERT(varchar(10), T2.ACHIEVE_COUNT_DATE, 23) between '"+achieve_sdate+"' and '"+achieve_edate+"'"))
)}


 ${IF(LEN(netsign_sdate)=0&&LEN(netsign_edate)=0,"",
if(LEN(netsign_sdate)=0&&LEN(netsign_edate)<>0,"AND T2.ID is not null and CONVERT(varchar(10), T2.AS_NETSIGN_DATE, 23) between '1900-01-01' and '"+netsign_edate+"'",
if(LEN(netsign_sdate)<>0&&LEN(netsign_edate)=0,"AND T2.ID is not null and CONVERT(varchar(10), T2.AS_NETSIGN_DATE, 23) between '"+netsign_sdate+"' and '2099-12-31'","AND T2.ID is not null and CONVERT(varchar(10), T2.AS_NETSIGN_DATE, 23) between '"+netsign_sdate+"' and '"+netsign_edate+"'"))
)}



${if(is_fullreceipt=0,"AND isnull(T6.CONTRACT_TOTAL_PRICE,0.001) > isnull(fin_receipt_sum,0) ",if(is_fullreceipt=1,"and isnull(T6.CONTRACT_TOTAL_PRICE,0) <= fin_receipt_sum and fin_receipt_sum <>0",""))}

${if(len(hand_status)=0,"","AND case when sales_date IS NOT NULL and sales_date <> '' then '01'
when sales_date IS  NULL  and  as_handover_date is not null and  as_handover_date <> '' then '02' else '03' end in ('"+hand_status+"')")}

ORDER BY 
T38.CITY_NAME,--城市
T20.PROJECT_NAME , --项目名称
T20.PERIOD_NAME, --分期
T1.BUILDING_NAME, --楼栋
CASE WHEN T11.is_show_unit = '0' THEN '-' ELSE T1.UNIT END, 
len(T1.SALE_FLOOR_ROOM_NAME),
T1.SALE_FLOOR_ROOM_NAME, --房源名称
T11.PRODUCT_NAME, --业态
T1.DECORATE_ID, --装修类型
T2.CUSTOMER_NAME

SELECT DISTINCT PERIOD_ID,PERIOD_NAME,ID,NAME 
FROM MKT_BUILDING 
WHERE SALE_ORG_ID IN ('${SALE_ORG_ID}')
AND DEL_FLAG=0
ORDER BY PERIOD_ID,NAME

SELECT 
	DISTINCT  
	T1.PRODUCT_ID,
	T1.PRODUCT_NAME
FROM  cux_cst_mkt_proj_v T1
WHERE SALE_ORG_ID IN ('${SALE_ORG_ID}')
ORDER BY T1.PRODUCT_ID

SELECT DISTINCT
  AREA_ID,
	CITY_ID,
	CITY_NAME
FROM
	MKT_PRO_CITY_AREA_RELATION a 
	left join  cux_cst_mkt_proj_v b  on a.PROJECT_ID=b.PROJECT_ID

where 1=1
${if(finename = 'huafa',"","and sale_org_id in ('"+sale_org+"')")}

ORDER BY AREA_ID,
	CITY_ID

SELECT tt1.HOUSE_NUMBER,tt1.[财务回款]A as fin_receipt_sum ,tt2.[营销回款]A as mkt_receipt_sum FROM (
SELECT t1.HOUSE_NUMBER,t1.receiptMoney-ISNULL(t2.refundMoney, 0)-ISNULL(t3.penaltyDue, 0) AS '财务回款' FROM 
(SELECT SUM(RECEIPT_SUM) AS receiptMoney,HOUSE_NUMBER 
FROM MKT_RECEIPTS 
WHERE (PAYMENT_TYPE_ID='1053001' and STATUS='COMPLETED' AND PAYMENT_NAME_ID!='1092013' AND BUSINESS_TYPE_ID!='1054004' or (business_type_id =1054004 and payment_name in ('定金','认筹转认购'))) AND DEL_FLAG='0' AND SALE_ORG_ID IN  ('${SALE_ORG_ID}') ${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), receipt_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), receipt_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'","and CONVERT(varchar(10), receipt_date, 23) between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)}  GROUP BY HOUSE_NUMBER) t1
LEFT JOIN (SELECT SUM(RECEIPT_SUM) AS refundMoney,HOUSE_NUMBER 
FROM MKT_RECEIPTS 
WHERE (PAYMENT_TYPE_ID='1053002' and STATUS='COMPLETED' AND PAYMENT_NAME_ID!='1092013' AND BUSINESS_TYPE_ID!='1054004' or (business_type_id =1054004 and payment_name in ('定金','认筹转认购'))) AND DEL_FLAG='0' AND SALE_ORG_ID IN  ('${SALE_ORG_ID}') ${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), receipt_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), receipt_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'","and CONVERT(varchar(10), receipt_date, 23) between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)}  GROUP BY HOUSE_NUMBER) t2 
ON t2.HOUSE_NUMBER=t1.HOUSE_NUMBER
LEFT JOIN (SELECT ROOM_ID,sum(CUSTOMER_PENALTY_DUE) AS penaltyDue FROM MKT_PENALTY WHERE CUSTOMER_PENALTY_DUE is not NULL AND SALE_ORG_ID IN  ('${SALE_ORG_ID}') ${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), handle_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), handle_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'"," and CONVERT(varchar(10), handle_date, 23)  between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)}  GROUP BY ROOM_ID) t3 on t3.ROOM_ID=t1.HOUSE_NUMBER
) tt1
LEFT JOIN
(
SELECT t1.HOUSE_NUMBER,t1.receiptMoney-ISNULL(t2.refundMoney, 0)-ISNULL(t3.penaltyDue, 0) AS '营销回款' FROM 
(SELECT SUM(CHARGE_SUM) AS receiptMoney,HOUSE_NUMBER FROM MKT_COLLECTION_PLAN WHERE DEL_FLAG = 0 AND CHECK_STATE_NUM = '20' AND HOUSE_NUMBER is not NULL AND PAYMENT_NAME_ID != '1092013' AND PAYMENT_TYPE_ID='1053001' AND SALE_ORG_ID IN  ('${SALE_ORG_ID}')  GROUP BY HOUSE_NUMBER) t1
LEFT JOIN (SELECT SUM(CHARGE_SUM) AS refundMoney,HOUSE_NUMBER FROM MKT_COLLECTION_PLAN WHERE DEL_FLAG = 0 AND CHECK_STATE_NUM = '20' AND HOUSE_NUMBER is not NULL AND PAYMENT_NAME_ID != '1092013' AND PAYMENT_TYPE_ID='1053002' AND SALE_ORG_ID IN  ('${SALE_ORG_ID}')  GROUP BY HOUSE_NUMBER) t2 
ON t2.HOUSE_NUMBER=t1.HOUSE_NUMBER
LEFT JOIN (SELECT ROOM_ID,sum(CUSTOMER_PENALTY_DUE) AS penaltyDue FROM MKT_PENALTY WHERE  CUSTOMER_PENALTY_DUE is not NULL  AND SALE_ORG_ID IN  ('${SALE_ORG_ID}') ${IF(LEN(receipt_sdate)=0&&LEN(receipt_edate)=0,"",
if(LEN(receipt_sdate)=0&&LEN(receipt_edate)<>0,"and CONVERT(varchar(10), handle_date, 23)  between '1900-01-01' and '"+receipt_edate+"'",
if(LEN(receipt_sdate)<>0&&LEN(receipt_edate)=0,"and CONVERT(varchar(10), handle_date, 23)  between '"+receipt_sdate+"' and '2099-12-31'","and CONVERT(varchar(10), handle_date, 23) between '"+receipt_sdate+"' and '"+receipt_edate+"'"))
)} GROUP BY ROOM_ID) t3 on t3.ROOM_ID=t1.HOUSE_NUMBER
) tt2 on tt2.HOUSE_NUMBER=tt1.HOUSE_NUMBER

select '1057003' id, '毛坯加精装' name
from mkt_dict 
union
select '1057002' id, '毛坯' name
from mkt_dict 
union
select '1057001' id, '精装修' name
from mkt_dict 


select 
distinct sale_org_id,id,name

from mkt_dict 
where dict_type_id = '1096'

select '50' id, '未审核' name
from mkt_dict 
union
select '10' id, '已审核' name
from mkt_dict 
union
select '20' id, '已转' name
from mkt_dict 
union
select '30' id, '已退' name
from mkt_dict 
union
select '40' id, '作废' name
from mkt_dict 
union
select '60' id, '退定中' name
from mkt_dict 
union
select '70' id, '换房中' name
from mkt_dict 
union
select '80' id, '更名中' name
from mkt_dict 
union
select '90' id, '已换' name
from mkt_dict 




select '10' id, '草签' name
union
select '20' id, '正式网签' name
-- union
-- select '30' id, '已退' name
-- union
-- select '40' id, '作废' name
union
select '50' id, '未审核' name



select '50' id, '通知客户' name
from mkt_dict 
union
select '10' id, '已打进账单' name
from mkt_dict 
union
select '20' id, '已出进账单' name
from mkt_dict 
union
select '30' id, '已送办理预告证' name
from mkt_dict 
union
select '40' id, '预告证已办好' name
from mkt_dict 
union
select '60' id, '通知银行' name
from mkt_dict 
union
select '70' id, '移交客户' name
from mkt_dict 
union
select '80' id, '移交银行' name
from mkt_dict 
union
select '90' id, '合同备案已办好' name
from mkt_dict 



select '50' id, '通知客户取资料' name
from mkt_dict 
union
select '10' id, '已收契税（客户已预缴契税）' name
from mkt_dict 
union
select '20' id, '已核契税（客户已交契税）' name
from mkt_dict 
union
select '30' id, '已送办房产证' name
from mkt_dict 
union
select '40' id, '房产证已办好' name
from mkt_dict 
union
select '60' id, '通知银行取资料' name
from mkt_dict 
union
select '70' id, '移交银行办证材料' name
from mkt_dict 
union
select '80' id, '移交客户办证材料' name
from mkt_dict 
union
select '90' id, '房产证已移交客户' name
from mkt_dict 
union
select '100' id, '房产证已移交银行' name
from mkt_dict 
union
select '110' id, '通知客户取房产证' name
from mkt_dict 
union
select '120' id, '通知银行取房产证' name
from mkt_dict 
union
select '130' id, '已收履约保证金' name
from mkt_dict 
union
select '150' id, '移交客户缴税资料' name
from mkt_dict 






select '10' id, '待提交' name
from mkt_dict 
union
select '20' id, '审批中' name
from mkt_dict 
union
select '30' id, '退回修改' name
from mkt_dict 
union
select '40' id, '审批不通过' name
from mkt_dict 
union
select '50' id, '审批通过' name
from mkt_dict 
union
select '' id, '' name
from mkt_dict 
union
select '0' id, '' name
from mkt_dict 



select 
ticket_number,customer_name,document_number,CHANNEL_NAME
from
MKT_ORDER_CON_CUS
WHERE SALE_ORG_ID IN  ('${SALE_ORG_ID}')
AND CUSTOMER_TYPE_NUM IN ('10','20')
ORDER BY ticket_number,CUSTOMER_TYPE_NUM 

select 
case when visit_channel = '1040001' then  '业主推荐' 
     when visit_channel = '1040038' then  '拓客团队推荐' 
     when visit_channel = '1040002' then  '自然到访' 
     when visit_channel = '1040027' then  '独立经纪人推荐' 
     when visit_channel = '1040026' then  '员工推荐' 
     when visit_channel = '1040003' then  '机构推荐' else '' end 
VISIT_CHANNEL_NAME,
id,
room_code
from mkt_order 


select '01' id ,  '已实际交楼' name 
union all 
select '02' id ,  '已视同交楼' name 
union all 
select '03' id ,  '未交楼' name 

SELECT distinct t2.ticket_number, t1.channel_name
FROM
(SELECT ID,NAME,TELPHONE,AGENT_NAME,CHANNEL_NAME FROM MKT_CUSTOMER )T1
LEFT JOIN (SELECT * FROM MKT_ORDER_CON_CUS WHERE  (CUSTOMER_TYPE_NUM = '10' OR CUSTOMER_TYPE_NUM = '20') AND DEL_FLAG = '0') T2 ON T2.CUSTOMER_NUMBER = T1.ID
LEFT JOIN MKT_CUSTOMER_CERT T3 ON T3.CUSTOMER_ID = T1.ID
WHERE T2.ticket_number in (select distinct ticket_number from MKT_ORDER_CON_CUS 
where 1=1 
${if(len(CUSTOMERNAME)=0,"","and customer_name = '"+CUSTOMERNAME+"'")})
and t1.channel_name is not null

select 
SALES_DATE,as_handover_date,contract_id
from(
select SALES_DATE,
as_handover_date,
contract_id, 
row_number() over (partition by contract_id order by create_date) row
from MKT_TRANFER_HOUSE_RECORDS 
where del_flag='0' 
)a
where row = 1


