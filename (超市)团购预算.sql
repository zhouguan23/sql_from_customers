    select a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,a.YM YEAR,isnull(b.Salesindex,0)Salesindex from 
    (SELECT  a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,YM from 
    dbo.TB部门信息表 a  
,
    (SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b)a
    left join 
    TB团购预算指标 b on a.NodeCode=b.deptcode  and a.YM=b.BudgetYM and   b.CategoryItemCode ='${lx}'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by a.AreaCode,a.NodeCode,a.YM

select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where   1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}


and  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601) 

