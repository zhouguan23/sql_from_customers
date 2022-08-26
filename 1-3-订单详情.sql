SELECT t.*,
case when t.sales_type='10' then '销售' else '退货' end as "types"
FROM pos_salesorder t
WHERE
1=1
${if(len(license_code)==0,"","and t.license_code='"+license_code+"'")}
${if(len(sales_date)==0,"","and t.sales_date='"+sales_date+"'")}
${if(len(key)==0,"","and t.sales_id like '%"+key+"%'")}
${if(status=='0',"","AND ROUND(t.sale_mny/t.sale_amt,4)<1")}

