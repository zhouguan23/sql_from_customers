select im.cust_id,sum(isd.qty_sold) qty1,sum(isd.amt_sold) amt
   from pi_cust_item_month isd,co_cust im 
   where isd.cust_id=im.cust_id 

   and date1>='${time1}' and date1<='${time2}' 
 and im.status='02'  
 and im.cust_id in 
(select cust_code  from   gis_cust_mview@hzzm ,
 (select longitude ll, latitude aa from gis_cust_mview@hzzm  where cust_code='${cust_id}')
 where cust_code like substr('${cust_id}',1,8)||'%' and power(power((longitude-ll)*90,2)+power((latitude-aa)*111,2),0.5)<${pri})

   ${if(len(item_id)==0,"", " and isd.item_id='"+item_id+"'")}
   group by im.cust_id
  

select c.cust_id,cust_short_name from co_cust c,
(select cust_code  from   gis_cust_mview@hzzm ,
 (select longitude ll, latitude aa from gis_cust_mview@hzzm  where cust_code='${cust_id}')
 where cust_code like substr('${cust_id}',1,8)||'%' and power(power((longitude-ll)*90,2)+power((latitude-aa)*111,2),0.5)<${pri})  a where  a.cust_code=c.cust_id and c.status='02'

select im.cust_id,sum(isd.qty_sold) qty1,sum(isd.amt_sold) amt
   from pi_cust_item_month isd,co_cust im 
   where isd.cust_id=im.cust_id 

   and date1>='${time3}' and date1<='${time4}' 
 and im.status='02'  
 and im.cust_id in 
(select cust_code  from   gis_cust_mview@hzzm ,
 (select longitude ll, latitude aa from gis_cust_mview@hzzm  where cust_code='${cust_id}')
 where cust_code like substr('${cust_id}',1,8)||'%' and power(power((longitude-ll)*90,2)+power((latitude-aa)*111,2),0.5)<${pri})

   ${if(len(item_id)==0,"", " and isd.item_id='"+item_id+"'")}
   group by im.cust_id

select note||' 周 '||calls as note from (
select note from slsman where slsman_id='${sls}'),
(
select ${calls} calls from dual
)

select cust_name from co_cust where cust_id='${cust_id}'

select years,years2 from 
(
select to_char(sysdate,'yyyy') years from dual
),
(
SELECT  TO_CHAR(add_months(to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd'),-12),'YYYY' ) years2 FROM DUAL
)

