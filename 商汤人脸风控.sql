select ba.area_id as areaCode #区域编码
      ,ba.area_name as areaName #区域名称
			,bc.city_id as cityCode #城市编码 
			,bc.city_name as cityName #城市名称
			,parcel.project_id as projectCode #项目编码
			,parcel.project_name as projectName #项目名称
			,MIN(si.VERIFY_TIME) as onlineTime #临时作为上线时间
			,customer.org_guid AS salesOrgId #销售组织Id
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.trade_guid IS NOT NULL THEN 1  ELSE 0 END) as weekChannelCount #本周报备成交客户
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.trade_guid IS NOT NULL AND customer.VERIFY_TIME IS NOT NULL THEN 1  ELSE 0 END) as weekChannelIdentityCount #本周报备刷证客户
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.trade_guid IS NOT NULL AND customer.VERIFY_TIME IS NULL THEN 1  ELSE 0 END) as weekChannelMissIdentityCount #本周报备漏刷证客户
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.trade_guid IS NOT NULL AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') = ''THEN 1  ELSE 0 END) as weekChannelMissIdentityWaitCkeckCount #本周报备漏刷证带复核客户
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.trade_guid IS NOT NULL AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') <> ''THEN 1  ELSE 0 END) as weekChannelMissIdentityCkeckCount #本周报备漏刷证已复核客户
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' THEN 1  ELSE 0 END) as weekRiskCount #本周疑似风险
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' THEN 1  ELSE 0 END)/SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.trade_guid IS NOT NULL THEN 1  ELSE 0 END) as weekRiskRate #本周疑似风险率
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = '' THEN 1  ELSE 0 END) as weekWaitCheckCount #本周待复核
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') <> '' THEN 1  ELSE 0 END) as weekCheckCount #本周复核数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') <> '' THEN 1  ELSE 0 END)/SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' THEN 1  ELSE 0 END) as weekCheckRate # 本周复核率
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'NORNAL' THEN 1  ELSE 0 END) as weekCheckNormalCount # 本周复核为正常数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as weekChecRiskCount # 本周复核为风险数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.VERIFY_TIME IS NOT NULL and customer.risk_status = 'UNJUDGED_CUSTOMERS' THEN 1  ELSE 0 END) as weekIdentityNoPhotoCount #本周已刷证无抓拍数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'NORMAL_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as weekIdentityNormalFinalRiskCount #本周初判正常确认风险
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' THEN 1  ELSE 0 END) as weekUnjudged1Count #本周未知客户总数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'NORNAL' THEN 1  ELSE 0 END) as weekUnjudged2Count #本周未知客户复核正常数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as weekUnjudged3Count #本周未知客户复核风险数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NOT NULL AND IFNULL(customer.AUDIT_RESULT,'') = 'NORNAL' THEN 1  ELSE 0 END) as weekUnjudged4Count #本周未知客户已刷证无抓拍复核为正常数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NOT NULL AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as weekUnjudged5Count #本周未知客户已刷证无抓拍复核为风险数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NOT NULL AND IFNULL(customer.AUDIT_RESULT,'') = '' THEN 1  ELSE 0 END) as weekUnjudged6Count #本周未知客户已刷证无抓拍未复核数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') = 'NORNAL' THEN 1  ELSE 0 END) as weekUnjudged7Count #本周未知客户未刷证无抓拍复核为正常数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as weekUnjudged8Count #本周未知客户未刷证无抓拍复核为风险数
			
			,SUM(CASE WHEN YEARWEEK(DATE_ADD(customer.rg_date, INTERVAL -1 DAY)) = YEARWEEK(DATE_ADD(NOW(), INTERVAL -1 DAY)) AND customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') = '' THEN 1  ELSE 0 END) as weekUnjudged9Count #本周未知客户未刷证无抓拍未复核数
			
			,SUM(CASE WHEN IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.trade_guid IS NOT NULL THEN 1  ELSE 0 END) as totalChannelCount #累计报备成交客户
			
			,SUM(CASE WHEN IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.VERIFY_TIME IS NOT NULL THEN 1  ELSE 0 END) as totalChannelIdentityCount #累计报备刷证客户
			
			,SUM(CASE WHEN IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.VERIFY_TIME IS NULL THEN 1  ELSE 0 END) as totalChannelMissIdentityCount #累计报备漏刷证客户
			
			,SUM(CASE WHEN IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') <> '' THEN 1  ELSE 0 END) as totalChannelMissIdentityCheckedCount #累计报备漏刷证客户(已复核)
			
			,SUM(CASE WHEN IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') = '' THEN 1  ELSE 0 END) as totalChannelMissIdentityNotChekedCount #累计报备漏刷证客户(待复核)
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' THEN 1  ELSE 0 END) as totalRiskCount #累计疑似风险
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' THEN 1  ELSE 0 END)/SUM(CASE WHEN IFNULL(customer.order_channel_name,'') <> '自然到访' AND customer.trade_guid IS NOT NULL THEN 1  ELSE 0 END) as totalRiskRate #累计疑似风险率
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = '' THEN 1  ELSE 0 END) as totalWaitCheckCount #累计待复核
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = '' AND DATE_ADD(customer.rg_date, INTERVAL 7 DAY) < NOW() THEN 1  ELSE 0 END) as totalWaitCheck7DayCount # 累计待复核风险客户(超7天)
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') <> '' THEN 1  ELSE 0 END) as totalCheckCount # 累计复核数
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') <> '' THEN 1  ELSE 0 END)/SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' THEN 1  ELSE 0 END) as totalCheckRate # 累计复核率
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'NORNAL' THEN 1  ELSE 0 END) as totalCheckNormalCount # 累计复核为正常数
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.risk_status = 'RISK_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as totalChecRiskCount # 累计复核为风险数
			
			,SUM(CASE WHEN customer.trade_guid IS NOT NULL AND customer.VERIFY_TIME IS NOT NULL AND customer.risk_status = 'UNJUDGED_CUSTOMERS' THEN 1  ELSE 0 END) as totalIdentityNoPhotoCount #累计已刷证无抓拍数
			
			,SUM(CASE WHEN customer.risk_status = 'NORMAL_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as totalIdentityNormalFinalRiskCount #累计初判正常确认风险
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' THEN 1  ELSE 0 END) as totalUnjudged1Count #累计未知客户总数
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'NORNAL' THEN 1  ELSE 0 END) as totalUnjudged2Count #累计未知客户复核正常数
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as totalUnjudged3Count #累计未知客户复核风险数
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NOT NULL AND IFNULL(customer.AUDIT_RESULT,'') = 'NORNAL' THEN 1  ELSE 0 END) as totalUnjudged4Count #累计未知客户已刷证无抓拍复核为正常数
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NOT NULL AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as totalUnjudged5Count #累计未知客户已刷证无抓拍复核为风险数
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NOT NULL AND IFNULL(customer.AUDIT_RESULT,'') = '' THEN 1  ELSE 0 END) as totalUnjudged6Count #累计未知客户已刷证无抓拍未复核数
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') = 'NORNAL' THEN 1  ELSE 0 END) as totalUnjudged7Count #累计未知客户未刷证无抓拍复核为正常数
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') = 'FLY_ORDER' THEN 1  ELSE 0 END) as totalUnjudged8Count #累计未知客户未刷证无抓拍复核为风险数
			
			,SUM(CASE WHEN customer.risk_status = 'UNJUDGED_CUSTOMERS' AND customer.VERIFY_TIME IS NULL AND IFNULL(customer.AUDIT_RESULT,'') = '' THEN 1  ELSE 0 END) as totalUnjudged9Count #累计未知客户未刷证无抓拍未复核数
		
from base_project parcel
inner join scere_store_relation ssr on ssr.project_code = parcel.project_id
left join (select min(VERIFY_TIME) as VERIFY_TIME, store_id from scere_identity group by store_id) si on si.store_id = ssr.store_id
inner join base_area ba on ba.area_id = parcel.area_id
inner join base_city bc on bc.city_id = parcel.city_id
left join (
		select min(sc.VERIFY_TIME) as VERIFY_TIME, sc.trade_guid, sc.order_channel_name, 
		case when SC.order_channel_name = '自然到访' then 'NATURE_CUSTOMERS'
		when locate('RISK_CUSTOMERS', GROUP_CONCAT(
		DISTINCT SC.RISK_STATUS
		ORDER BY
		SC.RISK_STATUS SEPARATOR '|'
		)) > 0 then 'RISK_CUSTOMERS'
		when locate('UNJUDGED_CUSTOMERS', GROUP_CONCAT(
		DISTINCT SC.RISK_STATUS
		ORDER BY
		SC.RISK_STATUS SEPARATOR '|'
		)) > 0 then 'UNJUDGED_CUSTOMERS'
		when locate('NORMAL_CUSTOMERS', GROUP_CONCAT(
		DISTINCT SC.RISK_STATUS
		ORDER BY
		SC.RISK_STATUS SEPARATOR '|'
		)) > 0 then 'NORMAL_CUSTOMERS'
		else 'NATURE_CUSTOMERS'
		end risk_status, #初判优先级：风险 > 未知 > 正常
		sc.audit_result, sc.project_guid, min(sc.rg_date) as rg_date, sc.org_guid
	from scere_customer sc 
	inner join scere_store_relation ssr on ssr.project_code = sc.project_guid
	left join (SELECT MIN(ID) AS ID, ID_NUMBER, STORE_ID FROM scere_identity GROUP BY ID_NUMBER, STORE_ID) AS identity on identity.ID_NUMBER = sc.CARD_ID AND identity.STORE_ID = ssr.STORE_ID
	where sc.record_status = 'Active' and IFNULL(sc.biz_type,0) not in (5)
	group by sc.trade_guid, sc.order_channel_name, sc.audit_result, sc.project_guid, sc.org_guid
) customer on customer.project_guid = parcel.project_id
left join (select row_number() over(partition by a.ROOM_GUID order by a.CREATION_DATE desc) rn, a.* from scere_order_judgement a ) judgement on judgement.rn = 1 and customer.trade_guid = judgement.trade_guid AND judgement.HISTORY_FLAG = 1
GROUP BY ba.area_id
      ,ba.area_name
			,bc.city_id
			,bc.city_name
			,parcel.project_id
			,parcel.project_name
			,customer.org_guid
order by instr("珠海区域|华南区域|华东区域|华中区域|山东区域|北方区域|北京公司",areaname)		

