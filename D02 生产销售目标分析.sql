select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(数量/1000) end) 上半年数量,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(数量/1000) end) 下半年数量,
	sum(数量/1000) 全年数量,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(金额*isnull(Rate,1)/1000) end) 上半年金额,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(金额*isnull(Rate,1)/1000) end) 下半年金额,
	sum(金额*isnull(Rate,1)/1000) 全年金额,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(数量*isnull(单品数,0)/1000 ) end) 上半年单品,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(数量*isnull(单品数,0)/1000 ) end) 下半年单品,
	sum(数量*isnull(单品数,0)/1000 ) 全年单品,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
union all select * from ETL_ERP_Business_3
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where YEAR(xmdk001)='${yearEditor0}' )a 
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and substring(部门,1,5) ='MBGPM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,单据状态,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date)a
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and  单据状态 ='M' and substring(部门,1,5) ='MBGPM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
union all select * from ETL_ERP_Business_3
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
  where YEAR(xmdk001)='${yearEditor0}' )a 
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and  单据状态 !='M'and substring(部门,1,5) ='MBGPM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,单据状态,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(数量/1000) end) 上半年数量,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(数量/1000) end) 下半年数量,
	sum(数量/1000) 全年数量,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(金额*isnull(Rate,1)/1000) end) 上半年金额,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(金额*isnull(Rate,1)/1000) end) 下半年金额,
	sum(金额*isnull(Rate,1)/1000) 全年金额,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(数量*isnull(单品数,0)/1000 ) end) 上半年单品,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(数量*isnull(单品数,0)/1000 ) end) 下半年单品,
	sum(数量*isnull(单品数,0)/1000 ) 全年单品,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
union all select * from ETL_ERP_Business_3
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
 where YEAR(xmdk001)='${yearEditor0}' )a 
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and substring(部门,1,5) ='MBGQM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,单据状态,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date)a
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and  单据状态 ='M' and substring(部门,1,5) ='MBGQM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
union all select * from ETL_ERP_Business_3
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
 where YEAR(xmdk001)='${yearEditor0}')a 
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and  单据状态 !='M'and substring(部门,1,5) ='MBGQM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,单据状态,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(数量/1000) end) 上半年数量,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(数量/1000) end) 下半年数量,
	sum(数量/1000) 全年数量,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(金额*isnull(Rate,1)/1000) end) 上半年金额,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(金额*isnull(Rate,1)/1000) end) 下半年金额,
	sum(金额*isnull(Rate,1)/1000) 全年金额,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(数量*isnull(单品数,0)/1000 ) end) 上半年单品,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(数量*isnull(单品数,0)/1000 ) end) 下半年单品,
	sum(数量*isnull(单品数,0)/1000 ) 全年单品,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
union all select * from ETL_ERP_Business_3
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
  where YEAR(xmdk001)='${yearEditor0}' )a 
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and substring(部门,1,5) ='MBHPM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,单据状态,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date)a
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and  单据状态 ='M' and substring(部门,1,5) ='MBHPM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
union all select * from ETL_ERP_Business_3
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
 where YEAR(xmdk001)='${yearEditor0}' )a 
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and  单据状态 !='M'and substring(部门,1,5) ='MBHPM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,单据状态,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(数量/1000) end) 上半年数量,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(数量/1000) end) 下半年数量,
	sum(数量/1000) 全年数量,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(金额*isnull(Rate,1)/1000) end) 上半年金额,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(金额*isnull(Rate,1)/1000) end) 下半年金额,
	sum(金额*isnull(Rate,1)/1000) 全年金额,
	(case when month(日期) in ('1','2','3','4','5','6') then sum(数量*isnull(单品数,0)/1000 ) end) 上半年单品,
	(case when month(日期) in ('7','8','9','10','11','12') then sum(数量*isnull(单品数,0)/1000 ) end) 下半年单品,
	sum(数量*isnull(单品数,0)/1000 ) 全年单品,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
union all select * from ETL_ERP_Business_3
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
 where YEAR(xmdk001)='${yearEditor0}' )a 
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and substring(部门,1,5) ='MBHQM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,单据状态,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date)a
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and  单据状态 ='M' and substring(部门,1,5) ='MBHQM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,客户编码,物料,种类

select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
物料,品名,isnull(客户编码,'***') 客户编码,isnull(客户名,'###') 客户名,种类,year(日期) 年, month(日期) 月份,sum(数量/1000) 数量,sum(金额*isnull(Rate,1)/1000) 金额,单品数,sum(数量*isnull(单品数,0)/1000 ) 单品总数 from (
select * from ETL_ERP_Business_2 
left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
union all SELECT * FROM ETL_ERP_Business_1 
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
union all select * from ETL_ERP_Business_3
left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
 where YEAR(xmdk001)='${yearEditor0}' )a 
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and  单据状态 !='M'and substring(部门,1,5) ='MBHQM'
group by 日期,单据状态,物料,品名,客户编码,客户名,种类,单品数
order by 年,月份,单据状态,客户编码,物料,种类

