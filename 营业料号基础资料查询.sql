select distinct * from (
select distinct --xmdcsite,xmdysite,xmdusite, --xmdu002 核价,xmdy002 合同,xmdc001 订单,
t5.oocql004 料号状态,
case when xmdc001 is not null then '受注' when  xmdc001 is null and (xmdu002 is not null or xmdy002 is not null) then '报价' end 受注状态,
--xmdt004 核价,
--xmdx004 合同,
--xmda004 订单,
--xmaauc002 客户,
case when xmdc001 is not null then xmda004 when  xmdc001 is null and (xmdu002 is not null or xmdy002 is not null) then NVL(xmdt004,xmdx004) end 客户,

imaa001 料号,imaal003 品名,imaal004 规格,imaa133 图材,imaduc003 选材,imaduc004 材料供应商,
(case when imaa009 IN('101','104','106','107','108','109','201','203','206','402','504') then 'MBG第一生产部' 
        when imaa009 IN('102','103','105','202','204','403','505') then 'MBG第二生产部' else '' end) 生产部门,
nvl(t1.oocql004,imaa134) 种类,t2.oocql004 性能,t3.oocql004 规格2,t4.oocql004 市场用途,  t6.ooefl003 营业部门, t7. oocql004 产品分类
from imaa_t--物料
left join (select xmdu002,xmduent,xmdusite,xmdt004 from xmdu_t,xmdt_t where xmdudocno=xmdtdocno and xmdtstus in ('A','C','Y')) on imaa001=xmdu002 and imaaent=xmduent --核价单
left join (select xmdy002,xmdyent,xmdysite,xmdx004 from xmdy_t,xmdx_t where xmdydocno=xmdxdocno and xmdxstus in ('A','C','Y')) on imaa001=xmdy002 and imaaent=xmdyent  --合同单
left join (select xmdc001,xmdcent,xmdcsite,xmdcdocno,xmda004 from xmda_t,xmdc_t where xmdadocno=xmdcdocno and xmdastus in ('A','C','Y')) on imaa001=xmdc001 and imaaent=xmdcent and substr(xmdcdocno,4 ,5) !='YY504' --and imaa143=xmdcsite --订单
left join xmaauc_t on imaa001=xmaauc001 and imaaent=xmaaucent --客户
left join imaduc_t on imaa001=imaduc001 and imaaent=imaducent and imaduc005='Y' --选材
left join imaal_t on imaa001=imaal001 and imaaent=imaalent --分类码
left join imae_t on imaa001=imae001 and imaaent=imaeent --供应商
left join oocql_t t1 on t1.oocql002=imaa134 and imaaent=t1.oocqlent and t1.oocql001 = '2008' and t1.oocql003 = 'zh_CN'
left join oocql_t t2 on t2.oocql002=imaa135 and imaaent=t2.oocqlent and t2.oocql001 = '2009' and t2.oocql003 = 'zh_CN'
left join oocql_t t3 on t3.oocql002=imaa136 and imaaent=t3.oocqlent and t3.oocql001 = '2010' and t3.oocql003 = 'zh_CN'
left join oocql_t t4 on t4.oocql002=imaa137 and imaaent=t4.oocqlent and t4.oocql001 = '2011' and t4.oocql003 = 'zh_CN'
left join oocql_t t5 on t5.oocql002=imaa010 and imaaent=t5.oocqlent and t5.oocql001 = '210' and t5.oocql003 = 'zh_CN'
left join ooefl_t t6 on t6.ooefl001=xmaauc004 and imaaent=t6.ooeflent and t6.ooefl002 = 'zh_CN'
left join oocql_t t7 on t7.oocql002=imaa009 and imaaent=t7.oocqlent and t7.oocql001 = '205' and t7.oocql003 = 'zh_CN'
where 1=1  --and xmaauc002='08001'
and imaaent='98'  and substr(imaa009,0,2)='10' --产品类
and （xmdu002 is not null or xmdy002 is not null or xmdc001 is not null）
${IF(LEN(comboCheckBox1) = 0, "", " AND imaa001 IN ('"+comboCheckBox1+"')")}
${IF(LEN(comboCheckBox2) = 0, "", " AND ooefl003 IN ('"+comboCheckBox2+"')")}
${IF(radioGroup0 = "N", "", " AND (imaa134 is null or imaa135 is null or imaa137 is null)")}
union all  
select distinct --xmdcsite,xmdysite,xmdusite, --xmdu002 核价,xmdy002 合同,xmdc001 订单,
t5.oocql004 料号状态,
case when xmdc001 is not null then '受注' when  xmdc001 is null and (xmdu002 is not null or xmdy002 is not null) then '报价' end 受注状态,
--xmdt004 核价,
--xmdx004 合同,
--xmda004 订单,
--xmaauc002 客户,
case when xmdc001 is not null then xmda004 when  xmdc001 is null and (xmdu002 is not null or xmdy002 is not null) then NVL(xmdt004,xmdx004) end 客户,
imaa001 料号,imaal003 品名,imaal004 规格,imaa133 图材,imaduc003 选材,imaduc004 材料供应商,
(case when imaa009 IN('101','104','106','107','108','109','201','203','206','402','504') then 'MBH第一生产部' 
        when imaa009 IN('102','103','105','202','204','403','505') then 'MBH第二生产部' else '' end) 生产部门,
nvl(t1.oocql004,imaa134) 种类,t2.oocql004 性能,t3.oocql004 规格2,t4.oocql004 市场用途,t6.ooefl003 营业部门 , t7. oocql004 产品分类
from imaa_t@MBH--物料
left join (select xmdu002,xmduent,xmdusite,xmdt004 from xmdu_t@MBH,xmdt_t@MBH where xmdudocno=xmdtdocno and xmdtstus in ('A','C','Y')) on imaa001=xmdu002 and imaaent=xmduent --核价单
left join (select xmdy002,xmdyent,xmdysite,xmdx004 from xmdy_t@MBH,xmdx_t@MBH where xmdydocno=xmdxdocno and xmdxstus in ('A','C','Y')) on imaa001=xmdy002 and imaaent=xmdyent  --合同单
left join (select xmdc001,xmdcent,xmdcsite,xmdcdocno,xmda004 from xmda_t@MBH,xmdc_t@MBH where xmdadocno=xmdcdocno and xmdastus in ('A','C','Y')) on imaa001=xmdc001 and imaaent=xmdcent and substr(xmdcdocno,4 ,5) !='YY504' --and imaa143=xmdcsite --订单
left join xmaauc_t on imaa001=xmaauc001 --and imaaent=xmaaucent --客户
left join imaduc_t@MBH on imaa001=imaduc001 and imaduc005='Y' and imaaent=imaducent --选材
left join imaal_t@MBH on imaa001=imaal001 and imaaent=imaalent --分类码
left join imae_t@MBH on imaa001=imae001 and imaaent=imaeent --供应商
left join oocql_t@MBH t1 on t1.oocql002=imaa134 and imaaent=t1.oocqlent and t1.oocql001 = '2008' and t1.oocql003 = 'zh_CN'
left join oocql_t@MBH t2 on t2.oocql002=imaa135 and imaaent=t2.oocqlent and t2.oocql001 = '2009' and t2.oocql003 = 'zh_CN'
left join oocql_t@MBH t3 on t3.oocql002=imaa136 and imaaent=t3.oocqlent and t3.oocql001 = '2010' and t3.oocql003 = 'zh_CN'
left join oocql_t@MBH t4 on t4.oocql002=imaa137 and imaaent=t4.oocqlent and t4.oocql001 = '2011' and t4.oocql003 = 'zh_CN'
left join oocql_t@MBH t5 on t5.oocql002=imaa010 and imaaent=t5.oocqlent and t5.oocql001 = '210' and t5.oocql003 = 'zh_CN'
left join ooefl_t@MBH t6 on t6.ooefl001=xmaauc004 and imaaent=t6.ooeflent and t6.ooefl002 = 'zh_CN'
left join oocql_t@MBH t7 on t7.oocql002=imaa009 and imaaent=t7.oocqlent and t7.oocql001 = '205' and t7.oocql003 = 'zh_CN'
where 1=1 and substr(imaa009,0,2)='10' --产品类
and imaaent='100' --and xmdaud003 is not null
and （xmdu002 is not null or xmdy002 is not null or xmdc001 is not null）
${IF(LEN(comboCheckBox1) = 0, "", " AND imaa001 IN ('"+comboCheckBox1+"')")}
${IF(LEN(comboCheckBox2) = 0, "", " AND ooefl003 IN ('"+comboCheckBox2+"')")}
${IF(radioGroup0 = "N", "", " AND (imaa134 is null or imaa135 is null or imaa137 is null)")}
union all
select distinct --xmdcsite,xmdysite,xmdusite, --xmdu002 核价,xmdy002 合同,xmdc001 订单,
t5.oocql004 料号状态,
case when xmdc001 is not null then '受注' when  xmdc001 is null and (xmdu002 is not null or xmdy002 is not null) then '报价' end 受注状态,
--xmdt004 核价,
--xmdx004 合同,
--xmda004 订单,
--xmaauc002 客户,
case when xmdc001 is not null then xmda004 when  xmdc001 is null and (xmdu002 is not null or xmdy002 is not null) then NVL(xmdt004,xmdx004) end 客户,
imaa001 料号,imaal003 品名,imaal004 规格,imaa133 图材,imaduc003 选材,imaduc004 材料供应商,
(case when imaa009 IN('101','104','106','107','108','109','201','203','206','402','504') then 'MBH第一生产部' 
        when imaa009 IN('102','103','105','202','204','403','505') then 'MBH第二生产部' else '' end) 生产部门,
nvl(t1.oocql004,imaa134) 种类,t2.oocql004 性能,t3.oocql004 规格2,t4.oocql004 市场用途,t6.ooefl003 营业部门 , t7. oocql004 产品分类
from imaa_t@SOL--物料
left join (select xmdu002,xmduent,xmdusite,xmdt004 from xmdu_t@SOL,xmdt_t@SOL where xmdudocno=xmdtdocno and xmdtstus in ('A','C','Y')) on imaa001=xmdu002 and imaaent=xmduent --核价单
left join (select xmdy002,xmdyent,xmdysite,xmdx004 from xmdy_t@SOL,xmdx_t@SOL where xmdydocno=xmdxdocno and xmdxstus in ('A','C','Y')) on imaa001=xmdy002 and imaaent=xmdyent  --合同单
left join (select xmdc001,xmdcent,xmdcsite,xmdcdocno,xmda004 from xmda_t@SOL,xmdc_t@SOL where xmdadocno=xmdcdocno and xmdastus in ('A','C','Y')) on imaa001=xmdc001 and imaaent=xmdcent and substr(xmdcdocno,4 ,5) !='YY504' --and imaa143=xmdcsite --订单
left join xmaauc_t on imaa001=xmaauc001 --and imaaent=xmaaucent --客户
left join imaduc_t@SOL on imaa001=imaduc001 and imaduc005='Y' and imaaent=imaducent --选材
left join imaal_t@SOL on imaa001=imaal001 and imaaent=imaalent --分类码
--left join xmda_t on xmdcdocno=xmdadocno and imaaent=xmdaent --业务部门
left join imae_t@SOL on imaa001=imae001 and imaaent=imaeent --供应商
left join oocql_t@SOL t1 on t1.oocql002=imaa134 and imaaent=t1.oocqlent and t1.oocql001 = '2008' and t1.oocql003 = 'zh_CN'
left join oocql_t@SOL t2 on t2.oocql002=imaa135 and imaaent=t2.oocqlent and t2.oocql001 = '2009' and t2.oocql003 = 'zh_CN'
left join oocql_t@SOL t3 on t3.oocql002=imaa136 and imaaent=t3.oocqlent and t3.oocql001 = '2010' and t3.oocql003 = 'zh_CN'
left join oocql_t@SOL t4 on t4.oocql002=imaa137 and imaaent=t4.oocqlent and t4.oocql001 = '2011' and t4.oocql003 = 'zh_CN'
left join oocql_t@SOL t5 on t5.oocql002=imaa010 and imaaent=t5.oocqlent and t5.oocql001 = '210' and t5.oocql003 = 'zh_CN'
left join ooefl_t@SOL t6 on t6.ooefl001=xmaauc004 and t6.ooefl002 = 'zh_CN' --and imaaent=t6.ooeflent 
left join oocql_t@SOL t7 on t7.oocql002=imaa009 and imaaent=t7.oocqlent and t7.oocql001 = '205' and t7.oocql003 = 'zh_CN'
where 1=1  and substr(imaa009,0,2)='10' --产品类
--and imaa010='20' --生命周期状态  
and imaaent='100' --and xmdaud003 is not null
and （xmdu002 is not null or xmdy002 is not null or xmdc001 is not null）
${IF(LEN(comboCheckBox1) = 0, "", " AND imaa001 IN ('"+comboCheckBox1+"')")}
${IF(LEN(comboCheckBox2) = 0, "", " AND ooefl003 IN ('"+comboCheckBox2+"')")}
${IF(radioGroup0 = "N", "", " AND (imaa134 is null or imaa135 is null or imaa137 is null)")}
)
where 1=1
${IF(LEN(comboCheckBox0) = 0, "", " AND 客户 IN ('"+comboCheckBox0+"')")}
${IF(LEN(comboCheckBox3) = 0, "", " AND 生产部门 IN ('"+comboCheckBox3+"')")}
order by 料号

select distinct ooefl003,xmaauc002 from xmaauc_t
left join ooefl_t t6 on t6.ooefl001=xmaauc004 and t6.ooefl002 = 'zh_CN'
and ooefl003 is not null 


select distinct * from (
select distinct * from (
select distinct xmdu002,imaal003 from xmdu_t
left join xmdt_t on xmdudocno=xmdtdocno and xmduent=xmdtent and xmdtstus in ('A','C','Y')
left join imaal_t on xmdu002=imaal001 and xmduent=imaalent --分类码
where 1=1 and xmduent=98  --核价
union all
select distinct xmdy002,imaal003 from xmdy_t
left join xmdx_t on xmdydocno=xmdxdocno and xmdyent=xmdxent and xmdxstus in ('A','C','Y')
left join imaal_t on xmdy002=imaal001 and xmdyent=imaalent --分类码
where 1=1 and xmdyent=98  --合同
union all
select distinct xmdc001,imaal003 from xmdc_t
left join xmda_t on xmdcdocno=xmdadocno and xmdcent=xmdaent and xmdastus in ('A','C','Y') and substr(xmdcdocno,4 ,5) !='YY504'
left join imaal_t on xmdc001=imaal001 and xmdcent=imaalent --分类码
where 1=1 and xmdcent=98 ) --订单
union all
select distinct * from (
select distinct xmdu002,imaal003 from xmdu_t@MBH
left join xmdt_t@MBH on xmdudocno=xmdtdocno and xmduent=xmdtent and xmdtstus in ('A','C','Y')
left join imaal_t@MBH on xmdu002=imaal001 and xmduent=imaalent --分类码
where 1=1 and xmduent=100  --核价
union all
select distinct xmdy002,imaal003 from xmdy_t@MBH
left join xmdx_t@MBH on xmdydocno=xmdxdocno and xmdyent=xmdxent and xmdxstus in ('A','C','Y')
left join imaal_t@MBH on xmdy002=imaal001 and xmdyent=imaalent --分类码
where 1=1 and xmdyent=100  --合同
union all
select distinct xmdc001,imaal003 from xmdc_t@MBH
left join xmda_t@MBH on xmdcdocno=xmdadocno and xmdcent=xmdaent and xmdastus in ('A','C','Y') and substr(xmdcdocno,4 ,5) !='YY504'
left join imaal_t@MBH on xmdc001=imaal001 and xmdcent=imaalent --分类码
where 1=1 and xmdcent=100 ) --订单
union all
select distinct * from (
select distinct xmdu002,imaal003 from xmdu_t@SOL
left join xmdt_t@SOL on xmdudocno=xmdtdocno and xmduent=xmdtent and xmdtstus in ('A','C','Y')
left join imaal_t@SOL on xmdu002=imaal001 and xmduent=imaalent --分类码
where 1=1 and xmduent=100  --核价
union all
select distinct xmdy002,imaal003 from xmdy_t@SOL
left join xmdx_t@SOL on xmdydocno=xmdxdocno and xmdyent=xmdxent and xmdxstus in ('A','C','Y')
left join imaal_t@SOL on xmdy002=imaal001 and xmdyent=imaalent --分类码
where 1=1 and xmdyent=100  --合同
union all
select distinct xmdc001,imaal003 from xmdc_t@SOL
left join xmda_t@SOL on xmdcdocno=xmdadocno and xmdcent=xmdaent and xmdastus in ('A','C','Y') and substr(xmdcdocno,4 ,5) !='YY504'
left join imaal_t@SOL on xmdc001=imaal001 and xmdcent=imaalent --分类码
where 1=1 and xmdcent=100 )) --订单
order by xmdu002

