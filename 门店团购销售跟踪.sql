    select a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,a.YM YEAR,isnull(b.Salesindex,0)Salesindex from 
    (SELECT  a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,YM from 
    dbo.TB部门信息表 a  
,
    (SELECT CONVERT(varchar(6),DATEADD(month,number,'${jsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${jsrq}'+'01') <= '${jsrq}'+'01')b)a
    left join 
    TB团购预算指标 b on a.NodeCode=b.deptcode  and a.YM=b.BudgetYM and   b.CategoryItemCode ='0000'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    

select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,'店'),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流')+case when convert(varchar(8),dateadd(YY,1,OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then '(新店)' else '' end   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") } 
and left(nodecode,1) between 1 and 2
union all 
select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,'店'),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流')+case when convert(varchar(8),dateadd(YY,1,OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then '(新店)' else '' end   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'店' ,'百货店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") } 
and left(nodecode,1) =9

  select a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,a.YM YEAR,isnull(b.cardsales,0)cardsales,isnull(b.Employeecardsales,0)Employeecardsales from 
    (SELECT  a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,YM from 
    dbo.TB部门信息表 a  
,
    (SELECT CONVERT(varchar(6),DATEADD(month,number,'${jsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${jsrq}'+'01') <= '${jsrq}'+'01')b)a
    left join 
    TB卡销售月表 b on a.NodeCode=b.deptcode  and a.YM=b.BudgetYM and   b.CategoryItemCode ='0000'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    

select NodeCode  ,sum(SaleMoney)SaleMoney from 
[000]A .TB${jsrq}_CASHIERMSUM
where SellCashierCode in ('777777','888888')
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode  in ('" + replace(bm,",","','")+"')") }
group by NodeCode

