
SELECT 
    distinct xmdddocno 单号,
    --add by yangqt 2020/02/24
    CASE xmdaud003 
    WHEN '1' THEN '第一生产本部'
    WHEN '2' THEN '第二生产本部'
    ELSE '其他'
    END 接单部门,
    --end add
	xmddseq 项次,
	xmddseq1 项序,
	xmddseq2 批序,
	xmdadocnoj 样品,
	xmdastus 状态码,
	ooag003 部门编号,
	l_d 业务部门,
    a.整袋数,
    a.整盒数,
    a.整箱数,
    a.整板数,
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
    imafua001 纳品仓库,
	NVL(l_f,imae034) 供应商,
	CAST( sum(inag008) as numeric(10,2))库存量,
	CAST(xmdd006 as numeric(10,2)) 订购数量,
	CAST(xmdd014 as numeric(10,2)) 已出货数量,
	CAST(xmdd031 as numeric(10,2)) 已转出货数量,
	CAST(xmdd016 as numeric(10,2)) 退换货数量,
	CAST(xmdd034 as numeric(10,2)) 已签退量, 
	CAST(xmdd015 as numeric(10,2)) 销退量,
	CAST(l_l as numeric(10,2)) 未出货量,
	NVL(l_j,0) 销退,NVL(l_m,0) 出货单出货量,to_char(xmdd011,'MM')||'/'||to_char(xmdd011,'dd') 出货日期,
	substr(to_char(xmdd011,'day'),3,1) 星期,
	xmdd011 出货, xmda007 销退号,
	(select  NVL(sum(NVL(xmdd006,0)-NVL(xmdd014,0)),0)l_l from xmdd_t@SOL 
		 LEFT JOIN xmda_t@SOL ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
    where 1=1 and a1.xmdadocnoj !='Y' and xmdd001=a1.xmdd001 AND xmddsite = a1.xmdasite and xmddent = a1.xmdaent  and NVL(xmdd006,0)-NVL(xmdd014,0)!=0 and xmdastus ='Y'
 and (xmdaud001 !='Y' or xmdaud001 is null) and substr(xmdadocno,4 ,5) in ('DLY11') ) 订单残1,
    (select  NVL(sum(NVL(xmdd006,0)-NVL(xmdd014,0)),0)l_l from xmdd_t@SOL 
		 LEFT JOIN xmda_t@SOL ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
    where 1=1 and a1.xmdadocnoj='Y' and xmdd001=a1.xmdd001 AND xmddsite = a1.xmdasite and xmddent = a1.xmdaent  and NVL(xmdd006,0)-NVL(xmdd014,0)!=0  and xmdastus ='Y' 
 and (xmdaud001 !='Y' or xmdaud001 is null) and substr(xmdadocno,4 ,5) in ('DLY07','DLY34','YY503','SHY13') ) 订单残2
    FROM (select DISTINCT (case substr(xmdadocno,4 ,5)
		when 'DLY07' then 'Y'
		when 'DLY34' then 'Y'
		when 'YY503' then 'Y'
		when 'SHY13' then 'Y'
		when 'SHY33' then 'D'
		else 'N' end ) xmdadocnoj,xmdaud003,xmdddocno,xmddseq,xmddseq1,xmddseq2,xmdd005,xmdd006,xmdd011,xmdd016,xmdd031 ,xmdd034 ,xmdd015 ,xmda007,imafua001, --add xmdaud003 by yangqt 2020/02/24
		xmdastus ,imaal003,xmdd001 , xmda022 ,pmab090,pmab091 ,pmab092,imafud001,ooag011,ooag003 ,xmdaent,xmdasite,imae034,imafud003,
		(case when xmdd014>=xmdd006 then xmdd006 when xmdd014<xmdd006 then xmdd014 end)xmdd014,
		(NVL(xmdd006,0)-NVL(xmdd014,0))l_l,
		(SELECT ooefl003 FROM ooefl_t@SOL WHERE ooefl001=ooag003 AND ooeflent=xmdaent AND ooefl002='zh_CN') l_d, 
		(SELECT pmaal004 FROM pmaal_t@SOL WHERE pmaal001=xmda022 AND pmaalent=xmdaent AND pmaal002='zh_CN') l_e,
		(SELECT ooefl003 FROM ooefl_t@SOL WHERE ooefl001=substr(imae034,1,5) AND ooeflent=xmdaent AND ooefl002='zh_CN') l_f,
		(SELECT oocql004 FROM oocql_t@SOL WHERE oocql002=pmab092 AND oocqlent=xmdaent AND oocql003='zh_CN' AND OOCQL001='315') l_k,
		NVL((select sum(xmdl018) from xmdl_t@SOL
		LEFT JOIN xmdk_t@SOL ON xmdldocno=xmdkdocno AND xmdlent=xmdkent
		where xmdl008=xmdd001 AND xmdlent=xmdaent AND xmdl003 = xmdddocno and xmdl004=XMDDSEQ 
		and xmddseq=xmdl004 and xmddseq1=xmdl005 and xmddseq2=xmdl006 and xmdk082 not in ('1','4') and xmdl018 !=0 and xmdk000 not in ('X','S') --add xmdk000 by xx 2020/04/10 销退单状态
		),0) l_j,
        NVL((select sum(xmdl018) from xmdl_t@SOL
		LEFT JOIN xmdk_t@SOL ON xmdldocno=xmdkdocno AND xmdlent=xmdkent
		where xmdl008=xmdd001 AND xmdlent=xmdaent AND xmdl003 = xmdddocno and xmdl004=XMDDSEQ 
		and xmddseq=xmdl004 and xmddseq1=xmdl005 and xmddseq2=xmdl006 and xmdastus ='Y' and xmdk026=xmdd011 and xmdk000 not in ('X','S') --add xmdk000 by xx 2020/04/10 出货单状态
		),0) l_m
	FROM xmda_t@SOL  
		 LEFT JOIN xmdd_t@SOL ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcdocno = xmdddocno AND xmdcseq = xmddseq
		 LEFT JOIN imaal_t@SOL t3 ON t3.imaalent=xmddent AND t3.imaal001=xmdd001 AND t3.imaal002='zh_CN' 
		 LEFT JOIN pmab_t@SOL ON xmda022 = pmab001 AND pmabent = xmdaent AND pmabsite = xmdasite 
		 LEFT JOIN imaf_t@SOL ON xmdd001 = imaf001 AND imafent = xmdaent AND imafsite = xmdasite 
		 LEFT JOIN ooag_t@SOL ON ooag001=imafud001 AND ooagent=xmdaent 
		 LEFT JOIN imae_t@SOL ON imae001=xmdd001 AND imaeent=xmdaent AND imaesite = xmdasite 
		 LEFT JOIN xmdg_t@SOL ON xmdg004=xmdddocno AND xmdgent=xmddent --and xmdgstus='Y'
		 where 1=1 
and xmdaent = '100' and xmdasite ='SOL'  --and xmdastus != 'X'
and xmdastus ='Y'--not in('X','C') 19/12/3 xx改已审核
--and xmdd015=0 --销退数量
and xmdc045='1'
and (xmdaud001 !='Y' or xmdaud001 is null)
and substr(xmda003,1,5)  in ('${comboCheckBox1}','MBGYY','MBHY1','MBHY2')
${IF(LEN(comboCheckBox2) = 0, "", " AND xmdd001 IN ('"+comboCheckBox2+"')")}
${IF(LEN(comboCheckBox3) = 0, "", " AND xmda022 IN ('"+comboCheckBox3+"')")}
${IF(LEN(comboCheckBox4) = 0, "", " AND ooag001 IN ('"+comboCheckBox4+"')")}
		) a1
LEFT JOIN inag_t@MBH ON inag001=xmdd001 AND inagent=xmdaent and inag004='ZC11' and inag005 in ('1101','1102') --排除可退库存
LEFT JOIN (select distinct imabuc001,sum(MBH01) 整袋数,sum(nvl(MBH02,MBH03)) 整盒数,sum(MBH04) 整箱数,sum(NVL(MBH05,MBH06)) 整板数 from imabuc_t@MBH
                    pivot
                        (
                          sum(imabuc005)
                            for imabuc003 in ('MBH01' MBH01,'MBH02' MBH02,'MBH03' MBH03,'MBH04' MBH04,'MBH05' MBH05,'MBH06' MBH06)                 )
 where imabuc002='Y'  group by imabuc001    )a on a.imabuc001=xmdd001 
where 1=1 and xmdd011 BETWEEN TO_DATE('${dateEditor0}','yyyy-mm-dd') and TO_DATE('${dateEditor1}','yyyy-mm-dd')  
AND  substr(xmdddocno,4 ,5) IN ('DLY11','DLY34') --add by yangqt 19/8/30
${If(LEN(comboCheckBox0) = 0,"",If(comboCheckBox0 = '5', "And xmda007 = '5'","And xmdadocnoj in ('" + comboCheckBox0 + "')"))}
and  l_l>0
Group By xmdddocno,xmdaud003,xmda022,xmddseq ,xmddseq1 ,xmddseq2 ,l_e ,ooag003,l_d ,imafud001 ,ooag011 ,pmab090,pmab091,pmab092 ,xmdastus,xmdd001 ,imaal003,imafua001,imafud003, --add xmdaud003 by yangqt 2020/02/24
xmdd006 ,l_l ,xmdd016 ,xmdd034 ,xmdd015,xmdd031  --,month(xmdd011)
,xmdd014,xmdasite,imae034,l_f,xmdd011,l_k,xmdadocnoj,l_j,xmda007,l_m,xmdaent,
a.整袋数,a.整盒数, a.整箱数,a.整板数
union all
SELECT 
    distinct xmdddocno 单号,
    --add by yangqt 2020/02/24
    CASE xmdaud003 
    WHEN '1' THEN '第一生产本部'
    WHEN '2' THEN '第二生产本部'
    ELSE '其他'
    END 接单部门,
    --end add
	xmddseq 项次,
	xmddseq1 项序,
	xmddseq2 批序,
	xmdadocnoj 样品,
	xmdastus 状态码,
	ooag003 部门编号,
	l_d 业务部门,
    a.整袋数,
    a.整盒数,
    a.整箱数,
    a.整板数,
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
    imafua001 纳品仓库,
	NVL(l_f,imae034) 供应商,
	CAST( sum(inag008) as numeric(10,2))库存量,
	CAST(xmdd006 as numeric(10,2)) 订购数量,
	CAST(xmdd014 as numeric(10,2)) 已出货数量,
	CAST(xmdd031 as numeric(10,2)) 已转出货数量,
	CAST(xmdd016 as numeric(10,2)) 退换货数量,
	CAST(xmdd034 as numeric(10,2)) 已签退量, 
	CAST(xmdd015 as numeric(10,2)) 销退量,
	CAST(l_l as numeric(10,2)) 未出货量,
	NVL(l_j,0) 销退,NVL(l_m,0) 出货单出货量,to_char(xmdd011,'MM')||'/'||to_char(xmdd011,'dd') 出货日期,
	substr(to_char(xmdd011,'day'),3,1) 星期,
	xmdd011 出货, xmda007 销退号,
	(select  NVL(sum(NVL(xmdd006,0)-NVL(xmdd014,0)),0)l_l from xmdd_t@MBH 
		 LEFT JOIN xmda_t@MBH ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
    where 1=1 and a1.xmdadocnoj !='Y' and xmdd001=a1.xmdd001 AND xmddsite = a1.xmdasite and xmddent = a1.xmdaent  and NVL(xmdd006,0)-NVL(xmdd014,0)!=0 and xmdastus ='Y' 
 and (xmdaud001 !='Y' or xmdaud001 is null) and substr(xmdadocno,4 ,5) in ('SHY03','SHY33') ) 订单残1,
    (select  NVL(sum(NVL(xmdd006,0)-NVL(xmdd014,0)),0)l_l from xmdd_t@MBH 
		 LEFT JOIN xmda_t@MBH ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
    where 1=1 and a1.xmdadocnoj='Y' and xmdd001=a1.xmdd001 AND xmddsite = a1.xmdasite and xmddent = a1.xmdaent  and NVL(xmdd006,0)-NVL(xmdd014,0)!=0 and xmdastus ='Y'
 and (xmdaud001 !='Y' or xmdaud001 is null) and substr(xmdadocno,4 ,5) in ('DLY07','DLY34','YY503','SHY13') ) 订单残2
    FROM (select DISTINCT (case substr(xmdadocno,4 ,5)
		when 'DLY07' then 'Y'
		when 'DLY34' then 'Y'
		when 'YY503' then 'Y'
		when 'SHY13' then 'Y'
		when 'SHY33' then 'D'
		else 'N' end ) xmdadocnoj,xmdaud003,xmdddocno,xmddseq,xmddseq1,xmddseq2,xmdd005,xmdd006,xmdd011,xmdd016,xmdd031 ,xmdd034 ,xmdd015 ,xmda007,imafua001,--add xmdaud003 by yangqt 2020/02/24
		xmdastus ,imaal003,xmdd001 , xmda022 ,pmab090,pmab091 ,pmab092,imafud001,ooag011,ooag003 ,xmdaent,xmdasite,imae034,imafud003,
		(case when xmdd014>=xmdd006 then xmdd006 when xmdd014<xmdd006 then xmdd014 end)xmdd014,
		(NVL(xmdd006,0)-NVL(xmdd014,0))l_l,
		(SELECT ooefl003 FROM ooefl_t@MBH WHERE ooefl001=ooag003 AND ooeflent=xmdaent AND ooefl002='zh_CN') l_d, 
		(SELECT pmaal004 FROM pmaal_t@MBH WHERE pmaal001=xmda022 AND pmaalent=xmdaent AND pmaal002='zh_CN') l_e,
		(SELECT ooefl003 FROM ooefl_t@MBH WHERE ooefl001=substr(imae034,1,5) AND ooeflent=xmdaent AND ooefl002='zh_CN') l_f,
		(SELECT oocql004 FROM oocql_t@MBH WHERE oocql002=pmab092 AND oocqlent=xmdaent AND oocql003='zh_CN' AND OOCQL001='315') l_k,
		NVL((select sum(xmdl018) from xmdl_t@MBH
		LEFT JOIN xmdk_t@MBH ON xmdldocno=xmdkdocno AND xmdlent=xmdkent
		where xmdl008=xmdd001 AND xmdlent=xmdaent AND xmdl003 = xmdddocno and xmdl004=XMDDSEQ 
		and xmddseq=xmdl004 and xmddseq1=xmdl005 and xmddseq2=xmdl006 and xmdastus ='Y' and xmdl018 !=0 and xmdk000 not in ('X','S') --add xmdk000 by xx 2020/04/10 销退单状态
		),0) l_j,
        NVL((select sum(xmdl018) from xmdl_t@MBH
		LEFT JOIN xmdk_t@MBH ON xmdldocno=xmdkdocno AND xmdlent=xmdkent
		where xmdl008=xmdd001 AND xmdlent=xmdaent AND xmdl003 = xmdddocno and xmdl004=XMDDSEQ 
		and xmddseq=xmdl004 and xmddseq1=xmdl005 and xmddseq2=xmdl006 and xmdastus ='Y' and xmdk026=xmdd011 and xmdk000 not in ('X','S') --add xmdk000 by xx 2020/04/10 出货单状态
		),0) l_m
	FROM xmda_t@MBH  
		 LEFT JOIN xmdd_t@MBH ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN xmdc_t@MBH ON xmdcent = xmdaent AND xmdcdocno = xmdddocno AND xmdcseq = xmddseq
		 LEFT JOIN imaal_t@MBH t3 ON t3.imaalent=xmddent AND t3.imaal001=xmdd001 AND t3.imaal002='zh_CN' 
		 LEFT JOIN pmab_t@MBH ON xmda022 = pmab001 AND pmabent = xmdaent AND pmabsite = xmdasite 
		 LEFT JOIN imaf_t@MBH ON xmdd001 = imaf001 AND imafent = xmdaent AND imafsite = xmdasite 
		 LEFT JOIN ooag_t@MBH ON ooag001=imafud001 AND ooagent=xmdaent 
		 LEFT JOIN imae_t@MBH ON imae001=xmdd001 AND imaeent=xmdaent AND imaesite = xmdasite 
		 LEFT JOIN xmdg_t@MBH ON xmdg004=xmdddocno AND xmdgent=xmddent --and xmdgstus='Y'
		 where 1=1  
         and ((xmda004 ='THK' and  substr(xmdadocno,4 ,5)='SHY33') OR xmda004 !='THK')
and xmdaent = '100' and xmdasite ='MBH'  --and xmdastus != 'X'
and xmdastus ='Y'--not in('X','C') 19/12/3 xx改已审核
--and xmdd015=0 --销退数量
and xmdc045='1'
AND substr(xmdadocno,4,5) IN 
(SELECT ooac002 
FROM ooac_t@MBH
WHERE ooacent = 100
AND ooac001 = (SELECT ooef004 FROM ooef_t@MBH WHERE ooefent = 100 AND ooef001 = 'MBH')
AND ooac003 = 'D-BASC0003'
AND ooac004 = '4')
and (xmdaud001 !='Y' or xmdaud001 is null)
and substr(xmda003,1,5)  in ('${comboCheckBox1}','MBGYY','MBHY1','MBHY2')
${IF(LEN(comboCheckBox2) = 0, "", " AND xmdd001 IN ('"+comboCheckBox2+"')")}
${IF(LEN(comboCheckBox3) = 0, "", " AND xmda022 IN ('"+comboCheckBox3+"')")}
${IF(LEN(comboCheckBox4) = 0, "", " AND ooag001 IN ('"+comboCheckBox4+"')")}
		) a1
LEFT JOIN inag_t@MBH ON inag001=xmdd001 AND inagent=xmdaent and inag004='ZC11' and inag005 in ('1101','1102') --排除可退库存
LEFT JOIN (select distinct imabuc001,sum(MBH01) 整袋数,sum(nvl(MBH02,MBH03)) 整盒数,sum(MBH04) 整箱数,sum(NVL(MBH05,MBH06)) 整板数 from imabuc_t@MBH
                    pivot
                        (
                          sum(imabuc005)
                            for imabuc003 in ('MBH01' MBH01,'MBH02' MBH02,'MBH03' MBH03,'MBH04' MBH04,'MBH05' MBH05,'MBH06' MBH06)                )
 where imabuc002='Y'  group by imabuc001    )a on a.imabuc001=xmdd001 
where 1=1 and xmdd011 BETWEEN TO_DATE('${dateEditor0}','yyyy-mm-dd') and TO_DATE('${dateEditor1}','yyyy-mm-dd')  
AND  substr(xmdddocno,4 ,5) IN ('SHY03','SHY13','SHY33') --add by yangqt 19/8/30
AND substr(xmdddocno,4,5) IN 
(SELECT ooac002 
FROM ooac_t@MBH
WHERE ooacent = 100
AND ooac001 = (SELECT ooef004 FROM ooef_t@MBH WHERE ooefent = 100 AND ooef001 = 'MBH')
AND ooac003 = 'D-BASC0003'
AND ooac004 = '4')
${If(LEN(comboCheckBox0) = 0,"",If(comboCheckBox0 = '5', "And xmda007 = '5'","And xmdadocnoj in ('" + comboCheckBox0 + "')"))}
and  l_l >0
Group By xmdddocno,xmdaud003,xmda022,xmddseq ,xmddseq1 ,xmddseq2 ,l_e ,ooag003,l_d ,imafud001 ,ooag011 ,pmab090,pmab091,pmab092 ,xmdastus,xmdd001 ,imaal003,imafua001,imafud003, --add xmdaud003 by yangqt 2020/02/24
xmdd006 ,l_l ,xmdd016 ,xmdd034 ,xmdd015,xmdd031  --,month(xmdd011)
,xmdd014,xmdasite,imae034,l_f,xmdd011,l_k,xmdadocnoj,l_j,xmda007,l_m,xmdaent,
a.整袋数,a.整盒数, a.整箱数,a.整板数
order by 出货,单号

    
  select distinct imaal003,xmdd001,XMDA022,(NVL(xmdd006,0)-NVL(xmdd014,0)) mm from xmda_t@SOL
		 LEFT JOIN xmdd_t@SOL ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN imaal_t@SOL t3 ON t3.imaalent=xmdaent AND t3.imaal001=xmdd001 AND t3.imaal002='zh_CN' 
		 LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcdocno = xmdddocno AND xmdcseq = xmddseq
		 where 1=1 and NVL(xmdd006,0)-NVL(xmdd014,0) >0
and xmdaent = '100' and xmdastus !='x' and xmdasite ='SOL'
--and XMDA022='03605'
and xmdaent = '100' and xmdasite ='SOL'  
and xmdastus not in('X','C') 
and xmdd015=0 
and xmdc045='1'
and (xmdaud001 !='Y' or xmdaud001 is null)
and xmdd011 BETWEEN TO_DATE('${dateEditor0}','yyyy-mm-dd') and TO_DATE('${dateEditor1}','yyyy-mm-dd')  
AND  substr(xmdddocno,4 ,5) IN ('DLY11','DLY34') --add by yangqt 19/8/30
union all
  select distinct imaal003,xmdd001,XMDA022,(NVL(xmdd006,0)-NVL(xmdd014,0)) mm from xmda_t@MBH
		 LEFT JOIN xmdd_t@MBH ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN imaal_t@MBH t3 ON t3.imaalent=xmdaent AND t3.imaal001=xmdd001 AND t3.imaal002='zh_CN' 
		 LEFT JOIN xmdc_t@MBH ON xmdcent = xmdaent AND xmdcdocno = xmdddocno AND xmdcseq = xmddseq
		 where 1=1 and NVL(xmdd006,0)-NVL(xmdd014,0) >0
and xmdaent = '100' and xmdastus !='x' and xmdasite ='MBH'
--and XMDA022='03605'
and xmdaent = '100' and xmdasite ='MBH'  
and xmdastus not in('X','C') 
--and xmdd015=0 
and xmdc045='1'
and (xmdaud001 !='Y' or xmdaud001 is null)
and xmdd011 BETWEEN TO_DATE('${dateEditor0}','yyyy-mm-dd') and TO_DATE('${dateEditor1}','yyyy-mm-dd')  
AND  substr(xmdddocno,4 ,5) IN ('SHY03','SHY13','SHY33') --add by yangqt 19/8/30
AND substr(xmdddocno,4,5) IN 
(SELECT ooac002 FROM ooac_t@MBH WHERE ooacent = 100
AND ooac001 = (SELECT ooef004 FROM ooef_t@MBH WHERE ooefent = 100 AND ooef001 = 'MBH')
AND ooac003 = 'D-BASC0003' AND ooac004 = '4')


select distinct * from (
select distinct
	imafud001 营业担当码,
	ooag011 营业担当 	FROM xmda_t@SOL  
		 LEFT JOIN xmdd_t@SOL ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN imaf_t@SOL ON xmdd001 = imaf001 AND imafent = xmdaent AND imafsite = xmdasite 
		 LEFT JOIN ooag_t@SOL ON ooag001=imafud001 AND ooagent=xmdaent
where 1=1 and xmdd011 BETWEEN TO_DATE('${dateEditor0}','yyyy-mm-dd') and TO_DATE('${dateEditor1}','yyyy-mm-dd')   
AND  substr(xmdddocno,4 ,5) IN ('DLY11','DLY34') --add by yangqt 19/8/30
union all
select distinct
	imafud001 营业担当码,
	ooag011 营业担当 	FROM xmda_t@MBH  
		 LEFT JOIN xmdd_t@MBH ON xmddent = xmdaent AND xmdddocno = xmdadocno AND xmddsite = xmdasite 
		 LEFT JOIN imaf_t@MBH ON xmdd001 = imaf001 AND imafent = xmdaent AND imafsite = xmdasite 
		 LEFT JOIN ooag_t@MBH ON ooag001=imafud001 AND ooagent=xmdaent
where 1=1  --and imafud001 like 'MBG%'  
AND  substr(xmdddocno,4 ,5) IN ('SHY03','SHY13','SHY33') --add by yangqt 19/8/30
and xmdd011 BETWEEN TO_DATE('${dateEditor0}','yyyy-mm-dd') and TO_DATE('${dateEditor1}','yyyy-mm-dd') 
AND substr(xmdddocno,4,5) IN 
(SELECT ooac002 FROM ooac_t@MBH WHERE ooacent = 100
AND ooac001 = (SELECT ooef004 FROM ooef_t@MBH WHERE ooefent = 100 AND ooef001 = 'MBH')
AND ooac003 = 'D-BASC0003' AND ooac004 = '4') 
)a
order by 营业担当码

