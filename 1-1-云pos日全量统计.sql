SELECT 
t.license_code,
t.sales_date,
t.sale_amt,
t.sale_mny,
t.smCount,
t.sumCount,
t.fy,
t.fyMoney,
t.fyCount,
t.jy,
t.jyMoney,
t.jyCount,
t.minTime,
t.maxTime,
d.cust_id,
d.cust_name,
d.sale_dept_id,
d.slsman_id,
d.busi_addr,
d.`status`,
d.cust_seg,
d.cust_type3,
d.rim_kind,
d.crm_latitude,
d.crm_longitude,
ROUND(t.fyMoney/t.fyCount,4) AS "fyAver",
ROUND(t.jyMoney/t.jyCount,4) AS "jyAver"
FROM pos_sum_day_2021_2022 t
LEFT JOIN pos_cust d ON d.license_code=t.license_code
WHERE 
1=1
${if(len(days)==0,"","and t.sales_date='"+days+"'")}
${if(len(key)==0,"","and (t.license_code like '%"+key+"%' or d.cust_id like '%"+key+"%'  or d.cust_name like '%"+key+"%')")}
${if(status=='0',"","AND ROUND(t.fyMoney/t.fyCount,4)<1")}

