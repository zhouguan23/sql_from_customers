select b.id,b.name,( CASE WHEN b.b_parent_id=0  THEN 1  ELSE b.b_parent_id END ) AS b_parent_id,(CASE WHEN p.name is null then '优配车联' else p.name end ) as b_parent_name from  erp_org_base b left join erp_org_base p on b.b_parent_id=p.id where  b.deleted=0
and b.type = 3


SELECT
 p.id,
 p.name_cn,
 p.code,
 p.factory_code,
 p.abc_type,
 p.adaptable_vehicle,
 p.brand_id,
 p.brand_name,
 p.category_id,
 p.category_name,
 c.parent_id 
FROM
 erp_parts p
 LEFT JOIN erp_parts_category c ON p.category_id = c.id 
WHERE
 p.deleted = 0 

select id,name,b_org_id from erp_warehouse where deleted=0
${if(len(org_id)=0,""," and b_org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}

select id,name_cn,parent_id from erp_parts_category where deleted=0

select id,name from erp_parts_abc


  SELECT
	 org_id,
	 warehouse_id,
	 parts_id,
	 parts_name,
	 parts_code,
	 brand_name,
	 category_name,
	 parts_factory_code,
	 unit,
   balance_count,
   total_agency_price_no,
   total_agency_price,
	 
	 cur_head_agency_price_no,
	 cur_head_agency_price,
	 total_head_agency_price_no,
	 total_head_agency_price
	 
  FROM
  erp_stock_transaction  WHERE
    id in
   (
    SELECT
      max(id) AS id
    FROM
     erp_stock_transaction t
    WHERE
        deleted = 0
				${if(len(org_id)==0,""," and t.org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
				${if(len(warehouse_id)==0,""," and t.warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
				${if(len(brand_id)==0,""," and t.brand_id in ('"+SUBSTITUTE(brand_id,",","','")+"')")}
				${if(len(category_id)==0,""," and t.category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")}
				${if(len(parts_id)==0,""," and t.parts_id in ('"+SUBSTITUTE(parts_id,",","','")+"')")}
				${if(len(parts_code)==0,""," and t.parts_code like '%"+parts_code+"%' ")}
				${if(len(factory_code)==0,""," and t.parts_factory_code like '%"+factory_code+"%' ")}
				${if(len(parts_name)==0,""," and t.parts_name like '%"+parts_name+"%' ")}
				${if(len(startdate)==0,""," and t.created_at<=UNIX_TIMESTAMP('"+startdate+" 23:59:59')")}
    GROUP BY
     org_id,
     warehouse_id,
     parts_id
   ) 
   

