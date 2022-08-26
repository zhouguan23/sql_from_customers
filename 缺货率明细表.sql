select 商品编码,商品名称,部门编码,商品条码,商品单位,商品规格,经营状态,流转途径,供应商,case when d.GoodsCode is not  null then '1' else 0 end  中央控制标识,A.最后进价,最后售价,isnull(b.Amount,0) 在途数量,a.促销DMS +a.正常DMS DMS,进目录日期,最后销货日,最后进货日,a.最后状态异动日 from 
dbo.TB${YM}_门店商品历史信息 a 
left join 
tbWayArrivalannual b on a.商品编码=b.goodscode and a.部门编码=b.deptcode
left join 
tb商品档案  c on a.商品编码=c.goodscode
left join 
TB部门特殊商品对照 d on d.GoodsPropertyCode='1999' and  a.部门编码=d.NodeCode and a.商品编码=d.GoodsCode
WHERE 报表日期='${rq}' 
and c.CategoryCode not like '1%' and c.CategoryCode not like '2%' 
and c.CategoryCode not like '6%' and c.CategoryCode not like '300%'
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.部门编码=z.nodecode and a.商品编码=z.goodscode)
and not exists(select 1 from 
TB部门特殊商品对照 b
where b.GoodsPropertyCode='2002' and a.部门编码=b.NodeCode and a.商品编码=b.goodscode)
and a.经营状态 in (1,2) and c.GoodsType=0 and 库存数量<=0
and  cast(经营状态 as varchar)+cast(datediff(day,最后状态异动日,报表日期)+1 as varchar)  
not in ('101','102','103','104','105','106','107','108','109','110','111','112','113','114','115') 

and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(fl2) == 0,   "",   "and left(c.CategoryCode,2) in ('" + replace(fl2,",","','")+"')") } 
and  1=1 ${if(sx == '0000',   "",   "and c.GoodsBrand='010001'") }

and  1=1 ${if(zz <> 1,   "",   "and  a.经营状态 ='1' and d.GoodsCode is null") }
and  1=1 ${if(zz <> 2,   "",   "and   d.GoodsCode is not  null") }
and  1=1 ${if(zz <> 3,   "",   "and  a.经营状态 !='1' and d.GoodsCode is  null") }
order by 1,3

select * from 
tbWayArrivalannual
where 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in ('" + replace(bm,",","','")+"')") }

