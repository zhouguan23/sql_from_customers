select id,name,b_parent_id from  erp_org_base  where  deleted=0
and type = 3
${if(len(org_id)=0,"","and id in ('"+SUBSTITUTE(org_id,",","','")+"')")}

select id,name,b_org_id from erp_warehouse where deleted=0
 ${if(len(org_id)=0,""," and b_org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}

SELECT
t3.org_id,
  sum(end_balance_count) AS end_balance_count,
  sum(end_total_agency_price_no) AS end_total_agency_price_no,
  sum(end_total_agency_price) AS end_total_agency_price
FROM
  (
  SELECT
	 t1.org_id,
   t1.balance_count AS end_balance_count,
   t1.total_agency_price_no AS end_total_agency_price_no,
   t1.total_agency_price AS end_total_agency_price
  FROM
  erp_stock_transaction t1 left join erp_parts_category t2 on t1.category_id=t2.id WHERE
    t1.id in
   (
    SELECT
      max(id) AS id
    FROM
     erp_stock_transaction t
    WHERE
        deleted = 0
	${if(len(org_id)==0,""," and t.org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and t.warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and t.created_at<UNIX_TIMESTAMP('"+startdate+"')")}
    GROUP BY
     org_id,
     warehouse_id,
     parts_id
   ) 
	 ) AS t3
   GROUP BY
    org_id

SELECT 
	A.supply_org_id as org_id,
	SUM( round( T.num, 0 ) ) AS distribution_count,
	SUM( T.num * sales_price ) AS distribution_total_amount,
	SUM( T.agency_price ) AS distribution_total_amount_no 
FROM
	erp_org_distribution_apply_parts A 
LEFT JOIN 
	erp_org_distribution_apply E ON A.org_distribution_apply_id = E.id
LEFT JOIN (
	SELECT
		round( sum( num ), 4 ) AS num,
		round( sum( agency_price ), 4 ) AS agency_price,
		round( sum( agency_price_no ), 4 ) AS agency_price_no,
		apply_parts_id 
	FROM (
		SELECT
			t1.num,
			t1.agency_price,
			t1.agency_price_no,
			t1.parts_id,
			t1.org_id,
			t2.org_distribution_apply_parts_id AS apply_parts_id 
		FROM (
			SELECT
				( 0 - parts_final_count ) AS num,
				( 0 - parts_final_count * agency_price ) AS agency_price,
				( 0 - parts_final_count * agency_price_no ) AS agency_price_no,
				parts_id,
				purchase_org_id AS org_id,
				relate_order_parts_id 
			FROM
				erp_stock_order_parts 
			WHERE
				stock_type = 110 
				AND deleted = 0 
				AND updated_at >= 0 
				${if(len(enddate)==0, "", " AND updated_at<UNIX_TIMESTAMP('"+startdate+"') ")} 
		) AS t1
	LEFT JOIN erp_org_distribution_return_parts AS t2 ON t1.relate_order_parts_id = t2.id 
	WHERE
		t2.org_distribution_apply_parts_id UNION ALL
	SELECT
		parts_final_count AS num,
		parts_final_count * agency_price AS agency_price,
		parts_final_count * agency_price_no AS agency_price_no,
		parts_id,
		sales_org_id AS org_id,
		relate_order_parts_id 
	FROM
		erp_stock_order_parts 
	WHERE
		stock_type = 117 
		AND deleted = 0 
		AND updated_at >= 0 
		${if(len(enddate)==0, "", " AND updated_at<UNIX_TIMESTAMP('"+startdate+"') ")} 
	UNION ALL
	SELECT
		( 0- final_send_count ) AS num,
		( 0- final_send_count ) * agency_price AS agency_price,
		( 0- final_send_count ) * agency_price_no AS agency_price_no,
		parts_id,
		supply_org_id AS org_id,
		org_distribution_apply_parts_id AS apply_parts_id 
	FROM
		`erp_org_distribution_order_parts` 
	WHERE
		deleted = 0 
		AND is_closed = 0 
		AND final_send_count > 0 
		AND updated_at >= 0 
		${if(len(enddate)==0, "", " AND updated_at<UNIX_TIMESTAMP('"+startdate+"') ")} 
	UNION ALL
	SELECT
		final_order_count AS num,
		final_order_count * agency_price AS agency_price,
		final_order_count * agency_price_no AS agency_price_no,
		parts_id,
		supply_org_id AS org_id,
		id AS apply_parts_id 
	FROM
		`erp_org_distribution_apply_parts` 
	WHERE
		deleted = 0 
		AND final_order_count > 0 
		AND org_distribution_apply_order_sn NOT LIKE '%COO%' 
		) AS g 
	GROUP BY
		apply_parts_id 
) T ON A.id = T.apply_parts_id 
WHERE
	is_out_check = 1 
	AND A.buy_type = 2 
	${if(len(org_id)==0, "", " AND A.supply_org_id in ('"+SUBSTITUTE(org_id, ",", "','")+"') ")}
	${if(len(warehouse_id)==0, "", " AND E.send_warehouse_id in ('"+SUBSTITUTE(warehouse_id, ",", "','")+"') ")}
GROUP BY 
	E.supply_org_id

SELECT
                o.org_id,
                sum( parts_final_count*cost ) AS price
                FROM
                erp_transfer_order_parts p
                LEFT JOIN erp_transfer_order o ON p.transfer_order_id = o.id
                WHERE
                o.deleted = 0
                AND p.deleted = 0
                 ${if(len(warehouse_id)==0,""," and o.warehouse_out in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
                ${if(len(org_id)=0,"","and p.org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}        
	${if(len(startdate)==0,"","							
	and ((stock_in_time >UNIX_TIMESTAMP('" + startdate + "') or stock_in_time=0)
     and stock_out_time<=UNIX_TIMESTAMP('" + startdate + "')  and stock_out_time!=0) ")}
	 GROUP BY org_id;

SELECT
	t3.org_id,
  sum(end_balance_count) AS end_balance_count,
  sum(end_total_agency_price_no) AS end_total_agency_price_no,
  sum(end_total_agency_price) AS end_total_agency_price
FROM
  (
  SELECT
	 t1.org_id,
   t1.balance_count AS end_balance_count,
   t1.total_agency_price_no AS end_total_agency_price_no,
   t1.total_agency_price AS end_total_agency_price
  FROM
  erp_stock_transaction t1 left join erp_parts_category t2 on t1.category_id=t2.id WHERE
    t1.id in
   (
    SELECT
      max(id) AS id
    FROM
     erp_stock_transaction t
    WHERE
        deleted = 0
				${if(len(org_id)==0,""," and t.org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
				${if(len(warehouse_id)==0,""," and t.warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
				${if(len(enddate)==0,""," and t.created_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59')")}
    GROUP BY
     org_id,
     warehouse_id,
     parts_id
   ) 
	 ) AS t3
   GROUP BY
    org_id

SELECT 
	A.supply_org_id as org_id,
	SUM( round( T.num, 0 ) ) AS distribution_count,
	SUM( T.num * sales_price ) AS distribution_total_amount,
	SUM( T.agency_price ) AS distribution_total_amount_no 
FROM
	erp_org_distribution_apply_parts A 
LEFT JOIN 
	erp_org_distribution_apply E ON A.org_distribution_apply_id = E.id
LEFT JOIN (
	SELECT
		round( sum( num ), 4 ) AS num,
		round( sum( agency_price ), 4 ) AS agency_price,
		round( sum( agency_price_no ), 4 ) AS agency_price_no,
		apply_parts_id 
	FROM (
		SELECT
			t1.num,
			t1.agency_price,
			t1.agency_price_no,
			t1.parts_id,
			t1.org_id,
			t2.org_distribution_apply_parts_id AS apply_parts_id 
		FROM (
			SELECT
				( 0 - parts_final_count ) AS num,
				( 0 - parts_final_count * agency_price ) AS agency_price,
				( 0 - parts_final_count * agency_price_no ) AS agency_price_no,
				parts_id,
				purchase_org_id AS org_id,
				relate_order_parts_id 
			FROM
				erp_stock_order_parts 
			WHERE
				stock_type = 110 
				AND deleted = 0 
				AND updated_at >= 0 
				${if(len(enddate)==0, "", " AND updated_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59') ")} 
		) AS t1
	LEFT JOIN erp_org_distribution_return_parts AS t2 ON t1.relate_order_parts_id = t2.id 
	WHERE
		t2.org_distribution_apply_parts_id UNION ALL
	SELECT
		parts_final_count AS num,
		parts_final_count * agency_price AS agency_price,
		parts_final_count * agency_price_no AS agency_price_no,
		parts_id,
		sales_org_id AS org_id,
		relate_order_parts_id 
	FROM
		erp_stock_order_parts 
	WHERE
		stock_type = 117 
		AND deleted = 0 
		AND updated_at >= 0 
		${if(len(enddate)==0, "", " AND updated_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59') ")} 
	UNION ALL
	SELECT
		( 0- final_send_count ) AS num,
		( 0- final_send_count ) * agency_price AS agency_price,
		( 0- final_send_count ) * agency_price_no AS agency_price_no,
		parts_id,
		supply_org_id AS org_id,
		org_distribution_apply_parts_id AS apply_parts_id 
	FROM
		`erp_org_distribution_order_parts` 
	WHERE
		deleted = 0 
		AND is_closed = 0 
		AND final_send_count > 0 
		AND updated_at >= 0 
		${if(len(enddate)==0, "", " AND updated_at<=UNIX_TIMESTAMP('"+enddate+" 23:59:59') ")} 
	UNION ALL
	SELECT
		final_order_count AS num,
		final_order_count * agency_price AS agency_price,
		final_order_count * agency_price_no AS agency_price_no,
		parts_id,
		supply_org_id AS org_id,
		id AS apply_parts_id 
	FROM
		`erp_org_distribution_apply_parts` 
	WHERE
		deleted = 0 
		AND final_order_count > 0 
		AND org_distribution_apply_order_sn NOT LIKE '%COO%' 
		) AS g 
	GROUP BY
		apply_parts_id 
) T ON A.id = T.apply_parts_id 
WHERE
	is_out_check = 1 
	AND A.buy_type = 2 
	${if(len(org_id)==0, "", " AND A.supply_org_id in ('"+SUBSTITUTE(org_id, ",", "','")+"') ")}
	${if(len(warehouse_id)==0, "", " AND E.send_warehouse_id in ('"+SUBSTITUTE(warehouse_id, ",", "','")+"') ")}
GROUP BY 
	E.supply_org_id 

SELECT
                o.org_id,
                sum( parts_final_count*cost ) AS price
                FROM
                erp_transfer_order_parts p
                LEFT JOIN erp_transfer_order o ON p.transfer_order_id = o.id
                WHERE
                o.deleted = 0
                AND p.deleted = 0
                 ${if(len(warehouse_id)==0,""," and o.warehouse_out in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
                ${if(len(org_id)=0,"","and p.org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
                
	${if(len(startdate)==0,"","
								
	and (
                    (stock_in_time >UNIX_TIMESTAMP('" + enddate + " 23:59:59') 
											
				or stock_in_time=0
										)
                     and stock_out_time<=UNIX_TIMESTAMP('" + enddate + " 23:59:59') 
											
				and stock_out_time!=0
                    )
										 ")}
								
                GROUP BY
								o.org_id;

SELECT
	org_id,
	SUM( lscgtotal_price ) AS lscgtotal_price,
	sum( wctotal_price ) AS wctotal_price,
	sum(ctcjtotal_price) as ctcjtotal_price,
	sum(xsagency_price) as xsagency_price,
	sum(ykckprice) as ykckprice,
	sum(ykrkprice) as ykrkprice,
	sum(syagency_price) as syagency_price,
	sum(qtcrkagency_price) as qtcrkagency_price,
	sum(zpcrkagency_price) as zpcrkagency_price,
	sum(bfckagency_price) as bfckagency_price,
	sum(zyckagency_price) as zyckagency_price,
	sum(zzagency_price) as zzagency_price,
	sum(cbtzagency_price) as cbtzagency_price
FROM
	(
SELECT
	org_id,
	SUM( price * parts_final_count * discount_rate / 100 ) AS lscgtotal_price,
	'0' AS wctotal_price,
	'0' as ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type IN ( 102, 105, 106, 107, 103, 143, 147, 133, 144, 124, 121 ) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
	
GROUP BY
	org_id 
	
	UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	SUM( price * parts_final_count * discount_rate / 100 ) AS wctotal_price,
	'0' as ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type IN ( 100, 125 ) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id 
	
	UNION ALL
	
	SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	SUM( (price-agency_price) * -1*parts_final_count * discount_rate / 100 ) AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type IN ( 124,125 ) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
	UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	sum(agency_price*-1*parts_final_count * discount_rate / 100) as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type IN ( 117,114,115,116,109 ) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
		UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	sum(price*-1*parts_final_count * discount_rate / 100) as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type=134 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
			UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	sum(price*parts_final_count * discount_rate / 100) as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type=135 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
				UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	sum(agency_price*-1*parts_final_count * discount_rate / 100) as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type in (140,141) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
	UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	sum(agency_price*-1*parts_final_count * discount_rate / 100) as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type in (112,128) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
	UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	sum(agency_price*-1*parts_final_count * discount_rate / 100) as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type in (138,139) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
		UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	sum(agency_price*-1*parts_final_count * discount_rate / 100) as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type=137 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
			UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	sum(agency_price*-1*parts_final_count * discount_rate / 100) as zyckagency_price,
	'0' as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type=136 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
				UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	sum(agency_price*-1*parts_final_count * discount_rate / 100) as zzagency_price,
	'0' as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type in (129,130) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
					UNION ALL
	
SELECT
	org_id,
	'0' AS lscgtotal_price,
	'0' as wctotal_price,
	'0' AS ctcjtotal_price,
	'0' as xsagency_price,
	'0' as ykckprice,
	'0' as ykrkprice,
	'0' as syagency_price,
	'0' as qtcrkagency_price,
	'0' as zpcrkagency_price,
	'0' as bfckagency_price,
	'0' as zyckagency_price,
	'0' as zzagency_price,
	sum(agency_price*-1*parts_final_count * discount_rate / 100) as cbtzagency_price
FROM
	dw_warehouse_detail 
WHERE
	stock_type in (149,148) 
	AND org_id != 1 
	AND deleted = 0 
	${if(len(org_id)==0,""," and org_id in ('"+SUBSTITUTE(org_id,",","','")+"')")}
	${if(len(warehouse_id)==0,""," and warehouse_id in ('"+SUBSTITUTE(warehouse_id,",","','")+"')")}
	${if(len(startdate)==0,""," and stock_at>=UNIX_TIMESTAMP('"+startdate+"')")}
	${if(len( enddate ) == 0, "", " and stock_at<=UNIX_TIMESTAMP('" + enddate + " 23:59:59')" ) }
GROUP BY
	org_id
	
	) t 
GROUP BY
org_id

