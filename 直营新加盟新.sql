
select b.union_area_name,
       sum(case
             when attribute = '加盟' and
                  extract(year from open_date) = substr('${month}', 1, 4) and
                  open_Date >= date '${month}' and open_date < date
              '${month1}' + 1 then
              1
             else
              0
           end) jm_open_num,
       sum(case
             when attribute = '加盟' and
                  extract(year from close_date) = substr('${month}', 1, 4) and
                  open_Date >= date '${month}' and open_date < date
              '${month1}' + 1 then
              1
             else
              0
           end) jm_close_num,
       sum(case
             when attribute = '直营' and
                  extract(year from open_date) = substr('${month}', 1, 4) and
                  open_Date >= date '${month}' and open_date < date
              '${month1}' + 1 then
              1
             else
              0
           end) zy_open_num,
       sum(case
             when attribute = '直营' and
                  extract(year from close_date) = substr('${month}', 1, 4) and
                  open_Date >= date '${month}' and open_date < date
              '${month1}' + 1 then
              1
             else
              0
           end) zy_close_num

  from dim_cus a
  left join dim_region b
    on a.area_code = b.area_code
 group by b.union_area_name


select * from dim_region where 1=1
order by 2


select b.union_area_name,
       sum(case
             when attribute = '加盟' and
                  extract(year from open_date) = substr('${month}', 1, 4) then
              delivery_amount
             else
              0
           end) jm_new_deliver,
       sum(case
             when attribute = '加盟' and
                  extract(year from open_date) = substr('${month}', 1, 4) then
              nvl(sale_amount, 0) - nvl(sale_cost, 0)
             else
              0
           end) jm_new_profit,
       sum(case
             when attribute = '加盟' and
                  extract(year from open_date) = substr('${month}', 1, 4) then
              dtp_delivery_amount
             else
              0
           end) jmdtp_new_deliver,
       sum(case
             when attribute = '加盟' and
                  extract(year from open_date) = substr('${month}', 1, 4) then
              nvl(dtp_sale_amount, 0) - nvl(dtp_sale_cost,0)
             else
              0
           end) jmdtp_new_profit,
       sum(case
             when attribute = '加盟' then
              nvl(delivery_amount, 0) - nvl(dtp_delivery_amount, 0)
             else
              0
           end) jm_normal_deliver,
       sum(case
             when attribute = '加盟' then
              nvl(sale_amount, 0) - nvl(dtp_sale_amount, 0) -
              nvl(oto_sale_amount, 0) -
              (nvl(sale_cost, 0) - nvl(dtp_sale_cost, 0) - nvl(oto_sale_cost, 0))
             else
              0
           end) jm_normal_profit,
       sum(case
             when attribute = '直营' and
                  extract(year from open_date) = substr('${month}', 1, 4) then
              nvl(sale_amount, 0)
             else
              0
           end) zy_new_amount,
       sum(case
             when attribute = '直营' and
                  extract(year from open_date) = substr('${month}', 1, 4) then
              nvl(sale_amount, 0) - nvl(sale_cost, 0)
             else
              0
           end) zy_new_profit,
       sum(case
             when attribute = '直营' and
                  extract(year from open_date) = substr('${month}', 1, 4) then
              nvl(sale_amount, 0) - nvl(sale_cost, 0)
             else
              0
           end) zy_new_profit,
       sum(case
             when extract(year from open_date) = substr('${month}', 1, 4) then
              nvl(sale_amount, 0)
             else
              0
           end) new_amount_total,
       sum(case
             when extract(year from open_date) = substr('${month}', 1, 4) then
              nvl(sale_amount, 0) - nvl(sale_cost, 0)
             else
              0
           end) new_profit_total

  from dm_delivery_sale_stock a
  left join dim_region b
    on a.area_code = b.area_code
 where date1>=date '${month}' and 
 date1<date'${month1}'+1
 and 1=1
 ${if(len(AREA)==0,"","AND b.union_area_name in ('"+AREA+"')")}

 group by b.union_area_name
    order by b.union_area_name

