
select * from
(
select
0 flag,
SUB_CATEGORY 品类,

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
group by SUB_CATEGORY 
union all
select
1 flag,
SUB_CATEGORY 品类,

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
group by SUB_CATEGORY 
)
where 1=1
${if(len(cate)=0,"","and 品类 in('"+cate+"')")}
${if(len(flag)=0,"","and flag ='"+flag+"'")}
order by 品类


select * from
(
select
0 flag,
SUB_CATEGORY 品类,

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
group by SUB_CATEGORY 
union all
select
1 flag,
SUB_CATEGORY 品类,

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
group by SUB_CATEGORY 
)
where 1=1
${if(len(cate)=0,"","and 品类 in('"+cate+"')")}
${if(len(flag)=0,"","and flag ='"+flag+"'")}
order by 品类


select * from
(
select
0 flag,
SUB_CATEGORY 品类,

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
group by SUB_CATEGORY 
union all
select
1 flag,
SUB_CATEGORY 品类,

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
group by SUB_CATEGORY 
)
where 1=1
${if(len(cate)=0,"","and 品类 in('"+cate+"')")}
${if(len(flag)=0,"","and flag ='"+flag+"'")}
order by 品类

select distinct
CATEGORY
from
DM_CATEGORY_YEAR_SALE

