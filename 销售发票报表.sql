SELECT 
a.*,
cast(a.order_id As DateTime) as DocDate,
sum(b.profit) as profit,
GROUP_CONCAT(sor.sid) as sidlist,
a.remark  as new_remark
FROM 
`orders` a left join order_goods b on a.order_sn= b.order_sn
left join statements_order_relation sor on a.id=sor.oid
where   a.order_id between replace('${开始日期}','-','') and replace('${结束日期}','-','')
and a.company_code='${所属公司代号变量}'
and (a.company_code in (${用户数据权限}) or a.deliver_company_code in (${用户数据权限})
)
${if(len(客户编码变量)  == 0,"","and a.customer_code = '" + 客户编码变量 + "'")}  
${if(len(销售部门变量)  == 0,"","and a.sale_dept like '%" + 销售部门变量 + "%'")} 
${if(len(wms单号变量)  == 0,"","and a.wms_num = '" + wms单号变量 + "'")} 
${if(len(备注变量)  == 0,"","and a.remark like '%" + 备注变量 + "%'")} 
${if(len(销售发票号变量)  == 0,""," and a.order_sn ='" + 销售发票号变量 + "'")} 
group by a.id  order by a.id desc 

SELECT code,name FROM s4_company
WHERE status =1
-- code IN ( '${所属公司}' )


SELECT company_code,
replace(ltrim(replace(code,'0',' ')),' ','0') as code,
name 
FROM s4_customer
where company_code = '${所属公司代号变量}'
and name <> ''
order by name


SELECT 
o.*,og.*
FROM 
`order_goods` og left join `orders` o on og.order_sn = o.order_sn
where  o.order_id between replace('${开始日期}','-','') and replace('${结束日期}','-','')
and company_code='${所属公司代号变量}'
and (o.company_code in (${用户数据权限}) or o.deliver_company_code in (${用户数据权限})
)
${if(len(客户编码变量)  == 0,"","and customer_code = '" + 客户编码变量 + "'")} 
${if(len(销售部门变量)  == 0,"","and o.sale_dept like '%" + 销售部门变量 + "%'")} 
${if(len(wms单号变量)  == 0,"","and o.wms_num = '" + wms单号变量 + "'")} 
${if(len(备注变量)  == 0,"","and o.remark like '%" + 备注变量 + "%'")} 
${if(len(销售发票号变量)  == 0,"","and o.order_sn in (" + 销售发票号变量 + ")")} 
order by o.id desc 

