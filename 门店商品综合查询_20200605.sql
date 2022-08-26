with 
cgoods as(
select article_id as cg_id from auth_goods_result_fr a
where  1=1 
 ${if(len(sFirst) == 0,"","AND first_categroy_id in ('" + sFirst + "')")}
  ${if(len(sSecond) == 0,"","AND second_categroy_id in ('" + sSecond + "')")}
  ${if(len(sThird) == 0,"","AND third_categroy_id in ('" + sThird + "')")}
and (user='${fine_username}' -- 存在于a表
 or (exists (select * from auth_role b where b.auth_type='门店' and  b.user='${fine_username}' ) -- 存在b
  and not exists (select 1 from auth_goods_result_fr c
        where 1=1 
         ${if(len(sFirst) == 0,"","AND c.first_categroy_id in ('" + sFirst + "')")}
          ${if(len(sSecond) == 0,"","AND c.second_categroy_id in ('" + sSecond + "')")}
          ${if(len(sThird) == 0,"","AND c.third_categroy_id in ('" + sThird + "')")}
        and c.user='${fine_username}'
      ) -- 不存在a表
    ) -- 存在b，不存在a
)
),
csecond as(
select second_categroy_id as cg_id from v_auth_goods_result_fr a
where first_categroy_id <>'' 
 ${if(len(sFirst) == 0,"","AND first_categroy_id in ('" + sFirst + "')")}
and (user='${fine_username}' -- 存在于a表
 or (exists (select * from auth_role b where b.auth_type='门店' and  b.user='${fine_username}' ) -- 存在b
  and not exists (select 1 from v_auth_goods_result_fr c
        where c.first_categroy_id <>'' 
         ${if(len(sFirst) == 0,"","AND c.first_categroy_id in ('" + sFirst + "')")}
        and c.user='${fine_username}'
      ) -- 不存在a表
    ) -- 存在b，不存在a
)
),
cfirst as(
select  first_categroy_id as cg_id  from v_auth_goods_result_fr a
where first_categroy_id <>''
and (user='${fine_username}' -- 存在于a表
 or (exists (select * from auth_role b where b.auth_type='门店' and  b.user='${fine_username}' ) -- 存在b
  and not exists (select 1 from v_auth_goods_result_fr c
        where c.first_categroy_id  <>'' 
        and c.user='${fine_username}'
      ) -- 不存在a表
    ) -- 存在b，不存在a
)
),
cthird as(
select  third_categroy_id as cg_id  from v_auth_goods_result_fr a
where first_categroy_id <>'' 
 ${if(len(sFirst) == 0,"","AND first_categroy_id in ('" + sFirst + "')")}
  ${if(len(sSecond) == 0,"","AND second_categroy_id in ('" + sSecond + "')")}
and (user='${fine_username}' -- 存在于a表
 or (exists (select * from auth_role b where b.auth_type='门店' and  b.user='${fine_username}') -- 存在b
  and not exists (select 1 from v_auth_goods_result_fr c
        where c.first_categroy_id <>'' 
         ${if(len(sFirst) == 0,"","AND c.first_categroy_id in ('" + sFirst + "')")}
          ${if(len(sSecond) == 0,"","AND c.second_categroy_id in ('" + sSecond + "')")}
        and c.user='${fine_username}'
      ) -- 不存在a表
    ) -- 存在b，不存在a
)
),
b as (
select cdate,cyear,cmonth,cweek  from dim_date_information
),
auth_result as 
(select distinct store_id from v_auth_store_result_fr where user='${fine_username}' ),
${if(Collect_Goods = '04',"/*","")} -- 第一段
t21 as (
select a.store_id,
${if(sDATES = '昨日',"if('"+Collect_Date+"' = '3',cdate,curdate) time,","case '" + sDATES + "'
when '本年' then  cyear 
when '本月' then  concat(cyear,cmonth)
when '本周' then  concat(cyear,cweek)
end time,")}
categroy_id,
sum(cust_num) cust_num,
sum(bf19_cust_num) bf19_cust_num,
sum(af19_cust_num) af19_cust_num,
count(*) sale_days 
from b left join rpt_db.sale_store_categroy_custs_counts  a on b.cdate=a.business_date 
join auth_result auth on a.store_id=auth.store_id 
where type_id ='${Collect_Goods}'
${if(len(sStore) == 0,"","AND a.store_id in ('" + sStore + "')")}
${if(sDATES ='本年'," and cyear in ('" +year+"') ","")}
${if(sDATES ='本月',"and cyear in ('" +year+"') and cmonth in ('" +ymqw+"') ","")}
${if(sDATES ='本周',"and cyear in ('" +year+"') and cweek in ('" +ymqw+"')  ","")}
${if(sDATES ='昨日',"and business_date>='" +date1+"'  and  business_date<='" +date2+"' ","")}
and cust_num>0
group by 
a.store_id,
${if(sDATES = '昨日',"if('"+Collect_Date+"' = '3',cdate,curdate) ,","case '" + sDATES + "'
when '本年' then  cyear 
when '本月' then  concat(cyear,cmonth)
when '本周' then  concat(cyear,cweek)
end ,")} 
categroy_id
),
t22 as (
select 
a.store_id,
${if(sDATES = '昨日',"if('"+Collect_Date+"' = '3',cdate,curdate) time,","case '" + sDATES + "'
when '本年' then  cyear 
when '本月' then  concat(cyear,cmonth)
when '本周' then  concat(cyear,cweek)
end time,")}
${if(sDATES = '昨日',"concat(min(cdate),'~',max(cdate))","1")} time_region,
case '${Collect_Goods}'  when '01' then  first_categroy_name 
 when '02' then  second_categroy_name
when '03' then  third_categroy_name
end  categroy_name,
case '${Collect_Goods}'  when '01' then  first_categroy_id 
 when '02' then  second_categroy_id
when '03' then  a.third_categroy_id
end  categroy_id,
sum(purchase_amt)  purchase_amt,
sum(to_stock_num) to_stock_num,
 sum(bf19_sales_amt)  bf19_sales_amt,
 sum(offline_bf19_sales_amt) offline_bf19_sales_amt,
 sum(online_sales_amt) online_sales_amt,
 sum(sales_amt-online_sales_amt) offline_sales_amt,
sum(af19_sales_amt)  af19_sales_amt,
 sum(sales_amt)  sales_amt,
  sum(sales_num) sales_num,
  sum(bf19_sales_num)  bf19_sales_num,
 sum(af19_sales_num)  af19_sales_num,
 sum(expect_sales_amt)  expect_sales_amt,
 sum(gross_profit)  gross_profit,
  sum(hour_discount_amt)  hour_discount_amt,
  sum(member_discount_amt)  member_discount_amt,
   sum(promotion_discount_amt)  promotion_discount_amt,
 sum(discount_amt)  discount_amt,
 sum(unknow_lost_amt)  unknow_lost_amt,
 sum(know_lost_amt)  know_lost_amt,
 sum(lost_amt)  lost_amt,
 sum(return_sale_amt)  return_sale_amt
from  
${if(sDATES ='昨日'," b left join sale_store_class_daily_fact a  on b.cdate=a.business_date  ","sale_store_class_weekly_fact a" )}  
 
left join dim_goods_categroy c on a.third_categroy_id=c.third_categroy_id
join auth_result auth on a.store_id=auth.store_id 

${if(len(cfirst) == 0,"inner join cfirst on first_categroy_id=cfirst.cg_id","")}

${if(len(csecond) == 0,"inner join csecond on second_categroy_id=csecond.cg_id","")}

${if(len(cthird) == 0,"inner join cthird on a.third_categroy_id=cthird.cg_id","")}

where  1=1
${if(len(sThird) == 0,"","AND a.third_categroy_id in ('" + sThird + "')")}
${if(len(sSecond) == 0,"","AND second_categroy_id in ('" + sSecond + "')")}
${if(len(sFirst) == 0,"","AND  first_categroy_id in ('" + sFirst + "')")}
${if(len(sStore) == 0,"","AND a.store_id in ('" + sStore + "')")} 
${if(sDATES ='本年'," and cyear in ('" +year+"') ","")}
${if(sDATES ='本月',"and cyear in ('" +year+"') and cmonth in ('" +ymqw+"') ","")}
${if(sDATES ='本周',"and cyear in ('" +year+"') and cweek in ('" +ymqw+"')  ","")}
${if(sDATES ='昨日',"and business_date>='" +date1+"'  and  business_date<='" +date2+"' ","")}

  
group by a.store_id,
${if(sDATES = '昨日',"if('"+Collect_Date+"' = '3',cdate,curdate) ,","case '" + sDATES + "'
when '本年' then  cyear 
when '本月' then  concat(cyear,cmonth)
when '本周' then  concat(cyear,cweek)
end ,")} 
case '${Collect_Goods}'  when '01' then  first_categroy_name 
 when '02' then  second_categroy_name
when '03' then  third_categroy_name
end  ,
case '${Collect_Goods}'  when '01' then  first_categroy_id 
 when '02' then  second_categroy_id
when '03' then  a.third_categroy_id
end
) 
${if(Collect_Goods = '04',"*/","/*")} -- 第二段
t1 as (
select 
a.store_id,
${if(sDATES = '昨日',"if('"+Collect_Date+"' = '3',cdate,curdate) time,","case '" + sDATES + "'
when '本年' then  cyear 
when '本月' then  concat(cyear,cmonth)
when '本周' then  concat(cyear,cweek)
end time,")}
${if(sDATES = '昨日',"concat(min(cdate),'~',max(cdate))","1")} time_region,
${if(sDATES = '昨日'," last_sysdate last_sysdate,","now() last_sysdate,")}
  article_name categroy_name,
  a.article_id categroy_id,
  ${if(sDATES = '昨日'," count(*) sale_days,","sum(sale_days) sale_days,")}
  c.third_categroy_name,
  c.second_categroy_name,
  c.first_categroy_name,
   g.order_unit,
   g.sale_unit,
 sum(purchase_amt)  purchase_amt,
 sum(to_stock_num)  to_stock_num,
  sum(order_num) order_num,
 sum(cust_num) cust_num,
 sum(bf19_cust_num)  bf19_cust_num,
 sum(af19_cust_num)  af19_cust_num,
 sum(bf19_sales_amt)  bf19_sales_amt,
 if(sum(cust_num)=0,0,sum(sales_amt)/sum(cust_num)) per_cust_amt,
 if(sum(bf19_cust_num)=0,0,sum(bf19_sales_amt)/sum(bf19_cust_num)) bf19_per_cust_amt,
if(sum(af19_cust_num)=0,0,sum(af19_sales_amt)/sum(af19_cust_num)) af19_per_cust_amt,
 sum(offline_bf19_sales_amt) offline_bf19_sales_amt,
 sum(online_sales_amt) online_sales_amt,
 sum(sales_amt-online_sales_amt) offline_sales_amt,
 sum(af19_sales_amt)  af19_sales_amt,
 sum(sales_amt)  sales_amt,
  sum(sales_num) sales_num,
  sum(bf19_sales_qty)  bf19_sales_num,
 sum(af19_sales_qty)  af19_sales_num,
 sum(expect_sales_amt)  expect_sales_amt,
 sum(gross_profit)  gross_profit,
  sum(hour_discount_amt)  hour_discount_amt,
  sum(member_discount_amt)  member_discount_amt,
   sum(promotion_discount_amt)  promotion_discount_amt,
 sum(discount_amt)  discount_amt,
 sum(unknow_lost_amt)  unknow_lost_amt,
 sum(unknow_lost_qty)  unknow_lost_qty,
 sum(know_lost_amt)  know_lost_amt,
 sum(know_lost_qty)  know_lost_qty,
 sum(lost_amt)  lost_amt,
 sum(return_sale_amt)  return_sale_amt,
 sum(return_sale_qty)  return_sale_qty
from  
${if(sDATES ='昨日',"b left join sale_store_goods_daily_fact a  on b.cdate=a.business_date   ","sale_store_goods_weekly_fact a")}  
left join dim_goods_information g on a.article_id=g.article_id 
 left join 
dim_goods_categroy c on g.third_categroy_id=c.third_categroy_id
join auth_result auth on a.store_id=auth.store_id 

${if(len(cgoods) == 0,"inner join cgoods on a.article_id=cgoods.cg_id","")}

${if(len(cfirst) == 0,"inner join cfirst on first_categroy_id=cfirst.cg_id","")}

${if(len(csecond) == 0,"inner join csecond on second_categroy_id=csecond.cg_id","")}

${if(len(cthird) == 0,"inner join cthird on a.third_categroy_id=cthird.cg_id","")}


where  1=1
${if(len(sThird) == 0,"","AND a.third_categroy_id in ('" + sThird + "')")}
${if(len(sSecond) == 0,"","AND second_categroy_id in ('" + sSecond + "')")}
${if(len(sFirst) == 0,"","AND  first_categroy_id in ('" + sFirst + "')")}
${if(len(sTag) == 0,"","AND  commodity_attribute = '" + sTag + "' ")}
${if(len(sGoods) == 0,"","AND  a.article_id in ('" + sGoods + "')")}
${if(len(sStore) == 0,"","AND a.store_id in ('" + sStore + "')")} 
${if(sDATES ='本年'," and cyear in ('" +year+"') ","")}
${if(sDATES ='本月',"and cyear in ('" +year+"') and cmonth in ('" +ymqw+"') ","")}
${if(sDATES ='本周',"and cyear in ('" +year+"') and cweek in ('" +ymqw+"')  ","")}
${if(sDATES ='昨日',"and business_date>='" +date1+"'  and  business_date<='" +date2+"' ","")}

  
group by a.store_id,
${if(sDATES = '昨日',"if('"+Collect_Date+"' = '3',cdate,curdate) ,","case '" + sDATES + "'
when '本年' then  cyear 
when '本月' then  concat(cyear,cmonth)
when '本周' then  concat(cyear,cweek)
end ,")}
article_name ,
  a.article_id
)
${if(Collect_Goods <> '04',"*/"," ")} -- 第三段

select 
case '${Collect_Store}' when '0' then area_id when '1' then d.operate_id when '2' then zone_manager_id when '3' then d.group_manager_code when '4' then d.city else  t.store_id end store_id,
case '${Collect_Store}'  when '0' then area_name when '1' then d.operate_region when '2' then zone_manager when '3' then d.group_manager when '4' then d.city else  d.store_name end store_name,
${if(Collect_Store = '5',"d.operate_region" ,"''")}  operate_region,
${if(Collect_Store = '5',"d.city" ,"''")}  city,
${if(Collect_Store = '5',"open_date ","''")} open_date,
${if(Collect_Store = '5',"DATEDIFF(curdate,open_date) " ,"''")} open_days,
${if(Collect_Goods = '04' && sDATES = '昨日',"max( last_sysdate) " ,"now()")}  last_sysdate,
  case when '${sDATES}'='昨日' and '${Collect_Date}'<> '3' then concat(min(left(t.time_region,10)),'~',max(right(t.time_region,10))) else max(t.time)  end   time_region,
  t.time,
  t.categroy_name,
  t.categroy_id,
${if(Collect_Goods='04', "t.third_categroy_name","'1'")} third_categroy_name,
${if(Collect_Goods='04', "t.second_categroy_name","'1'")} second_categroy_name,
${if(Collect_Goods='04', "t.first_categroy_name","'1'")} first_categroy_name,
 ${if( Collect_Goods='04'," t.order_unit"," 1")} order_unit,
  ${if( Collect_Goods='04'," t.sale_unit"," 1")} sale_unit,
  sum(sale_days) sale_days,
 sum(purchase_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  purchase_amt,
sum(to_stock_num)/${if(Collect_Date = '1',"sum(sale_days)","1")} to_stock_num,
 ${if(Collect_Goods='04',"sum(order_num)/if('"+Collect_Date+"' = '1',sum(sale_days),1)",0 )} order_num,
 sum(cust_num)/${if(Collect_Date = '1',"sum(sale_days)","1")} cust_num,
 sum(bf19_cust_num)/${if(Collect_Date = '1',"sum(sale_days)","1")}  bf19_cust_num,
 sum(af19_cust_num)/${if(Collect_Date = '1',"sum(sale_days)","1")}  af19_cust_num,
 sum(bf19_sales_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  bf19_sales_amt,
 sum(offline_bf19_sales_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")} offline_bf19_sales_amt,
 sum(online_sales_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")} online_sales_amt,
 sum(sales_amt-online_sales_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")} offline_sales_amt,
 sum(af19_sales_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  af19_sales_amt,
 sum(sales_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  sales_amt,

 if(sum(cust_num)=0,0,sum(sales_amt)/sum(cust_num)) per_cust_amt,
 if(sum(bf19_cust_num)=0,0,sum(bf19_sales_amt)/sum(bf19_cust_num)) bf19_per_cust_amt,
if(sum(af19_cust_num)=0,0,sum(af19_sales_amt)/sum(af19_cust_num)) af19_per_cust_amt,


  sum(sales_num)/${if(Collect_Date = '1',"sum(sale_days)","1")} sales_num,
  sum(bf19_sales_num)/${if(Collect_Date = '1',"sum(sale_days)","1")} bf19_sales_num,
  sum( af19_sales_num)/${if(Collect_Date = '1',"sum(sale_days)","1")}  af19_sales_num,


 sum(expect_sales_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  expect_sales_amt,
 sum(gross_profit)/${if(Collect_Date = '1',"sum(sale_days)","1")}  gross_profit,
 if(sum(sales_amt)=0,0,sum(gross_profit)/sum(sales_amt)) profit_rate,
  sum(hour_discount_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  hour_discount_amt,
  if(sum(sales_amt+discount_amt)=0,0,sum(hour_discount_amt)/sum(sales_amt+discount_amt)) hour_discount_rate,
  sum(member_discount_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  member_discount_amt,
   sum(promotion_discount_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  promotion_discount_amt,
 sum(discount_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  discount_amt,
 if(sum(sales_amt+discount_amt)=0,0,sum(discount_amt)/sum(sales_amt+discount_amt)) discount_rate,
 sum(unknow_lost_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  unknow_lost_amt,
 ${if(Collect_Goods='04',"sum( unknow_lost_qty)/if('"+Collect_Date+"' = '1',sum(sale_days),1)",0 )}  unknow_lost_qty,
 if(sum(purchase_amt)=0,0,sum(unknow_lost_amt)/sum(purchase_amt)) unknow_lost_rate,
 sum(know_lost_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  know_lost_amt,
 ${if(Collect_Goods='04',"sum( know_lost_qty)/if('"+Collect_Date+"' = '1',sum(sale_days),1)",0 )}  know_lost_qty,
 sum(lost_amt)/${if(Collect_Date = '1',"sum(sale_days)","1")}  lost_amt,
 if(sum(purchase_amt)=0,0,sum(lost_amt)/sum(purchase_amt)) lost_rate,
 abs(sum(return_sale_amt))/${if(Collect_Date = '1',"sum(sale_days)","1")}  return_amt,
 if(abs(sum(sales_amt+return_sale_amt))=0,0,abs(sum(return_sale_amt))/sum(sales_amt+abs(return_sale_amt))) return_rate,
${if(Collect_Goods='04',"abs(sum( return_sale_qty))/if('"+Collect_Date+"' = '1',sum(sale_days),1)",0 )}  return_sale_qty
from  
${if(Collect_Goods ='04'," t1 t ","t22 t left join t21 on t.store_id=t21.store_id and t.categroy_id=t21.categroy_id and t.time=t21.time  ")} 
left join dim_store_information d on t.store_id=d.store_id
left join ipt_zone_manager_information c on d.group_manager=c.group_manager
where d.sp_level='1' and t.categroy_id is not null
${if(len(sArea) == 0,"","AND d.area_id in ('" + sArea + "')")}
${if(len(sRegion) == 0,"","AND d.operate_id in ('" + sRegion + "')")}
${if(len(sType) == 0,"","AND d.type in ('" + sType + "')")}
${if(len(sCity) == 0,"","AND d.city in ('" + sCity + "')")}
${if(len(sZone) == 0,"","AND c.zone_manager_id in ('" + sZone + "')")} 
${if(len(sGroup) == 0,"","AND d.group_manager_code in ('" + sGroup + "')")}
group by 
  case '${Collect_Store}'  when '0' then area_id when '1' then d.operate_id when '2' then zone_manager_id when '3' then d.group_manager_code when '4' then d.city else  t.store_id end,
  t.time ,
  t.categroy_name,
  t.categroy_id
  order by case '${Collect_Store}'  when '0' then area_id when '1' then d.operate_id when '2' then zone_manager_id when '3' then d.group_manager_code when '4' then d.city else  t.store_id end,t.categroy_id,t.time

select 
case '${Collect_Store}' when '0' then area_id when '1' then d.operate_id when '2' then zone_manager_id when '3' then d.group_manager_code when '4' then d.city else  a.store_id end store_id,
${if(sDATES = '昨日',"if('"+Collect_Date+"' = '3', business_date,curdate) time,","case '" + sDATES + "'
when '本年' then  cyear 
when '本月' then  concat(cyear,cmonth)
when '本周' then  concat(cyear,cweek)
end time,")}
 sum(cust_num)  t_cust_num,
 sum(sales_amt-ifnull(round_amt,0))  t_sales_amt 
from 
${if(sDATES ='昨日',"sale_store_daily_fact a ","sale_store_weekly_fact a")}
 left join dim_store_information d on a.store_id=d.store_id
left join ipt_zone_manager_information c on d.group_manager=c.group_manager
where 1=1
${if(len(sArea) == 0,"","AND d.area_id in ('" + sArea + "')")}
${if(len(sStore) == 0,"","AND a.store_id in ('" + sStore + "')")}
${if(len(sRegion) == 0,"","AND d.operate_id in ('" + sRegion + "')")}
${if(len(sType) == 0,"","AND d.type in ('" + sType + "')")}
${if(len(sCity) == 0,"","AND d.city in ('" + sCity + "')")}
${if(len(sZone) == 0,"","AND c.zone_manager_id in ('" + sZone + "')")} 
${if(len(sGroup) == 0,"","AND d.group_manager_code in ('" + sGroup + "')")}
${if(sDATES ='本年'," and cyear in ('" +year+"') ","")}
${if(sDATES ='本月',"and cyear in ('" +year+"') and cmonth in ('" +ymqw+"') ","")}
${if(sDATES ='本周',"and cyear in ('" +year+"') and cweek in ('" +ymqw+"')  ","")}
${if(sDATES ='昨日',"and business_date>='" +date1+"'  and  business_date<='" +date2+"' ","")}
group by case '${Collect_Store}' when '0' then area_id when '1' then d.operate_id when '2' then zone_manager_id when '3' then d.group_manager_code when '4' then d.city else  a.store_id end,
${if(sDATES = '昨日',"if('"+Collect_Date+"' = '3', business_date,curdate) ","case '" + sDATES + "'
when '本年' then  cyear 
when '本月' then  concat(cyear,cmonth)
when '本周' then  concat(cyear,cweek)
end ")}

SELECT
	cyear,
CASE '${sDATES}'
WHEN '本周' THEN
   cweek
WHEN '本月' THEN
	cmonth
WHEN '本年' THEN
	cyear
ELSE
	NULL
END name,
concat(cyear,
CASE '${sDATES}'
WHEN '本周' THEN
   cweek
WHEN '本月' THEN
	cmonth
WHEN '本年' THEN
	cyear
ELSE
	NULL
END) time_name,
	CASE '${sDATES}'
WHEN '本周' THEN
	concat(
		min(cdate),
		'~',
		max(cdate),': ',week_name
	)
WHEN '本月' THEN
	month_name
WHEN '本年' THEN
	year_name	
ELSE
	NULL
END rejion,
min(cdate) sdate 
FROM
	rpt_db.dim_date_information where cyear in ('${year}') and cdate<=curdate
	
GROUP BY
		cyear,
CASE '${sDATES}'
WHEN '本周' THEN
   cweek
WHEN '本月' THEN
	cmonth
WHEN '本年' THEN
	cyear
ELSE
	NULL
END order by sdate

select a.store_id, a.store_name from v_auth_store_result_fr a left join dim_store_information d on a.store_id=d.store_id
where user='${fine_username}'
${if(len(sArea) == 0,"","AND d.area_id in ('" + sArea + "')")}
${if(len(sRegion) == 0,"","AND d.operate_id in ('" + sRegion + "')")}
${if(len(sCity) == 0,"","AND d.city in ('" + sCity + "')")}
${if(len(sZone) == 0,"","AND a.zone_manager_id in ('" + sZone + "')")} 
${if(len(sGroup) == 0,"","AND a.group_manager_code in ('" + sGroup + "')")}
${if(len(sType) == 0,"","AND d.type in ('" + sType + "')")}
ORDER BY 
a.store_id

with a as(
select distinct first_categroy_id,first_categroy_name from v_auth_goods_result_fr a
where first_categroy_id <>''
and (user='${fine_username}' -- 存在于a表
 or (exists (select * from auth_role b where b.auth_type='门店' and  b.user='${fine_username}' ) -- 存在b
	and not exists (select 1 from v_auth_goods_result_fr c
				where c.first_categroy_id  <>'' 
				and c.user='${fine_username}'
			) -- 不存在a表
    ) -- 存在b，不存在a
)
)
select first_categroy_id,first_categroy_name from a
order by  first_categroy_id 

with a as(
select distinct second_categroy_id,second_categroy_name from v_auth_goods_result_fr a
where first_categroy_id <>'' 
 ${if(len(sFirst) == 0,"","AND first_categroy_id in ('" + sFirst + "')")}
and (user='${fine_username}' -- 存在于a表
 or (exists (select * from auth_role b where b.auth_type='门店' and  b.user='${fine_username}' ) -- 存在b
	and not exists (select 1 from v_auth_goods_result_fr c
				where c.first_categroy_id <>'' 
				 ${if(len(sFirst) == 0,"","AND c.first_categroy_id in ('" + sFirst + "')")}
				and c.user='${fine_username}'
			) -- 不存在a表
    ) -- 存在b，不存在a
)
)

select second_categroy_id,second_categroy_name from a
order by second_categroy_id

with a as(
select distinct third_categroy_id,third_categroy_name from v_auth_goods_result_fr a
where first_categroy_id <>'' 
 ${if(len(sFirst) == 0,"","AND first_categroy_id in ('" + sFirst + "')")}
  ${if(len(sSecond) == 0,"","AND second_categroy_id in ('" + sSecond + "')")}
and (user='${fine_username}' -- 存在于a表
 or (exists (select * from auth_role b where b.auth_type='门店' and  b.user='${fine_username}') -- 存在b
	and not exists (select 1 from v_auth_goods_result_fr c
				where c.first_categroy_id <>'' 
				 ${if(len(sFirst) == 0,"","AND c.first_categroy_id in ('" + sFirst + "')")}
				  ${if(len(sSecond) == 0,"","AND c.second_categroy_id in ('" + sSecond + "')")}
				and c.user='${fine_username}'
			) -- 不存在a表
    ) -- 存在b，不存在a
)
)

select third_categroy_id,third_categroy_name from a
order by third_categroy_id


with a as(
select distinct article_id  from auth_goods_result_fr a
where  1=1 
 ${if(len(sFirst) == 0,"","AND first_categroy_id in ('" + sFirst + "')")}
  ${if(len(sSecond) == 0,"","AND second_categroy_id in ('" + sSecond + "')")}
  ${if(len(sThird) == 0,"","AND third_categroy_id in ('" + sThird + "')")}
and (user='${fine_username}' -- 存在于a表
 or (exists (select * from auth_role b where b.auth_type='门店' and  b.user='${fine_username}' ) -- 存在b
	and not exists (select 1 from auth_goods_result_fr c
				where 1=1 
				 ${if(len(sFirst) == 0,"","AND c.first_categroy_id in ('" + sFirst + "')")}
				  ${if(len(sSecond) == 0,"","AND c.second_categroy_id in ('" + sSecond + "')")}
				  ${if(len(sThird) == 0,"","AND c.third_categroy_id in ('" + sThird + "')")}
				and c.user='${fine_username}'
			) -- 不存在a表
    ) -- 存在b，不存在a
)
)
select a.article_id,concat(a.article_id,article_name) article_name from a join dim_goods_information b on a.article_id=b.article_id where  pt='01'
${if(len(sTag) == 0,"","AND  commodity_attribute = '" + sTag + "' ")}
order by a.article_id
;

SELECT
	cyear,
CASE '${sDATES}'
WHEN '本周' THEN
	cweek
WHEN '本月' THEN
	cmonth
WHEN '本年' THEN
	cyear	
ELSE
	NULL
END name,
	CASE '${sDATES}'
WHEN '本周' THEN
	concat(
		min(cdate),
		'~',
		max(cdate),': ',week_name
	)
WHEN '本月' THEN
	month_name
WHEN '本年' THEN
	year_name	
ELSE
	NULL
END rejion,
min(cdate) sdate
FROM
	rpt_db.dim_date_information where  cdate=date_add(curdate,-1)
	
GROUP BY
	cyear,
CASE '${sDATES}'
WHEN '本周' THEN
	cweek
WHEN '本月' THEN
	cmonth
WHEN '本年' THEN
	cyear	
ELSE
	NULL
END
ORDER BY
	sdate

select operate_id,operate_region from  dim_store_information where store_id in ( select store_id from v_auth_store_result_fr
where user='${fine_username}' 
) and sp_level='1'
${if(len(sArea) == 0,"","AND area_id in ('" + sArea + "')")}
 group by operate_id,operate_region
ORDER BY 
operate_id


select zone_manager_id,zone_manager from v_auth_store_result_fr a left join dim_store_information b on a.store_id=b.store_id
where user='${fine_username}'
${if(len(sArea) == 0,"","AND b.area_id in ('" + sArea + "')")}
${if(len(sRegion) == 0,"","AND a.operate_id in ('" + sRegion + "')")}
and zone_manager_id is not null
group by zone_manager_id,zone_manager
ORDER BY 

zone_manager_id
 

select a.group_manager_code,a.group_manager from v_auth_store_result_fr a left join dim_store_information b on a.store_id=b.store_id
where user='${fine_username}'
${if(len(sArea) == 0,"","AND b.area_id in ('" + sArea + "')")}
${if(len(sRegion) == 0,"","AND a.operate_id in ('" + sRegion + "')")}
${if(len(sZone) == 0,"","AND a.zone_manager_id in ('" + sZone + "')")}
group by a.group_manager_code,a.group_manager
ORDER BY 

a.group_manager_code



select area_id, area_name from dim_store_information where store_id in ( select store_id from v_auth_store_result_fr
where user='${fine_username}' 
) and sp_level='1'
group by area_id
order by area_id
  

select  city from  dim_store_information where store_id in ( select store_id from v_auth_store_result_fr
where user='${fine_username}' 
) and sp_level='1'
${if(len(sArea) == 0,"","AND area_id in ('" + sArea + "')")}
${if(len(sRegion) == 0,"","AND operate_id in ('" + sRegion + "')")}
 group by city
ORDER BY 
city

