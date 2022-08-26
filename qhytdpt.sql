 select D.base_type,DICT_VALUE,custb,QTYB,amtb,custs,QTYs,amts,custt,QTYt,amtt FROM 

(select  NVL(base_type,'51') custqh,count(distinct a.cust_id) custb,sum(a.qty_sold*t_size)/200 qtyb,sum(a.amt_sold) amtb
  from pi_cust_item_month a,plm_item i ,co_cust cc
 where  a.item_id=i.item_id and cc.sale_dept_id= '${dptid}' and a.cust_id=cc.cust_id and  date1='${date1}'   group by  NVL(base_type,'51')) a,
(

select  NVL(base_type,'51') custqh,count(distinct a.cust_id) custs,sum(a.qty_sold*t_size)/200 qtys,sum(a.amt_sold) amts
  from pi_cust_item_month a,plm_item i ,co_cust cc
 where  a.item_id=i.item_id and cc.sale_dept_id= '${dptid}' and a.cust_id=cc.cust_id and  
date1=(select to_char(add_months(to_date('${date1}','yyyymm'),-1),'yyyymm' ) from dual)
group by  NVL(base_type,'51')) b,

(
select  NVL(base_type,'51') custqh,count(distinct a.cust_id) custt,sum(a.qty_sold*t_size)/200 qtyt,sum(a.amt_sold) amtt
  from pi_cust_item_month a,plm_item i ,co_cust cc
 where  a.item_id=i.item_id and cc.sale_dept_id= '${dptid}' and a.cust_id=cc.cust_id and  
date1=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm' ) from dual)
group by  NVL(base_type,'51')
) c,
(


select  DISTINCT   B.DICT_KEY  BASE_TYPE,B.DICT_VALUE  from co_cust cc,  base_dict  b 
where  cc.base_type=b.dict_key and b.dict_id='BASE_TYPE'
and cc.status='02' and cc.sale_dept_id='${dptid}'  
) D
WHERE A.CUSTQH(+)=D.base_type
AND B.CUSTQH(+)=D.base_type
AND C.CUSTQH(+)=D.base_type

order by  base_type

