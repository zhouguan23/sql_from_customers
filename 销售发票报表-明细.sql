SELECT o.*,og.*,
  og.rise_code as og_rise_code,
  og.rise_num as og_rise_num,
  og.order_id as og_order_id,
  group_concat(distinct i.out_invoice_sn) as out_invoice_sn,
  case 
  	when og.i_status =0  then '未开票'
  	when og.i_status =1  then '部分开票'
  	when og.i_status =1  then '已开票'
  end as invoice_status,
  case 
  	when o.invoice_type like '%货票同行%'  then '货票同行'
  	when o.invoice_type like '%预开票%' or o.rise_code != ''  then '预开票' 
  	when i.id is not null  then 'T3开票' 
  else '不开票'
  end as kp_type
  FROM order_goods og 
  left join orders o on og.order_sn = o.order_sn
  left join order_goods_alias ior on ior.goods_id = og.id
  left join invoice i on ior.invoice_id = i.id
 where      
 o.order_id  >=
 replace('${开始日期}','-','')  
 and o.order_id 
 <=   
 replace('${结束日期}','-','')
       and o.company_code in  ('${所属公司代号变量}')
${if(len(CustomCode) == 0,""," and o.customer_code in ('"+CustomCode+"')")}       
${if(len(销售部门变量)== 0,""," and o.sale_dept like '%"+销售部门变量+"%'")} 
${if(len(wms单号变量)== 0,""," and o.wms_num like '%"+wms单号变量+"%'")}
${if(len(备注变量)== 0,"","and o.remark like '%"+备注变量+"%'")} 
${if(len(销售发票号变量)== 0,""," and o.order_sn = '"+销售发票号变量+"'")} 
group by  og.id
 order by o.id desc 

