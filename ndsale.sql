select yearid,dpt_sale_id,sum(qty) qty,sum(amt) amt from com_year_sale
group by yearid,dpt_sale_id order by yearid desc

