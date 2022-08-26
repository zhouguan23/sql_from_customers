select aa.Id, (case when isnull(dd.MaterialType,'')='' then '' else dd.MaterialType+'-'end)+(case when isnull(cc.MaterialType,'')='' then '' else cc.MaterialType+'-'end)+(case when isnull(bb.MaterialType,'')='' then '' else bb.MaterialType+'-'end)+(case when isnull(aa.MaterialType,'')='' then '' else aa.MaterialType end)  MaterialType,isnull(dd.MaterialPrefix,'')+isnull(cc.MaterialPrefix,'')+isnull(bb.MaterialPrefix,'')+isnull(aa.MaterialPrefix,'')  MaterialTypeNo
from TZ_MaterialType aa with(nolock)
	Left Join TZ_MaterialType bb with(nolock) on aa.Fk_Id=bb.Id 
	Left Join TZ_MaterialType cc with(nolock) on bb.Fk_Id=cc.Id	
	Left Join TZ_MaterialType dd with(nolock) on cc.Fk_Id=dd.Id
where aa.Menu =0 and aa.Status=1	

select * from T_DataDictionary with(nolock) where FType='DeliveryCostType' and Status=1

select a.Id,a.Qty,a.upddate
	,case when i.PlanWay=3 then '委外出库' 
		when i.PlanWay in (1,2,4) then '生产领料' 
		when g.CostType=1 then '销售出库' 
		when g.CostType=6 then '红字其它入库'
		when g.CostType=7 then '研发支出'
		when g.CostType=8 then '销售支出'
		when g.CostType=9 then '制造支出'
		when g.CostType=10 then '管理支出'
		when g.CostType=11 then '盘亏'
		when g.CostType=12 then '调拨出库' 
		else '' end CostName
	,d.MaterialNo,d.MaterialName,d.MaterialModel,d.Unit
	,b.CostPrice,b.CostLabor,b.FactoryOverhead,b.NotTaxPrice,b.Price,b.TaxRate,b.Currency,b.Rate,b.MTONo 
	,c.FK_Id,c.PlanProcedureId,c.PlanProcedureEntryId,c.PlanId
	,e.StockName,f.Name CnUnit,i.PlanWay 
	,g.SystemId,g.ProcessName,g.ProcInstId,g.CostType,h.FName  
from TZ_DeliveryRelation a with(nolock) 
	inner join TZ_StorageEntry b with(nolock) on a.StorageEntryId=b.Id	
	inner join TZ_DeliveryEntry c with(nolock) on a.DeliveryEntryId=c.Id	
	inner join t_Material d with(nolock)  on c.MaterialId=d.Id 
	inner join TZ_Stock e with(nolock) on c.StockId=e.Id	
	inner join (select * from [aZaaS.Framework]A.dbo.VM_DataDictionary with(nolock) where pCode='Unit') f on d.Unit=f.Value 
	Left Join TZ_Delivery g with(nolock) on  c.Fk_Id=g.SystemId 
	Left Join [aZaaS.Framework]A.dbo.view_K2SQLUserName h with(nolock) on g.EmployeeGuid=h.SysId 
	Left Join TZ_Plan i with(nolocK) on c.PlanId=i.Id 
	Left Join (select * from T_DataDictionary with(nolock)  where FType= 'DeliveryCostType')j on g.CostType=j.Value 
where a.Status=1  
		${if(len(parUpddateStart)>0 && len(parUpddateEnd)==0," and a.Upddate between '"+parUpddateStart+"' and '"+DATEDELTA(parUpddateStart,1)+"'","")}
		${if(len(parUpddateStart)>0 && len(parUpddateEnd)>0," and a.Upddate between '"+parUpddateStart+"' and '"+DATEDELTA(parUpddateEnd,1)+"'","")} 
		${if(len(parUpddateStart)==0 && len(parUpddateEnd)>0," and a.Upddate between '"+parUpddateEnd+"' and '"+DATEDELTA(parUpddateEnd,1)+"'","")} 
		--无日期时，查询月初到当前
		${if(len(parUpddateStart)==0 && len(parUpddateEnd)==0," and a.Upddate between '"+DATEINMONTH(now(),1) +"' and '"+now()+"'","")} 
		${if(len(parMaterialTypeId) == 0,""," and d.MaterialTypeId in ("+parMaterialTypeId+")")} 
		${if(len(parMaterialNo) == 0,""," and d.MaterialNo like '%"+parMaterialNo+"%'")}
		${if(len(parMaterialName) == 0,""," and d.MaterialName like '%"+parMaterialName+"%'")}
		${if(len(parMaterialModel) == 0,""," and d.MaterialModel like '%"+parMaterialModel+"%'")}  
		${if(len(parCostType) == 0,""," and (j.Name in ('"+parCostType+"') or (Charindex('委外出库','"+replace(parCostType,',','')+"')>0  and i.PlanWay=3)  or (Charindex('生产领料','"+replace(parCostType,',','')+"')>0  and i.PlanWay in (1,2,4)) )")}  

