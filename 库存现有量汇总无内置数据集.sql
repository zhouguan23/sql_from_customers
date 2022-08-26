select moqd.SUBINVENTORY_CODE as 子库存,
       msi.DESCRIPTION as 子库存说明,
       micv.CATEGORY_CONCAT_SEGS as 类别,
       ffvv.DESCRIPTION as 类别说明,
       substr(ffvv.DESCRIPTION, 1, instr(ffvv.DESCRIPTION, '-') -1)  小类,
       substr(ffvv.DESCRIPTION,instr(ffvv.DESCRIPTION,'-')+1,length(ffvv.DESCRIPTION)-instr(ffvv.DESCRIPTION,'-'))  系列,
       msif.SEGMENT1 as 物料编码,
       msif.DESCRIPTION as 物料说明,
       moqd.TRANSACTION_UOM_CODE as 主要单位,
       sum(moqd.TRANSACTION_QUANTITY) as 数量,
       cictv.item_cost as 物料单位成本,
       sum(moqd.TRANSACTION_QUANTITY) * cictv.item_cost as 物料库存成本
  from apps.mtl_onhand_quantities_detail moqd,
       apps.mtl_secondary_inventories    msi,
       apps.MTL_ITEM_CATEGORIES_V        micv,
       apps.FND_FLEX_VALUES_VL           ffvv,
       apps.mtl_system_items_fvl         msif,
       apps.CST_ITEM_COST_TYPE_V         cictv
 where (msif.DESCRIPTION like '%${name}%' or '${name}' is null)
   and moqd.SUBINVENTORY_CODE in ('${sub_code}')
   and moqd.ORGANIZATION_ID = 109
   and msi.ORGANIZATION_ID = 109
   and msi.SECONDARY_INVENTORY_NAME = moqd.SUBINVENTORY_CODE
   and micv.ORGANIZATION_ID = 109
   and micv.INVENTORY_ITEM_ID = moqd.INVENTORY_ITEM_ID
   and micv.CATEGORY_SET_NAME = '产品系列'
   and micv.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
   and ffvv.SUMMARY_FLAG = 'N'
   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE
   and msif.ORGANIZATION_ID = 109
   and msif.INVENTORY_ITEM_ID = moqd.INVENTORY_ITEM_ID
   and cictv.organization_id = 109
   and cictv.inventory_item_id = moqd.INVENTORY_ITEM_ID
   and cictv.cost_type = 'Frozen'
 group by moqd.SUBINVENTORY_CODE,
          msi.DESCRIPTION,
          micv.CATEGORY_CONCAT_SEGS,
          ffvv.DESCRIPTION,
          msif.SEGMENT1,
          msif.DESCRIPTION,
          moqd.TRANSACTION_UOM_CODE,
          cictv.item_cost
 order by moqd.SUBINVENTORY_CODE, msif.SEGMENT1

select moqd.SUBINVENTORY_CODE as 子库存,
       msi.DESCRIPTION as 子库存说明,
       micv.CATEGORY_CONCAT_SEGS as 类别,
       ffvv.DESCRIPTION as 类别说明,
       msif.SEGMENT1 as 物料编码,
       msif.DESCRIPTION as 物料说明,
       moqd.TRANSACTION_UOM_CODE as 主要单位,
       sum(moqd.TRANSACTION_QUANTITY) as 数量,
       cictv.item_cost as 物料单位成本,
       sum(moqd.TRANSACTION_QUANTITY) * cictv.item_cost as 物料库存成本
  from apps.mtl_onhand_quantities_detail moqd,
       apps.mtl_secondary_inventories    msi,
       apps.MTL_ITEM_CATEGORIES_V        micv,
       apps.FND_FLEX_VALUES_VL           ffvv,
       apps.mtl_system_items_fvl         msif,
       apps.CST_ITEM_COST_TYPE_V         cictv
 where 1=1
   and moqd.ORGANIZATION_ID = 109
   and msi.ORGANIZATION_ID = 109
   and msi.SECONDARY_INVENTORY_NAME = moqd.SUBINVENTORY_CODE
   and micv.ORGANIZATION_ID = 109
   and micv.INVENTORY_ITEM_ID = moqd.INVENTORY_ITEM_ID
   and micv.CATEGORY_SET_NAME = '产品系列'
   and micv.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
   and ffvv.SUMMARY_FLAG = 'N'
   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE
   and msif.ORGANIZATION_ID = 109
   and msif.INVENTORY_ITEM_ID = moqd.INVENTORY_ITEM_ID
   and cictv.organization_id = 109
   and cictv.inventory_item_id = moqd.INVENTORY_ITEM_ID
   and cictv.cost_type = 'Frozen'
 group by moqd.SUBINVENTORY_CODE,
          msi.DESCRIPTION,
          micv.CATEGORY_CONCAT_SEGS,
          ffvv.DESCRIPTION,
          msif.SEGMENT1,
          msif.DESCRIPTION,
          moqd.TRANSACTION_UOM_CODE,
          cictv.item_cost
 order by moqd.SUBINVENTORY_CODE, msif.SEGMENT1

select moqd.SUBINVENTORY_CODE as 子库存,
       msi.DESCRIPTION as 子库存说明,
       micv.CATEGORY_CONCAT_SEGS as 类别,
       ffvv.DESCRIPTION as 类别说明,
       msif.SEGMENT1 as 物料编码,
       msif.DESCRIPTION as 物料说明,
       moqd.TRANSACTION_UOM_CODE as 主要单位,
       sum(moqd.TRANSACTION_QUANTITY) as 数量,
       cictv.item_cost as 物料单位成本,
       sum(moqd.TRANSACTION_QUANTITY) * cictv.item_cost as 物料库存成本
  from apps.mtl_onhand_quantities_detail moqd,
       apps.mtl_secondary_inventories    msi,
       apps.MTL_ITEM_CATEGORIES_V        micv,
       apps.FND_FLEX_VALUES_VL           ffvv,
       apps.mtl_system_items_fvl         msif,
       apps.CST_ITEM_COST_TYPE_V         cictv
 where moqd.ORGANIZATION_ID = 109
   and msi.ORGANIZATION_ID = 109
   and msi.SECONDARY_INVENTORY_NAME = moqd.SUBINVENTORY_CODE
   and micv.ORGANIZATION_ID = 109
   and micv.INVENTORY_ITEM_ID = moqd.INVENTORY_ITEM_ID
   and micv.CATEGORY_SET_NAME = '产品系列'
   and micv.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
   and ffvv.SUMMARY_FLAG = 'N'
   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE
   and msif.ORGANIZATION_ID = 109
   and msif.INVENTORY_ITEM_ID = moqd.INVENTORY_ITEM_ID
   and cictv.organization_id = 109
   and cictv.inventory_item_id = moqd.INVENTORY_ITEM_ID
   and cictv.cost_type = 'Frozen'
 group by moqd.SUBINVENTORY_CODE,
          msi.DESCRIPTION,
          micv.CATEGORY_CONCAT_SEGS,
          ffvv.DESCRIPTION,
          msif.SEGMENT1,
          msif.DESCRIPTION,
          moqd.TRANSACTION_UOM_CODE,
          cictv.item_cost
 order by moqd.SUBINVENTORY_CODE, msif.SEGMENT1

