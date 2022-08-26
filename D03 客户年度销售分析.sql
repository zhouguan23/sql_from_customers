select 集团编码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团编码 )A ) ELSE 集团名称 END 集团名称,单据状态,sum(nu) nu

	from (select 客户编码,jt2.pmaa006 集团编码,jt2.oocql004 集团名称, (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu,
				(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
				when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' end) 单据状态 

			from (select * from ETL_ERP_Business_2 
				left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
				union all SELECT * FROM ETL_ERP_Business_1 
				left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
				where Bus_Type ='S')a
			LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
					SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
					SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
					SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
					WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	

where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and jt2.pmaa006 in( select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		group by jt1.pmaa006
		order by nu desc)c)
group by 客户编码,jt2.pmaa006,jt2.oocql004,日期,单据状态 ) d
group by 单据状态,集团编码,集团名称
order by 单据状态,nu desc

select 集团编码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团编码 )A ) ELSE 集团名称 END 集团名称,单据状态,sum(nu) nu

 from ( select 客户编码,jt2.pmaa006 集团编码,jt2.oocql004 集团名称,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
	from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

	LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	

where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and jt2.pmaa006 in(select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		group by jt1.pmaa006
		order by nu desc)c)
group by 客户编码,jt2.pmaa006,jt2.oocql004,日期,单据状态 ) d 
group by 单据状态,集团编码,集团名称

union all

select isnull(null,'其他'),isnull(null,'其他'), 单据状态,sum(nu) nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
	
	LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and jt2.pmaa006 not in(select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		group by jt1.pmaa006
		order by nu desc)c)
group by 日期,单据状态 ) d
group by 单据状态
order by 单据状态,nu desc

select 集团代码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团代码)A ) ELSE 集团名称 END 集团名称,客户编码,客户名称,单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select jt2.pmaa006 集团代码,jt2.oocql004 集团名称,客户编码,客户名称=(select 客户名
from (select ol.客户编码,客户名, row_number() OVER(PARTITION BY ol.客户编码 ORDER BY ol.客户编码) ds 
	from (SELECT distinct 客户编码,客户名 
		from (select * from ETL_ERP_Business_2 )t) ol) s where ds = 1 and a.客户编码=s.客户编码 ),
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and jt2.pmaa006 in( select 集团编码 from (
		select TOP 10 pmaa006 集团编码,(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu 
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
		SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
		WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		group by pmaa006
		order by 全年nu desc)c)
group by jt2.pmaa006,jt2.oocql004,客户编码,日期,单据状态 ) d
group by 单据状态,集团代码,客户编码,集团名称,客户名称
union all
select 集团代码,'' 集团名称,客户编码,客户名称=(select 客户名
from (select ol.客户编码,客户名, row_number() OVER(PARTITION BY ol.客户编码 ORDER BY ol.客户编码) ds 
	from (SELECT distinct 客户编码,客户名 
		from (select * from ETL_ERP_Business_2 )t) ol) s where ds = 1 and d.客户编码=s.客户编码 ),单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select '其他' 集团代码,客户编码,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and jt2.pmaa006 not in( select 集团编码 from (
		select TOP 10 pmaa006 集团编码,(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu 
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
		SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
		WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		group by pmaa006
		order by 全年nu desc)c)
group by jt2.oocql004,客户编码,日期,单据状态 ) d
group by 单据状态,集团代码,客户编码
union all
select 集团代码,'' 集团名称,客户代码,'' 客户名称,单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select '合计' 集团代码,'' 客户代码,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
group by jt2.oocql004,日期,单据状态 ) d
group by 单据状态,集团代码,客户代码
order by 单据状态,全年nu desc,集团代码

select 集团代码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团代码)A ) ELSE 集团名称 END 集团名称,客户编码,客户名称,单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select jt2.pmaa006 集团代码,jt2.oocql004 集团名称,客户编码,客户名称=(select 客户名
from (select ol.客户编码,客户名, row_number() OVER(PARTITION BY ol.客户编码 ORDER BY ol.客户编码) ds 
	from (SELECT distinct 客户编码,客户名 
		from (select * from ETL_ERP_Business_2 )t) ol) s where ds = 1 and a.客户编码=s.客户编码 ),
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
and jt2.pmaa006 in( select 集团编码 from (
		select TOP 10 pmaa006 集团编码,(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu 
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
		SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
		WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
		group by pmaa006
		order by 全年nu desc)c)
group by jt2.pmaa006,jt2.oocql004,客户编码,日期,单据状态 ) d
group by 单据状态,集团代码,客户编码,集团名称,客户名称
union all
select 集团代码,'' 集团名称,客户编码,客户名称=(select 客户名
from (select ol.客户编码,客户名, row_number() OVER(PARTITION BY ol.客户编码 ORDER BY ol.客户编码) ds 
	from (SELECT distinct 客户编码,客户名 
		from (select * from ETL_ERP_Business_2 )t) ol) s where ds = 1 and d.客户编码=s.客户编码 ),单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select '其他' 集团代码,客户编码,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
and jt2.pmaa006 not in( select 集团编码 from (
		select TOP 10 pmaa006 集团编码,(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu 
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
		SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
		WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
		group by pmaa006
		order by 全年nu desc)c)
group by jt2.oocql004,客户编码,日期,单据状态 ) d
group by 单据状态,集团代码,客户编码
union all
select 集团代码,'' 集团名称,客户代码,'' 客户名称,单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select '合计' 集团代码,'' 客户代码,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
group by jt2.oocql004,日期,单据状态 ) d
group by 单据状态,集团代码,客户代码
order by 单据状态,全年nu desc,集团代码

select 集团编码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团编码 )A ) ELSE 集团名称 END 集团名称,单据状态,sum(nu) nu

	from (select 客户编码,jt2.pmaa006 集团编码,jt2.oocql004 集团名称, (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu,
				(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
				when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' end) 单据状态 

			from (select * from ETL_ERP_Business_2 
				left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
				union all SELECT * FROM ETL_ERP_Business_1 
				left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
				where Bus_Type ='S')a
			LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
					SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
					SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
					SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
					WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	

where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
and jt2.pmaa006 in( select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
		group by jt1.pmaa006
		order by nu desc)c)
group by 客户编码,jt2.pmaa006,jt2.oocql004,日期,单据状态 ) d
group by 单据状态,集团编码,集团名称
order by 单据状态,nu desc

select 集团编码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团编码 )A ) ELSE 集团名称 END 集团名称,单据状态,sum(nu) nu

 from ( select 客户编码,jt2.pmaa006 集团编码,jt2.oocql004 集团名称,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
	from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

	LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	

where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
and jt2.pmaa006 in(select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
		group by jt1.pmaa006
		order by nu desc)c)
group by 客户编码,jt2.pmaa006,jt2.oocql004,日期,单据状态 ) d 
group by 单据状态,集团编码,集团名称

union all

select isnull(null,'其他'),isnull(null,'其他'), 单据状态,sum(nu) nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
	
	LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
and jt2.pmaa006 not in(select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBG' or substring(订单号,4,5) IN ('DLY07','DLY01','YY501','YY503','GY500','SGY01','SGY22','AY500','BY500','GS001','GS011'))
		group by jt1.pmaa006
		order by nu desc)c)
group by 日期,单据状态 ) d
group by 单据状态
order by 单据状态,nu desc

select 集团代码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团代码)A ) ELSE 集团名称 END 集团名称,客户编码,客户名称,单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select jt2.pmaa006 集团代码,jt2.oocql004 集团名称,客户编码,客户名称=(select 客户名
from (select ol.客户编码,客户名, row_number() OVER(PARTITION BY ol.客户编码 ORDER BY ol.客户编码) ds 
	from (SELECT distinct 客户编码,客户名 
		from (select * from ETL_ERP_Business_2 )t) ol) s where ds = 1 and a.客户编码=s.客户编码 ),
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
and jt2.pmaa006 in( select 集团编码 from (
		select TOP 10 pmaa006 集团编码,(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu 
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
		SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
		WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
		group by pmaa006
		order by 全年nu desc)c)
group by jt2.pmaa006,jt2.oocql004,客户编码,日期,单据状态 ) d
group by 单据状态,集团代码,客户编码,集团名称,客户名称
union all
select 集团代码,'' 集团名称,客户编码,客户名称=(select 客户名
from (select ol.客户编码,客户名, row_number() OVER(PARTITION BY ol.客户编码 ORDER BY ol.客户编码) ds 
	from (SELECT distinct 客户编码,客户名 
		from (select * from ETL_ERP_Business_2 )t) ol) s where ds = 1 and d.客户编码=s.客户编码 ),单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select '其他' 集团代码,客户编码,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
and jt2.pmaa006 not in( select 集团编码 from (
		select TOP 10 pmaa006 集团编码,(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu 
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
		SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
		SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
		WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
		group by pmaa006
		order by 全年nu desc)c)
group by jt2.oocql004,客户编码,日期,单据状态 ) d
group by 单据状态,集团代码,客户编码
union all
select 集团代码,'' 集团名称,客户代码,'' 客户名称,单据状态,sum(上半年nu) 上半年nu,sum(下半年nu) 下半年nu,sum(全年nu) 全年nu,
s=(select sum(全年nu) 全年nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
group by 日期,单据状态 ) p
where p.单据状态=d.单据状态
group by 单据状态)
 from ( select '合计' 集团代码,'' 客户代码,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	isnull((case when month(日期) in ('1','2','3','4','5','6') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 上半年nu,
	isnull((case when month(日期) in ('7','8','9','10','11','12') then (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) end),0) 下半年nu,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) 全年nu
from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
group by jt2.oocql004,日期,单据状态 ) d
group by 单据状态,集团代码,客户代码
order by 单据状态,全年nu desc,集团代码

select 集团编码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团编码 )A ) ELSE 集团名称 END 集团名称,单据状态,sum(nu) nu

	from (select 客户编码,jt2.pmaa006 集团编码,jt2.oocql004 集团名称, (case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu,
				(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
				when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' end) 单据状态 

			from (select * from ETL_ERP_Business_2 
				left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
				union all SELECT * FROM ETL_ERP_Business_1 
				left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
				where Bus_Type ='S')a
			LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
					SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
					SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
					SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
					WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	

where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
and jt2.pmaa006 in( select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
		group by jt1.pmaa006
		order by nu desc)c)
group by 客户编码,jt2.pmaa006,jt2.oocql004,日期,单据状态 ) d
group by 单据状态,集团编码,集团名称
order by 单据状态,nu desc

select 集团编码,CASE WHEN 集团名称 IS NULL THEN (SELECT TOP 1 pmaal004 FROM (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,pmaal004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,pmaal004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_pmaal_t ON pmaalent = 98 AND pmaal001 = pmaa001 UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001') UNION ALL 
			SELECT pmaa001,pmaa006,pmaal004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN pmaal_t ON pmaalent = 100 AND pmaal001 = pmaa001'))X1 )Y1
			WHERE rowid = 1 AND pmaa006 = 集团编码 )A ) ELSE 集团名称 END 集团名称,单据状态,sum(nu) nu

 from ( select 客户编码,jt2.pmaa006 集团编码,jt2.oocql004 集团名称,
	(case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
	from (select * from ETL_ERP_Business_2 
		left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
		 where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)a

	LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	

where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
and jt2.pmaa006 in(select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
		group by jt1.pmaa006
		order by nu desc)c)
group by 客户编码,jt2.pmaa006,jt2.oocql004,日期,单据状态 ) d 
group by 单据状态,集团编码,集团名称

union all

select isnull(null,'其他'),isnull(null,'其他'), 单据状态,sum(nu) nu
 from (select (case when year(日期)='${yearEditor0}'-1 and 单据状态='S' then '去年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='S' then '今年实际' 
	when year(日期)='${yearEditor0}' and 单据状态='Y' then '销售预测' 
	when year(日期)='${yearEditor0}' and 单据状态='M' then '年度目标'end) 单据状态,
	(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
	from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where Bus_Type !='Y' or (Bus_Type='Y'and datediff(MM,xmdk001,getdate())<=0)
			union all select * from ETL_ERP_Business_3
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date
			where YEAR(xmdk001)='${yearEditor0}' and datediff(MM,xmdk001,getdate())>0)o
	
	LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001) pmaa006,oocql004,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006,oocql004 FROM ETL_ERP_pmaa_t LEFT JOIN ETL_ERP_oocql_t ON OOCQLENT = '98' AND OOCQL001 = '261' AND OOCQL002 = pmaa006 AND OOCQL003 = 'zh_CN' UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006') UNION ALL 
			SELECT pmaa001,pmaa006,oocql004 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t LEFT JOIN oocql_t ON OOCQLENT = 100 AND OOCQL001 = 261 AND OOCQL002 = pmaa006'))X1 )Y1
			WHERE rowid = 1)jt2 ON jt2.pmaa001 = 客户编码	
where (YEAR(日期)='${yearEditor0}' or (YEAR(日期)='${yearEditor0}'-1 and 单据状态='s'))
and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
and jt2.pmaa006 not in(select 集团编码 from (
		select TOP 10 jt1.pmaa006 集团编码,
		(case '${comboBox0}' when '数量' then sum(isnull(数量,0)/1000)
							when '金额' then isnull(sum(金额*isnull(Rate,1)/1000),0)
							when '单品数' then sum(isnull(数量,0)*isnull(单品数,0)/1000) end) nu
		from (select * from ETL_ERP_Business_2 
			left join THSL_DW.dbo.[FILL_Currency]A on 币种=Cur_Code and 日期 between Effective_date and Expiration_date
			union all SELECT * FROM ETL_ERP_Business_1 
			left join THSL_DW.dbo.[FILL_Currency]A on xmda015=Cur_Code and xmdk001 between Effective_date and Expiration_date) b
		LEFT JOIN (SELECT * FROM (SELECT pmaa001,isnull(pmaa006,pmaa001)pmaa006,(ROW_NUMBER() over(PARTITION By pmaa001 order by pmaa006 desc)) rowid  FROM(
			SELECT pmaa001,pmaa006 FROM ETL_ERP_pmaa_t UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_SOL, 'SELECT * FROM pmaa_t ') UNION ALL 
			SELECT pmaa001,pmaa006 FROM OPENQUERY(DB_ERP_MBH, 'SELECT * FROM pmaa_t'))X2 )Y2
			WHERE rowid = 1)jt1 ON jt1.pmaa001 = 客户编码
		where year(日期)='${yearEditor0}' and 单据状态='S'
		and (据点='MBH' or substring(订单号,4,5) IN ('DLY11','DLY34','SGY08','SGY29','SY03','SY13','SY33','HS001','HS011'))
		group by jt1.pmaa006
		order by nu desc)c)
group by 日期,单据状态 ) d
group by 单据状态
order by 单据状态,nu desc

