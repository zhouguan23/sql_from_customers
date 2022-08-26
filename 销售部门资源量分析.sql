
SELECT
	b.NAME,
	s_k.label,
	SUM(m.a_num) AS all_num,
	SUM(m.l_num) AS loc_num,
	TO_CHAR((ROUND(DECODE(SUM(m.a_num),0,0,SUM(m.l_num)/SUM(m.a_num)),4))*100,'fm999990.00')||'%' AS loc_ratio,
	SUM(m.na_num) AS nall_num,
	SUM(m.nl_num) AS nloc_num,
	TO_CHAR((ROUND(DECODE(SUM(m.na_num),0,0,SUM(m.nl_num)/SUM(m.na_num)),4))*100,'fm999990.00')||'%' AS nloc_ratio,
	SUM(m.va_num) AS vall_num,
	SUM(m.vl_num) AS vloc_num,
	TO_CHAR((ROUND(DECODE(SUM(m.va_num),0,0,SUM(m.vl_num)/SUM(m.va_num)),4))*100,'fm999990.00')||'%' AS vloc_ratio,
	SUM(m.vt_num) AS vtotal_num,
	TO_CHAR((ROUND(SUM(m.vt_num)/SUM(m.a_num),4))*100,'fm999990.00')||'%' AS t_ratio
FROM
(
	-- 总资源量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		COUNT(a.accountId) AS a_num,
		0 AS l_num,
		0 AS na_num,
 		0 AS nl_num,
		0 AS va_num,
		0 AS vl_num,
		0 AS vt_num
	FROM
		CRM_ACCOUNT a
	WHERE
		TO_CHAR((a.createdOn),'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	GROUP BY 
				a.c__kaifaqudao,
				a.owningBusinessUnit
UNION ALL


-- 当地资源量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS a_num,
		COUNT(a.accountId) AS l_num,
		0 AS na_num,
 		0 AS nl_num,
		0 AS va_num,
		0 AS vl_num,
		0 AS vt_num
	FROM
		CRM_ACCOUNT a
	INNER JOIN CRM_SUBJECT s_s ON a.C__SHENGSHI = s_s.SUBJECTID
	WHERE
		TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	AND INSTR(
				'北京|沈阳|天津|石家庄|青岛|乌鲁木齐|太原|上海|南京|合肥
				|杭州|温州|宁波|武汉|长沙|郑州|西安|成都|重庆|贵阳|昆明|
				广州|深圳|东莞|南宁|福州|厦门|大连|泉州|哈尔滨|昆山|南通|无锡|珠海|徐州',
				SUBSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),1,INSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),'市',1)-1),
					1,1				
					) > 0
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 未来院总资源量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS a_num,
		0 AS l_num,
		COUNT(a.accountId) AS na_num,
 		0 AS nl_num,
		0 AS va_num,
		0 AS vl_num,
		0 AS vt_num
	FROM
		CRM_ACCOUNT a
	WHERE
		TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	AND a.c__kehuzhuangtai IN(1,2,7)
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 未来院当地资源量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS a_num,
		0 AS l_num,
		0 AS na_num,
 		COUNT(a.accountId) AS nl_num,
		0 AS va_num,
		0 AS vl_num,
		0 AS vt_num
	FROM
		CRM_ACCOUNT a
	INNER JOIN CRM_SUBJECT s_s ON a.C__SHENGSHI = s_s.SUBJECTID
	WHERE
		TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	AND a.c__kehuzhuangtai IN(1,2,7)
	AND INSTR(
				'北京|沈阳|天津|石家庄|青岛|乌鲁木齐|太原|上海|南京|合肥
				|杭州|温州|宁波|武汉|长沙|郑州|西安|成都|重庆|贵阳|昆明|
				广州|深圳|东莞|南宁|福州|厦门|大连|泉州|哈尔滨|昆山|南通|无锡|珠海|徐州',
				SUBSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),1,INSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),'市',1)-1),
					1,1				
					) > 0
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 未来院有效总资源量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS a_num,
		0 AS l_num,
		0 AS na_num,
 		0 AS nl_num,
		COUNT(a.accountId) AS va_num,
		0 AS vl_num,
		0 AS vt_num
	FROM
		CRM_ACCOUNT a
	WHERE
		TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	AND a.c__kehuzhuangtai IN(1,2,7)
	AND a.typeCode < 4
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 未来院有效当地资源量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS a_num,
		0 AS l_num,
		0 AS na_num,
 		0 AS nl_num,
		0 AS va_num,
		COUNT(a.accountId) AS vl_num,
		0 AS vt_num
	FROM
		CRM_ACCOUNT a
	INNER JOIN CRM_SUBJECT s_s ON a.C__SHENGSHI = s_s.SUBJECTID
	WHERE
		TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	AND a.c__kehuzhuangtai IN(1,2,7)
	AND a.typeCode < 4
	AND INSTR(
				'北京|沈阳|天津|石家庄|青岛|乌鲁木齐|太原|上海|南京|合肥
				|杭州|温州|宁波|武汉|长沙|郑州|西安|成都|重庆|贵阳|昆明|
				广州|深圳|东莞|南宁|福州|厦门|大连|泉州|哈尔滨|昆山|南通|无锡|珠海|徐州',
				SUBSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),1,INSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),'市',1)-1),
					1,1				
					) > 0
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 总有效资源量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS a_num,
		0 AS l_num,
		0 AS na_num,
 		0 AS nl_num,
		0 AS va_num,
		0 AS vl_num,
		COUNT(a.accountId) AS vt_num
	FROM
		CRM_ACCOUNT a
	WHERE
			TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	AND a.typeCode < 4
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
) m
INNER JOIN CRM_SUBJECT s_k ON m.c__kaifaqudao = s_k.SUBJECTID
INNER JOIN CRM_BUSINESSUNIT b ON m.owningBusinessUnit = b.BUSINESSUNITID
WHERE b.c__bumenshuxing = 3 
AND 1=1${if(len(quyu) == 0,"","and b.NAME in ('" + quyu + "')")}
AND 1=1${if(len(qudao) == 0,"","and s_k.label in ('" + qudao + "')")}
GROUP BY b.NAME,s_k.label













SELECT
	b.NAME,
	s_k.label,
	TO_CHAR((ROUND(DECODE(SUM(m.a_num),0,0,SUM(m.sv_num)/SUM(m.a_num)),4))*100,'fm999990.00')||'%' AS s_ratio,
	TO_CHAR((ROUND(DECODE(SUM(m.la_num),0,0,SUM(m.slv_num)/SUM(m.la_num)),4))*100,'fm999990.00') || '%' AS sl_ratio,
	TO_CHAR((ROUND(DECODE(SUM(m.a_num)-SUM(m.la_num),0,0,(SUM(m.sv_num)-SUM(m.slv_num))/(SUM(m.a_num)-SUM(m.la_num))),4))*100,'fm999990.00')|| '%' AS so_ratio,
	SUM(m.a_num) AS a_num,
	TO_CHAR((ROUND(DECODE(SUM(m.a_num),0,0,SUM(m.v_num)/SUM(m.a_num)),4))*100,'fm999990.00') || '%' AS a_ratio,
	SUM(m.la_num) AS la_num,
	TO_CHAR((ROUND(DECODE(SUM(m.la_num),0,0,SUM(m.lv_num)/SUM(m.la_num)),4))*100,'fm999990.00') || '%' AS la_ratio,
	SUM(m.a_num)-SUM(m.la_num) AS o_num,
	TO_CHAR((ROUND(DECODE(SUM(m.a_num)-SUM(m.la_num),0,0,(SUM(m.v_num)-SUM(m.lv_num))/(SUM(m.a_num)-SUM(m.la_num))),4))*100,'fm999990.00') || '%' AS o_ratio


FROM
(
	-- 7日新资源到诊量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		COUNT(a.accountId) AS sv_num,
 		0 AS a_num,
 		0 AS slv_num,
 		0 AS la_num,
 		0 AS v_num,
		0 AS lv_num
	FROM
		CRM_ACCOUNT a
	INNER JOIN
	(
		SELECT
			x.c__xingming,
			MIN(x.c__fenzhenshijian) AS min_time
		FROM
			CRM_E__GHXX x
		WHERE x.isDeleted IS NULL
		GROUP BY
			x.c__xingming
	) f ON a.accountId = f.c__xingming
	WHERE
			TO_CHAR(f.min_time,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
		AND f.min_time - a.createdOn <= 7 AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 新资源总量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS sv_num,
 		COUNT(a.accountId) AS a_num,
 		0 AS slv_num,
 		0 AS la_num,
 		0 AS v_num,
		0 AS lv_num
	FROM
		CRM_ACCOUNT a
	WHERE
		TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 7日新资源当地到诊量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS sv_num,
 		0 AS a_num,
 		COUNT(a.accountId) AS slv_num,
 		0 AS la_num,
 		0 AS v_num,
		0 AS lv_num
	FROM
		CRM_ACCOUNT a
	INNER JOIN
	(
		SELECT
			x.c__xingming,
			MIN(x.c__fenzhenshijian) AS min_time
		FROM
			CRM_E__GHXX x
		WHERE x.isDeleted IS NULL
		GROUP BY
			x.c__xingming
	) f ON a.ACCOUNTID = f.C__XINGMING
	INNER JOIN CRM_SUBJECT s_s ON a.C__SHENGSHI = s_s.SUBJECTID
	WHERE
			TO_CHAR(f.min_time,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
		AND f.min_time - a.createdOn <= 7 AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND INSTR(
				'北京|沈阳|天津|石家庄|青岛|乌鲁木齐|太原|上海|南京|合肥
				|杭州|温州|宁波|武汉|长沙|郑州|西安|成都|重庆|贵阳|昆明|
				广州|深圳|东莞|南宁|福州|厦门|大连|泉州|哈尔滨|昆山|南通|无锡',
				SUBSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),1,INSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),'市',1)-1),
					1,1				
					) > 0
	

	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 当地新资源总量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS sv_num,
 		0 AS a_num,
 		0 AS slv_num,
 		COUNT(a.accountId) AS la_num,
 		0 AS v_num,
		0 AS lv_num
	FROM
		CRM_ACCOUNT a
	INNER JOIN CRM_SUBJECT s_s ON a.C__SHENGSHI = s_s.SUBJECTID
	WHERE
		TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
	AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND a.isDeleted = 0
	AND INSTR(
				'北京|沈阳|天津|石家庄|青岛|乌鲁木齐|太原|上海|南京|合肥
				|杭州|温州|宁波|武汉|长沙|郑州|西安|成都|重庆|贵阳|昆明|
				广州|深圳|东莞|南宁|福州|厦门|大连|泉州|哈尔滨|昆山|南通|无锡',
				SUBSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),1,INSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),'市',1)-1),
					1,1				
					) > 0
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit	
UNION ALL
	-- 总到诊量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS sv_num,
 		0 AS a_num,
 		0 AS slv_num,
 		0 AS la_num,
 		COUNT(a.accountId) AS v_num,
		0 AS lv_num
	FROM
		CRM_ACCOUNT a
	INNER JOIN
	(
		SELECT
			x.c__xingming,
			MIN(x.c__fenzhenshijian) AS min_time
		FROM
			CRM_E__GHXX x
		WHERE x.isDeleted IS NULL
		GROUP BY
			x.c__xingming
	) f ON a.accountId = f.c__xingming
	WHERE
		TO_CHAR(f.min_time,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}' 
		AND TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
		AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
UNION ALL
	-- 当地到诊量
	SELECT
		a.c__kaifaqudao,
		a.owningBusinessUnit,
		0 AS sv_num,
 		0 AS a_num,
 		0 AS slv_num,
 		0 AS la_num,
 		0 AS v_num,
		COUNT(a.accountId) AS lv_num
	FROM
		CRM_ACCOUNT a
	INNER JOIN
	(
		SELECT
			x.c__xingming,
			MIN(x.c__fenzhenshijian) AS min_time
		FROM
			CRM_E__GHXX x
		WHERE x.isDeleted IS NULL
		GROUP BY
			x.c__xingming
	) f ON a.accountId = f.c__xingming
	INNER JOIN CRM_SUBJECT s_s ON a.c__shengshi = s_s.subjectId
	WHERE
			TO_CHAR(f.min_time,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
			AND TO_CHAR(a.createdOn,'yyyy-MM-DD') BETWEEN '${startDate}' AND '${endDate}'
			AND NVL(a.c__kehukahao,'') NOT LIKE '小强%'
	AND NVL(a.c__kehukahao,'') != '0'
	AND INSTR(
				'北京|沈阳|天津|石家庄|青岛|乌鲁木齐|太原|上海|南京|合肥
				|杭州|温州|宁波|武汉|长沙|郑州|西安|成都|重庆|贵阳|昆明|
				广州|深圳|东莞|南宁|福州|厦门|大连|泉州|哈尔滨|昆山|南通|无锡',
				SUBSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),1,INSTR(SUBSTR(s_s.label,INSTR(s_s.label,'>',-1,1)+2,length(s_s.label)),'市',1)-1),
					1,1				
					) > 0
	GROUP BY a.c__kaifaqudao,a.owningBusinessUnit
) m
INNER JOIN CRM_SUBJECT s_k ON m.c__kaifaqudao = s_k.subjectId
INNER JOIN CRM_BUSINESSUNIT b ON m.owningBusinessUnit = b.businessUnitId
WHERE b.c__bumenshuxing = 3 
	AND 1=1${if(len(quyu) == 0,"","and b.NAME in ('" + quyu + "')")}
	AND 1=1${if(len(qudao) == 0,"","and s_k.label in ('" + qudao + "')")}
GROUP BY b.NAME,s_k.label











SELECT b.NAME FROM CRM_BUSINESSUNIT b WHERE b.c__bumenshuxing = 3


SELECT LABEL FROM CRM_SUBJECT t
where t.type='kaifaqudao（yonghe）'

