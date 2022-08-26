select c.TABLE_SCHEMA 数据库
,c.TABLE_NAME 表名称
,c.COLUMN_TYPE 字段类型
,c.COLUMN_COMMENT
,c.IS_NULLABLE 能否为空
,c.column_name 字段名称
,t.TABLE_COMMENT as 表注释
from information_schema.columns c
left join 
information_schema.TABLES t
on c.table_name=t.TABLE_NAME
where c.TABLE_NAME in ('${TABLE}') and  c.TABLE_SCHEMA='gfreport'  
and t.TABLE_SCHEMA='gfreport'  
${if(len(zd) == 0,"","and c.column_name  in ('" + zd + "')")}

select c.TABLE_SCHEMA 数据库
,c.TABLE_NAME 表名称
,c.COLUMN_TYPE 字段类型
,c.COLUMN_COMMENT
,c.IS_NULLABLE 能否为空
,c.column_name 字段名称
,t.TABLE_COMMENT as 表注释,
CONCAT(c.TABLE_NAME,t.TABLE_COMMENT) as 表名加注释
from information_schema.columns c
left join 
information_schema.TABLES t
on c.table_name=t.TABLE_NAME
where c.TABLE_SCHEMA='gfreport'
order by c.TABLE_NAME 

select c.TABLE_SCHEMA 数据库
,c.TABLE_NAME 表名称
,c.COLUMN_TYPE 字段类型
,c.COLUMN_COMMENT
,c.IS_NULLABLE 能否为空
,c.column_name 字段名称
,t.TABLE_COMMENT as 表注释
from information_schema.columns c
left join 
information_schema.TABLES t
on c.table_name=t.TABLE_NAME
where c.TABLE_NAME='${TABLE}' and  c.TABLE_SCHEMA='gfreport'  


select business_date,store_id,type_id,categroy_id,count(1)
from sale_store_categroy_custs_counts
group by business_date,store_id,type_id,categroy_id
having count(1)>1


