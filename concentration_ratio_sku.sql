with sale as
(
select no_tax_amount,no_tax_cost,no_tax_gp,goods_code,attribute from   gygd_bi.dm_goods_sale a
         where a.sale_date between  date'${date1}' and  date'${date2}'
         ${if(len(attribute)=0,"","and attribute in ('"+attribute+"')")}
          --and attribute in ('集采专销','集采品牌高毛','集采高毛','集采贴牌')
         union all
         select 0,0,0,goods_code,attribute from 
(select count(1), a.goods_code, nvl(c.new_attribute, '地采') attribute
  from FACT_STOCK_SHOP_new a, dim_net_catalogue_general_all c
 where ddate = (select max(ddate) from FACT_STOCK_SHOP_new)
 and c.new_or_old not in ('新品','淘汰')
   and not exists
 (select 'Y'
          from dm_goods_sale b
         where sale_date between  date'${date1}' and  date'${date2}'
           and a.goods_code = b.goods_code)
   and a.area_code = c.area_code(+)
   and a.goods_code = c.goods_code(+)
   and to_char( a.ddate, 'yyyy-mm') = c.create_month(+)
 group by a.goods_code，nvl(c.new_attribute, '地采'))
 where 1=1
-- and attribute in ('集采专销','集采品牌高毛','集采高毛','集采贴牌')
 ${if(len(attribute)=0,"","and attribute in ('"+attribute+"')")}
),
days as
(select case when round(months_between(date'${date2}',date'${date1}'),0) =0 then 
1 else
 round(months_between(date'${date2}',date'${date1}'),0)
end  as n from dual)
select rankxse, 
count(goods_code) sku, 
case when rankxse='0' then 
0
else
  sum(no_tax_amount) 
end  no_tax_amount，
case when rankxse= '0' then 
0
else
  sum(no_tax_gp) 
end  no_tax_gp
  from (select case
                 when sum(no_tax_amount/(select n from days)) / 10000*12 <= 0 then
                  '0'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 > 0 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 10 then
                  '0-10'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 10 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 20 then
                  '10-20'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 20 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 30 then
                  '20-30'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 30 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 40 then
                  '30-40'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 40 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 50 then
                  '40-50'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 40 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 50 then
                  '40-50'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 50 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 60 then
                  '50-60'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 60 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 70 then
                  '60-70'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 70 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 80 then
                  '70-80'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 80 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 90 then
                  '80-90'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 90 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 100 then
                  '90-100'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 100 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 200 then
                  '100-200'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 200 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 300 then
                  '200-300'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 300 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 500 then
                  '300-500'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 500 and
                      sum(no_tax_amount/(select n from days)) / 10000*12 < 1000 then
                  '500-1000'
                 when sum(no_tax_amount/(select n from days)) / 10000*12 >= 1000 then
                  '1000-5000'
               end rankxse,
               sum(no_tax_amount) no_tax_amount,
               sum(no_tax_gp) no_tax_gp,
               a.goods_code,
               attribute
          from sale a
         group by a.goods_code, attribute)
 group by rankxse
 order by decode(rankxse,
                 '0',
                 0,
                 '0-10',
                 1,
                 '10-20',
                 2,
                 '20-30',
                 3,
                 '30-40',
                 4,
                 '40-50',
                 5,
                 '50-60',
                 6,
                 '60-70',
                 7,
                 '70-80',
                 8,
                 '80-90',
                 9,
                 '90-100',
                 10,
                 '100-200',
                 11,
                 '200-300',
                 12,
                 '300-500',
                 13,
                 '500-1000',
                 14,
                 '1000-5000',
                 15)

select case
         when gather = '否' then
          '地采'
         else
          gather
       end as gather_look,
       gather
  from (select distinct gather from DM_PURCHASE_RATE)

