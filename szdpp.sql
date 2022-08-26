select brand_id,brand_name from plm_brand where is_key_brd=1

select p.brand_id,brand_name,sum(qty) sqtyb from s_zdpp s,plm_brand p 
where  s.brand_id=p.brand_id
and p.is_key_brd=1
and qty_bz='qtyben'
group by p.brand_id,brand_name
order by sum(qty) desc
 

select p.brand_id,brand_name,sum(qty) sqtyy from s_zdpp s,plm_brand p 
where  s.brand_id=p.brand_id
and p.is_key_brd=1
and qty_bz='qtyy'
group by p.brand_id,brand_name
order by sum(qty) desc

select brand_id,sum(qty) qtyy from s_zdpp
where qty_bz='qtyy' and com_id='10371701' and is_key_brd=1 
 group by brand_id

select brand_id,sum(qty) qtyb from s_zdpp
where qty_bz='qtyben' and com_id='10371701' and is_key_brd=1 
 group by brand_id

select brand_id, sum(qty) sqtyyt from s_zdpp s 
where is_key_brd=1
and qty_bz='qtyyt'
group by brand_id  

select brand_id, sum(qty) sqtyt from s_zdpp s 
where is_key_brd=1
and qty_bz='qtybent'
group by brand_id  

select brand_id,sum(qty) qtyyt from s_zdpp
where qty_bz='qtyyt' and com_id='10371701' and is_key_brd=1 
 group by brand_id

select brand_id,sum(qty) qtyt from s_zdpp
where qty_bz='qtybent' and com_id='10371701' and is_key_brd=1 
 group by brand_id

