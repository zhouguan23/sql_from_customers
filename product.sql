select dpst_sale_id,cust_id,

SELECT
     产品.产品名称 AS 产品_产品名称,
     产品.产品ID AS 产品_产品ID,
     类别.类别名称 AS 类别_类别名称
FROM
     产品 产品 INNER JOIN 类别 类别 ON 产品.类别ID = 类别.类别ID
     where 类别.类别ID<=4

select dpt_sale_id,
case when cust_type2_root='01' then 1
 when cust_type2_root='02' then 2
 when cust_type2_root='03' then 3
 when cust_type2_root='04' then 4
 when cust_type2_root='05' then 5
 when cust_type2_root='06' then 6
 when cust_type2_root='07' then 7
else 8
end cust_type2_root
,count(1) custcm  from cust
where  status='02' group by dpt_sale_id,cust_type2_root order by dpt_sale_id,cust_type2_root  asc
 



select benbegin, benend,tongbegin,tongend from 
(
select substr(to_char(sysdate+1,'yyyymmdd'),1,6)||'01'  benbegin from dual
) ,
(
select to_char(sysdate+1,'yyyymmdd')  benend  from dual
) ,
(
SELECT  substr(to_char(add_months(to_date(to_char(sysdate+1,'yyyymmdd'),'yyyymmdd'),-12),'yyyymmdd'),1,6)||'01'   tongbegin FROM DUAL
),
(
SELECT to_char(add_months(to_date(to_char(sysdate+1,'yyyymmdd'),'yyyymmdd'),-12),'yyyymmdd') tongend FROM DUAL
)

