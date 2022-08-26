select a.area_code,r.area_name,a.cus_code,c.cus_name,count(distinct s.goods_code) goods_num from dm_stock_shop_day a
left join dim_region r
on a.area_code=r.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
join dim_goods_stockup s
on a.area_code=s.area_code
and a.cus_code=s.cus_code
and a.goods_code=s.goods_code
where 1=1
 ${if(len(AREA)=0,"","and a.area_code in('"+AREA+"')")}
 ${if(len(CUS)=0,"","and a.cus_code in('"+CUS+"')")}  
group by a.area_code,r.area_name,a.cus_code,c.cus_name
order by 1

select count(distinct s.goods_code) goods_num from dm_stock_shop_day a
left join dim_region r
on a.area_code=r.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
join dim_goods_stockup s
on a.area_code=s.area_code
and a.cus_code=s.cus_code
and a.goods_code=s.goods_code
where 1=1
 ${if(len(AREA)=0,"","and a.area_code in('"+AREA+"')")}
 ${if(len(CUS)=0,"","and a.cus_code in('"+CUS+"')")}  


select area_code,cus_code,count(distinct goods_code) goods_stockup from dim_goods_stockup
where 1=1
 ${if(len(AREA)=0,"","and area_code in('"+AREA+"')")}
 ${if(len(CUS)=0,"","and cus_code in('"+CUS+"')")}  
group by area_code,cus_code

select count(distinct goods_code) goods_stockup from dim_goods_stockup
where 1=1
 ${if(len(AREA)=0,"","and area_code in('"+AREA+"')")}
 ${if(len(CUS)=0,"","and cus_code in('"+CUS+"')")}  


select distinct c.cus_code,c.cus_name,r.area_code,r.area_name,r.union_area_name from dim_cus c,dim_region r
where c.area_code=r.area_code
and 1=1
 ${if(len(AREA)=0,"","and R.area_code in('"+AREA+"')")}
 ${if(len(CUS)=0,"","and C.cus_code in('"+CUS+"')")} 

