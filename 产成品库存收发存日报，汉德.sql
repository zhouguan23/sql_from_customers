select t.sub_code as 子库存,
       t.sub_name as 子库存说明,
       t.loc_id as 货位,
       (case when (t.loc_name like '%出口%' and t.LONG_DESCRIPTION='螺伞齿轮') then '出口'
             when (t.loc_name like '%军品%' and t.LONG_DESCRIPTION='螺伞齿轮') then '军品'
             when (t.loc_name like '%磨齿%' and t.LONG_DESCRIPTION='螺伞齿轮') then '磨齿'
             else null
        end) as 货位说明,
       t.item_type as 类别,
       t.产品系列,
       t.小类,
       t.系列, 
       t.item_code as 物料编码,
       t.item_name as 物料说明,
       t.LONG_DESCRIPTION as 说明,
       t.item_uom as 单位,
       t.item_cost as 物料成本,
       (t.end_qut - (t.msc_out + t.inv_out + t.mfg_out + t.om_out) -
       (t.po_in + t.inv_in + t.mfg_in + t.msc_in)) as 期初,
       (t.end_qut - (t.msc_out + t.inv_out + t.mfg_out + t.om_out) -
       (t.po_in + t.inv_in + t.mfg_in + t.msc_in)) * t.item_cost as 期初金额,
       t.end_qut as 期末,
       t.end_money as 期末金额,
       t.po_in+t.inv_in+t.mfg_in+t.msc_in as 本期入库,
       t.om_out+t.inv_out+t.mfg_out+t.msc_out  as 本期出库
  from (SELECT a.subinventory_code sub_code,
               msi1.DESCRIPTION sub_name,
               a.location_id loc_id,
               a.location_name loc_name,
               a.category_concat_segs item_type,
               (select ffvv.DESCRIPTION
                  from apps.FND_FLEX_VALUES_VL ffvv
                 where 1 = 1
                   and a.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
                   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
                   and ffvv.SUMMARY_FLAG = 'N'
                   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE) 产品系列,
               (select substr(ffvv.DESCRIPTION, 1, instr(ffvv.DESCRIPTION, '-') -1)
                  from apps.FND_FLEX_VALUES_VL ffvv
                 where 1 = 1
                   and a.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
                   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
                   and ffvv.SUMMARY_FLAG = 'N'
                   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE) 小类,
               (select substr(ffvv.DESCRIPTION,instr(ffvv.DESCRIPTION,'-')+1,length(ffvv.DESCRIPTION)-instr(ffvv.DESCRIPTION,'-'))
                  from apps.FND_FLEX_VALUES_VL ffvv
                 where 1 = 1
                   and a.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
                   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
                   and ffvv.SUMMARY_FLAG = 'N'
                   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE) 系列,
               a.segment1 item_code,
               a.item_name item_name,
               (case when a.LONG_DESCRIPTION like '%LS%' then '螺伞齿轮'
                     when a.long_description like '%YZCL%' then '圆柱齿轮'
                     when a.long_description like '%YZJD%' then '精锻齿轮'
                     else null
               end)  as long_description,
               a.primary_uom_code item_uom,
               round(nvl(b.item_cost, 0), 2) item_cost,
               SUM(a.end_qut) end_qut,
               round(nvl(b.item_cost, 0), 2) * SUM(a.end_qut) as end_money,
               SUM(a.po_in) po_in,
               SUM(a.inv_in) inv_in,
               SUM(a.mfg_in) mfg_in,
               SUM(a.msc_in) msc_in,
               sum(a.om_out) om_out,
               sum(a.inv_out) inv_out,
               sum(a.mfg_out) mfg_out,
               sum(a.msc_out) msc_out
          FROM (SELECT moq.subinventory_code,
                       mil.SEGMENT1 location_id,
                       mil.description location_name,
                       mic.category_concat_segs,
                       msi.inventory_item_id,
                       msi.segment1,
                       msi.description item_name,
                       msi.LONG_DESCRIPTION,
                       msi.primary_uom_code,
                       SUM(moq.primary_transaction_quantity) end_qut,
                       0 po_in,
                       0 inv_in,
                       0 mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.mtl_onhand_quantities_detail moq,
                       apps.mtl_item_categories_v        mic,
                       apps.mtl_system_items_fvl         msi,
                       apps.mtl_item_locations           mil
                 WHERE msi.organization_id = moq.organization_id
                   AND msi.inventory_item_id = moq.inventory_item_id
                   AND moq.inventory_item_id = mic.inventory_item_id
                   AND moq.organization_id = mic.organization_id
                   AND moq.organization_id = mil.organization_id(+)
                   AND moq.locator_id = mil.inventory_location_id(+)
                   AND (moq.subinventory_code like 'CP%' or
                       moq.SUBINVENTORY_CODE like 'DFK%' or
                       moq.SUBINVENTORY_CODE like 'JK%')
                   AND mic.structure_id = '2'
                   AND msi.organization_id = 109
                   AND (mil.segment1 NOT LIKE '%失效%' OR mil.segment1 IS NULL)
                 GROUP BY moq.subinventory_code,
                          mil.SEGMENT1,
                          mil.description,
                          mic.category_concat_segs,
                          msi.inventory_item_id,
                          msi.segment1,
                          msi.description,
                          msi.LONG_DESCRIPTION,
                          msi.primary_uom_code
                --2。取统计日期之后发生的业务
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       -nvl(SUM(mht.transaction_quantity), 0) end_qut,
                       0 po_in,
                       0 inv_in,
                       0 mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date >
                       to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                               'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code
                --3。取统计期间的业务活动
                --3.1 采购入库数量
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       0 end_qut,
                       nvl(SUM(mht.transaction_quantity), 0) po_in,
                       0 inv_in,
                       0 mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE mht.transaction_type_name IN
                       ('PO 接收', '向供应商退货', '在途接收')
                   AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date >=
                       nvl(to_char(to_date('${startdate}', 'yyyy-mm-dd'),
                                   'yyyy-mm-dd'),
                           mht.transaction_date)
                   AND mht.transaction_date <=
                       to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                               'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code
                --3.2 库存入库数量
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       0 end_qut,
                       0 po_in,
                       nvl(SUM(mht.transaction_quantity), 0) inv_in,
                       0 mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE mht.transaction_type_name IN
                       ('子库存转移', '物料搬运单转移')
                   AND mht.transaction_quantity > 0
                   AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date >=
                       nvl(to_char(to_date('${startdate}', 'yyyy-mm-dd'),
                                   'yyyy-mm-dd'),
                           mht.transaction_date)
                   AND mht.transaction_date <=
                       to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                               'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code
                --3.3 生产入库数量
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       0 end_qut,
                       0 po_in,
                       0 inv_in,
                       nvl(SUM(mht.transaction_quantity), 0) mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE mht.transaction_type_name IN
                       ('WIP 装配件完成', 'WIP 装配件退货')
                   AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date >=
                       nvl(to_char(to_date('${startdate}', 'yyyy-mm-dd'),
                                   'yyyy-mm-dd'),
                           mht.transaction_date)
                   AND mht.transaction_date <=
                       to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                               'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code
                --3.4 杂项入库数量
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       0 end_qut,
                       0 po_in,
                       0 inv_in,
                       0 mfg_in,
                       nvl(SUM(mht.transaction_quantity), 0) msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out                       
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE mht.transaction_type_name IN
                       ('帐户别名接收', '杂项接收')
                   AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date >=
                       nvl(to_char(to_date('${startdate}', 'yyyy-mm-dd'),
                                   'yyyy-mm-dd'),
                           mht.transaction_date)
                   AND mht.transaction_date <=
                       to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                               'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code  
         --3.5 销售出数量
              UNION ALL
              SELECT mht.subinventory_code,
                     mht.location_id,
                     mht.location_name,
                     mht.category_concat_segs,
                     mht.inventory_item_id,
                     mht.segment1,
                     mht.item_name,
                     mht.long_description,
                     mht.primary_uom_code,
                     0 end_qut,
                     0 po_in,
                     0 inv_in,
                     0 mfg_in,
                     0 msc_in,
                     nvl(SUM(mht.transaction_quantity), 0) om_out,
                     0 inv_out,
                     0 mfg_out,
                     0 msc_out
                FROM apps.cux_mtl_hande_transaction_v mht
               WHERE mht.transaction_type_name IN
                     ('销售订单发放', 'RMA 接收', '在途发运')
                 AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                 AND mht.transaction_date >=
                     nvl(to_char(to_date('${startdate}', 'yyyy-mm-dd'),
                                 'yyyy-mm-dd'),
                         mht.transaction_date)
                 AND mht.transaction_date <=
                     to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                             'yyyy-mm-dd')
                 AND mht.structure_id = '2'
                 AND mht.organization_id =109
               GROUP BY mht.subinventory_code,
                        mht.location_id,
                        mht.location_name,
                        mht.category_concat_segs,
                        mht.inventory_item_id,
                        mht.segment1,
                        mht.item_name,
                        mht.long_description,
                        mht.primary_uom_code
              --3.6 生产出数量
              UNION ALL
              SELECT mht.subinventory_code,
                     mht.location_id,
                     mht.location_name,
                     mht.category_concat_segs,
                     mht.inventory_item_id,
                     mht.segment1,
                     mht.item_name,
                     mht.long_description,
                     mht.primary_uom_code,
                     0 end_qut,
                     0 po_in,
                     0 inv_in,
                     0 mfg_in,
                     0 msc_in,
                     0 om_out,
                     0 inv_out,
                     nvl(SUM(mht.transaction_quantity), 0) mfg_out,
                     0 msc_out
                FROM apps.cux_mtl_hande_transaction_v mht
               WHERE mht.transaction_type_name IN
                     ('WIP 组件发放', 'WIP 组件退货')
                 AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                 AND mht.transaction_date >=
                     nvl(to_char(to_date('${startdate}', 'yyyy-mm-dd'),
                                 'yyyy-mm-dd'),
                         mht.transaction_date)
                 AND mht.transaction_date <=
                     to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                             'yyyy-mm-dd')
                 AND mht.structure_id = '2'
                 AND mht.organization_id =109
               GROUP BY mht.subinventory_code,
                     mht.location_id,
                     mht.location_name,
                     mht.category_concat_segs,
                     mht.inventory_item_id,
                     mht.segment1,
                     mht.item_name,
                     mht.long_description,
                     mht.primary_uom_code
              --3.7 库存出数量
              UNION ALL
              SELECT mht.subinventory_code,
                     mht.location_id,
                     mht.location_name,
                     mht.category_concat_segs,
                     mht.inventory_item_id,
                     mht.segment1,
                     mht.item_name,
                     mht.long_description,
                     mht.primary_uom_code,
                     0 end_qut,
                     0 po_in,
                     0 inv_in,
                     0 mfg_in,
                     0 msc_in,
                     0 om_out,
                     nvl(SUM(mht.transaction_quantity), 0) inv_out,
                     0 mfg_out,
                     0 msc_out
                FROM apps.cux_mtl_hande_transaction_v mht
               WHERE mht.transaction_type_name IN
                     ('子库存转移', '物料搬运单转移', '物料搬运单发放')
                 AND mht.transaction_quantity < 0
                 AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                 AND mht.transaction_date >=
                     nvl(to_char(to_date('${startdate}', 'yyyy-mm-dd'),
                                 'yyyy-mm-dd'),
                         mht.transaction_date)
                 AND mht.transaction_date <=
                     to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                             'yyyy-mm-dd')
                 AND mht.structure_id = '2'
                 AND mht.organization_id =109
               GROUP BY mht.subinventory_code,
                     mht.location_id,
                     mht.location_name,
                     mht.category_concat_segs,
                     mht.inventory_item_id,
                     mht.segment1,
                     mht.item_name,
                     mht.long_description,
                     mht.primary_uom_code
              --3.8 杂出数量
              UNION ALL
              SELECT mht.subinventory_code,
                     mht.location_id,
                     mht.location_name,
                     mht.category_concat_segs,
                     mht.inventory_item_id,
                     mht.segment1,
                     mht.item_name,
                     mht.long_description,
                     mht.primary_uom_code,
                     0 end_qut,
                     0 po_in,
                     0 inv_in,
                     0 mfg_in,
                     0 msc_in,
                     0 om_out,
                     0 inv_out,
                     0 mfg_out,
                     nvl(SUM(mht.transaction_quantity), 0) msc_out
                FROM apps.cux_mtl_hande_transaction_v mht
               WHERE mht.transaction_type_name IN
                     ('帐户别名发放', '杂项发放')
                 AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                 AND mht.transaction_date >=
                     nvl(to_char(to_date('${startdate}', 'yyyy-mm-dd'),
                                 'yyyy-mm-dd'),
                         mht.transaction_date)
                 AND mht.transaction_date <=
                     to_char(to_date('${enddate}', 'yyyy-mm-dd'),
                             'yyyy-mm-dd')
                 AND mht.structure_id ='2'
                 AND mht.organization_id =109
               GROUP BY mht.subinventory_code,
                     mht.location_id,
                     mht.location_name,
                     mht.category_concat_segs,
                     mht.inventory_item_id,
                     mht.segment1,
                     mht.item_name,
                     mht.long_description,
                     mht.primary_uom_code) a,
               apps.cst_item_costs b,
               apps.mtl_secondary_inventories msi1
         WHERE b.cost_type_id = 1
           AND b.organization_id = 109
           AND a.inventory_item_id = b.inventory_item_id(+)
           and a.subinventory_code = msi1.SECONDARY_INVENTORY_NAME
           and msi1.ORGANIZATION_ID = 109
         GROUP BY a.subinventory_code,
                  msi1.DESCRIPTION,
                  a.location_id,
                  a.location_name,
                  a.category_concat_segs,
                  a.segment1,
                  a.item_name,
                  a.LONG_DESCRIPTION,
                  a.primary_uom_code,
                  b.item_cost
         ORDER BY subinventory_code, location_name, segment1) t 
 where  t.long_description=nvl('${dep}',t.long_description)


select substr(t.dates,6,5)
from (SELECT
  to_char(to_date('${startdate}','YYYY-MM-DD')+level-1,'yyyy-mm-dd') as dates
FROM 
  dual 
CONNECT BY 
  level <= to_date('${enddate}','YYYY-MM-DD')-to_date('${startdate}','YYYY-MM-DD')+1 )t


select t.sub_code as 子库存,
       t.sub_name as 子库存说明,
       t.loc_id as 货位,
       t.loc_name as 货位说明,
       t.item_type as 类别,
       t.产品系列,
       t.小类,
       t.系列, 
       t.item_code as 物料编码,
       t.item_name as 物料说明,
       t.long_description  as 说明,
       t.item_uom as 单位,
       t.item_cost as 物料成本,
       (t.end_qut - (t.msc_out + t.inv_out + t.mfg_out + t.om_out) -
       (t.po_in + t.inv_in + t.mfg_in + t.msc_in)) as 期初,
       (t.end_qut - (t.msc_out + t.inv_out + t.mfg_out + t.om_out) -
       (t.po_in + t.inv_in + t.mfg_in + t.msc_in)) * t.item_cost as 期初金额,
       t.end_qut as 期末,
       t.end_money as 期末金额,
       t.po_in+t.inv_in+t.mfg_in+t.msc_in as 本期入库,
       t.om_out+t.inv_out+t.mfg_out+t.msc_out  as 本期出库
  from (SELECT a.subinventory_code sub_code,
               msi1.DESCRIPTION sub_name,
               a.location_id loc_id,
               a.location_name loc_name,
               a.category_concat_segs item_type,
               (select ffvv.DESCRIPTION
                  from apps.FND_FLEX_VALUES_VL ffvv
                 where 1 = 1
                   and a.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
                   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
                   and ffvv.SUMMARY_FLAG = 'N'
                   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE) 产品系列,
               (select substr(ffvv.DESCRIPTION, 1, instr(ffvv.DESCRIPTION, '-') -1)
                  from apps.FND_FLEX_VALUES_VL ffvv
                 where 1 = 1
                   and a.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
                   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
                   and ffvv.SUMMARY_FLAG = 'N'
                   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE) 小类,
               (select substr(ffvv.DESCRIPTION,instr(ffvv.DESCRIPTION,'-')+1,length(ffvv.DESCRIPTION)-instr(ffvv.DESCRIPTION,'-'))
                  from apps.FND_FLEX_VALUES_VL ffvv
                 where 1 = 1
                   and a.CATEGORY_CONCAT_SEGS = ffvv.FLEX_VALUE
                   and ffvv.FLEX_VALUE_SET_ID in ('1017164', '1017168')
                   and ffvv.SUMMARY_FLAG = 'N'
                   and ffvv.PARENT_FLEX_VALUE_LOW = ffvv.FLEX_VALUE) 系列,
               a.segment1 item_code,
               a.item_name item_name,
               (case when a.LONG_DESCRIPTION like '%LS%' then '螺伞齿轮'
                     when a.long_description like '%YZCL%' then '圆柱齿轮'
                     when a.long_description like '%YZJD%' then '精锻齿轮'
                     else null
               end) long_description,
               a.primary_uom_code item_uom,
               round(nvl(b.item_cost, 0), 2) item_cost,
               SUM(a.end_qut) end_qut,
               round(nvl(b.item_cost, 0), 2) * SUM(a.end_qut) as end_money,
               SUM(a.po_in) po_in,
               SUM(a.inv_in) inv_in,
               SUM(a.mfg_in) mfg_in,
               SUM(a.msc_in) msc_in,
               SUM(a.om_out) om_out,
               SUM(a.inv_out) inv_out,
               SUM(a.mfg_out) mfg_out,
               SUM(a.msc_out) msc_out
          FROM (SELECT moq.subinventory_code,
                       mil.SEGMENT1 location_id,
                       mil.description location_name,
                       mic.category_concat_segs,
                       msi.inventory_item_id,
                       msi.segment1,
                       msi.description item_name,
                       msi.LONG_DESCRIPTION,
                       msi.primary_uom_code,
                       SUM(moq.primary_transaction_quantity) end_qut,
                       0 po_in,
                       0 inv_in,
                       0 mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.mtl_onhand_quantities_detail moq,
                       apps.mtl_item_categories_v        mic,
                       apps.mtl_system_items_fvl         msi,
                       apps.mtl_item_locations           mil
                 WHERE msi.organization_id = moq.organization_id
                   AND msi.inventory_item_id = moq.inventory_item_id
                   AND moq.inventory_item_id = mic.inventory_item_id
                   AND moq.organization_id = mic.organization_id
                   AND moq.organization_id = mil.organization_id(+)
                   AND moq.locator_id = mil.inventory_location_id(+)
                   AND (moq.subinventory_code like 'CP%' or
                       moq.SUBINVENTORY_CODE like 'DFK%' or
                       moq.SUBINVENTORY_CODE like 'JK%')
                   AND mic.structure_id = '2'
                   AND msi.organization_id = 109
                   AND (mil.segment1 NOT LIKE '%失效%' OR mil.segment1 IS NULL)
                 GROUP BY moq.subinventory_code,
                          mil.SEGMENT1,
                          mil.description,
                          mic.category_concat_segs,
                          msi.inventory_item_id,
                          msi.segment1,
                          msi.description,
                          msi.LONG_DESCRIPTION,
                          msi.primary_uom_code
                --2。取统计日期之后发生的业务
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       -nvl(SUM(mht.transaction_quantity), 0) end_qut,
                       0 po_in,
                       0 inv_in,
                       0 mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date >to_char(to_date('${date}', 'yyyy-mm-dd'),'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code
                --3。取统计期间的业务活动
                --3.1 采购入库数量
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       0 end_qut,
                       nvl(SUM(mht.transaction_quantity), 0) po_in,
                       0 inv_in,
                       0 mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE mht.transaction_type_name IN
                       ('PO 接收', '向供应商退货', '在途接收')
                   AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date =to_char(to_date('${date}', 'yyyy-mm-dd'),'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code
                --3.2 库存入库数量
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       0 end_qut,
                       0 po_in,
                       nvl(SUM(mht.transaction_quantity), 0) inv_in,
                       0 mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE mht.transaction_type_name IN
                       ('子库存转移', '物料搬运单转移')
                   AND mht.transaction_quantity > 0
                   AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date =to_char(to_date('${date}', 'yyyy-mm-dd'),'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code
                --3.3 生产入库数量
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       0 end_qut,
                       0 po_in,
                       0 inv_in,
                       nvl(SUM(mht.transaction_quantity), 0) mfg_in,
                       0 msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE mht.transaction_type_name IN
                       ('WIP 装配件完成', 'WIP 装配件退货')
                   AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date =to_char(to_date('${date}', 'yyyy-mm-dd'),'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code
                --3.4 杂项入库数量
                UNION ALL
                SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                       0 end_qut,
                       0 po_in,
                       0 inv_in,
                       0 mfg_in,
                       nvl(SUM(mht.transaction_quantity), 0) msc_in,
                       0 om_out,
                       0 inv_out,
                       0 mfg_out,
                       0 msc_out
                  FROM apps.cux_mtl_hande_transaction_v mht
                 WHERE mht.transaction_type_name IN
                       ('帐户别名接收', '杂项接收')
                   AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                   AND mht.transaction_date =to_char(to_date('${date}', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                   AND mht.structure_id = '2'
                   AND mht.organization_id = 109
                 GROUP BY mht.subinventory_code,
                          mht.location_id,
                          mht.location_name,
                          mht.category_concat_segs,
                          mht.inventory_item_id,
                          mht.segment1,
                          mht.item_name,
                          mht.LONG_DESCRIPTION,
                          mht.primary_uom_code   
          --3.5 销售出数量
              UNION ALL
              SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                     0 end_qut,
                     0 po_in,
                     0 inv_in,
                     0 mfg_in,
                     0 msc_in,
                     nvl(SUM(mht.transaction_quantity), 0) om_out,
                     0 inv_out,
                     0 mfg_out,
                     0 msc_out
                FROM apps.cux_mtl_hande_transaction_v mht
               WHERE mht.transaction_type_name IN
                     ('销售订单发放', 'RMA 接收', '在途发运')
                 AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                 AND mht.transaction_date =to_char(to_date('${date}', 'yyyy-mm-dd'),
                             'yyyy-mm-dd')
                 AND mht.structure_id = '2'
                 AND mht.organization_id =109
               GROUP BY mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code              
              --3.6 生产出数量
              UNION ALL
              SELECT   mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                     0 end_qut,
                     0 po_in,
                     0 inv_in,
                     0 mfg_in,
                     0 msc_in,
                     0 om_out,
                     0 inv_out,
                     nvl(SUM(mht.transaction_quantity), 0) mfg_out,
                     0 msc_out
                FROM apps.cux_mtl_hande_transaction_v mht
               WHERE mht.transaction_type_name IN
                     ('WIP 组件发放', 'WIP 组件退货')
                 AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                 AND mht.transaction_date =to_char(to_date('${date}', 'yyyy-mm-dd'),
                             'yyyy-mm-dd')
                 AND mht.structure_id = '2'
                 AND mht.organization_id =109
               GROUP BY mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code
              --3.7 库存出数量
              UNION ALL
              SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                     0 end_qut,
                     0 po_in,
                     0 inv_in,
                     0 mfg_in,
                     0 msc_in,
                     0 om_out,
                     nvl(SUM(mht.transaction_quantity), 0) inv_out,
                     0 mfg_out,
                     0 msc_out
                FROM apps.cux_mtl_hande_transaction_v mht
               WHERE mht.transaction_type_name IN
                     ('子库存转移', '物料搬运单转移', '物料搬运单发放')
                 AND mht.transaction_quantity < 0
                 AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                 AND mht.transaction_date = to_char(to_date('${date}', 'yyyy-mm-dd'),
                             'yyyy-mm-dd')
                 AND mht.structure_id = '2'
                 AND mht.organization_id =109
               GROUP BY mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code
              --3.8 杂出数量
              UNION ALL
              SELECT mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code,
                     0 end_qut,
                     0 po_in,
                     0 inv_in,
                     0 mfg_in,
                     0 msc_in,
                     0 om_out,
                     0 inv_out,
                     0 mfg_out,
                     nvl(SUM(mht.transaction_quantity), 0) msc_out
                FROM apps.cux_mtl_hande_transaction_v mht
               WHERE apps.mht.transaction_type_name IN
                     ('帐户别名发放', '杂项发放')
                 AND (mht.subinventory_code like 'CP%' or
                       mht.subinventory_code like 'DFK%' or
                       mht.subinventory_code like 'JK%')
                 AND mht.transaction_date =to_char(to_date('${date}', 'yyyy-mm-dd'),
                             'yyyy-mm-dd')
                 AND mht.structure_id ='2'
                 AND mht.organization_id =109
               GROUP BY mht.subinventory_code,
                       mht.location_id,
                       mht.location_name,
                       mht.category_concat_segs,
                       mht.inventory_item_id,
                       mht.segment1,
                       mht.item_name,
                       mht.LONG_DESCRIPTION,
                       mht.primary_uom_code ) a,
               apps.cst_item_costs b,
               apps.mtl_secondary_inventories msi1
         WHERE b.cost_type_id = 1
           AND b.organization_id = 109
           AND a.inventory_item_id = b.inventory_item_id(+)
           and a.subinventory_code = msi1.SECONDARY_INVENTORY_NAME
           and msi1.ORGANIZATION_ID = 109
         GROUP BY a.subinventory_code,
                  msi1.DESCRIPTION,
                  a.location_id,
                  a.location_name,
                  a.category_concat_segs,
                  a.segment1,
                  a.item_name,
                  a.LONG_DESCRIPTION,
                  a.primary_uom_code,
                  b.item_cost
         ORDER BY subinventory_code, location_name, segment1) t 
where  t.long_description=nvl('${dep}',t.long_description)

select t.dates
from (SELECT
  to_char(to_date('${startdate}','YYYY-MM-DD')+level-1,'yyyy-mm-dd') as dates
FROM 
  dual 
CONNECT BY 
  level <= to_date('${enddate}','YYYY-MM-DD')-to_date('${startdate}','YYYY-MM-DD')+1 )t


select * from CUX_ZC_FR_LS_CSB

