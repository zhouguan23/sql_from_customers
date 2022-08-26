select distinct a.union_area_name,a.area_name,a.area_code,a.trans_party_relation,a.sorted from dim_region a
where
 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")}
--order by a.area_code
--order by decode(a.area_code,'00','00',union_area_name),a.area_code
order by sorted

--累计完成率区域

select area_code,sum(累计销售),sum(销售指标),(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select area_code,(case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
group by area_code
union all
select area_code,0 累计销售, (case when '${Tax}'='无税' then sum(value) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY')
group by area_code)
group by area_code

--累计完成率区域加盟配送

select area_code,sum(累计销售),sum(销售指标),(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select area_code,(case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
and  attribute='加盟'
group by area_code
union all
select area_code,0 累计销售, (case when '${Tax}'='无税' then sum(mem) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY')
group by area_code)
group by area_code

--区域累计完成率剔除关联交易

select area_code,sum(累计销售),sum(销售指标),(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select area_code,(case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
group by area_code
union all
select area_code,0 累计销售, (case when '${Tax}'='无税' then sum(value) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY')
group by area_code)
group by area_code

--累计完成率区域批发

select area_code,sum(累计销售),sum(销售指标),(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select area_code,(case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
and  attribute='批发'
group by area_code
union all
select area_code,0 累计销售, (case when '${Tax}'='无税' then sum(batch) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY')
group by area_code)
group by area_code
order by 1

--累计完成率国大整体

select sum(累计销售),sum(销售指标),(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select (case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
union all
select 0 累计销售, (case when '${Tax}'='无税' then sum(value) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY'))

--累计完成率国大整体加盟配送

select sum(累计销售),sum(销售指标),(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select (case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
and  attribute='加盟'
union all
select 0 累计销售, (case when '${Tax}'='无税' then sum(mem) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY'))

--累计完成率国大整体剔除关联交易

select sum(累计销售),sum(销售指标),(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select (case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
union all
select 0 累计销售, (case when '${Tax}'='无税' then sum(value) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY'))

--累计完成率国大整体批发

select sum(累计销售),sum(销售指标),(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select (case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
and  attribute='批发'
union all
select 0 累计销售, (case when '${Tax}'='无税' then sum(batch) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY'))

--加盟配送对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='加盟'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

--剔除关联交易合计对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额
from dm_monthly_company a,dim_region b 
where 
((related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否'))
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

--整体批发对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

--批发关联交易对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and RELATED_PARTY_TRNSACTION ='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code


--直营对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(to_date('${end_date1}', 'yyyy-mm-dd')-to_date('${start_date1}', 'yyyy-mm-dd'))+1 as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

--DTP直营对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

--非DTP直营对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='否'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

--非DTP直营线上（O2O）对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

--非DTP直营线下对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

--加盟配送
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='加盟'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--剔除关联交易合计
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额
from dm_monthly_company a,dim_region b 
where 
((related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否'))
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--批发
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--批发关联交易
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and RELATED_PARTY_TRNSACTION ='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--直营
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(to_date('${end_date}', 'yyyy-mm-dd')-to_date('${start_date}', 'yyyy-mm-dd'))as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--区域DTP直营
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--非DTP直营
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--非DTP直营线上（O2O）
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--非DTP直营线下
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--加盟配送同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='加盟'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--剔除关联交易合计同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额
from dm_monthly_company a,dim_region b 
where 
((related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否'))
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--批发同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--批发关联交易同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and RELATED_PARTY_TRNSACTION ='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--直营同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)-add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12))as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
--and is_b2c!='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--DTP直营同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--非DTP直营同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--非DTP直营线上（O2O）同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--非DTP直营线下同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--加盟配送同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='加盟'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)


--剔除关联交易合计同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额
from dm_monthly_company a,dim_region b 
where 
 RELATED_PARTY_TRNSACTION ='否'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--批发同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--批发关联交易同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and RELATED_PARTY_TRNSACTION ='是'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--直营同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)-add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12))+1 as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--DTP直营同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--非DTP直营同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--非DTP直营线上（O2O）同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--非DTP直营线下同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--加盟配送
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='加盟'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--剔除关联交易合计
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额
from dm_monthly_company a,dim_region b 
where 
 RELATED_PARTY_TRNSACTION ='否'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/

and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--批发
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--批发关联交易
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and RELATED_PARTY_TRNSACTION ='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--直营
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(to_date('${end_date}', 'yyyy-mm-dd')-to_date('${start_date}', 'yyyy-mm-dd'))+1 as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--国大整体DTP直营
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--非DTP直营线下
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--非DTP直营
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--非DTP直营线上（O2O）
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--加盟配送对比期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='加盟'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

--剔除关联交易合计对比期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额
from dm_monthly_company a,dim_region b 
where 
 RELATED_PARTY_TRNSACTION ='否'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

--整体批发对比期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

--批发关联交易对比期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and RELATED_PARTY_TRNSACTION ='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

--直营对比期
select
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(to_date('${end_date1}', 'yyyy-mm-dd')-to_date('${start_date1}', 'yyyy-mm-dd'))+1 as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'

and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')


--DTP直营对比期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='是'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

--非DTP直营对比期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

--非DTP直营对比期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

--非DTP直营线下对比期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额
from dm_monthly_company a,dim_region b
where attribute='直营'
and dtp='否'
and oto='否'
and nvl(is_b2c,'否')!='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

--直营
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(to_date('${end_date}', 'yyyy-mm-dd')-to_date('${start_date}', 'yyyy-mm-dd'))+1 as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and is_b2c='是'
and a.area_code=b.area_code
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

--直营同期
select 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)-add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12))+1 as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and is_b2c='是'
and a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

--b2c对比期
select
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(to_date('${end_date1}', 'yyyy-mm-dd')-to_date('${start_date1}', 'yyyy-mm-dd'))+1 as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and is_b2c='是'
and a.area_code=b.area_code

/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')


--直营
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(to_date('${end_date}', 'yyyy-mm-dd')-to_date('${start_date}', 'yyyy-mm-dd'))as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and is_b2c='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code

--直营同期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)-add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12))as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and is_b2c='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by a.area_code

--b2c对比期
select a.area_code,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  
else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
to_number(to_date('${end_date1}', 'yyyy-mm-dd')-to_date('${start_date1}', 'yyyy-mm-dd'))+1 as 天数
from dm_monthly_company a,dim_region b 
where attribute='直营'
and is_b2c='是'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
/*and sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')
group by a.area_code

select a.area_code,a.area_name,a.UNION_AREA_NAME,a.sorted from dim_region a /*, (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}*/
--${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
where 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
--order by decode(a.area_code,'00','AA',a.union_area_name),a.area_code
order by sorted

select a.area_code,a.area_name,a.UNION_AREA_NAME,a.sorted from dim_region a /*, (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}*/


--order by decode(a.area_code,'00','AA',a.union_area_name),a.area_code
order by sorted

