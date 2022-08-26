select 
r.SALE_DEPT_ID,
depa.dpt_sale_name,
sum(r.PPD) as PPD,
sum(r.JPD_CQ) as JPD_CQ,
sum(r.JPD_XZ) as JPD_XZ,
sum(r.JPD_NC) as JPD_NC,
sum(r.BZD_CQ) as BZD_CQ,
sum(r.BZD_XZ) as BZD_XZ,
sum(r.BZD_NC) as BZD_NC,
sum(r.FIVE_PPD) as FIVE_PPD,
sum(r.FIVE_JPD) as FIVE_JPD,
sum(r.FIVE_BZD) as FIVE_BZD,
sum(r.KD_PPD) as KD_PPD,
sum(r.KD_JPD_CQ) as KD_JPD_CQ,
sum(r.KD_JPD_XZ) as KD_JPD_XZ,
sum(r.KD_JPD_NC) as KD_JPD_NC,
sum(r.KD_BZD_CQ) as KD_BZD_CQ,
sum(r.KD_BZD_XZ) as KD_BZD_XZ,
sum(r.KD_BZD_NC) as KD_BZD_NC,
sum(r.KD_FIVE_PPD) as KD_FIVE_PPD,
sum(r.KD_FIVE_JPD) as KD_FIVE_JPD,
sum(r.KD_FIVE_BZD) as KD_FIVE_BZD
from (
select
zcc.license_code,
zcc.cust_name,
zcc.sale_dept_id,
cp.cust_id,
cp.price,
f.rim_kind,
zcc.cust_seg,
zcc.cust_type3,
case when f.rim_kind='11' and zcc.cust_seg>5 and cp.price<70 then 1 else 0 end as ppd,
case when f.rim_kind='12' and zcc.cust_type3='011' and zcc.cust_seg>5 and cp.price<53 then 1 else 0 end as jpd_cq,
case when f.rim_kind='12' and (zcc.cust_type3='012' or zcc.cust_type3='013') and zcc.cust_seg>5 and cp.price<53 then 1 else 0 end as jpd_xz,
case when f.rim_kind='12' and (zcc.cust_type3='023' or zcc.cust_type3='024') and zcc.cust_seg>5 and cp.price<30 then 1 else 0 end as jpd_nc,
case when f.rim_kind='13' and zcc.cust_type3='011' and zcc.cust_seg>5 and cp.price<35 then 1 else 0 end as bzd_cq,
case when f.rim_kind='13' and (zcc.cust_type3='012' or zcc.cust_type3='013') and zcc.cust_seg>5 and cp.price<28 then 1 else 0 end as bzd_xz,
case when f.rim_kind='13' and (zcc.cust_type3='023' or zcc.cust_type3='024') and zcc.cust_seg>5 and cp.price<22 then 1 else 0 end as bzd_nc,
case when f.rim_kind='11' and zcc.cust_seg<=5 and cp.price<16 then 1 else 0 end as five_ppd,
case when f.rim_kind='12' and zcc.cust_seg<=5 and cp.price<16 then 1 else 0 end as five_jpd,
case when f.rim_kind='13' and zcc.cust_seg<=5 and cp.price<16 then 1 else 0 end as five_bzd,
case when f.rim_kind='11' and zcc.cust_seg>5 and item.itemCount<90 then 1 else 0 end as kd_ppd,
case when f.rim_kind='12' and zcc.cust_type3='011' and zcc.cust_seg>5 and item.itemCount<55 then 1 else 0 end as kd_jpd_cq,
case when f.rim_kind='12' and (zcc.cust_type3='012' or zcc.cust_type3='013') and zcc.cust_seg>5 and item.itemCount<50 then 1 else 0 end as kd_jpd_xz,
case when f.rim_kind='12' and (zcc.cust_type3='023' or zcc.cust_type3='024') and zcc.cust_seg>5 and item.itemCount<40 then 1 else 0 end as kd_jpd_nc,
case when f.rim_kind='13' and zcc.cust_type3='011' and zcc.cust_seg>5 and item.itemCount<40 then 1 else 0 end as kd_bzd_cq,
case when f.rim_kind='13' and (zcc.cust_type3='012' or zcc.cust_type3='013') and zcc.cust_seg>5 and item.itemCount<25 then 1 else 0 end as kd_bzd_xz,
case when f.rim_kind='13' and (zcc.cust_type3='023' or zcc.cust_type3='024') and zcc.cust_seg>5 and item.itemCount<15 then 1 else 0 end as kd_bzd_nc,
case when f.rim_kind='11' and zcc.cust_seg<=5 and item.itemCount<10 then 1 else 0 end as kd_five_ppd,
case when f.rim_kind='12' and zcc.cust_seg<=5 and item.itemCount<10 then 1 else 0 end as kd_five_jpd,
case when f.rim_kind='13' and zcc.cust_seg<=5 and item.itemCount<10 then 1 else 0 end as kd_five_bzd
from (
select  
t.CUST_ID,
max(p.PRICE_RETAIL)/10 as price
from PI_CUST_ITEM_MONTH t
LEFT JOIN ZCFW_PLM_ITEM_COM p on p.ITEM_ID=t.ITEM_ID
LEFT JOIN ZCFW_CO_CUST cc on cc.cust_id=t.CUST_ID
where t.DATE1>='${begin}'
and t.DATE1<='${end}'
and t.QTY_SOLD>0
and cc.STATUS='02'
group by t.CUST_ID)cp
left join CRM_CUST f on f.CUST_ID=cp.CUST_ID
LEFT JOIN ZCFW_CO_CUST zcc on zcc.cust_id=cp.CUST_ID
left join (
select ci.CUST_ID,
count(1) as itemCount
from (
select  
t.CUST_ID,
t.ITEM_ID
from PI_CUST_ITEM_MONTH t
LEFT JOIN ZCFW_CO_CUST cc on cc.cust_id=t.CUST_ID
where t.DATE1>='${begin}'
and t.DATE1<='${end}'
and t.QTY_SOLD>0
and cc.STATUS='02'
group by t.CUST_ID,t.ITEM_ID)ci
GROUP BY ci.CUST_ID
)item on item.CUST_ID=cp.CUST_ID
left join (
select CUST_ID,count(1) as orderCount from CO_CO
where 
substr(BORN_DATE,1,6)>='${begin}'
and substr(BORN_DATE,1,6)<='${end}'
group by CUST_ID
)oc on oc.CUST_ID=cp.CUST_ID
where
f.RIM_KIND<>'14'
and zcc.license_code not in ('371702105429','371702105406')
${if(ddCount=='0',"and oc.orderCount>=12","")}
${if(ddCount=='1',"and oc.orderCount<12","")}
)r
left join dpt_sale depa on depa.dpt_sale_id=r.SALE_DEPT_ID
where 1=1
${if(depa=='all',"and 1=1","and r.SALE_DEPT_ID = '"+depa+"'")}
group by r.SALE_DEPT_ID,depa.dpt_sale_name

select * from (
select 'all' as dpt_sale_id,'全部' as dpt_sale_name from dual
union all
SELECT  dpt_sale_id,dpt_sale_name FROM dpt_sale
)w

