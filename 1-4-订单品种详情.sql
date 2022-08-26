SELECT t.*,g.is_tobacco,
case when g.is_tobacco='01' then '烟' ELSE '非烟' END AS "isTobacco"
FROM pos_salesdata t
LEFT JOIN pos_goodsinfo g ON g.org_code='11371701' AND g.barcode=t.barcode
WHERE
1=1
${if(len(license_code)==0,"","and t.license_code='"+license_code+"'")}
${if(len(sales_date)==0,"","and t.sales_date='"+sales_date+"'")}
${if(len(types)==0,"",if(types=='01',"and g.is_tobacco='01'","and (g.is_tobacco='00' or g.is_tobacco is null)"))}
${if(len(key)==0,"","and t.sales_id like '%"+key+"%'")}
${if(status=='0',"","AND ROUND(t.amoney/t.amount,4)<1")}

