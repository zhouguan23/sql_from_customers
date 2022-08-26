
select a.* from
(
select
0 flag,
area_code,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction='是' then no_tax_amount end) 
when '${rela}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end)
else sum(no_tax_amount)end 品类销售额,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else sum(no_tax_amount) - sum(no_tax_cost) end 品类毛利额,

sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 贴牌销售额,
sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 贴牌毛利额,

sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 贴牌直营店销售额,
sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 贴牌直营店毛利额,
 
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 专销销售额,
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 专销毛利额,

sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 专销直营店销售额,
sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 专销直营店毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 自有品牌销售额,
sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 自有品牌毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 自有品牌直营店销售额,
sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 自有品牌直营店毛利额


from DM_MONTHLY_COMPANY_GATHER_CATE
where sale_date>=date'${start_date}' and sale_date<=date'${end_date}'
group by area_code
union all
select
1 flag,
area_code,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction='是' then tax_amount end) 
when '${rela}' = '否' then sum(case when related_party_trnsaction='否' then tax_amount end)
else sum(tax_amount)end 品类销售额,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else sum(tax_amount) - sum(tax_cost) end 品类毛利额,

sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 贴牌销售额,
sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 贴牌毛利额,

sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 贴牌直营店销售额,
sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 贴牌直营店毛利额,
 
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 专销销售额,
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 专销毛利额,

sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 专销直营店销售额,
sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 专销直营店毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 自有品牌销售额,
sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 自有品牌毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 自有品牌直营店销售额,
sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 自有品牌直营店毛利额


from DM_MONTHLY_COMPANY_GATHER_CATE
where sale_date>=date'${start_date}' and sale_date<=date'${end_date}'
group by area_code
) a,dim_region b
where 1=1 and a.area_code=b.area_code
${if(len(AREA)=0,"","and area_code in('"+AREA+"')")}
${if(len(flag)=0,"","and flag ='"+flag+"'")}
order by b.sorted


select a.* from
(
select
0 flag,
area_code,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction='是' then no_tax_amount end) 
when '${rela}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end)
else sum(no_tax_amount)end 品类销售额,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else sum(no_tax_amount) - sum(no_tax_cost) end 品类毛利额,

sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 贴牌销售额,
sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 贴牌毛利额,

sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 贴牌直营店销售额,
sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 贴牌直营店毛利额,
 
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 专销销售额,
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 专销毛利额,

sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 专销直营店销售额,
sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 专销直营店毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 自有品牌销售额,
sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 自有品牌毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 自有品牌直营店销售额,
sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 自有品牌直营店毛利额


from DM_MONTHLY_COMPANY_GATHER_CATE
where sale_date>=date'${DATE3}' and sale_date<=date'${DATE4}'
group by area_code
union all
select
1 flag,
area_code,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction='是' then tax_amount end) 
when '${rela}' = '否' then sum(case when related_party_trnsaction='否' then tax_amount end)
else sum(tax_amount)end 品类销售额,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else sum(tax_amount) - sum(tax_cost) end 品类毛利额,

sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 贴牌销售额,
sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 贴牌毛利额,

sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 贴牌直营店销售额,
sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 贴牌直营店毛利额,
 
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 专销销售额,
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 专销毛利额,

sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 专销直营店销售额,
sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 专销直营店毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 自有品牌销售额,
sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 自有品牌毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 自有品牌直营店销售额,
sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 自有品牌直营店毛利额


from DM_MONTHLY_COMPANY_GATHER_CATE
where sale_date>=date'${DATE3}' and sale_date<=date'${DATE4}'
group by area_code
) a,dim_region b
where 1=1 and a.area_code=b.area_code
${if(len(AREA)=0,"","and area_code in('"+AREA+"')")}
${if(len(flag)=0,"","and flag ='"+flag+"'")}
order by b.sorted


select a.* from
(
select
0 flag,
area_code,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction='是' then no_tax_amount end) 
when '${rela}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end)
else sum(no_tax_amount)end 品类销售额,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else sum(no_tax_amount) - sum(no_tax_cost) end 品类毛利额,

sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 贴牌销售额,
sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 贴牌毛利额,

sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 贴牌直营店销售额,
sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 贴牌直营店毛利额,
 
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 专销销售额,
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 专销毛利额,

sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 专销直营店销售额,
sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 专销直营店毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 自有品牌销售额,
sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 自有品牌毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then no_tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then no_tax_amount end)
else (no_tax_amount)end) end) 自有品牌直营店销售额,
sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) 
else (no_tax_amount) - (no_tax_cost) end) end) 自有品牌直营店毛利额


from DM_MONTHLY_COMPANY_GATHER_CATE
where sale_date>=add_months(date'${start_date}',-12) and sale_date<=add_months(date'${end_date}',-12)
group by area_code
union all
select
1 flag,
area_code,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction='是' then tax_amount end) 
when '${rela}' = '否' then sum(case when related_party_trnsaction='否' then tax_amount end)
else sum(tax_amount)end 品类销售额,

case 
when '${rela}' = '是' then sum(case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else sum(tax_amount) - sum(tax_cost) end 品类毛利额,

sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 贴牌销售额,
sum(
case 
when gather='集采贴牌' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 贴牌毛利额,

sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 贴牌直营店销售额,
sum(
case 
when gather='集采贴牌' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 贴牌直营店毛利额,
 
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 专销销售额,
sum(
case 
when gather='集采专销' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 专销毛利额,

sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 专销直营店销售额,
sum(
case 
when gather='集采专销' and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 专销直营店毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 自有品牌销售额,
sum(
case 
when gather in('集采贴牌','集采专销') then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 自有品牌毛利额,

sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction='是'  then tax_amount end) 
when '${rela}' = '否' then (case when related_party_trnsaction='否'  then tax_amount end)
else (tax_amount)end) end) 自有品牌直营店销售额,
sum(
case 
when gather in('集采贴牌','集采专销') and attribute='直营' then
(case 
when '${rela}' = '是' then (case when related_party_trnsaction = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) 
else (tax_amount) - (tax_cost) end) end) 自有品牌直营店毛利额


from DM_MONTHLY_COMPANY_GATHER_CATE
where sale_date>=add_months(date'${start_date}',-12) and sale_date<=add_months(date'${end_date}',-12)
group by area_code
)a,dim_region b 
where 1=1 and a.area_code=b.area_code
${if(len(AREA)=0,"","and area_code in('"+AREA+"')")}
${if(len(flag)=0,"","and flag ='"+flag+"'")}
order by b.sorted

select distinct
CATEGORY
from
DM_CATEGORY_YEAR_SALE

select distinct a.union_area_name,a.area_name,a.area_code,a.trans_party_relation from dim_region a,(select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}

and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")}


