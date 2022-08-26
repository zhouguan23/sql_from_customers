
 select c.cust_id,cust_name,busi_addr,c.sale_dept_id,sum(amt_sum)  amt from co_co cc,  co_cust c
  where c.tax_account='372901724812645' and cc.status<>'90'  and cc.cust_id=c.cust_id and cc.pmt_status=1
 and cc.born_date>='${date1}' and cc.born_date<='${date2}' group by c.cust_id,cust_name,busi_addr,c.sale_dept_id
 

 select c.cust_id,cust_name,busi_addr,c.sale_dept_id,sum(amt_sum)  amt from co_co cc,  co_cust c
  where tax_account='372901777743705X'   and cc.status<>'90'  and cc.cust_id=c.cust_id
and cc.pmt_status=1
 and cc.born_date>='${date1}' and cc.born_date<='${date2}' group by c.cust_id,cust_name,busi_addr,c.sale_dept_id

 select  '1702' regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='372901724812645' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id   like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
union

 select  substr(region_id,1,4) regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='372901724812645' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id not like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
 group by   substr(region_id,1,4)

 select  '1702' regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='372901777743705X' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id   like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
union

 select  substr(region_id,1,4) regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='372901777743705X' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id not like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
 group by   substr(region_id,1,4)

 select '1702'  regionid from dual
 union
 select substr(region_id,1,4) regionid    from ldm_cust where region_id not like '00%'


 select c.cust_id,cust_name,busi_addr,c.sale_dept_id,sum(amt_sum)  amt from co_co cc,  co_cust c
  where c.tax_account='91370000732603894Y' and cc.status<>'90'  and cc.cust_id=c.cust_id and cc.pmt_status=1
 and cc.born_date>='${date1}' and cc.born_date<='${date2}' group by c.cust_id,cust_name,busi_addr,c.sale_dept_id

 select  '1702' regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='91370000732603894Y' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id   like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
union

 select  substr(region_id,1,4) regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='91370000732603894Y' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id not like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
 group by   substr(region_id,1,4)


 select c.cust_id,cust_name,busi_addr,c.sale_dept_id,sum(amt_sum)  amt from co_co cc,  co_cust c
  where c.tax_account='91371700793904535W' and cc.status<>'90'  and cc.cust_id=c.cust_id and cc.pmt_status=1
 and cc.born_date>='${date1}' and cc.born_date<='${date2}' group by c.cust_id,cust_name,busi_addr,c.sale_dept_id
 

 select  '1702' regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='91371700793904535W' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id   like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
union

 select  substr(region_id,1,4) regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='91371700793904535W' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id not like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
 group by   substr(region_id,1,4)

select c.cust_id,cust_name,busi_addr,c.sale_dept_id,sum(amt_sum)  amt from co_co cc,  co_cust c
  where c.tax_account='913717000906941567' and cc.status<>'90'  and cc.cust_id=c.cust_id and cc.pmt_status=1
 and cc.born_date>='${date1}' and cc.born_date<='${date2}' group by c.cust_id,cust_name,busi_addr,c.sale_dept_id

 select  '1702' regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='913717000906941567' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id   like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
union

 select  substr(region_id,1,4) regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='913717000906941567' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id not like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
 group by   substr(region_id,1,4)

 select c.cust_id,cust_name,busi_addr,c.sale_dept_id,sum(amt_sum)  amt from co_co cc,  co_cust c
  where tax_account='9137170068229831M'   and cc.status<>'90'  and cc.cust_id=c.cust_id
and cc.pmt_status=1
 and cc.born_date>='${date1}' and cc.born_date<='${date2}' group by c.cust_id,cust_name,busi_addr,c.sale_dept_id


 select c.cust_id,cust_name,busi_addr,c.sale_dept_id,sum(amt_sum)  amt from co_co cc,  co_cust c
  where c.tax_account='91371700MA3M079U4Y' and cc.status<>'90'  and cc.cust_id=c.cust_id and cc.pmt_status=1
 and cc.born_date>='${date1}' and cc.born_date<='${date2}' group by c.cust_id,cust_name,busi_addr,c.sale_dept_id

 select  '1702' regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='9137170068229831M' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id   like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
union

 select  substr(region_id,1,4) regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='91371700683229831M' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id not like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
 group by   substr(region_id,1,4)

 select  '1702' regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='91371700MA3M079U4Y' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id   like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
union

 select  substr(region_id,1,4) regionid,sum(amt_sum)  amt from co_co cc,co_cust c,  ldm_cust lc
  where c.tax_account='91371700MA3M079U4Y' and cc.status<>'90'  and c.cust_id=lc.cust_id and cc.pmt_status=1 and cc.cust_id=c.cust_id and lc.region_id not like '00%'
 and cc.born_date>='${date1}' and cc.born_date<='${date2}'
 group by   substr(region_id,1,4)

