select
depa.DPT_SALE_NAME,
w.license_code,
w.cust_name,
w.sale_dept_id,
w.cust_id,
w.itemCount,
case when w.rim_kind='11' then '品牌店' when w.rim_kind='12' then '精品店' when w.rim_kind='13' then '标准店' else '未知' end as rim_kind,
w.cust_seg,
case when w.cust_type3='011' then '城区' when w.cust_type3='012' or w.cust_type3='013' then '乡镇' when w.cust_type3='023' or w.cust_type3='024' then '农村' else '品牌店' end as cust_type3,
case when w.cust_seg>5 then (
case when w.rim_kind='11' then '90' 
when w.rim_kind='12' then (case when w.cust_type3='011' then '55' when w.cust_type3='012' or w.cust_type3='013' then '50' when w.cust_type3='023' or w.cust_type3='024' then '40' else '未知' end) 
when w.rim_kind='13' then (case when w.cust_type3='011' then '40' when w.cust_type3='012' or w.cust_type3='013' then '25' when w.cust_type3='023' or w.cust_type3='024' then '15' else '未知' end)  
else '未知' end)
else '10' end as rim_kind_number,
w.busi_addr,
depa.DPT_SALE_NAME,
case when w.PPD>0 then '不合格' else '合格' end as ppd,
case when w.jpd_cq>0 then '不合格' else '合格' end as jpd_cq,
case when w.jpd_xz>0 then '不合格' else '合格' end as jpd_xz,
case when w.jpd_nc>0 then '不合格' else '合格' end as jpd_nc,
case when w.bzd_cq>0 then '不合格' else '合格' end as bzd_cq,
case when w.bzd_xz>0 then '不合格' else '合格' end as bzd_xz,
case when w.bzd_nc>0 then '不合格' else '合格' end as bzd_nc,
case when w.five_ppd>0 then '不合格' else '合格' end as five_ppd,
case when w.five_jpd>0 then '不合格' else '合格' end as five_jpd,
case when w.five_bzd>0 then '不合格' else '合格' end as five_bzd
from (
select
zcc.license_code,
zcc.cust_name,
zcc.sale_dept_id,
zcc.cust_id,
f.rim_kind,
zcc.cust_seg,
zcc.cust_type3,
zcc.busi_addr,
item.itemCount,
case when f.rim_kind='11' and zcc.cust_seg>5 and item.itemCount<90 then 1 else 0 end as ppd,
case when f.rim_kind='12' and zcc.cust_type3='011' and zcc.cust_seg>5 and item.itemCount<55 then 1 else 0 end as jpd_cq,
case when f.rim_kind='12' and (zcc.cust_type3='012' or zcc.cust_type3='013') and zcc.cust_seg>5 and item.itemCount<50 then 1 else 0 end as jpd_xz,
case when f.rim_kind='12' and (zcc.cust_type3='023' or zcc.cust_type3='024') and zcc.cust_seg>5 and item.itemCount<40 then 1 else 0 end as jpd_nc,
case when f.rim_kind='13' and zcc.cust_type3='011' and zcc.cust_seg>5 and item.itemCount<40 then 1 else 0 end as bzd_cq,
case when f.rim_kind='13' and (zcc.cust_type3='012' or zcc.cust_type3='013') and zcc.cust_seg>5 and item.itemCount<25 then 1 else 0 end as bzd_xz,
case when f.rim_kind='13' and (zcc.cust_type3='023' or zcc.cust_type3='024') and zcc.cust_seg>5 and item.itemCount<15 then 1 else 0 end as bzd_nc,
case when f.rim_kind='11' and zcc.cust_seg<=5 and item.itemCount<10 then 1 else 0 end as five_ppd,
case when f.rim_kind='12' and zcc.cust_seg<=5 and item.itemCount<10 then 1 else 0 end as five_jpd,
case when f.rim_kind='13' and zcc.cust_seg<=5 and item.itemCount<10 then 1 else 0 end as five_bzd
from (
select  
t.CUST_ID
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
select CUST_ID,count(1) as orderCount from CO_CO
where 
substr(BORN_DATE,1,6)>='${begin}'
and substr(BORN_DATE,1,6)<='${end}'
group by CUST_ID
)oc on oc.CUST_ID=cp.CUST_ID
left join (
select ci.CUST_ID,
count(1) as itemCount
from (
select  
t.CUST_ID,
t.ITEM_ID
from PI_CUST_ITEM_MONTH t
where t.DATE1>='${begin}'
and t.DATE1<='${end}'
and t.QTY_SOLD>0
group by t.CUST_ID,t.ITEM_ID)ci
GROUP BY ci.CUST_ID
)item on item.CUST_ID=cp.CUST_ID
where
f.RIM_KIND<>'14'
${if(ddCount=='0',"and oc.orderCount>=12","")}
${if(ddCount=='1',"and oc.orderCount<12","")}
${if(len(storeType)>0,"and f.RIM_KIND = '"+storeType+"'","")}
${if(qy=='011',"and zcc.cust_type3 = '"+qy+"'","")}
${if(qy=='012',"and (zcc.cust_type3 = '012' or zcc.cust_type3 = '013')","")}
${if(qy=='023',"and (zcc.cust_type3 = '023' or zcc.cust_type3 = '024')","")}
${if(seg=='0',"and zcc.cust_seg in ('06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30')","")}
${if(seg=='1',"and zcc.cust_seg in ('01','02','03','04','05')","")}
ORDER BY zcc.sale_dept_id asc)w
left join dpt_sale depa on depa.dpt_sale_id=w.SALE_DEPT_ID 
where 
1=1
and w.license_code not in ('371702105406')
and (w.PPD>0 or w.JPD_CQ>0 or w.JPD_NC>0 or w.JPD_XZ>0 or w.BZD_CQ>0 or w.BZD_NC>0 or w.BZD_XZ>0 or w.FIVE_BZD>0 or w.FIVE_JPD>0 or w.FIVE_PPD>0)
${if(depa=='all',"and 1=1","and w.SALE_DEPT_ID = '"+depa+"'")}

select * from (
select 'all' as dpt_sale_id,'全部' as dpt_sale_name from dual
union all
SELECT  dpt_sale_id,dpt_sale_name FROM dpt_sale
)w
where 1=1
${if("市局"=fine_role,"and 1=1","")}
${if("曹县"=fine_role,"and w.dpt_sale_id='11371703'","")}
${if("成武"=fine_role,"and w.dpt_sale_id='11371704'","")}
${if("单县"=fine_role,"and w.dpt_sale_id='11371705'","")}
${if("定陶"=fine_role,"and w.dpt_sale_id='11371706'","")}
${if("东明"=fine_role,"and w.dpt_sale_id='11371707'","")}
${if("巨野"=fine_role,"and w.dpt_sale_id='11371708'","")}
${if("鄄城"=fine_role,"and w.dpt_sale_id='11371709'","")}
${if("牡丹区"=fine_role,"and w.dpt_sale_id='11371710'","")}
${if("郓城"=fine_role,"and w.dpt_sale_id='11371711'","")}

