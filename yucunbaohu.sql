select  c.born_date,c.cust_id,cc.cust_name,c.amt_sum
 from  co_co c,co_cust cc,(select cust_id from crm_cust where is_multiple_shop='1') a
 WHERE C.CUST_ID=CC.CUST_ID
 and a.cust_id=cc.cust_id
 AND CC.STATUS='02'
 AND C.STATUS<>'90'
  AND C.BORN_DATE>='${date1}'
 AND C.BORN_DATE<='${date2}'
 AND CC.SALE_DEPT_ID='${dept}'
 AND CC.TAX_ACCOUNT  IS NOT NULL
 and cc.tax_account not  in
 ('372901724812645','372901777743705X','913717000906941567','91370000732603894Y'，'91371700793904535W')
 ORDER BY  TAX_ACCOUNT







