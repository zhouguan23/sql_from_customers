SELECT
 parts_id,
 org_id,
 sum(start_balance_count) AS start_balance_count,
 sum(start_total_agency_price_no) AS start_total_agency_price_no,
 sum(start_total_agency_price) AS start_total_agency_price,
 sum(in_count) as in_count,
 sum(out_count) as out_count,
 sum(in_cur_total_price) as in_cur_total_price,
 sum(out_cur_total_price) as out_cur_total_price,
 sum(in_cur_total_price_no) as in_cur_total_price_no,
 sum(out_cur_total_price_no) as out_cur_total_price_no,
 sum(end_balance_count) AS end_balance_count,
 sum(end_total_agency_price_no) AS end_total_agency_price_no,
 sum(end_total_agency_price) AS end_total_agency_price
FROM
 (
  SELECT
   t2.parts_id,
   t2.org_id,
   t3.balance_count AS end_balance_count,
   t3.total_agency_price_no AS end_total_agency_price_no,
   t3.total_agency_price AS end_total_agency_price,
      in_count,
      out_count,
      in_cur_total_price,
      out_cur_total_price,
      in_cur_total_price_no,
      out_cur_total_price_no,
      t5.balance_count AS start_balance_count,
   t5.total_agency_price_no AS start_total_agency_price_no,
   t5.total_agency_price AS start_total_agency_price
  FROM
   (
    SELECT
     max(id) AS id,
     org_id,
     parts_id,
     warehouse_id
    FROM
     erp_stock_transaction t
    WHERE
     (t.created_at,t.warehouse_id,t.parts_id)
   in (
   SELECT
    max(created_at) as created_at,
    warehouse_id,
    parts_id
   FROM
    erp_stock_transaction
   WHERE
    t.org_id = org_id
    AND  
    t.warehouse_id = warehouse_id
    AND 
    t.parts_id = parts_id
       AND 
        deleted = 0
     ${if(len(enddate)==0,""," and created_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59')")}
    ${if(len(org_id)==0,""," and org_id = '"+org_id+"'")}
     ${if(len(warehouse_id)==0,""," and warehouse_id = '"+warehouse_id+"'")}
     ${if(len(parts_id)==0,""," and parts_id like '%"+parts_id+"%'")}
     ${if(len(parts_code)==0,""," and parts_code like '%"+parts_code+"%'")}
     ${if(len(parts_name)==0,""," and parts_name like '%"+parts_name+"%'")}
     ${if(len(brand_id)==0,""," and brand_id = '"+brand_id+"'")}
     ${if(len(category_id)=0,"","and category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")} 
  )
    GROUP BY
     org_id,
     warehouse_id,
     parts_id
   ) AS t2
  LEFT JOIN erp_stock_transaction AS t3 ON t2.id = t3.id
  LEFT JOIN (
   SELECT
    max(id) AS id,
    org_id,
    parts_id,
    warehouse_id
   FROM
    erp_stock_transaction t
   WHERE
     (t.created_at,t.warehouse_id,t.parts_id)
   in (
   SELECT
    max(created_at) as created_at,
    warehouse_id,
    parts_id
   FROM
    erp_stock_transaction
   WHERE
    t.org_id = org_id
    AND  
    t.warehouse_id = warehouse_id
    AND 
    t.parts_id = parts_id
       AND 
       deleted = 0
    ${if(len(startdate)==0,""," and created_at<=UNIX_TIMESTAMP('"+startdate+" 00:00:00')")}
    ${if(len(org_id)==0,""," and org_id = '"+org_id+"'")}
    ${if(len(warehouse_id)==0,""," and warehouse_id = '"+warehouse_id+"'")}
    ${if(len(parts_id)==0,""," and parts_id like '%"+parts_id+"%'")}
    ${if(len(parts_code)==0,""," and parts_code like '%"+parts_code+"%'")} 
    ${if(len(parts_name)==0,""," and parts_name like '%"+parts_name+"%'")}
    ${if(len(brand_id)==0,""," and brand_id = '"+brand_id+"'")}
    ${if(len(category_id)=0,"","and category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")} 
  )
   GROUP BY
    org_id,
    warehouse_id,
    parts_id
  ) AS t4 ON t4.org_id = t2.org_id
  AND t4.parts_id = t2.parts_id
  AND t4.warehouse_id = t2.warehouse_id
  LEFT JOIN erp_stock_transaction AS t5 ON t4.id = t5.id
    LEFT JOIN (
       SELECT
        sum(if(type=1,count,0)) as in_count,
        sum(if(type=2,count,0)) as out_count,
        sum(if(type=1,cur_total_price,0)) as in_cur_total_price,
        sum(if(type=1,0,cur_total_price)) as out_cur_total_price,
        sum(if(type=1,cur_total_price_no,0)) as in_cur_total_price_no,
        sum(if(type=1,0,cur_total_price_no)) as out_cur_total_price_no,
    org_id,
    parts_id,
    warehouse_id
   FROM
    erp_stock_transaction
   WHERE 
    deleted = 0
     and 1=1
   ${if(len(startdate)==0,""," and created_at>=UNIX_TIMESTAMP('"+startdate+" 00:00:00')")}
   ${if(len(enddate)==0,""," and created_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59')")}
   ${if(len(org_id)==0,""," and org_id = '"+org_id+"'")}
   ${if(len(warehouse_id)==0,""," and warehouse_id = '"+warehouse_id+"'")}
   ${if(len(parts_id)==0,""," and parts_id like '%"+parts_id+"%'")}
   ${if(len(parts_code)==0,""," and parts_code like '%"+parts_code+"%'")}
   ${if(len(parts_name)==0,""," and parts_name like '%"+parts_name+"%'")}
   ${if(len(brand_id)==0,""," and brand_id = '"+brand_id+"'")}
   ${if(len(category_id)=0,"","and category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")} 
   GROUP BY
    org_id,
    warehouse_id,
    parts_id
    ) as t6  ON t6.org_id = t2.org_id
  AND t6.parts_id = t2.parts_id
  AND t6.warehouse_id = t2.warehouse_id
 ) AS t1
GROUP BY
 parts_id,
 org_id

select id,code,name_cn,brand_id,brand_name,category_id,category_name,unit_name,abc_type,adaptable_vehicle from erp_parts where deleted=0
    ${if(len(parts_id)==0,""," and id like '%"+parts_id+"%'")}
    ${if(len(parts_code)==0,""," and code like '%"+parts_code+"%'")}
    ${if(len(parts_name)==0,""," and name_cn like '%"+parts_name+"%'")}               	  	${if(len(brand_id)==0,""," and brand_id = '"+brand_id+"'")}
    ${if(len(category_id)=0,"","and category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")}    

select id,parent_id,name_cn from erp_parts_category where status=1 and level=1

select id,parent_id,name_cn from erp_parts_category where status=1 and parent_id='${layer1}' and parent_id is not null

select id,parent_id,name_cn from erp_parts_category where status=1 and parent_id='${layer2}' and parent_id is not null

