SELECT 
    distinct xmdddocno 单号,
	xmddseq 项次,
	xmddseq1 项序,
	xmddseq2 批序,
	xmdadocnoj 样品,
	xmdastus 状态码,
	ooag003 部门编号,
	l_d 业务部门,
	imafud001 营业担当码,
	ooag011 营业担当,
	pmab090 运输方式,imafud003,
	pmab091 交易起点,
	pmab092 交易终点,
	NVL(l_K,'广州') 交易终点名称,
	xmda022 客户编码,
	l_e 客户名称,  
	xmdd001 料件编号,
	imaal003 品名, 
	NVL(l_f,imae034) 供应商,
	CAST( sum(inag008) as numeric(10,2))库存量,
	CAST(xmdd006 as numeric(10,2)) 订购数量,
	CAST(xmdd014 as numeric(10,2)) 已出货数量,
	CAST(xmdd031 as numeric(10,2)) 已转出货数量,
	CAST(xmdd016 as numeric(10,2)) 退换货数量,
	CAST(xmdd034 as numeric(10,2)) 已签退量, 
	CAST(xmdd015 as numeric(10,2)) 销退量,
	CAST(l_l as numeric(10,2)) 未出货量,
	NVL(l_j,0) 销退,NVL(l_m,0) 出货单出货量,to_char(xmdd011,'YYYYMM') 出货日期,
	'*' 星期,
	to_char(xmdd011,'YYYYMM') 出货, xmda007 销退号,
	(select  NVL(sum(NVL(xmdd006,0)-NVL(xmdd014,0)),0)l_l from xmdd_t@SOL 
		 LEFT JOIN xmda_t@SOL ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
    where 1=1 and a1.xmdadocnoj !='Y' and xmdd001=a1.xmdd001 AND xmddsite = a1.xmdasite and xmddent = a1.xmdaent  and NVL(xmdd006,0)-NVL(xmdd014,0)!=0  and xmdastus not in('X','C') 
 and (xmdaud001 !='Y' or xmdaud001 is null) and substr(xmdadocno,4 ,5) not in ('DLY07','DLY34','YY503','SHY13') ) 订单残1,
    (select  NVL(sum(NVL(xmdd006,0)-NVL(xmdd014,0)),0)l_l from xmdd_t@SOL 
		 LEFT JOIN xmda_t@SOL ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
    where 1=1 and a1.xmdadocnoj='Y' and xmdd001=a1.xmdd001 AND xmddsite = a1.xmdasite and xmddent = a1.xmdaent  and NVL(xmdd006,0)-NVL(xmdd014,0)!=0  and xmdastus not in('X','C') 
 and (xmdaud001 !='Y' or xmdaud001 is null) and substr(xmdadocno,4 ,5) in ('DLY07','DLY34','YY503','SHY13') ) 订单残2
    FROM (select DISTINCT (case substr(xmdadocno,4 ,5)
		when 'BY500' then 'Y'
		--when 'DLY07' then 'Y'
		--when 'DLY34' then 'Y'
		--when 'YY503' then 'Y'
		--when 'SGY22' then 'Y'
		else 'N' end ) xmdadocnoj,xmdddocno,xmddseq,xmddseq1,xmddseq2,xmdd005,xmdd006,xmdd011,xmdd016,xmdd031 ,xmdd034 ,xmdd015 ,xmda007,imafua001,
		xmdastus ,imaal003,xmdd001 , xmda022 ,pmab090,pmab091 ,pmab092,imafud001,ooag011,ooag003 ,xmdaent,xmdasite,imae034,imafud003,
		(case when xmdd014>=xmdd006 then xmdd006 when xmdd014<xmdd006 then xmdd014 end)xmdd014,
		(NVL(xmdd006,0)-NVL(xmdd014,0))l_l,
		(SELECT ooefl003 FROM ooefl_t@SOL WHERE ooefl001=ooag003 AND ooeflent=xmdaent AND ooefl002='zh_CN') l_d, 
		(SELECT pmaal004 FROM pmaal_t@SOL WHERE pmaal001=xmda022 AND pmaalent=xmdaent AND pmaal002='zh_CN') l_e,
		(SELECT ooefl003 FROM ooefl_t WHERE ooefl001=substr(imae034,1,5) AND ooeflent=98 AND ooefl002='zh_CN') l_f,
		(SELECT oocql004 FROM oocql_t@SOL WHERE oocql002=pmab092 AND oocqlent=xmdaent AND oocql003='zh_CN' AND OOCQL001='315') l_k,
		NVL((select sum(xmdl018) from xmdl_t@SOL
		LEFT JOIN xmdk_t@SOL ON xmdldocno=xmdkdocno AND xmdlent=xmdkent
		where xmdl008=xmdd001 AND xmdlent=xmdaent AND xmdl003 = xmdddocno and xmdl004=XMDDSEQ 
		and xmddseq=xmdl004 and xmddseq1=xmdl005 and xmddseq2=xmdl006 and xmdk082 not in ('1','4') and xmdl018 !=0
		),0) l_j,
        NVL((select sum(xmdl018) from xmdl_t@SOL
		LEFT JOIN xmdk_t@SOL ON xmdldocno=xmdkdocno AND xmdlent=xmdkent
		where xmdl008=xmdd001 AND xmdlent=xmdaent AND xmdl003 = xmdddocno and xmdl004=XMDDSEQ 
		and xmddseq=xmdl004 and xmddseq1=xmdl005 and xmddseq2=xmdl006 and xmdkstus  not in ('X','S') and xmdk026=xmdd011
		),0) l_m
	FROM xmda_t@SOL  
		 LEFT JOIN xmdd_t@SOL ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcdocno = xmdddocno AND xmdcseq = xmddseq
		 LEFT JOIN imaal_t@SOL t3 ON t3.imaalent=xmddent AND t3.imaal001=xmdd001 AND t3.imaal002='zh_CN' 
		 LEFT JOIN pmab_t@SOL ON xmda022 = pmab001 AND pmabent = xmdaent AND pmabsite = xmdasite 
		 LEFT JOIN imaf_t@SOL ON xmdd001 = imaf001 AND imafent = xmdaent AND imafsite = xmdasite 
		 LEFT JOIN ooag_t@SOL ON ooag001=imafud001 AND ooagent=xmdaent 
		 LEFT JOIN imae_t ON imae001=xmdd001 AND imaeent=98 AND imaesite = 'MBG' 
		 LEFT JOIN xmdg_t@SOL ON xmdg004=xmdddocno AND xmdgent=xmddent --and xmdgstus='Y'
		 where 1=1 
and xmdaent = '100' and xmdasite ='SOL'  --and xmdastus != 'X'
and xmdastus not in('X','C') 
--and xmdd015=0 --销退数量
and xmdc045='1'
and (xmdaud001 !='Y' or xmdaud001 is null)
and substr(xmda003,1,5)  in ('${comboCheckBox1}','MBGYY','MBHY1','MBHY2')--部门筛选
and xmdd011 BETWEEN TO_DATE('${dateEditor0}','yyyy-mm-dd') and TO_DATE('${dateEditor1}','yyyy-mm-dd') 
${IF(LEN(comboCheckBox2) = 0, "", " AND xmdd001 IN ('"+comboCheckBox2+"')")}
${IF(LEN(l_imae034) = 0, "", " AND substr(imae034,1,5) IN ('"+l_imae034+"')")}
${IF(LEN(comboCheckBox3) = 0, "", " AND xmda022 IN ('"+comboCheckBox3+"')")}
${IF(LEN(comboCheckBox4) = 0, "", " AND ooag001 IN ('"+comboCheckBox4+"')")}
		) a1
LEFT JOIN inag_t ON inag001=xmdd001 AND inagent=98 and inag004='KW11' and inag005 in ('143','144') --排除可退库存
where 1=1 AND  substr(xmdddocno,4 ,5) IN ('AY500','BY500') 
${If(LEN(comboCheckBox0) = 0,"",If(comboCheckBox0 = '5', "And xmda007 = '5'","And xmdadocnoj in ('" + comboCheckBox0 + "')"))}
and  l_l>0
Group By xmdddocno,xmda022,xmddseq ,xmddseq1 ,xmddseq2 ,l_e ,ooag003,l_d ,imafud001 ,ooag011 ,pmab090,pmab091,pmab092 ,xmdastus,xmdd001 ,imaal003,imafua001,imafud003,
xmdd006 ,l_l ,xmdd016 ,xmdd034 ,xmdd015,xmdd031  --,month(xmdd011)
,xmdd014,xmdasite,imae034,l_f,xmdd011,l_k,xmdadocnoj,l_j,xmda007,l_m,xmdaent
union all
SELECT 
    distinct xmdddocno 单号,
	xmddseq 项次,
	xmddseq1 项序,
	xmddseq2 批序,
	xmdadocnoj 样品,
	xmdastus 状态码,
	ooag003 部门编号,
	l_d 业务部门,
	imafud001 营业担当码,
	ooag011 营业担当,
	pmab090 运输方式,imafud003,
	pmab091 交易起点,
	pmab092 交易终点,
	NVL(l_K,'广州') 交易终点名称,
	xmda022 客户编码,
	l_e 客户名称,  
	xmdd001 料件编号,
	imaal003 品名,
	NVL(l_f,imae034) 供应商,
	CAST( sum(inag008) as numeric(10,2))库存量,
	CAST(xmdd006 as numeric(10,2)) 订购数量,
	CAST(xmdd014 as numeric(10,2)) 已出货数量,
	CAST(xmdd031 as numeric(10,2)) 已转出货数量,
	CAST(xmdd016 as numeric(10,2)) 退换货数量,
	CAST(xmdd034 as numeric(10,2)) 已签退量, 
	CAST(xmdd015 as numeric(10,2)) 销退量,
	CAST(l_l as numeric(10,2)) 未出货量,
	NVL(l_j,0) 销退,NVL(l_m,0) 出货单出货量,to_char(xmdd011,'YYYYMM') 出货日期,
	'*' 星期,
	to_char(xmdd011,'YYYYMM') 出货, xmda007 销退号,
	(select  NVL(sum(NVL(xmdd006,0)-NVL(xmdd014,0)),0)l_l from xmdd_t
		 LEFT JOIN xmda_t ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
    where 1=1 and a1.xmdadocnoj !='Y' and xmdd001=a1.xmdd001 AND xmddsite = a1.xmdasite and xmddent = a1.xmdaent  and NVL(xmdd006,0)-NVL(xmdd014,0)!=0  and xmdastus not in('X','C') 
 and (xmdaud001 !='Y' or xmdaud001 is null) and substr(xmdadocno,4 ,5) not in ('DLY07','DLY34','YY503','SHY13') ) 订单残1,
    (select  NVL(sum(NVL(xmdd006,0)-NVL(xmdd014,0)),0)l_l from xmdd_t 
		 LEFT JOIN xmda_t ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
    where 1=1 and a1.xmdadocnoj='Y' and xmdd001=a1.xmdd001 AND xmddsite = a1.xmdasite and xmddent = a1.xmdaent  and NVL(xmdd006,0)-NVL(xmdd014,0)!=0  and xmdastus not in('X','C') 
 and (xmdaud001 !='Y' or xmdaud001 is null) and substr(xmdadocno,4 ,5) in ('DLY07','DLY34','YY503','SHY13') ) 订单残2
    FROM (select DISTINCT (case substr(xmdadocno,4 ,5)
		--when 'DLY07' then 'Y'
		--when 'DLY34' then 'Y'
		when 'YY503' then 'Y'
		--when 'SGY22' then 'Y'
		when 'GY500' then 'D'
		else 'N' end ) xmdadocnoj,xmdddocno,xmddseq,xmddseq1,xmddseq2,xmdd005,xmdd006,xmdd011,xmdd016,xmdd031 ,xmdd034 ,xmdd015 ,xmda007,imafua001,
		xmdastus ,imaal003,xmdd001 , xmda022 ,pmab090,pmab091 ,pmab092,imafud001,ooag011,ooag003 ,xmdaent,xmdasite,imae034,imafud003,
		(case when xmdd014>=xmdd006 then xmdd006 when xmdd014<xmdd006 then xmdd014 end)xmdd014,
		(NVL(xmdd006,0)-NVL(xmdd014,0))l_l,
		(SELECT ooefl003 FROM ooefl_t WHERE ooefl001=ooag003 AND ooeflent=xmdaent AND ooefl002='zh_CN') l_d, 
		(SELECT pmaal004 FROM pmaal_t WHERE pmaal001=xmda022 AND pmaalent=xmdaent AND pmaal002='zh_CN') l_e,
		(SELECT ooefl003 FROM ooefl_t WHERE ooefl001=substr(imae034,1,5) AND ooeflent=xmdaent AND ooefl002='zh_CN') l_f,
		(SELECT oocql004 FROM oocql_t WHERE oocql002=pmab092 AND oocqlent=xmdaent AND oocql003='zh_CN' AND OOCQL001='315') l_k,
		NVL((select sum(xmdl018) from xmdl_t
		LEFT JOIN xmdk_t ON xmdldocno=xmdkdocno AND xmdlent=xmdkent
		where xmdl008=xmdd001 AND xmdlent=xmdaent AND xmdl003 = xmdddocno and xmdl004=XMDDSEQ 
		and xmddseq=xmdl004 and xmddseq1=xmdl005 and xmddseq2=xmdl006 and xmdk082 not in ('1','4') and xmdl018 !=0
		),0) l_j,
        NVL((select sum(xmdl018) from xmdl_t
		LEFT JOIN xmdk_t ON xmdldocno=xmdkdocno AND xmdlent=xmdkent
		where xmdl008=xmdd001 AND xmdlent=xmdaent AND xmdl003 = xmdddocno and xmdl004=XMDDSEQ 
		and xmddseq=xmdl004 and xmddseq1=xmdl005 and xmddseq2=xmdl006 and xmdkstus  not in ('X','S') and xmdk026=xmdd011
		),0) l_m
	FROM xmda_t  
		 LEFT JOIN xmdd_t ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcdocno = xmdddocno AND xmdcseq = xmddseq
		 LEFT JOIN imaal_t t3 ON t3.imaalent=xmddent AND t3.imaal001=xmdd001 AND t3.imaal002='zh_CN' 
		 LEFT JOIN pmab_t ON xmda022 = pmab001 AND pmabent = xmdaent AND pmabsite = xmdasite 
		 LEFT JOIN imaf_t ON xmdd001 = imaf001 AND imafent = xmdaent AND imafsite = xmdasite 
		 LEFT JOIN ooag_t ON ooag001=imafud001 AND ooagent=xmdaent 
		 LEFT JOIN imae_t ON imae001=xmdd001 AND imaeent=xmdaent AND imaesite = xmdasite 
		 LEFT JOIN xmdg_t ON xmdg004=xmdddocno AND xmdgent=xmddent --and xmdgstus='Y'
		 where 1=1 
and xmdaent = '98' and xmdasite ='MBG'  --and xmdastus != 'X'
and xmdastus not in('X','C') 
--and xmdd015=0 --销退数量
and xmdc045='1'
AND substr(xmdadocno,4,5) IN 
(SELECT ooac002 
FROM ooac_t
WHERE ooacent = 98
AND ooac001 = (SELECT ooef004 FROM ooef_t WHERE ooefent = 98 AND ooef001 = 'MBG')
AND ooac003 = 'D-BASC0003'
AND ooac004 IN ('4','3','2','1'))
and (xmdaud001 !='Y' or xmdaud001 is null)
and substr(xmda003,1,5)  in ('${comboCheckBox1}','MBGYY')--部门筛选
and xmdd011 BETWEEN TO_DATE('${dateEditor0}','yyyy-mm-dd') and TO_DATE('${dateEditor1}','yyyy-mm-dd')  
${IF(LEN(comboCheckBox2) = 0, "", " AND xmdd001 IN ('"+comboCheckBox2+"')")}
${IF(LEN(l_imae034) = 0, "", " AND substr(imae034,1,5) IN ('"+l_imae034+"')")}
${IF(LEN(comboCheckBox3) = 0, "", " AND xmda022 IN ('"+comboCheckBox3+"')")}
${IF(LEN(comboCheckBox4) = 0, "", " AND ooag001 IN ('"+comboCheckBox4+"')")}
		) a1
LEFT JOIN inag_t ON inag001=xmdd001 AND inagent=xmdaent and inag004='KW11' and inag005 in ('143','144') --排除可退库存
where 1=1 AND  substr(xmdddocno,4 ,5) IN ('YY501','YY503','GY500','EY500','FY500','HY500') 
AND substr(xmdddocno,4,5) IN 
(SELECT ooac002 
FROM ooac_t
WHERE ooacent = 98
AND ooac001 = (SELECT ooef004 FROM ooef_t WHERE ooefent = 98 AND ooef001 = 'MBG')
AND ooac003 = 'D-BASC0003'
AND ooac004 IN ('4','3','2','1'))
${If(LEN(comboCheckBox0) = 0,"",If(comboCheckBox0 = '5', "And xmda007 = '5'","And xmdadocnoj in ('" + comboCheckBox0 + "')"))}
and  l_l>0
Group By xmdddocno,xmda022,xmddseq ,xmddseq1 ,xmddseq2 ,l_e ,ooag003,l_d ,imafud001 ,ooag011 ,pmab090,pmab091,pmab092 ,xmdastus,xmdd001 ,imaal003,imafua001,imafud003,
xmdd006 ,l_l ,xmdd016 ,xmdd034 ,xmdd015,xmdd031  --,month(xmdd011)
,xmdd014,xmdasite,imae034,l_f,xmdd011,l_k,xmdadocnoj,l_j,xmda007,l_m,xmdaent
order by 出货,单号

  select distinct imaal003,xmdd001,XMDA022,(NVL(xmdd006,0)-NVL(xmdd014,0)) mm from xmda_t
		 LEFT JOIN xmdd_t ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN imaal_t t3 ON t3.imaalent=xmdaent AND t3.imaal001=xmdd001 AND t3.imaal002='zh_CN' 
		 LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcdocno = xmdddocno AND xmdcseq = xmddseq
		 where 1=1 and NVL(xmdd006,0)-NVL(xmdd014,0) >0
and xmdaent = '98' and xmdastus !='x' and xmdasite ='MBG'
--and XMDA022='03605'
and xmdaent = '98' and xmdasite ='MBG'  
and xmdastus not in('X','C') 
and xmdd015=0 
and xmdc045='1'
and (xmdaud001 !='Y' or xmdaud001 is null)
AND substr(xmdadocno,4,5) IN 
(SELECT ooac002 
FROM ooac_t
WHERE ooacent = 98
AND ooac001 = (SELECT ooef004 FROM ooef_t WHERE ooefent = 98 AND ooef001 = 'MBG')
AND ooac003 = 'D-BASC0003'
AND ooac004 IN ('4','3','2','1'))


select distinct
	imafud001 营业担当码,
	ooag011 营业担当 	FROM xmda_t  
		 LEFT JOIN xmdd_t ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN imaf_t ON xmdd001 = imaf001 AND imafent = xmdaent AND imafsite = xmdasite 
		 LEFT JOIN ooag_t ON ooag001=imafud001 AND ooagent=xmdaent
where  imafud001 like 'MBG%'

