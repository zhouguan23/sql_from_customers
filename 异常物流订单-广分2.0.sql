select h.oid as 物流订单ID,
       h.status,
       case
         when h.status = 200 then
          '已确认'
         when h.status = 250 then 
          '已出库'
         when h.status = 240 then 
          '已入库'
         else 
          ''
       end as 状态,
       line.name as 紧急程度,
       h.no as 物流订单号,
       h.OrderDateTime as 下单日期,
       org.name as 接单机构,
       case
         when h.LOH_TYPE = 'outbound_deliver' then
          '出库配送'
         when h.LOH_TYPE = 'collect_inbound' then
          '提货入库'
         when h.LOH_TYPE = 'collect_deliver' then
          '提货配送' 
         when h.LOH_TYPE = 'outbound' then
          '仅出库'
         when h.LOH_TYPE = 'inbound' then
          '仅入库'
         when h.LOH_TYPE = 'outbound_inbound' then
          '调拨（无运输）'
         when h.LOH_TYPE = 'outbound_transport_inbound' then
          '调拨（含运输）'
         else
          ''
       end as 订单类型,
       tyep.name as 出库事务类型,
       flow.name as 出库流程,
       tyep1.name as 入库事务类型,
       flow1.name as 入库流程,
       mat.code as 物料编码,
       mat.name as 物料名称,
       l.Spec as 规格型号,
       l.view_lol_material_category as 物料大类,
       line1.name as 单位,
       l.Qty as 数量,
       l.LOH_TierTwoUnits as 包装单位,
       l.LevelTwoQty as 包装数量,
       l.NumUserDef1 as 不含税单价,
       l.MONEY as 合计金额,
       org1.name as 发货仓库,
       h.LOH_LOAD_ADDRESS as 发货地址,
       h.LOH_LOAD_CONTACT as 发货人,
       h.LOH_LOAD_TEL as 发货联系电话,
       org2.name as 收货仓库,
       h.LOH_UNLOAD_ORG_ID,
       h.LOH_UNLOAD_ADDRESS as 收货地址,
       h.LOH_UNLOAD_CONTACT as 收货人,
       h.LOH_UNLOAD_TEL as 收货联系电话,
       h.loh_remark as 备注1,
       l.StrUserDef1 as 安装点,
       pa.code as 甲方项目编码1,
       pa.name as 甲方项目名称1,
       l.StrUserDef5 as 项目负责人1,
       l.StrUserDef2 as 需求单号,
       l.StrUserDef3 as 采购订单号1,
       l.StrUserDef4 as 备货订单号1,
       ven.name as 供应商1,
       l.StrUserDef6 as 备注2,
       l.loh_material_code as 客户物资编码,
       l.loh_material_name as 客户物资名称,
       op.name as 制单人,
       h.CREATETIME as 制单时间,
       op1.name as 修改人,
       h.MODIFYTIME as 修改时间,
       ow.name as 项目,
       ven1.name as 供应商2,
       pa1.name as 甲方项目名称2,
       pa1.code as 甲方项目编码2,
       h.SingleProjectName as 单项工程名称,
       dep.name as 工程主管部门,
       ma.name as 专业,
       h.Substation as 所属分局,
       h.LOH_PurchasingOrderNO as 采购订单号2,
       h.zhandianleixing as 站点类型,
       h.attachment as 附件,
       h.FORECASTTIME as 预计到货日期,
       h.LOH_TOTAL_PACKS as 总数量,
       h.LOH_TOTAL_GROSS_WEIGHT as 总毛重,
       h.LOH_TOTAL_CUBAGE as 总体积,
       h.LOH_TOTAL_AMOUNT as 总金额,
       h.ProjectManager1 as 项目负责人2
  from LRP_LogisticsOrder_H h
  left join LRP_LogisticsOrderMat_L l
    on h.oid = l.soid
  left join LRP_Lookup_L line
    on line.oid = h.LOH_EMERGENCY_DEGREE_ID
  left join LRP_WarehouseCenter org
    on org.oid = h.LOH_ORG_ID
  left join LRP_WarehouseTxType tyep
    on tyep.oid = h.LOH_OUTBOUND_TX_TYPE_ID
  left join LRP_StepType flow
    on flow.oid = h.LOH_OUTBOUND_FLOW_HEADER_ID
  left join LRP_WarehouseTxType tyep1
    on tyep1.oid = h.LOH_INBOUND_TX_TYPE_ID
  left join LRP_StepType flow1
    on flow1.oid = h.LOH_INBOUND_FLOW_HEADER_ID
  left join LRP_Material mat
    on mat.oid = l.MaterialId
  left join LRP_Lookup_L line1
    on line1.oid = l.unitl
  left join LRP_WarehouseCenter org1
    on org1.oid = h.LOH_LOAD_ORG_ID
  left join LRP_WarehouseCenter org2
    on org2.oid = h.LOH_UNLOAD_ORG_ID
  left join LRP_PartyAProject pa
    on pa.oid = l.DictUserDef4
  left join LRP_VendorCustomer ven
    on ven.oid = l.DictUserDef3
  left join SYS_Operator op
    on op.oid = h.CREATOR
  left join SYS_Operator op1
    on op1.oid = h.MODIFIER
  left join LRP_Owner ow
    on ow.oid = h.OwnerId
  left join LRP_VendorCustomer ven1
    on ven1.oid = h.LOH_VENDOR_ID
  left join LRP_VendorCustomer pa1
    on pa1.oid = h.LOH_PARTYAPROJECT_CODE
  left join Engineer_Depart dep
    on dep.oid = h.LOH_Engineering_Department
  left join Major ma
    on ma.oid = h.LOH_Major
 where h.OwnerId = '113003031'
 and org.name like '广州配送中心%'
 and (h.LOH_TYPE = 'outbound_inbound'
   or h.LOH_TYPE = 'outbound_transport_inbound')
 and org2.name like '广州分屯库%'
 and h.status = 250
 and to_char(h.MODIFYTIME,'yyyy-mm-dd') =
     to_char(trunc(sysdate-1),'yyyy-mm-dd')
     order by h.MODIFYTIME

select h.oid as 物流订单ID,
       h.status,
       case
         when h.status = 200 then
          '已确认'
         when h.status = 250 then 
          '已出库'
         when h.status = 240 then 
          '已入库'
         else 
          ''
       end as 状态,
       line.name as 紧急程度,
       h.no as 物流订单号,
       h.OrderDateTime as 下单日期,
       org.name as 接单机构,
       case
         when h.LOH_TYPE = 'outbound_deliver' then
          '出库配送'
         when h.LOH_TYPE = 'collect_inbound' then
          '提货入库'
         when h.LOH_TYPE = 'collect_deliver' then
          '提货配送' 
         when h.LOH_TYPE = 'outbound' then
          '仅出库'
         when h.LOH_TYPE = 'inbound' then
          '仅入库'
         when h.LOH_TYPE = 'outbound_inbound' then
          '调拨（无运输）'
         when h.LOH_TYPE = 'outbound_transport_inbound' then
          '调拨（含运输）'
         else
          ''
       end as 订单类型,
       tyep.name as 出库事务类型,
       flow.name as 出库流程,
       tyep1.name as 入库事务类型,
       flow1.name as 入库流程,
       mat.code as 物料编码,
       mat.name as 物料名称,
       l.Spec as 规格型号,
       l.view_lol_material_category as 物料大类,
       line1.name as 单位,
       l.Qty as 数量,
       l.LOH_TierTwoUnits as 包装单位,
       l.LevelTwoQty as 包装数量,
       l.NumUserDef1 as 不含税单价,
       l.MONEY as 合计金额,
       org1.name as 发货仓库,
       h.LOH_LOAD_ADDRESS as 发货地址,
       h.LOH_LOAD_CONTACT as 发货人,
       h.LOH_LOAD_TEL as 发货联系电话,
       org2.name as 收货仓库,
       h.LOH_UNLOAD_ORG_ID,
       h.LOH_UNLOAD_ADDRESS as 收货地址,
       h.LOH_UNLOAD_CONTACT as 收货人,
       h.LOH_UNLOAD_TEL as 收货联系电话,
       h.loh_remark as 备注1,
       l.StrUserDef1 as 安装点,
       pa.code as 甲方项目编码1,
       pa.name as 甲方项目名称1,
       l.StrUserDef5 as 项目负责人1,
       l.StrUserDef2 as 需求单号,
       l.StrUserDef3 as 采购订单号1,
       l.StrUserDef4 as 备货订单号1,
       ven.name as 供应商1,
       l.StrUserDef6 as 备注2,
       l.loh_material_code as 客户物资编码,
       l.loh_material_name as 客户物资名称,
       op.name as 制单人,
       h.CREATETIME as 制单时间,
       op1.name as 修改人,
       h.MODIFYTIME as 修改时间,
       ow.name as 项目,
       ven1.name as 供应商2,
       pa1.name as 甲方项目名称2,
       pa1.code as 甲方项目编码2,
       h.SingleProjectName as 单项工程名称,
       dep.name as 工程主管部门,
       ma.name as 专业,
       h.Substation as 所属分局,
       h.LOH_PurchasingOrderNO as 采购订单号2,
       h.zhandianleixing as 站点类型,
       h.attachment as 附件,
       h.FORECASTTIME as 预计到货日期,
       h.LOH_TOTAL_PACKS as 总数量,
       h.LOH_TOTAL_GROSS_WEIGHT as 总毛重,
       h.LOH_TOTAL_CUBAGE as 总体积,
       h.LOH_TOTAL_AMOUNT as 总金额,
       h.ProjectManager1 as 项目负责人2
  from LRP_LogisticsOrder_H h
  left join LRP_LogisticsOrderMat_L l
    on h.oid = l.soid
  left join LRP_Lookup_L line
    on line.oid = h.LOH_EMERGENCY_DEGREE_ID
  left join LRP_WarehouseCenter org
    on org.oid = h.LOH_ORG_ID
  left join LRP_WarehouseTxType tyep
    on tyep.oid = h.LOH_OUTBOUND_TX_TYPE_ID
  left join LRP_StepType flow
    on flow.oid = h.LOH_OUTBOUND_FLOW_HEADER_ID
  left join LRP_WarehouseTxType tyep1
    on tyep1.oid = h.LOH_INBOUND_TX_TYPE_ID
  left join LRP_StepType flow1
    on flow1.oid = h.LOH_INBOUND_FLOW_HEADER_ID
  left join LRP_Material mat
    on mat.oid = l.MaterialId
  left join LRP_Lookup_L line1
    on line1.oid = l.unitl
  left join LRP_WarehouseCenter org1
    on org1.oid = h.LOH_LOAD_ORG_ID
  left join LRP_WarehouseCenter org2
    on org2.oid = h.LOH_UNLOAD_ORG_ID
  left join LRP_PartyAProject pa
    on pa.oid = l.DictUserDef4
  left join LRP_VendorCustomer ven
    on ven.oid = l.DictUserDef3
  left join SYS_Operator op
    on op.oid = h.CREATOR
  left join SYS_Operator op1
    on op1.oid = h.MODIFIER
  left join LRP_Owner ow
    on ow.oid = h.OwnerId
  left join LRP_VendorCustomer ven1
    on ven1.oid = h.LOH_VENDOR_ID
  left join LRP_VendorCustomer pa1
    on pa1.oid = h.LOH_PARTYAPROJECT_CODE
  left join Engineer_Depart dep
    on dep.oid = h.LOH_Engineering_Department
  left join Major ma
    on ma.oid = h.LOH_Major
 where h.OwnerId = '113003031'
 and org.name like '广州分屯库%'
 and h.LOH_TYPE = 'inbound'
 and h.status = 200
 and to_char(h.MODIFYTIME,'yyyy-mm-dd') =
     to_char(trunc(sysdate-1),'yyyy-mm-dd')
     order by h.MODIFYTIME

select h.oid as 物流订单ID,
       h.status,
       case
         when h.status = 200 then
          '已确认'
         when h.status = 250 then 
          '已出库'
         when h.status = 240 then 
          '已入库'
         else 
          ''
       end as 状态,
       line.name as 紧急程度,
       h.no as 物流订单号,
       h.OrderDateTime as 下单日期,
       org.name as 接单机构,
       case
         when h.LOH_TYPE = 'outbound_deliver' then
          '出库配送'
         when h.LOH_TYPE = 'collect_inbound' then
          '提货入库'
         when h.LOH_TYPE = 'collect_deliver' then
          '提货配送' 
         when h.LOH_TYPE = 'outbound' then
          '仅出库'
         when h.LOH_TYPE = 'inbound' then
          '仅入库'
         when h.LOH_TYPE = 'outbound_inbound' then
          '调拨（无运输）'
         when h.LOH_TYPE = 'outbound_transport_inbound' then
          '调拨（含运输）'
         else
          ''
       end as 订单类型,
       tyep.name as 出库事务类型,
       flow.name as 出库流程,
       tyep1.name as 入库事务类型,
       flow1.name as 入库流程,
       mat.code as 物料编码,
       mat.name as 物料名称,
       l.Spec as 规格型号,
       l.view_lol_material_category as 物料大类,
       line1.name as 单位,
       l.Qty as 数量,
       l.LOH_TierTwoUnits as 包装单位,
       l.LevelTwoQty as 包装数量,
       l.NumUserDef1 as 不含税单价,
       l.MONEY as 合计金额,
       org1.name as 发货仓库,
       h.LOH_LOAD_ADDRESS as 发货地址,
       h.LOH_LOAD_CONTACT as 发货人,
       h.LOH_LOAD_TEL as 发货联系电话,
       org2.name as 收货仓库,
       h.LOH_UNLOAD_ORG_ID,
       h.LOH_UNLOAD_ADDRESS as 收货地址,
       h.LOH_UNLOAD_CONTACT as 收货人,
       h.LOH_UNLOAD_TEL as 收货联系电话,
       h.loh_remark as 备注1,
       l.StrUserDef1 as 安装点,
       pa.code as 甲方项目编码1,
       pa.name as 甲方项目名称1,
       l.StrUserDef5 as 项目负责人1,
       l.StrUserDef2 as 需求单号,
       l.StrUserDef3 as 采购订单号1,
       l.StrUserDef4 as 备货订单号1,
       ven.name as 供应商1,
       l.StrUserDef6 as 备注2,
       l.loh_material_code as 客户物资编码,
       l.loh_material_name as 客户物资名称,
       op.name as 制单人,
       h.CREATETIME as 制单时间,
       op1.name as 修改人,
       h.MODIFYTIME as 修改时间,
       ow.name as 项目,
       ven1.name as 供应商2,
       pa1.name as 甲方项目名称2,
       pa1.code as 甲方项目编码2,
       h.SingleProjectName as 单项工程名称,
       dep.name as 工程主管部门,
       ma.name as 专业,
       h.Substation as 所属分局,
       h.LOH_PurchasingOrderNO as 采购订单号2,
       h.zhandianleixing as 站点类型,
       h.attachment as 附件,
       h.FORECASTTIME as 预计到货日期,
       h.LOH_TOTAL_PACKS as 总数量,
       h.LOH_TOTAL_GROSS_WEIGHT as 总毛重,
       h.LOH_TOTAL_CUBAGE as 总体积,
       h.LOH_TOTAL_AMOUNT as 总金额,
       h.ProjectManager1 as 项目负责人2
  from LRP_LogisticsOrder_H h
  left join LRP_LogisticsOrderMat_L l
    on h.oid = l.soid
  left join LRP_Lookup_L line
    on line.oid = h.LOH_EMERGENCY_DEGREE_ID
  left join LRP_WarehouseCenter org
    on org.oid = h.LOH_ORG_ID
  left join LRP_WarehouseTxType tyep
    on tyep.oid = h.LOH_OUTBOUND_TX_TYPE_ID
  left join LRP_StepType flow
    on flow.oid = h.LOH_OUTBOUND_FLOW_HEADER_ID
  left join LRP_WarehouseTxType tyep1
    on tyep1.oid = h.LOH_INBOUND_TX_TYPE_ID
  left join LRP_StepType flow1
    on flow1.oid = h.LOH_INBOUND_FLOW_HEADER_ID
  left join LRP_Material mat
    on mat.oid = l.MaterialId
  left join LRP_Lookup_L line1
    on line1.oid = l.unitl
  left join LRP_WarehouseCenter org1
    on org1.oid = h.LOH_LOAD_ORG_ID
  left join LRP_WarehouseCenter org2
    on org2.oid = h.LOH_UNLOAD_ORG_ID
  left join LRP_PartyAProject pa
    on pa.oid = l.DictUserDef4
  left join LRP_VendorCustomer ven
    on ven.oid = l.DictUserDef3
  left join SYS_Operator op
    on op.oid = h.CREATOR
  left join SYS_Operator op1
    on op1.oid = h.MODIFIER
  left join LRP_Owner ow
    on ow.oid = h.OwnerId
  left join LRP_VendorCustomer ven1
    on ven1.oid = h.LOH_VENDOR_ID
  left join LRP_VendorCustomer pa1
    on pa1.oid = h.LOH_PARTYAPROJECT_CODE
  left join Engineer_Depart dep
    on dep.oid = h.LOH_Engineering_Department
  left join Major ma
    on ma.oid = h.LOH_Major
 where h.OwnerId = '113003031'
 and org.name like '广州分屯库%'
 and (h.LOH_TYPE = 'outbound'
   or h.LOH_TYPE = 'outbound_deliver')
 and h.status = 200
 and to_char(h.MODIFYTIME,'yyyy-mm-dd') =
     to_char(trunc(sysdate-2),'yyyy-mm-dd')
     order by h.MODIFYTIME

select h.oid as 物流订单ID,
       h.status,
       case
         when h.status = 200 then
          '已确认'
         when h.status = 250 then 
          '已出库'
         when h.status = 240 then 
          '已入库'
         else 
          ''
       end as 状态,
       line.name as 紧急程度,
       h.no as 物流订单号,
       h.OrderDateTime as 下单日期,
       org.name as 接单机构,
       case
         when h.LOH_TYPE = 'outbound_deliver' then
          '出库配送'
         when h.LOH_TYPE = 'collect_inbound' then
          '提货入库'
         when h.LOH_TYPE = 'collect_deliver' then
          '提货配送' 
         when h.LOH_TYPE = 'outbound' then
          '仅出库'
         when h.LOH_TYPE = 'inbound' then
          '仅入库'
         when h.LOH_TYPE = 'outbound_inbound' then
          '调拨（无运输）'
         when h.LOH_TYPE = 'outbound_transport_inbound' then
          '调拨（含运输）'
         else
          ''
       end as 订单类型,
       tyep.name as 出库事务类型,
       flow.name as 出库流程,
       tyep1.name as 入库事务类型,
       flow1.name as 入库流程,
       mat.code as 物料编码,
       mat.name as 物料名称,
       l.Spec as 规格型号,
       l.view_lol_material_category as 物料大类,
       line1.name as 单位,
       l.Qty as 数量,
       l.LOH_TierTwoUnits as 包装单位,
       l.LevelTwoQty as 包装数量,
       l.NumUserDef1 as 不含税单价,
       l.MONEY as 合计金额,
       org1.name as 发货仓库,
       h.LOH_LOAD_ADDRESS as 发货地址,
       h.LOH_LOAD_CONTACT as 发货人,
       h.LOH_LOAD_TEL as 发货联系电话,
       org2.name as 收货仓库,
       h.LOH_UNLOAD_ORG_ID,
       h.LOH_UNLOAD_ADDRESS as 收货地址,
       h.LOH_UNLOAD_CONTACT as 收货人,
       h.LOH_UNLOAD_TEL as 收货联系电话,
       h.loh_remark as 备注1,
       l.StrUserDef1 as 安装点,
       pa.code as 甲方项目编码1,
       pa.name as 甲方项目名称1,
       l.StrUserDef5 as 项目负责人1,
       l.StrUserDef2 as 需求单号,
       l.StrUserDef3 as 采购订单号1,
       l.StrUserDef4 as 备货订单号1,
       ven.name as 供应商1,
       l.StrUserDef6 as 备注2,
       l.loh_material_code as 客户物资编码,
       l.loh_material_name as 客户物资名称,
       op.name as 制单人,
       h.CREATETIME as 制单时间,
       op1.name as 修改人,
       h.MODIFYTIME as 修改时间,
       ow.name as 项目,
       ven1.name as 供应商2,
       pa1.name as 甲方项目名称2,
       pa1.code as 甲方项目编码2,
       h.SingleProjectName as 单项工程名称,
       dep.name as 工程主管部门,
       ma.name as 专业,
       h.Substation as 所属分局,
       h.LOH_PurchasingOrderNO as 采购订单号2,
       h.zhandianleixing as 站点类型,
       h.attachment as 附件,
       h.FORECASTTIME as 预计到货日期,
       h.LOH_TOTAL_PACKS as 总数量,
       h.LOH_TOTAL_GROSS_WEIGHT as 总毛重,
       h.LOH_TOTAL_CUBAGE as 总体积,
       h.LOH_TOTAL_AMOUNT as 总金额,
       h.ProjectManager1 as 项目负责人2
  from LRP_LogisticsOrder_H h
  left join LRP_LogisticsOrderMat_L l
    on h.oid = l.soid
  left join LRP_Lookup_L line
    on line.oid = h.LOH_EMERGENCY_DEGREE_ID
  left join LRP_WarehouseCenter org
    on org.oid = h.LOH_ORG_ID
  left join LRP_WarehouseTxType tyep
    on tyep.oid = h.LOH_OUTBOUND_TX_TYPE_ID
  left join LRP_StepType flow
    on flow.oid = h.LOH_OUTBOUND_FLOW_HEADER_ID
  left join LRP_WarehouseTxType tyep1
    on tyep1.oid = h.LOH_INBOUND_TX_TYPE_ID
  left join LRP_StepType flow1
    on flow1.oid = h.LOH_INBOUND_FLOW_HEADER_ID
  left join LRP_Material mat
    on mat.oid = l.MaterialId
  left join LRP_Lookup_L line1
    on line1.oid = l.unitl
  left join LRP_WarehouseCenter org1
    on org1.oid = h.LOH_LOAD_ORG_ID
  left join LRP_WarehouseCenter org2
    on org2.oid = h.LOH_UNLOAD_ORG_ID
  left join LRP_PartyAProject pa
    on pa.oid = l.DictUserDef4
  left join LRP_VendorCustomer ven
    on ven.oid = l.DictUserDef3
  left join SYS_Operator op
    on op.oid = h.CREATOR
  left join SYS_Operator op1
    on op1.oid = h.MODIFIER
  left join LRP_Owner ow
    on ow.oid = h.OwnerId
  left join LRP_VendorCustomer ven1
    on ven1.oid = h.LOH_VENDOR_ID
  left join LRP_VendorCustomer pa1
    on pa1.oid = h.LOH_PARTYAPROJECT_CODE
  left join Engineer_Depart dep
    on dep.oid = h.LOH_Engineering_Department
  left join Major ma
    on ma.oid = h.LOH_Major
 where h.OwnerId = '113003031'
 and org.name like '广州分屯库%'
 and (h.LOH_TYPE = 'outbound_inbound'
   or h.LOH_TYPE = 'outbound_transport_inbound')
 and (h.status = 200 or
      h.status = 250)
 and to_char(h.MODIFYTIME,'yyyy-mm-dd') =
     to_char(trunc(sysdate-2),'yyyy-mm-dd')
     order by h.MODIFYTIME

