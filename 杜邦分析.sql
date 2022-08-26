--批发关联交易
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and RELATED_PARTY_TRNSACTION ='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and RELATED_PARTY_TRNSACTION ='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--批发
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='批发'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
)


--B2C
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and is_b2c='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and is_b2c='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--加盟配送
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='加盟'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='加盟'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--直营
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--DTP直营
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--非DTP直营
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='否'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='否'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--非DTP直营线上（O2O）
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='否'
and oto='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='否'
and oto='是'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--非DTP直营线下
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='否'
and oto='否'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where attribute='直营'
and nvl(is_b2c,'否')!='是'
and dtp='否'
and oto='否'
and a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--子公司销售
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率, 
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where  a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where   a.area_code !='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--总部
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率, 
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where  a.area_code ='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
--and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where   a.area_code ='00'
and a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
--and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


--整体
select sum(销售额)as 销售额,
sum(毛利额)as 毛利额,
sum(同比销售额)as 同比销售额,
sum(同比毛利额)as 同比毛利额,
(case when sum(同比销售额)=0 then 0 else (sum(销售额)-sum(同比销售额))/sum(同比销售额) end)as 同比销售增长率,
(case when sum(同比毛利额)=0 then 0 else (sum(毛利额)-sum(同比毛利额))/sum(同比毛利额) end)as 同比毛利增长率 
from (
select 
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 毛利额,
0 as 同比销售额,
0 as 同比毛利额
from dm_monthly_company a,dim_region b 
where   a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
--and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
union all
select 
0 as 销售额,
0 as 毛利额,
(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' then nvl(no_tax_amount,0)end) else sum(case when related_party_trnsaction='否' then nvl(tax_amount,0)end) end) as 同比销售额,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0)  else nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end) as 同比毛利额
from dm_monthly_company a,dim_region b 
where a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
--and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and sale_date>=nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
and sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
)


