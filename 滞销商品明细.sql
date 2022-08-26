	select  
	
	b.商品编码,b.商品名称,b.库存数量,b.含税库存成本,b.正常DMS+b.促销DMS DMS,b.最后销货日,b.最后进货日,datediff(day,case when len(b.最后销货日)=0 then  b.最后进货日 else b.最后销货日 end,报表日期)未销天数
	
	   from  
	TB商品档案 a 
	left join
	TB${YM}_门店商品历史信息 b on a.GoodsCode=b.商品编码 and b.报表日期='${rq}' and  1=1 ${if(len(bm) == 0,   "",   "and b.部门编码 in ('" + replace(bm,",","','")+"')") }
	left join 
	TBREPORTPARADEFINE c on left(a.CategoryCode,4)=c.GoodsCode 
	where a.GoodsType in ('0','2') and a.CategoryCode  not like '0%'   and a.CategoryCode  not like '6%'  and a.CategoryCode  not like '23%' and a.CategoryCode  not like '28%' and a.CategoryCode  not like '29%'
	 and a.CategoryCode  not like '300%'
	 and a.GoodsCode not in ('302000011','302000026','302000160','302000161','302030035','302000159','302000177','302000324','302000076','302000084','302000323','302000348','302000349','302000003','302000012','302010001','303000007','303000008','303000009','303000010','303000011','303000013','303000016','303010001','303010003','303010008','303010013','303010014','303010015','303010016')
	 and b.经营状态 in ('1','2','3','4','5','50')
	 and round(b.库存数量 , 1)>0
	 and  1=1 ${if(len(fl2) == 0,   "",   "and left(a.CategoryCode,2)  in ('" + replace(fl2,",","','")+"')") } 

	 order by 8 desc ,1,2 asc 




