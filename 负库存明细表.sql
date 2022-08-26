select a.商品编码,a.商品名称,a.部门编码,a.商品条码,a.商品单位,a.商品规格,a.经营状态,a.流转途径,a.供应商,b.GoodsPropertyCode,a.最后进价,a.最后售价,a.库存数量,a.含税库存成本,a.正常DMS+a.促销DMS DMS,
进目录日期,最后销货日,最后进货日,最后状态异动日 from 
dbo.TB${YM}_门店商品历史信息 a 
left join 
TB部门特殊商品对照 b on a.部门编码=b.nodecode  and a.商品编码=b.goodscode and b.GoodsPropertyCode='1999'
WHERE a.报表日期='${rq}' and  round(a.库存数量,1)<0  
and 1=1 ${if(len(bm) == 0,   "",   "and a.部门编码 in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(a.分类编码,2) in ('" + replace(fl,",","','")+"')") } 
and a.商品编码 in (select goodscode from  tb商品档案 where GoodsType in ('0'))
order by 1,3

select * from 
(select DeptCode ,GoodsCode  from 
[6001]A.TBCENTERCONTROL 
where convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and EndDate
and ControlType=1 and DeptType  =1  
union all 
select NodeCode  ,GoodsCode  from 
[6001]A.TBCENTERCONTROL a 
left join 
[6001]A .TBCATTODEPARTMENT  b on a.DeptCode=b.DeptCategoryCode and b.DeptCatItemCode ='0001'
where convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and EndDate
and ControlType=1 and DeptType  =0)a
where 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in ('" + replace(bm,",","','")+"')") }

