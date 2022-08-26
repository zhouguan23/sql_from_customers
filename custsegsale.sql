select distinct cust_seg from co_cust where status='02' order by cust_seg

select b.sale_dept_id,sum(c.qty_sold)/250 qty,sum(c.amt)/10000 amt  from 
cust_sold c,co_cust b,custseg a  where 
c.cust_id=b.cust_id and c.cust_id=a.cust_id  and 
  c.date1>=(Select dayf from year_week where year1='${byseason}' ) and 
 c.date1<=(Select daye from year_week where year1='${byseason}') and a.date1='${byseason}' 
 	
  and a.cust_seg>='${custseg1}' and a.cust_seg<='${custseg2}'
group by b.sale_dept_id 

select year1,yname from year_week  where year1>'20174'

select b.sale_dept_id,sum(c.qty_sold)/250 qtys,sum(amt)/10000 amts  from 
cust_sold c,co_cust b,custseg a  where 
c.cust_id=b.cust_id and c.cust_id=a.cust_id  and 
  c.date1>=(Select daysf from year_week where year1='${byseason}'  ) and 
	c.date1<=(Select dayse from year_week where year1='${byseason}') 
	and a.date1=(select year2 from year_week where year1='${byseason}')
 	
  and a.cust_seg>='${custseg1}' and a.cust_seg<='${custseg2}'
  and a.date1=(Select year2 from year_week where year1='${byseason}'  )
group by b.sale_dept_id 

select dpt_sale_id sale_dept_id,sum(qty_sold)/250 qty,sum(amt)/10000 amt  from 
 cust_sold where 

 date1>=(Select dayf from year_week where year1='${byseason}'  ) and 
	date1<=(Select daye from year_week where year1='${byseason}')   
 
group by dpt_sale_id

select    sale_dept_id,sum(qty_sold)/250 qtys,sum(amt_sold)/10000 amts  from 
custsolddptseg  where 
   date1>=(Select daysf from year_week where year1='${byseason}'  ) and 
	date1<=(Select dayse from year_week where year1='${byseason}') 
 	
 
group by sale_dept_id 

