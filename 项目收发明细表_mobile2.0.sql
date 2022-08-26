  select a.项目名称,
         a.项目负责人,
         a.物料大类,
         a.物料名称,
         a.库存数量,
         b.发货数量 
  from (
select   DictUserDef4,
         项目名称,
         项目负责人,
         物料大类,
         MAT_CATEGORY_ID,
         MaterialId,
         物料名称,
         sum(amount) as 库存数量
  from (select a.WAREHOUSECENTERID,
               b.name as 接单机构,
               a.OwnerId,
               c.name as 项目,
               a.MaterialId,
               d.name as 物料名称,
               d.MAT_CATEGORY_ID,
               e.name as 物料大类,
               a.OnhandQty as amount,
               a.DictUserDef4,
               g.name as 项目名称,
               g.ProjectManager as 项目负责人
          from lrp_quant a
          left join LRP_WarehouseCenter b
            on a.WAREHOUSECENTERID = b.oid
          left join LRP_Owner c
            on a.OwnerId = c.oid
          left join LRP_Material d
            on a.MaterialId = d.oid
          left join LRP_MaterialCategory e
            on d.MAT_CATEGORY_ID = e.oid
          left join LRP_PartyAProject g
            on a.DictUserDef4 = g.oid
         where a.OwnerId = '113003031'
           and a.OnhandQty != 0
           and a.DictUserDef5 <> 13691
           and b.name NOT LIKE '%配送中心%'
           and g.ProjectManager in (select properson_name from zjtx2.fr_properson@BILINK2 where user_id='${fine_username}') )
 where 项目负责人 <> '待提供'
   and 项目负责人 <> '*'
   and 项目负责人 is not null  
 group by 项目名称,
          项目负责人,
          物料大类,
          DictUserDef4,
          MAT_CATEGORY_ID,
          MaterialId,
          物料名称) a  
 left join (
 select a.SrcDictUserDef4,
        a.MaterialId,
        b.MAT_CATEGORY_ID,
        sum(a.Qty) as 发货数量
 from LRP_WMTx_L a 
left join LRP_WMTx_H c 
  on a.soid=c.oid
left join LRP_Material b 
  on a.MaterialId =b.oid
left join LRP_MaterialCategory e
  on b.MAT_CATEGORY_ID = e.oid
left join LRP_WarehouseCenter g 
  on c.WarehouseCenterId = g.oid
where c.OwnerId ='113003031'
  and g.name NOT LIKE '%配送中心%'       
group by a.SrcDictUserDef4,
         a.MaterialId,
         b.MAT_CATEGORY_ID
 ) b 
 on a.DictUserDef4=b.SrcDictUserDef4 
and a.MAT_CATEGORY_ID=b.MAT_CATEGORY_ID 
and a.MaterialId=b.MaterialId
where 1=1 ${if(len(项目名称)==0,"","and 项目名称 in ('" + 项目名称 + "')")} 
          ${if(len(项目负责人)==0,"","and 项目负责人 in ('" + 项目负责人 + "')")}

  select distinct
         a.项目名称,
         a.项目负责人
  from (
  select   DictUserDef4,
         项目名称,
         项目负责人,
         物料大类,
         MAT_CATEGORY_ID,
         MaterialId,
         物料名称,
         sum(amount) as 库存数量
  from (select a.WAREHOUSECENTERID,
               b.name as 接单机构,
               a.OwnerId,
               c.name as 项目,
               a.MaterialId,
               d.name as 物料名称,
               d.MAT_CATEGORY_ID,
               e.name as 物料大类,
               a.OnhandQty as amount,
               a.DictUserDef4,
               g.name as 项目名称,
               g.ProjectManager as 项目负责人
          from lrp_quant a
          left join LRP_WarehouseCenter b
            on a.WAREHOUSECENTERID = b.oid
          left join LRP_Owner c
            on a.OwnerId = c.oid
          left join LRP_Material d
            on a.MaterialId = d.oid
          left join LRP_MaterialCategory e
            on d.MAT_CATEGORY_ID = e.oid
          left join LRP_PartyAProject g
            on a.DictUserDef4 = g.oid
         where a.OwnerId = '113003031'
           and a.OnhandQty != 0
           and a.DictUserDef5 <> 13691
           and b.name NOT LIKE '%配送中心%'
           and g.ProjectManager in (select properson_name from zjtx2.fr_properson@BILINK2 where user_id='${fine_username}') )
 where 项目负责人 <> '待提供'
   and 项目负责人 <> '*'
   and 项目负责人 is not null  
 group by 项目名称,
          项目负责人,
          物料大类,
          DictUserDef4,
          MAT_CATEGORY_ID,
          MaterialId,
          物料名称) a  
 left join (
 select a.SrcDictUserDef4,
        a.MaterialId,
        b.MAT_CATEGORY_ID,
        sum(a.Qty) as 发货数量
 from LRP_WMTx_L a 
left join LRP_WMTx_H c 
  on a.soid=c.oid
left join LRP_Material b 
  on a.MaterialId =b.oid
left join LRP_MaterialCategory e
  on b.MAT_CATEGORY_ID = e.oid
left join LRP_WarehouseCenter g 
  on c.WarehouseCenterId = g.oid
where c.OwnerId ='113003031'
  and g.name NOT LIKE '%配送中心%'       
group by a.SrcDictUserDef4,
         a.MaterialId,
         b.MAT_CATEGORY_ID
 ) b 
 on a.DictUserDef4=b.SrcDictUserDef4 
and a.MAT_CATEGORY_ID=b.MAT_CATEGORY_ID 
and a.MaterialId=b.MaterialId

