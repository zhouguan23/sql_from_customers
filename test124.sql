select cust_id,crm_longitude,crm_latitude from crm_cust
where crm_longitude is not null
and rownum<100

