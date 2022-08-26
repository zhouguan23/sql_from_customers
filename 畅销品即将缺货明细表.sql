 select
        商品编码,
        商品名称,
        部门编码,
        商品条码,
        商品单位,
        经营状态,
        流转途径,
        供应商,
        最后进价,
        最后售价,
        库存数量,
        含税库存成本,
        正常DMS,
        库存数量/正常DMS 可销天数,
        进目录日期,
        最后销货日,
        最后进货日,
        最后状态异动日 
    from
        TB${YM}_门店商品历史信息 a 
    left join
        tb商品档案 b 
            on a.商品编码=b.goodscode 
    where
        报表日期='${rq}' 
        and  经营状态 in (
            1,2,5
        ) 
        and 商品类型='0' 
        and  (
            b.CategoryCode like '3%' 
            or b.CategoryCode like '4%' 
            or b.CategoryCode like '5%' 
        ) 
        and b.CategoryCode not like '300%' 
        and 库存数量>0  
        and case 
            when 库存数量=0 
            or 正常DMS=0 then 0 
            else 库存数量/正常DMS 
        end <=3 
        and  (
            b.CategoryCode like '3%' 
            and 正常DMS>=0.8 
            or   b.CategoryCode like '4%' 
            and 正常DMS>=0.3 
            or   b.CategoryCode like '5%' 
            and 正常DMS>=0.3  
        ) 
        and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") } 
        and 1=1 ${if(len(fl2) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }  

select distinct * from 
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

