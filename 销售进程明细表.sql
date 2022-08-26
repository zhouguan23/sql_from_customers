SELECT distinct
	t1.id,
	t4.product_name,
	t1.HOUSE_ID,
	t3.project_name, -- 项目名称
CASE
		t3.IS_SHOW_PERIOD 
		WHEN '1' THEN
		t3.period_name ELSE '' 
	END AS period_name, -- 分期	
CASE
		t4.IS_SHOW_UNIT 
		WHEN '1' THEN
		t4.NAME + t2.UNIT + t2.SALE_FLOOR_ROOM_NAME ELSE t4.NAME + t2.SALE_FLOOR_ROOM_NAME 
	END AS house_resource_name, -- 房源
  t9.CUSTOMER_NAME, -- 客户名称
CASE 
 WHEN t1.FOLLOW_UP_NODE ='01' THEN '认购'
 WHEN t1.FOLLOW_UP_NODE ='02' THEN '签约'
 WHEN t1.FOLLOW_UP_NODE ='03' THEN '按揭资料办理'
 WHEN t1.FOLLOW_UP_NODE ='04' THEN '预告证备案'
 WHEN t1.FOLLOW_UP_NODE ='05' THEN '办理入住'
 WHEN t1.FOLLOW_UP_NODE ='06' THEN '面积补差'
 WHEN t1.FOLLOW_UP_NODE ='07' THEN '权属登记'
 WHEN t1.FOLLOW_UP_NODE ='08' AND t1.FOLLOW_TYPE = '01' THEN '产权办理通知'
 WHEN t1.FOLLOW_UP_NODE ='09' AND t1.FOLLOW_TYPE = '01' THEN '产权转移登记'
 ELSE t19.NAME
END FOLLOW_UP_NODE, -- 逾期节点
	case when t1.FOLLOW_TYPE = '01' then '事项' else '款项' end FOLLOW_TYPE, -- 逾期类型 
	 CONVERT(VARCHAR(10),SIGNING_DATE,120) SIGNING_DATE, -- 认购日期
	t1.TEMP_DATE_COMPLETION,  -- 应完成日期
  t1.TEMP_ACTUAL_DATE_COMPLETION,  -- 实际完成日期
  t1.TEMP_OVERDUE,           -- 逾期天数
  case when t16.DATE_COMPLETION is not null and t16.DATE_COMPLETION <>'' then '是' else '否' end isapplydelay,   --  是否申请过延期
  t16.DATE_COMPLETION as delayDateComplete,        -- 申请前应完成日期
  t1.TEMP_PLAN_COLLECTION_SUM,   -- 应收金额
  t1.TEMP_CHARGE_SUM, -- 实收金额
  t1.TEMP_ALL_ACTUAL_PAYMENT_MONEY,  -- 累计实收违约金
	t1.TEMP_ALL_REDUCTION_MONEY,  -- 累计减免违约金
  t24.NAME  AS ORDER_PAYMENT_NUMBER,   -- 认购付款方式类型  转义 问荣杰
 CASE t10.PAY_TYPE
 WHEN t24.ID THEN t24.NAME
 ELSE t10.PAY_TYPE
END  AS CONTRACT_PAYMENT_NUMBER,   -- 签约付款方式类型   转义 问荣杰
  t12.NAME AS MORTGAGE_BANK, -- 按揭银行
  t2.SALE_STATE,  -- 房源状态
  '',          -- 合同备案进度   contractFilingName   ContractFiling表通过HOUSE_ID
  '',                    -- 权属登记进度  registraStateName  registration_titlehood  houseId
  t7.NAME AS consultant_name, -- 置业顾问 
  '',                     -- 跟进时间   cutomer_follow     follow node id    id  取第一个follow_date 
  '',                     -- 跟进方式    cutomer_follow     follow node id    id  取第一个FOLLOW_TYPE_name
  '' ,                    -- 预计履约时间   cutomer_follow     follow node id    id  取第一个predict_agreement_date 
  t17.name as delay_cause_name,  -- 逾期原因 
  case when t21.IS_RISK= 0 or t21.IS_RISK is null then '否' else '是' end as isrisk,    -- 是否有挞定或退房风险
  '' ,                      -- 备注  cutomer_follow     follow node id    id  取description 
	t1.TEMP_TOTAL_PRICE,     -- 成交总价
  t1.TEMP_CHARGE_SUM,  -- 回款金额	
	t22.city_name,   -- 城市名称  city_name

	t5.prepared_Signing_Date AS preparedSigningDate,
	t5.ORDER_STATUS,
	t2.ID AS house_id,
	t10.ID AS contract_id,
	t10.CONTRACT_DATE,
	case when t1.TEMP_ACTUAL_DATE_COMPLETION is not null and t1.TEMP_ACTUAL_DATE_COMPLETION<>'' then '是' else '否' end,
  t5.ID AS order_id

FROM
	( SELECT * FROM MKT_HOUSE_SALES_PROCESS_INFO WHERE DEL_FLAG = 0 AND  SALE_ORG_ID  in  ('${SALE_ORG_ID}')  ) t1
	LEFT JOIN MKT_HOUSE_RESOURCE t2 ON t1.HOUSE_ID = t2.ID
	LEFT JOIN  MKT_BUILDING t4 ON t2.BUILDING_ID = t4.ID
	LEFT JOIN ( SELECT DISTINCT project_id, org_id, project_name, period_id, period_name, IS_SHOW_PERIOD FROM cux_cst_mkt_proj_v ) t3 ON t3.project_id = t1.project_Id 
	AND t3.org_id = t1.ORG_ID 
	AND t3.period_id = t4.PERIOD_ID
	LEFT JOIN MKT_ORDER t5 ON t5.ROOM_CODE = t2.ID 
	AND t5.ORDER_STATUS IN ( '10', '20', '50' ) 
	AND t5.DEL_FLAG = 0
	LEFT JOIN MKT_SALE_CONSULTANT t7 ON t7.USER_KEY = t5.FOLLOW_PROPERTY_CONSULTANT 
	AND t7.PROJECT_ID = t5.PROJECT_ID 
	AND t7.ORG_ID = t5.ORG_ID 
	AND t7.SALE_ORG_ID = t5.SALE_ORG_ID
	LEFT JOIN MKT_ORDER_CON_CUS t9 ON t9.TICKET_NUMBER = t5.ID 
	AND CUSTOMER_TYPE_NUM = '10' 
	AND t9.DEL_FLAG = 0
	LEFT JOIN MKT_CONTRACT t10 ON t10.ORDER_NUMBER = t5.ID 
	AND t10.CONTRACT_STATE IN ( '10', '20', '50' ) 
	AND t10.DEL_FLAG = 0
	LEFT JOIN MKT_MORTGAGE t11 ON t11.HOUSE_ID = t2.ID 
	AND t11.DEL_FLAG = 0 
	AND t11.STATE IN ( '10', '20' )
	LEFT JOIN MKT_DICT t12 ON t12.PROJECT_ID = t1.PROJECT_ID 
	AND t12.ORG_ID = t1.ORG_ID 
	AND t12.SALE_ORG_ID = t1.SALE_ORG_ID 
	AND t12.ID = t11.MORTGAGE_BANK
	LEFT JOIN (
	SELECT
		OVERDUE_NODE AS overdueNode,
		HOUSE_ID AS houseId,
		MAX ( CREATE_DATE ) AS CREATE_DATE1 
	FROM
		MKT_DELAY_REQUEST 
	WHERE
		DEL_FLAG = 0 
	GROUP BY
		HOUSE_ID,
		OVERDUE_NODE 
	) t18 ON t18.overdueNode = t1.FOLLOW_UP_NODE 
	AND t18.houseId = T1.HOUSE_ID
	LEFT JOIN MKT_DELAY_REQUEST t16 ON t16.OVERDUE_NODE = t18.overdueNode 
	AND T16.HOUSE_ID = T18.houseId 
	AND T16.CREATE_DATE = T18.CREATE_DATE1
	LEFT JOIN MKT_DELAY_REQUEST_CAUSE t17 ON t17.CODE = t1.delay_cause_code 
	AND t17.del_flag = 0
	LEFT JOIN MKT_CONFIG_PAYMETHOD_DET T19 ON T1.FOLLOW_UP_NODE = T19.ID
	LEFT JOIN MKT_DICT_PAYMENT_OTHER_NAME t20 ON t19.MONEY_NAME_ID = t20.ID 
	AND t19.SALE_ORG_ID = t20.SALE_ORG_ID
	LEFT JOIN (
	SELECT
		C.ROOM_CODE,
		C.IS_RISK 
	FROM
		MKT_ORDER C,
		(
		SELECT
			A.ROOM_CODE,
			MAX ( A.CREATE_DATE ) CREATE_DATE 
		FROM
			MKT_ORDER A
			LEFT JOIN MKT_CONTRACT B ON A.ID= B.ORDER_NUMBER 
		WHERE
			A.DEL_FLAG= 0 
			AND (
				A.ORDER_STATUS NOT IN ( '20', '30', '40', '90' ) 
			OR ( A.ORDER_STATUS= '20' AND B.CONTRACT_STATE<> '30' )) 
		GROUP BY
			A.ROOM_CODE 
		) D 
	WHERE
		C.ROOM_CODE= D.ROOM_CODE 
		AND C.CREATE_DATE= D.CREATE_DATE 
	) t21 ON t1.HOUSE_ID= t21.ROOM_CODE
	LEFT JOIN MKT_PRO_CITY_AREA_RELATION t22 ON t1.PROJECT_ID = t22.PROJECT_ID 
LEFT JOIN MKT_CONFIG_PAYMENT_METHOD t24 ON t5.PAYMENT_NUMBER = t24.ID

WHERE
	1 = 1 
	
	${if(len(BUILD_ID)==0,""," AND T2.BUILDING_ID IN ("+"'"+treelayer(BUILD_ID,true,"\',\'")+"'"+")")}
  ${if(len(PRODUCT_ID)=0,"","AND t4.PRODUCT_ID IN ('"+PRODUCT_ID+"')")}
  ${if(len(CUSTOMERNAME)=0,""," and t9.CUSTOMER_NAME in ('"+CUSTOMERNAME+"')")}
  ${if(len(FOLLOW_TYPE)=0,"","and t1.FOLLOW_TYPE in ('"+FOLLOW_TYPE+"')")}
  ${if(len(DELAY_REASON)=0,""," and t17.code in ('"+DELAY_REASON+"')")}
  ${if(len(FOLLOW_UP_NODE)=0,"","and CASE 
 WHEN t1.FOLLOW_UP_NODE ='01' THEN '认购'
 WHEN t1.FOLLOW_UP_NODE ='02' THEN '签约'
 WHEN t1.FOLLOW_UP_NODE ='03' THEN '按揭资料办理'
 WHEN t1.FOLLOW_UP_NODE ='04' THEN '预告证备案'
 WHEN t1.FOLLOW_UP_NODE ='05' THEN '办理入住'
 WHEN t1.FOLLOW_UP_NODE ='06' THEN '面积补差'
 WHEN t1.FOLLOW_UP_NODE ='07' THEN '权属登记'
 WHEN t1.FOLLOW_UP_NODE ='08' AND t1.FOLLOW_TYPE = '01' THEN '产权办理通知'
 WHEN t1.FOLLOW_UP_NODE ='09' AND t1.FOLLOW_TYPE = '01' THEN '产权转移登记'
 ELSE t19.NAME
END in ('"+FOLLOW_UP_NODE+"')")}
${if(len(HOUSENAME)=0,""," AND T2.SALE_FLOOR_ROOM_NAME like'%"+HOUSENAME+"%'")}
  ${if(LEN(IS_COMP)=0,"",if(IS_COMP = '已完成',"and t1.TEMP_ACTUAL_DATE_COMPLETION is not null and t1.TEMP_ACTUAL_DATE_COMPLETION<>''","and (t1.TEMP_ACTUAL_DATE_COMPLETION is null or t1.TEMP_ACTUAL_DATE_COMPLETION='')" ))}


 ${IF(LEN(plan_start_date)=0&&LEN(plan_end_date)=0,"",
if(LEN(plan_start_date)=0&&LEN(plan_end_date)<>0,"AND T2.ID is not null and CONVERT(varchar(10), t1.TEMP_DATE_COMPLETION, 23)  between '1900-01-01' and '"+plan_end_date+"'",
if(LEN(plan_start_date)<>0&&LEN(plan_end_date)=0,"AND T2.ID is not null and CONVERT(varchar(10), t1.TEMP_DATE_COMPLETION, 23)  between '"+plan_start_date+"' and '2099-12-31'","AND T2.ID is not null and CONVERT(varchar(10),t1.TEMP_DATE_COMPLETION, 23) between '"+plan_start_date+"' and '"+plan_end_date+"'"))
)}

 ${IF(LEN(actual_start_date)=0&&LEN(actual_end_date)=0,"",
if(LEN(actual_start_date)=0&&LEN(actual_end_date)<>0,"AND T2.ID is not null and CONVERT(varchar(10),  t1.TEMP_ACTUAL_DATE_COMPLETION, 23)  between '1900-01-01' and '"+actual_end_date+"'",
if(LEN(actual_start_date)<>0&&LEN(actual_end_date)=0,"AND T2.ID is not null and CONVERT(varchar(10),  t1.TEMP_ACTUAL_DATE_COMPLETION, 23)  between '"+plan_start_date+"' and '2099-12-31'","AND T2.ID is not null and CONVERT(varchar(10),  t1.TEMP_ACTUAL_DATE_COMPLETION, 23) between '"+actual_start_date+"' and '"+actual_end_date+"'"))
)}
 ${IF(LEN(OVERDUE)=0,"",if(overdue = 1,"and (t1.TEMP_DATE_COMPLETION < t1.TEMP_ACTUAL_DATE_COMPLETION or (t1.TEMP_ACTUAL_DATE_COMPLETION is null and t1.TEMP_DATE_COMPLETION < getdate())) ",
"and (t1.TEMP_DATE_COMPLETION > t1.TEMP_ACTUAL_DATE_COMPLETION or (t1.TEMP_ACTUAL_DATE_COMPLETION is null and t1.TEMP_DATE_COMPLETION > getdate())) "))}

order by 
city_name,
t3.project_name, -- 项目名称
CASE
		t3.IS_SHOW_PERIOD 
		WHEN '1' THEN
		t3.period_name ELSE '' 
	END , -- 分期	
CASE 
 WHEN t1.FOLLOW_UP_NODE ='01' THEN '认购'
 WHEN t1.FOLLOW_UP_NODE ='02' THEN '签约'
 WHEN t1.FOLLOW_UP_NODE ='03' THEN '按揭资料办理'
 WHEN t1.FOLLOW_UP_NODE ='04' THEN '预告证备案'
 WHEN t1.FOLLOW_UP_NODE ='05' THEN '办理入住'
 WHEN t1.FOLLOW_UP_NODE ='06' THEN '面积补差'
 WHEN t1.FOLLOW_UP_NODE ='07' THEN '权属登记'
 WHEN t1.FOLLOW_UP_NODE ='08' AND t1.FOLLOW_TYPE = '01' THEN '产权办理通知'
 WHEN t1.FOLLOW_UP_NODE ='09' AND t1.FOLLOW_TYPE = '01' THEN '产权转移登记'
 ELSE t19.NAME
END, -- 逾期节点
	case when t1.FOLLOW_TYPE = '01' then '事项' else '款项' end


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
and sale_org_id in ('${sale_org}')
ORDER BY
	T2.CITY_ID, T1.PROJECT_ID,
	T1.SALE_ORG_ID 

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

select 
ticket_number,customer_name,document_number,CHANNEL_NAME
from
MKT_ORDER_CON_CUS
WHERE SALE_ORG_ID IN  ('${SALE_ORG_ID}')
AND CUSTOMER_TYPE_NUM IN ('10','20')
ORDER BY CUSTOMER_TYPE_NUM desc

select 0 as num, '初始' as state
union all
select 1 as num, '待售' as state
union all
select 2 as num, '销控' as state
union all
select 3 as num, '认购' as state
union all
select 4 as num, '签约' as state
union all
select 5 as num, '交房' as state




select  follow_node_id, convert(varchar(10),min(CREAT_DATE),120) CREAT_DATE
 from  mkt_customer_follow
 group by follow_node_id

 


select  follow_node_id, FOLLOW_TYPE_NAME
 from  mkt_customer_follow


 

select follow_node_id,
predict_agreement_date 
from  mkt_customer_follow



select follow_node_id,description 
from(
select 
follow_node_id,
description,
row_number() over (partition by follow_node_id order by creat_date) as num
from  mkt_customer_follow
where follow_node_id is not null
)a
where num = 1

select 
CASE WHEN contract_Filing = '10' THEN '已打进账单'
WHEN contract_Filing = '20' THEN '已出进账单'
WHEN contract_Filing = '30' THEN '已送办理预告证'
WHEN contract_Filing = '40' THEN '预告证已办好'
WHEN contract_Filing = '50' THEN '通知客户'
WHEN contract_Filing = '60' THEN '通知银行'
WHEN contract_Filing = '70' THEN '移交客户'
WHEN contract_Filing = '80' THEN '移交银行'
WHEN contract_Filing = '90' THEN '合同备案已办好'
ELSE NULL END contract_Filing,
HOUSE_ID
from
mkt_Contract_Filing

select house_Id, 
CASE WHEN registra_State = '10' THEN '已收契税'
WHEN registra_State = '20' THEN '已核契税'
WHEN registra_State = '30' THEN '已送办房产证'
WHEN registra_State = '40' THEN '房产证已办好'
WHEN registra_State = '50' THEN '通知客户取资料'
WHEN registra_State = '60' THEN '通知银行取资料'
WHEN registra_State = '70' THEN '移交银行办证资料'
WHEN registra_State = '80' THEN '移交客户办证资料'
WHEN registra_State = '90' THEN '房产证已移交客户'
WHEN registra_State = '100' THEN '房产证已移交银行'
WHEN registra_State = '110' THEN '通知客户取房产证'
WHEN registra_State = '120' THEN '通知银行取房产证'
ELSE '-' END registra_State
from  mkt_registration_titlehood
where del_Flag =0

select distinct  code,name from MKT_DELAY_REQUEST_CAUSE
order by code

SELECT 
distinct
CASE 
 WHEN t1.FOLLOW_UP_NODE ='01' THEN '认购'
 WHEN t1.FOLLOW_UP_NODE ='02' THEN '签约'
 WHEN t1.FOLLOW_UP_NODE ='03' THEN '按揭资料办理'
 WHEN t1.FOLLOW_UP_NODE ='04' THEN '预告证备案'
 WHEN t1.FOLLOW_UP_NODE ='05' THEN '办理入住'
 WHEN t1.FOLLOW_UP_NODE ='06' THEN '面积补差'
 WHEN t1.FOLLOW_UP_NODE ='07' THEN '权属登记'
 WHEN t1.FOLLOW_UP_NODE ='08' AND t1.FOLLOW_TYPE = '01' THEN '产权办理通知'
 WHEN t1.FOLLOW_UP_NODE ='09' AND t1.FOLLOW_TYPE = '01' THEN '产权转移登记'
 ELSE t19.NAME
END  FOLLOW_UP_NODE

FROM MKT_HOUSE_SALES_PROCESS_INFO T1
LEFT JOIN MKT_CONFIG_PAYMETHOD_DET T19 ON T1.FOLLOW_UP_NODE = T19.ID
WHERE T1.DEL_FLAG = 0 
AND  T1.SALE_ORG_ID  in  ('${SALE_ORG_ID}') 
order by
CASE 
 WHEN t1.FOLLOW_UP_NODE ='01' THEN '认购'
 WHEN t1.FOLLOW_UP_NODE ='02' THEN '签约'
 WHEN t1.FOLLOW_UP_NODE ='03' THEN '按揭资料办理'
 WHEN t1.FOLLOW_UP_NODE ='04' THEN '预告证备案'
 WHEN t1.FOLLOW_UP_NODE ='05' THEN '办理入住'
 WHEN t1.FOLLOW_UP_NODE ='06' THEN '面积补差'
 WHEN t1.FOLLOW_UP_NODE ='07' THEN '权属登记'
 WHEN t1.FOLLOW_UP_NODE ='08' AND t1.FOLLOW_TYPE = '01' THEN '产权办理通知'
 WHEN t1.FOLLOW_UP_NODE ='09' AND t1.FOLLOW_TYPE = '01' THEN '产权转移登记'
 ELSE t19.NAME
END 

	SELECT HOUSE_ID,SUM(TEMP_CHARGE_SUM)TEMP_CHARGE_SUM
	FROM MKT_HOUSE_SALES_PROCESS_INFO 
	WHERE DEL_FLAG = 0 AND  SALE_ORG_ID  in  ('${SALE_ORG_ID}')  
	GROUP BY HOUSE_ID
	

