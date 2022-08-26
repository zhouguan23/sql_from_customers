select cwhname as 仓库名称,cInvName,cinvdefine2 规格,cInvStd as 等级,iQuantity 平方数,(iQuantity/iChangRate) as 每架片数,(iQuantity/cInvDefine13) as 重箱数,
substring(substring(cInvName,0,patINDEX('%[吖-做]A%',cInvName)),charindex('X',cInvName,charindex('X',cInvName)+1)+1,10)+'mm'  厚度
from CurrentStock
left join Inventory on CurrentStock.cInvCode=Inventory.cInvCode
left join ComputationUnit on Inventory.cSAComUnitCode=ComputationUnit.cComunitCode
left join Warehouse on CurrentStock.cWhCode=Warehouse.cWhCode
where    iQuantity>'0' 
and dbo.[Fun_GetNum]A(reverse(substring(reverse(cInvName),1,charindex('X',reverse(cInvName)) - 1)))  is not null and  cInvStd is not null and cinvdefine2 is not null 
and  (iQuantity/cInvDefine13) >'1'
and CurrentStock.cWhCode in ('31','32','33','34','35','38','39') 
and (iQuantity/iChangRate)>'5' 
and 1=1${if(len(仓库名称) == 0,"","and cwhname in ('" + 仓库名称 + "')")}
order by charindex(substring(cwhname,1,1),'一三五七') ,cInvDefine1 ,charindex(substring(cInvStd,1,1),'一二等混')

select cwhname as 仓库名称,cInvName,cinvdefine2 规格,cInvStd as 等级,iQuantity as 平方数,(iQuantity/iChangRate) as 每架片数,(iQuantity/cInvDefine13) as 重箱数,substring(substring(cInvName,0,patINDEX('%[吖-做]A%',cInvName)),charindex('X',cInvName,charindex('X',cInvName)+1)+1,
10)+'mm'  厚度
from CurrentStock
left join Inventory on CurrentStock.cInvCode=Inventory.cInvCode
left join ComputationUnit on Inventory.cSAComUnitCode=ComputationUnit.cComunitCode
left join Warehouse on CurrentStock.cWhCode=Warehouse.cWhCode
where   iQuantity>'0' 
and  (iQuantity/cInvDefine13) >'1'
and CurrentStock.cWhCode in ('31','32','33','34','35','38','39') 
and (iQuantity/iChangRate)>'5' 
and 1=1${if(len(仓库名称) == 0,"","and cwhname in ('" + 仓库名称 + "')")}
order by charindex(substring(cwhname,1,1),'一三五七') ,cInvDefine1 ,charindex(substring(cInvStd,1,1),'一二等混')

