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

select org_id,parts_id,from_unixtime(created_at, '%Y-%m-%d %H:%i' ) as purdate from `dw_warehouse_detail` where id in 
	(
		select max(id) from `dw_warehouse_detail` where deleted=0 and stock_type in (100,101,102,103,104,105,106,107) 
		${if(len(org_id)=0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	  ${if(len(warehouse_id)=0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	  ${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	  ${if(len(enddate)==0,""," and stock_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59')")}
		group by org_id,parts_id			
	)

select org_id,parts_id,from_unixtime(created_at, '%Y-%m-%d %H:%i') as salesdate from `dw_sales_report` where id in 
	(
		select max(id) from `dw_sales_report` where deleted=0 
		${if(len(org_id)=0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	  ${if(len(warehouse_id)=0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	  ${if(len(startdate)==0,""," and end_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	  ${if(len(enddate)==0,""," and end_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59')")}
		group by org_id,parts_id
	) ;

select id,name,b_org_id from erp_warehouse where deleted=0
${if(len(org_id)=0,""," and b_org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}

select id,name_cn,parent_id from erp_parts_category where deleted=0

select id,name from erp_parts_abc

SELECT
		s.id,
		s.org_id,
		s.warehouse_id,
		s.parts_id,
		p.brand_id,
		p.category_id,
		p.name_cn,
		p.code,
		p.factory_code,
		p.abc_type,
		p.adaptable_vehicle
	FROM
		erp_stock s
	left join	erp_parts p on s.parts_id=p.id 
	WHERE
		s.deleted = 0
		and s.warehouse_id>=1
		${if(len(org_id)=0,""," and s.org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
		${if(len(warehouse_id)=0,""," and s.warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
		${if(len(category_id)=0,""," and p.category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")}
		${if(len(brand_id)=0,""," and p.brand_id in ('"+SUBSTITUTE(brand_id,",","','")+"')")}
		${if(len(parts_id)=0,""," and s.parts_id in ('"+SUBSTITUTE(parts_id,",","','")+"')")}
		${if(len(parts_code)=0,""," and p.code like '%"+parts_code+"%'")}
		${if(len(factory_code)=0,""," and p.factory_code like '%"+factory_code+"%'")}
		${if(len(parts_name)=0,""," and p.name_cn like '%"+parts_name+"%'")}
	GROUP BY
		s.org_id,
		s.warehouse_id,
		s.parts_id


select 
		stock_id,
		balance_count,
		total_agency_price  
		from erp_stock_transaction 
		where id in
	(
	SELECT
		max(id) 
	FROM
		`erp_stock_transaction` 
	WHERE
		deleted =0 
		${if(len(org_id)=0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
		${if(len(warehouse_id)=0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
		${if(len(enddate)==0,""," and created_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59')")}
		group by stock_id
		)

SELECT
		stock_id,
		balance_count,
		total_agency_price 
	FROM
		`erp_stock_transaction` 
	WHERE
		deleted =0 
		${if(len(org_id)=0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
		${if(len(warehouse_id)=0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
		${if(len(startdate)==0,""," and created_at>=UNIX_TIMESTAMP('"+startdate+"')")}
		group by stock_id

select stock_id,FROM_UNIXTIME(stock_time,'%Y-%m-%d') as stock_time from erp_stock_detail where deleted=0 and available_count>=1 group by stock_id

SELECT
	org_id,
	warehouse_id,
	parts_id,
	SUM( CASE WHEN business_type = 5 THEN - 1 *final_parts_count ELSE final_parts_count END ) AS final_parts_count,
	SUM( CASE WHEN business_type = 5 THEN - 1 * agency_price * final_parts_count ELSE agency_price * final_parts_count END ) AS agency_price,
	SUM( CASE WHEN business_type = 5 THEN - 1 * price * final_parts_count ELSE price * final_parts_count END ) AS price,
	SUM( CASE WHEN business_type = 5 THEN - 1 * profit * final_parts_count ELSE profit * final_parts_count END ) AS profit
FROM
	`dw_sales_report` 
WHERE
	deleted = 0 and final_parts_count<>0
	${if(len(org_id)=0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)=0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and end_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len(enddate)==0,""," and end_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59')")}
	
	group by org_id,warehouse_id,parts_id

select  * from erp_stock_time where 1=1
${if(len(org_id)=0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}

