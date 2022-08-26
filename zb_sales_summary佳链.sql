SELECT id,name_cn FROM erp_parts_brand where deleted=0 

SELECT id,name,grade FROM crm_vendor where deleted=0
and grade=1 and org_id=1
and id in (SELECT supplier_id FROM erp_purchase_order_parts  WHERE supplier_type = 2 GROUP BY supplier_id)


select id,parent_id,name_cn from erp_parts_category where status=1

SELECT id,name FROM crm_vendor where deleted=0

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
 c.parent_id 
FROM
 erp_parts p
 LEFT JOIN erp_parts_category c ON p.category_id = c.id 
WHERE
 p.deleted = 0 
 ${if(len(brand_id)==0,""," and p.brand_id in ('"+SUBSTITUTE(brand_id,",","','")+"')")}
${if(len(parts_id)==0,""," and p.id in ('"+SUBSTITUTE(parts_id,",","','")+"')")}
 ${if(len(category_id)==0,""," and p.category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")}

SELECT
	parts_id,
	brand_id,
	first_category_id,
	first_category_name,
	second_category_id,
	second_category_name,
	third_category_id,
	third_category_name,
	SUM( CASE WHEN (stock_type = 108 or stock_type = 104 or stock_type = 145 ) THEN -1 * parts_final_count ELSE -1 * parts_final_count END ) AS parts_final_count,
	SUM( CASE WHEN (stock_type = 108 or stock_type = 104 or stock_type = 145 ) THEN -1 * price * parts_final_count*discount_rate/100 ELSE -1 * price * parts_final_count*discount_rate/100 END ) AS total_price,
	SUM( CASE WHEN (stock_type = 108 or stock_type = 104 or stock_type = 145 ) THEN -1 * profit * parts_final_count ELSE -1 * profit * parts_final_count END ) AS total_profit
FROM
	dw_warehouse_detail 
WHERE
	stock_type IN (118,119, 120,122,123,142,146,108,104,145)
	AND deleted = 0 
${if(len(brand_id)==0,""," and brand_id in ('"+SUBSTITUTE(brand_id,",","','")+"')")}
${if(len(parts_id)==0,""," and parts_id in ('"+SUBSTITUTE(parts_id,",","','")+"')")}
${if(len(category_id)==0,""," and third_category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")}
${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"-01')")}

${if(len(startdate)==0,""," and stock_at<=UNIX_TIMESTAMP(CONCAT(last_day('"+startdate+"-01'),' 23:59:59'))" )}

GROUP BY
	parts_id;

SELECT
	parts_id,
	brand_id,
	first_category_id,
	first_category_name,
	second_category_id,
	second_category_name,
	third_category_id,
	third_category_name,
	SUM( CASE business_type WHEN  5 THEN -1 * final_parts_count ELSE final_parts_count END ) AS final_parts_count,
	SUM( CASE business_type WHEN  5 THEN -1 * price * final_parts_count*discount_rate/100 ELSE price * final_parts_count*discount_rate/100 END ) AS total_price,
	SUM( CASE business_type WHEN  5 THEN -1 * profit * final_parts_count ELSE profit * final_parts_count END ) AS total_profit
FROM
	dw_sales_report 
WHERE
	final_parts_count <> 0
	AND deleted = 0 
	and org_id = 1 
	${if(len(brand_id)==0,""," and brand_id in ('"+SUBSTITUTE(brand_id,",","','")+"')")}
	${if(len(parts_id)==0,""," and parts_id in ('"+SUBSTITUTE(parts_id,",","','")+"')")}
	${if(len(category_id)==0,""," and third_category_id in ('"+SUBSTITUTE(category_id,",","','")+"')")}
	${if(len(startdate)==0,""," and end_at>=UNIX_TIMESTAMP('"+startdate+"-01')")}
	${if(len( startdate ) == 0, "", " and end_at<=UNIX_TIMESTAMP(CONCAT(last_day('" +startdate+ "-01'),' 23:59:59'))" ) }
GROUP BY
	parts_id;

SELECT id,concat(name_cn,'|',factory_code,'|',code,'|',brand_name,'|',id)  as name_cn from erp_parts where deleted=0



