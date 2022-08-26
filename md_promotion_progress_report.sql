SELECT
  r.id as group_id,
 r.parts_group_id,
 r.start_date,
 r.end_date,
 s.ref_id AS org_id,
 s.ref_name AS org_name,
 (
    SELECT
    SUM( CASE WHEN business_type = 5 THEN - 1 * price * final_parts_count*discount_rate/100 ELSE price * final_parts_count*discount_rate/100 END ) AS total_price 
   FROM
    dw_sales_report 
   WHERE
    deleted = 0 
    AND final_parts_count <> 0
    and org_id=s.ref_id 
   ${if(len(F2)=0,""," and parts_id in ("+F2+")")} 
   and end_at>=UNIX_TIMESTAMP(r.start_date) 
   and end_at<=UNIX_TIMESTAMP(CONCAT(r.end_date," 23:59:59"))
   
 ) as total_price,
 (
    SELECT
    SUM( CASE WHEN business_type = 5 THEN - 1  * final_parts_count ELSE  final_parts_count END ) AS final_parts_count 
   FROM
    dw_sales_report 
   WHERE
    deleted = 0 
    AND final_parts_count <> 0
    and org_id=s.ref_id 
   ${if(len(F2)=0,""," and parts_id in ("+F2+")")} 
   and end_at>=UNIX_TIMESTAMP(r.start_date) 
   and end_at<=UNIX_TIMESTAMP(CONCAT(r.end_date," 23:59:59"))
   
 ) as final_parts_count
FROM
 `kpi_report_sales` AS s
 LEFT JOIN `kpi_report` r ON s.kpi_id = r.id 
WHERE
 r.CODE = "cuxiao" 
 AND r.is_ban = 1 
 AND r.deleted = 0 
 ${if(len(group_id)=0,""," and r.id in ('"+SUBSTITUTE(group_id,",","','")+"')")}
${if(len(org_id)=0,""," and s.ref_id='"+org_id+"'")} 
GROUP BY
 r.id,
 s.ref_id;

SELECT
 t1.*,
 t2.b_parent_name,
 t2.b_parent_id,
 g.`sql` as group_sql
FROM
 (
SELECT
 r.id,
 r.name,
 r.parts_group_id,
 s.ref_id AS org_id,
 s.ref_name AS org_name,
 r.start_date,
 r.end_date,
 sum( s.parts_sum) as parts_sum,
 sum( s.amount ) AS amount
FROM
 `kpi_report_sales` AS s
 LEFT JOIN `kpi_report` r ON s.kpi_id = r.id 
WHERE
 r.CODE = "cuxiao" 
 AND r.is_ban = 1 
 AND r.deleted = 0 
 ${if(len(group_id)=0,""," and r.id in ('"+SUBSTITUTE(group_id,",","','")+"')")}
 ${if(len(org_id)=0,""," and s.ref_id='"+org_id+"'")}
 
GROUP BY
 r.id,
 s.ref_id 
 ) AS t1
 
 LEFT JOIN (
SELECT
 b.id,
 b.NAME,
 b.b_parent_id,
 p.NAME AS b_parent_name 
FROM
 erp_org_base b
 LEFT JOIN erp_org_base p ON b.b_parent_id = p.id 
WHERE
 b.deleted = 0 
 ) AS t2 ON t1.org_id = t2.id
 
 left join kpi_parts_group as g on t1.parts_group_id=g.id

SELECT
 t1.*,
 g.`sql` as group_sql
FROM
 (
SELECT
 r.id,
 r.name,
 r.parts_group_id
FROM
 `kpi_report_sales` AS s
 LEFT JOIN `kpi_report` r ON s.kpi_id = r.id 
WHERE
 r.CODE = "cuxiao" 
 AND r.is_ban = 1 
 AND r.deleted = 0 
 ${if(len(org_id)=0,""," and s.ref_id='"+org_id+"'")} 
GROUP BY
 r.id
 ) AS t1
 left join kpi_parts_group as g on t1.parts_group_id=g.id

