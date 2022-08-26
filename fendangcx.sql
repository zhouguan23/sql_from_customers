select distinct i.item_id,item_name ,i.brdowner_id   from  
 SGP_CUSTTYPE_ITEM_spw    a,  
 plm_item i  where  a.item_id=i.item_id  and  week='${week1}'
order by i.brdowner_id 

  WITH CC AS ( SELECT CC.CUST_ID,CC.CUST_SEG,CC.COM_ID FROM CO_CUST CC , 
( SELECT DISTINCT CUST_ID FROM CSC_CUST_ORDERDATE_VIEW WHERE   CALL_DATE>='${date1}' 
  and call_date<='${date2}' ) CSC_VIEW 
   WHERE CC.CUST_ID = CSC_VIEW.CUST_ID  and cc.status='02'
   
 )  
 
  SELECT cust_seg cust_type,count(1) custnum, qty_remain qty_once_limit
  FROM ( SELECT cc.cust_id,cust_seg,sc.qty_remain FROM CC LEFT JOIN SGP_CUSTTYPE_ITEM_SPW SC ON SC.CUST_TYPE=CC.CUST_SEG AND SC.TYPE_KIND='301FD'
   AND SC.ITEM_ID='${itemid}' AND SC.WEEK='${week1}'  LEFT JOIN SGP_CUST_ITEM_SPW SCIS ON SCIS.ITEM_ID='${itemid}' 
   AND SCIS.WEEK='${week1}'  AND CC.CUST_ID=SCIS.CUST_ID WHERE COALESCE(SCIS.QTY_REMAIN,COALESCE(SC.QTY_REMAIN,0)) > 0 ) SCT 
   group by cust_seg,qty_remain order by cust_seg desc

select  cust_type4  ,count(1) custnum from  cust 
where status='02'  and  insp_dpt_id in 
(select  periods_id FROM CALLPERIODS WHERE DATE1>='${date1}' AND DATE1<='${date2}')
group by cust_type4 order by cust_type4 desc
 

select   cs.cust_seg cust_type4,sum(a.qty_sold*t_size)/50000 qtysold,sum(a.qty_need*t_size)/50000 qtyneed,count(distinct cs.cust_id) custsl 
from pi_cust_item_bnd_day a,co_cust cs,plm_item i 
where a.cust_id=cs.cust_id and a.item_id=i.item_id 
and a.date1>='${date1}' and a.date1<='${date2}' and i.item_id='${itemid}'
group by cs.cust_seg  

select cust_type4 cust_type, count(cust_id) custqty from 
 (
 select aa.cust_type4,aa.cust_id,qtysold,qty_plan from 
 (
select  cs.cust_seg cust_type4 , cs.cust_id,sum(a.qty_sold) qtysold 
from pi_cust_item_bnd_day a,co_cust cs  
where a.cust_id=cs.cust_id   and  a.item_id='${itemid}'  
and a.date1>='${date1}' and a.date1<='${date2}'  
group by cs.cust_seg,cs.cust_id having sum(a.qty_sold)<>0
) aa,
(
select cust_id, qty_plan from sgp_custtype_item_spw_hz  a,co_cust c
 where  a.cust_type=c.cust_seg and  item_id='${itemid}'  and c.status='02' and qty_plan<>0 
union
select cust_id,qty_once_limit qty_plan from SGP_CUSTTYPE_ITEM_limit a,co_cust c 
where a.cust_type=c.cust_seg and c.status='02' and item_id='${itemid}'  and  qty_once_limit<>0

) bb
where   aa.cust_id=bb.cust_id and aa.qtysold=bb.qty_plan
)
 group by cust_type4

 
   select i.item_id,ic.short_code,item_name,ic.price_trade,count(1) qtycust,sum(a.qty_plan)/250 qtytf 
  from plm_item i ,plm_item_com ic,
  (select   item_id,cust_id,qty_Plan  from   sgp_cust_item_spw_hz where item_id='${itemid}'
    and qty_plan<>0  union
     
  select item_id, cust_id,qty_once_limit  qty_plan from SGP_CUSTTYPE_ITEM_limit a,co_cust cc
  where a.cust_type=cc.cust_seg and cc.status='02' and item_id='${itemid}'
 and qty_once_limit<>0

  union
 select item_id, cust_id,  qty_plan from SGP_CUSTTYPE_ITEM_spw a,co_cust cc
  where a.cust_type=cc.cust_seg and cc.status='02' and item_id='${itemid}'
 and qty_plan<>0 and week='${week1}'
 ) a
   where i.item_id=ic.item_id and i.item_id=a.item_id and ic.com_id='10371701'
and i.item_id='${itemid}'
      group by i.item_id,ic.short_code,item_name,ic.price_trade
   

select i.item_id,count(distinct cust_id) custnum,sum(qty_need*t_size)/50000 qtyneed,sum(qty_sold*t_size)/50000 qtysold from pi_cust_item_bnd_day a,plm_item i  where a.item_id=i.item_id and i.item_id='${itemid}'
and date1>='${date1}' and date1<='${date2}' group by i.item_id
 

select   cs.cust_seg   cust_type4,count(distinct cs.cust_id) custsl 
from pi_cust_item_bnd_day a,co_cust cs
where a.cust_id=cs.cust_id and a.qty_sold<>0
and a.date1>='${date1}' and a.date1<='${date2}' and a.item_id='${itemid}'
group by cs.cust_seg 


select cust_seg cust_type,qty_once_limit from 
(
select distinct cust_seg,qty_plan qty_once_limit  
from sgp_cust_item_spw a,co_cust ct 
where a.cust_id=ct.cust_id and item_id='${itemid}' and week='${week1}' and a.com_id='10371701'
 
union
select distinct  cust_seg,qty_once_limit   from SGP_CUSTTYPE_ITEM_limit a,
co_cust ct where ct.cust_seg=a.cust_type and item_id='${itemid}'
and ct.status='02'  

union
select distinct  cust_seg,qty_plan qty_once_limit   from SGP_CUSTTYPE_ITEM_spw a,
co_cust ct where ct.cust_seg=a.cust_type and ct.status='02'  and item_id='${itemid}'  and week='${week1}'
) order by cust_seg desc

select distinct  week from  SGP_CUSTTYPE_ITEM_spw
where week>'2016083' and com_id='10371701' order by week desc



