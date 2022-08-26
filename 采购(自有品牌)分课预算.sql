select
WhetherNew,AreaCode,FormatCode,NodeCode ,
 ParentCategoryCode,CategoryCode1,CONVERT(varchar(255), CategoryCode)CategoryCode,CategoryName,CONVERT(varchar(255),YM)YM,CASE       
 when RIGHT(YM,2) in('06','07','08')   then '第一季度'  
 when RIGHT(YM,2) in('09','10','11')   then '第二季度'   
 when  RIGHT(YM,2) in('12','01','02')  then '第三季度' 
 when RIGHT(YM,2) in('03','04','05')   then '第四季度'      end Quarter
from 

(
select '7' ParentCategoryCode,'7'+CategoryCode CategoryCode1,'7'+CategoryCode CategoryCode,case  when CategoryCode='10' then '生鲜' when CategoryCode='30' then '食品' when CategoryCode='40' then '家居' when CategoryCode='46' then '家纺' when CategoryCode='50' then '日化' end CategoryName from 
TB商品分类表
where CategoryLevel='2' and ParentCategoryCode  in (1,3,4,5) 
and CategoryItemCode='0000' and CategoryCode in (10,30,40,46,50)
)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p' AND DATEADD(month,number,'${qsrq}'+'01') <= '${dqrq}'+'01')b,
(select WhetherNew,AreaCode,FormatCode,NodeCode from 
tb部门信息表
where (nodecode like '1%' or nodecode like '2%')
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") })c
order by 9,1,2,3,4,5,6,7




select DeptCode, '7'+CategoryCode CategoryCode,BudgetYM,Salesindex,Grossprofitindex,CategoryItemCode from 
含税分课预算表
where  CategoryItemCode='0001' and left(DeptCode,1) between  1 and 2 and (CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%')
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'

select CategoryItemCode,'7'+CategoryCode CategoryCode,case when CategoryCode='30' then '食品' when CategoryCode='40' then '家居' when CategoryCode='46' then '家纺' when CategoryCode='50' then '日化' end CategoryName,
'7' ParentCategoryCode,CategoryLevel  from 
TB商品分类表
where CategoryLevel='2' and ParentCategoryCode  in (3,4,5) 
and CategoryItemCode='0000' and CategoryCode in (30,40,46,50)
order by 2


select DeptCode, '7'+CategoryCode CategoryCode,BudgetYM,Salesindex,Grossprofitindex,CategoryItemCode from 
无税分课预算表
where  CategoryItemCode='0001' and left(DeptCode,1) between  1 and 2 and (CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%')
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'

select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where   1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}


and  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601) 

