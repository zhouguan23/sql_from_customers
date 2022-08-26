select t.地市,
       t.仓库,
       n.接单机构,
       t.项目,
       n.物料编码,
       t.二级编码,
       t.物料名称,
       t.规格型号,
       t.单位,
       t.物料大类,
       t.三级大类,
       t.数量,
       t.不含税单价,
       t.合计金额,
       n.供应商,
       t.需求单号,
       t.采购订单号,
       t.备货订单号,
       t.甲方项目编码,
       t.甲方项目名称,
       t.项目负责人,
       t.安装点,
       t.客户物料编码,
       t.客户物料名称,
       t.入库时间,
       t.在库时间,
       n.接收子库,
       t.备注
 from(
 select m.* from 
 (select k.*,
     case
     when k.下单时间 is not null
     then 
     floor(sysdate-to_date(to_char(k.下单时间,'yyyy-mm-dd'),'yyyy-mm-dd'))
     else k.在库时间
     end as 停置天数
from (
(select t.*,
       t1.发货单号 as 收发货单号,
       t1.最新下单时间 as 下单时间
from
(select 
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.qt_org_id,
       a.QT_LOT_LOOKUP1,
       b.name AS 接单机构,
       a.qt_owner_id,
       c.name as 项目,
       a.qt_material_id,
       d.code as 物料编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       d.name as 物料名称,
       d.MAT_SPEC as 规格型号,
       d.MAT_CATEGORY_ID,
       d.MAT_UNIT_ID,
       n.name as 单位,
       e.name as 物料大类,
       case
         when e."LEVEL" = 5 then
          e1.name
         else
          e.name
       end as 三级大类,
       e1.id as id20,
       a.qt_onhand_qty as 数量,
       a.qt_lot_number0 as 不含税单价,
       round(a.qt_onhand_qty * a.qt_lot_number0,2) as 合计金额,
       a.qt_lot_mstdata0,
       f.name as 供应商,
       a.qt_lot_string2 as 需求单号,
       a.qt_lot_string3 as 采购订单号,
       a.qt_lot_string4 as 备货订单号,
       a.qt_lot_mstdata1,
       g.code as 甲方项目编码,
       g.name  as 甲方项目名称,
       g.ProjectManager as 项目负责人,
       a.qt_lot_string1 as 安装点,
       d.MSS_Code as 客户物料编码,
       d.MSS_Name as 客户物料名称,
       a.qt_recv_date as 入库时间,
       ROUND(TO_NUMBER(sysdate - a.qt_recv_date), 0) as 在库时间,
       a.qt_lot_mstdata2,
       i.name as 接收子库,
       a.qt_location_id,
       j.name as 储位,
       j.LOC_STOREROOM_ID,
       j.LOC_STOREAREA_ID,
       k.name as 仓间,
       m.name as 库区,
       a.qt_lot_string6 as 备注
  from wm_quant a
  left join CP_ORGANIZATION b
    on a.qt_org_id = b.id
  left join CP_OWNER c
    on a.qt_owner_id = c.id
  left join CP_Material d
    on a.qt_material_id = d.id
  left join CP_MATERIAL_CATEGORY e
    on d.MAT_CATEGORY_ID = e.id
  left join CP_MATERIAL_CATEGORY e1
    on e1.id = e.parentid
  left join CP_VENDOR_CUSTOMER f
    on a.qt_lot_mstdata0 = f.id
  left join CP_PartyAProject g
    on a.qt_lot_mstdata1 = g.id
  left join CP_ReceivingSubsystem i
    on a.qt_lot_mstdata2 = i.id
  left join CP_LOCATION j
    on j.id = a.qt_location_id
  left join CP_STOREROOM k
    on j.LOC_STOREROOM_ID = k.id
  left join CP_STOREAREA m
    on j.LOC_STOREAREA_ID = m.id
  left join CP_LOOKUP_LINE n
    on d.MAT_UNIT_ID = n.id
 where a.qt_owner_id = '113003031'
   and a.qt_onhand_qty != 0
   order by a.qt_onhand_qty * a.qt_lot_number0 desc) t
left join (
select b.name as 接单机构,
       c.name as 项目,
       d.LOH_LOGISTICS_NO,
       e.ONH_NOTICE_NO,
       a.SH_SHIP_NO as 发货单号,
       max(a.MakeDate) as 最新下单时间,
       g.SL_MATERIAL_ID,
       f.code as 物料编码,
       f.name as 物料名称,
       f.MAT_SPEC as 规格型号,
       o.name as 供应商,
       p.code as code1
  from WM_SHIP_HEADER a
  left join CP_ORGANIZATION b
    on a.SH_ORG_ID = b.id
  left join CP_OWNER c
    on a.SH_OWNER_ID = c.id
  left join OM_LOGISTICS_ORDER_H d
    on a.SH_LOGISTICS_HEADER_ID = d.billid
  left join WM_OUTBOUND_NOTICE_HEADER e
    on e.billid = a.SH_NOTICE_HEADER_ID
  left join WM_SHIP_LINE g
    on a.billid = g.billid
  left join CP_Material f
    on g.SL_MATERIAL_ID = f.id
  left join CP_VENDOR_CUSTOMER o
    on g.SL_LOT_MSTDATA0 = o.id
  left join CP_PartyAProject p
    on g.SL_LOT_MSTDATA1 = p.id   
 where a.SH_OWNER_ID = '113003031'
 group by b.name,
          c.name,
          d.LOH_LOGISTICS_NO,
          e.ONH_NOTICE_NO,
          a.SH_SHIP_NO,
          o.name,
          g.SL_MATERIAL_ID,
          f.code,
          f.name,
          f.MAT_SPEC,
          p.code
) t1
on t.接单机构 = t1.接单机构
and t.项目 = t1.项目
and t.供应商 = t1.供应商
and t.物料编码 = t1.物料编码
and t.物料名称 = t1.物料名称
and t.规格型号 = t1.规格型号)
UNION 
(select t.*,
       t2.收货单号 as 收发货单号,
       t2.最新下单时间 as 下单时间
from
(      select 
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.qt_org_id,
       a.QT_LOT_LOOKUP1,
       b.name AS 接单机构,
       a.qt_owner_id,
       c.name as 项目,
       a.qt_material_id,
       d.code as 物料编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       d.name as 物料名称,
       d.MAT_SPEC as 规格型号,
       d.MAT_CATEGORY_ID,
       d.MAT_UNIT_ID,
       n.name as 单位,
       e.name as 物料大类,
       case
         when e."LEVEL" = 5 then
          e1.name
         else
          e.name
       end as 三级大类,
       e1.id as id20,
       a.qt_onhand_qty as 数量,
       a.qt_lot_number0 as 不含税单价,
       round(a.qt_onhand_qty * a.qt_lot_number0,2) as 合计金额,
       a.qt_lot_mstdata0,
       f.name as 供应商,
       a.qt_lot_string2 as 需求单号,
       a.qt_lot_string3 as 采购订单号,
       a.qt_lot_string4 as 备货订单号,
       a.qt_lot_mstdata1,
       g.code as 甲方项目编码,
       g.name  as 甲方项目名称,
       g.ProjectManager as 项目负责人,
       a.qt_lot_string1 as 安装点,
       d.MSS_Code as 客户物料编码,
       d.MSS_Name as 客户物料名称,
       a.qt_recv_date as 入库时间,
       ROUND(TO_NUMBER(sysdate - a.qt_recv_date), 0) as 在库时间,
       a.qt_lot_mstdata2,
       i.name as 接收子库,
       a.qt_location_id,
       j.name as 储位,
       j.LOC_STOREROOM_ID,
       j.LOC_STOREAREA_ID,
       k.name as 仓间,
       m.name as 库区,
       a.qt_lot_string6 as 备注
  from wm_quant a
  left join CP_ORGANIZATION b
    on a.qt_org_id = b.id
  left join CP_OWNER c
    on a.qt_owner_id = c.id
  left join CP_Material d
    on a.qt_material_id = d.id
  left join CP_MATERIAL_CATEGORY e
    on d.MAT_CATEGORY_ID = e.id
  left join CP_MATERIAL_CATEGORY e1
    on e1.id = e.parentid
  left join CP_VENDOR_CUSTOMER f
    on a.qt_lot_mstdata0 = f.id
  left join CP_PartyAProject g
    on a.qt_lot_mstdata1 = g.id
  left join CP_ReceivingSubsystem i
    on a.qt_lot_mstdata2 = i.id
  left join CP_LOCATION j
    on j.id = a.qt_location_id
  left join CP_STOREROOM k
    on j.LOC_STOREROOM_ID = k.id
  left join CP_STOREAREA m
    on j.LOC_STOREAREA_ID = m.id
  left join CP_LOOKUP_LINE n
    on d.MAT_UNIT_ID = n.id
 where a.qt_owner_id = '113003031'
   and a.qt_onhand_qty != 0
   order by a.qt_onhand_qty * a.qt_lot_number0 desc) t
left join (
select b.name as 接单机构,
       c.name as 项目,
       d.LOH_LOGISTICS_NO,
       e.INH_NOTICE_NO,
       a.RH_RECEIPT_NO as 收货单号,
       max(a.MakeDate) as 最新下单时间,
       g.RL_MATERIAL_ID,
       f.code as 物料编码,
       f.name as 物料名称,
       f.MAT_SPEC as 规格型号,
       o.name as 供应商,
       p.code as code1
  from WM_RECEIPT_HEADER a
  left join CP_ORGANIZATION b
    on a.RH_ORG_ID = b.id
  left join CP_OWNER c
    on a.RH_OWNER_ID = c.id
  left join OM_LOGISTICS_ORDER_H d
    on a.RH_LOGISTICS_HEADER_ID = d.billid
  left join WM_INBOUND_NOTICE_HEADER e
    on e.billid = a.RH_NOTICE_HEADER_ID
  left join WM_RECEIPT_LINE g
    on a.billid = g.billid
  left join CP_Material f
    on g.RL_MATERIAL_ID = f.id
  left join CP_VENDOR_CUSTOMER o
    on g.RL_LOT_MSTDATA0 = o.id
  left join CP_PartyAProject p
    on g.RL_LOT_MSTDATA1 = p.id
 where a.RH_OWNER_ID = '113003031'
 group by b.name,
          c.name,
          d.LOH_LOGISTICS_NO,
          e.INH_NOTICE_NO,
          a.RH_RECEIPT_NO,
          o.name,
          g.RL_MATERIAL_ID,
          f.code,
          f.name,
          f.MAT_SPEC,
          p.code
) t2
on t.接单机构 = t2.接单机构
and t.项目 = t2.项目
and t.供应商 = t2.供应商
and t.物料编码 = t2.物料编码
and t.物料名称 = t2.物料名称
and t.规格型号 = t2.规格型号)
) k
) m
WHERE 
  1=1
 ${if(len(项目名称) == 0,"","and m.项目名称 in（ '" + 项目名称 + "'）")}
 ${if(len(接单机构) == 0,"","and m.接单机构 in（ '" + 接单机构 + "'）")}
 ${if(len(三级大类) == 0,"","and m.三级大类 in（ '" + 三级大类 + "'）")}
 ${if(len(供应商) == 0,"","and m.供应商 in（ '" + 供应商 + "'）")}
 ${if(len(接收子库) == 0,"","and m.接收子库 in（ '" + 接收子库 + "'）")}
 ${if(len(入库时间) == 0,"","and m.入库时间 in（ '" + 入库时间 + "'）")}
 ${if(len(备注) == 0,"","and m.备注 in（ '" + 备注 + "'）")}
 ${if(len(需求单号) == 0,"","and m.需求单号 in（ '" + 需求单号 + "'）")}
 ${if(len(地市) == 0,"","and m.地市 in（ '" + 地市 + "'）")}
 ${if(len(仓库) == 0,"","and m.仓库 in（ '" + 仓库 + "'）")}
 ${if(len(停置天数) == 0,"","and m.停置天数 <（ '" + 停置天数 + "'）")}) n 
left join 
(      select 
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.qt_org_id,
       a.QT_LOT_LOOKUP1,
       b.name AS 接单机构,
       a.qt_owner_id,
       c.name as 项目,
       a.qt_material_id,
       d.code as 物料编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       d.name as 物料名称,
       d.MAT_SPEC as 规格型号,
       d.MAT_CATEGORY_ID,
       d.MAT_UNIT_ID,
       n.name as 单位,
       e.name as 物料大类,
       case
         when e."LEVEL" = 5 then
          e1.name
         else
          e.name
       end as 三级大类,
       e1.id as id20,
       a.qt_onhand_qty as 数量,
       a.qt_lot_number0 as 不含税单价,
       round(a.qt_onhand_qty * a.qt_lot_number0,2) as 合计金额,
       a.qt_lot_mstdata0,
       f.name as 供应商,
       a.qt_lot_string2 as 需求单号,
       a.qt_lot_string3 as 采购订单号,
       a.qt_lot_string4 as 备货订单号,
       a.qt_lot_mstdata1,
       g.code as 甲方项目编码,
       g.name  as 甲方项目名称,
       g.ProjectManager as 项目负责人,
       a.qt_lot_string1 as 安装点,
       d.MSS_Code as 客户物料编码,
       d.MSS_Name as 客户物料名称,
       a.qt_recv_date as 入库时间,
       ROUND(TO_NUMBER(sysdate - a.qt_recv_date), 0) as 在库时间,
       a.qt_lot_mstdata2,
       i.name as 接收子库,
       a.qt_location_id,
       j.name as 储位,
       j.LOC_STOREROOM_ID,
       j.LOC_STOREAREA_ID,
       k.name as 仓间,
       m.name as 库区,
       a.qt_lot_string6 as 备注
  from wm_quant a
  left join CP_ORGANIZATION b
    on a.qt_org_id = b.id
  left join CP_OWNER c
    on a.qt_owner_id = c.id
  left join CP_Material d
    on a.qt_material_id = d.id
  left join CP_MATERIAL_CATEGORY e
    on d.MAT_CATEGORY_ID = e.id
  left join CP_MATERIAL_CATEGORY e1
    on e1.id = e.parentid
  left join CP_VENDOR_CUSTOMER f
    on a.qt_lot_mstdata0 = f.id
  left join CP_PartyAProject g
    on a.qt_lot_mstdata1 = g.id
  left join CP_ReceivingSubsystem i
    on a.qt_lot_mstdata2 = i.id
  left join CP_LOCATION j
    on j.id = a.qt_location_id
  left join CP_STOREROOM k
    on j.LOC_STOREROOM_ID = k.id
  left join CP_STOREAREA m
    on j.LOC_STOREAREA_ID = m.id
  left join CP_LOOKUP_LINE n
    on d.MAT_UNIT_ID = n.id
 where a.qt_owner_id = '113003031'
   and a.qt_onhand_qty != 0
   order by a.qt_onhand_qty * a.qt_lot_number0 desc) t
on n.接单机构 = t.接单机构
and n.接收子库 = t.接收子库
and n.物料编码 = t.物料编码
and n.供应商 = t.供应商

group by t.地市,
       t.仓库,
       n.接单机构,
       t.项目,
       n.物料编码,
       t.二级编码,
       t.物料名称,
       t.规格型号,
       t.单位,
       t.物料大类,
       t.三级大类,
       t.数量,
       t.不含税单价,
       t.合计金额,
       n.供应商,
       t.需求单号,
       t.采购订单号,
       t.备货订单号,
       t.甲方项目编码,
       t.甲方项目名称,
       t.项目负责人,
       t.安装点,
       t.客户物料编码,
       t.客户物料名称,
       t.入库时间,
       t.在库时间,
       n.接收子库,
       t.备注
order by n.供应商,
         n.物料编码

select 地市 from
(select 
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.qt_org_id,
       a.QT_LOT_LOOKUP1,
       b.name AS 接单机构,
       a.qt_owner_id,
       c.name as 项目,
       a.qt_material_id,
       d.code as 物料编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       d.name as 物料名称,
       d.MAT_SPEC as 规格型号,
       d.MAT_CATEGORY_ID,
       d.MAT_UNIT_ID,
       n.name as 单位,
       e.name as 物料大类,
       case
         when e."LEVEL" = 5 then
          e1.name
         else
          e.name
       end as 三级大类,
       e1.id as id20,
       a.qt_onhand_qty as 数量,
       a.qt_lot_number0 as 不含税单价,
       round(a.qt_onhand_qty * a.qt_lot_number0,2) as 合计金额,
       a.qt_lot_mstdata0,
       f.name as 供应商,
       a.qt_lot_string2 as 需求单号,
       a.qt_lot_string3 as 采购订单号,
       a.qt_lot_string4 as 备货订单号,
       a.qt_lot_mstdata1,
       g.code as 甲方项目编码,
       g.name  as 甲方项目名称,
       g.ProjectManager as 项目负责人,
       a.qt_lot_string1 as 安装点,
       d.MSS_Code as 客户物料编码,
       d.MSS_Name as 客户物料名称,
       a.qt_recv_date as 入库时间,
       ROUND(TO_NUMBER(sysdate - a.qt_recv_date), 0) as 在库时间,
       a.qt_lot_mstdata2,
       i.name as 接收子库,
       a.qt_location_id,
       j.name as 储位,
       j.LOC_STOREROOM_ID,
       j.LOC_STOREAREA_ID,
       k.name as 仓间,
       m.name as 库区,
       a.qt_lot_string6 as 备注
  from wm_quant a
  left join CP_ORGANIZATION b
    on a.qt_org_id = b.id
  left join CP_OWNER c
    on a.qt_owner_id = c.id
  left join CP_Material d
    on a.qt_material_id = d.id
  left join CP_MATERIAL_CATEGORY e
    on d.MAT_CATEGORY_ID = e.id
  left join CP_MATERIAL_CATEGORY e1
    on e1.id = e.parentid
  left join CP_VENDOR_CUSTOMER f
    on a.qt_lot_mstdata0 = f.id
  left join CP_PartyAProject g
    on a.qt_lot_mstdata1 = g.id
  left join CP_ReceivingSubsystem i
    on a.qt_lot_mstdata2 = i.id
  left join CP_LOCATION j
    on j.id = a.qt_location_id
  left join CP_STOREROOM k
    on j.LOC_STOREROOM_ID = k.id
  left join CP_STOREAREA m
    on j.LOC_STOREAREA_ID = m.id
  left join CP_LOOKUP_LINE n
    on d.MAT_UNIT_ID = n.id
 where a.qt_owner_id = '113003031'
   and a.qt_onhand_qty != 0
   order by a.qt_onhand_qty * a.qt_lot_number0 desc)

select 仓库 from 
(select 
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.qt_org_id,
       a.QT_LOT_LOOKUP1,
       b.name AS 接单机构,
       a.qt_owner_id,
       c.name as 项目,
       a.qt_material_id,
       d.code as 物料编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       d.name as 物料名称,
       d.MAT_SPEC as 规格型号,
       d.MAT_CATEGORY_ID,
       d.MAT_UNIT_ID,
       n.name as 单位,
       e.name as 物料大类,
       case
         when e."LEVEL" = 5 then
          e1.name
         else
          e.name
       end as 三级大类,
       e1.id as id20,
       a.qt_onhand_qty as 数量,
       a.qt_lot_number0 as 不含税单价,
       round(a.qt_onhand_qty * a.qt_lot_number0,2) as 合计金额,
       a.qt_lot_mstdata0,
       f.name as 供应商,
       a.qt_lot_string2 as 需求单号,
       a.qt_lot_string3 as 采购订单号,
       a.qt_lot_string4 as 备货订单号,
       a.qt_lot_mstdata1,
       g.code as 甲方项目编码,
       g.name  as 甲方项目名称,
       g.ProjectManager as 项目负责人,
       a.qt_lot_string1 as 安装点,
       d.MSS_Code as 客户物料编码,
       d.MSS_Name as 客户物料名称,
       a.qt_recv_date as 入库时间,
       ROUND(TO_NUMBER(sysdate - a.qt_recv_date), 0) as 在库时间,
       a.qt_lot_mstdata2,
       i.name as 接收子库,
       a.qt_location_id,
       j.name as 储位,
       j.LOC_STOREROOM_ID,
       j.LOC_STOREAREA_ID,
       k.name as 仓间,
       m.name as 库区,
       a.qt_lot_string6 as 备注
  from wm_quant a
  left join CP_ORGANIZATION b
    on a.qt_org_id = b.id
  left join CP_OWNER c
    on a.qt_owner_id = c.id
  left join CP_Material d
    on a.qt_material_id = d.id
  left join CP_MATERIAL_CATEGORY e
    on d.MAT_CATEGORY_ID = e.id
  left join CP_MATERIAL_CATEGORY e1
    on e1.id = e.parentid
  left join CP_VENDOR_CUSTOMER f
    on a.qt_lot_mstdata0 = f.id
  left join CP_PartyAProject g
    on a.qt_lot_mstdata1 = g.id
  left join CP_ReceivingSubsystem i
    on a.qt_lot_mstdata2 = i.id
  left join CP_LOCATION j
    on j.id = a.qt_location_id
  left join CP_STOREROOM k
    on j.LOC_STOREROOM_ID = k.id
  left join CP_STOREAREA m
    on j.LOC_STOREAREA_ID = m.id
  left join CP_LOOKUP_LINE n
    on d.MAT_UNIT_ID = n.id
 where a.qt_owner_id = '113003031'
   and a.qt_onhand_qty != 0
   order by a.qt_onhand_qty * a.qt_lot_number0 desc)
WHERE 1=1 
 ${if(len(地市) == 0,"","and 地市 in（ '" + 地市 + "'）")}

select 三级大类 from 
(select 
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.qt_org_id,
       a.QT_LOT_LOOKUP1,
       b.name AS 接单机构,
       a.qt_owner_id,
       c.name as 项目,
       a.qt_material_id,
       d.code as 物料编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       d.name as 物料名称,
       d.MAT_SPEC as 规格型号,
       d.MAT_CATEGORY_ID,
       d.MAT_UNIT_ID,
       n.name as 单位,
       e.name as 物料大类,
       case
         when e."LEVEL" = 5 then
          e1.name
         else
          e.name
       end as 三级大类,
       e1.id as id20,
       a.qt_onhand_qty as 数量,
       a.qt_lot_number0 as 不含税单价,
       round(a.qt_onhand_qty * a.qt_lot_number0,2) as 合计金额,
       a.qt_lot_mstdata0,
       f.name as 供应商,
       a.qt_lot_string2 as 需求单号,
       a.qt_lot_string3 as 采购订单号,
       a.qt_lot_string4 as 备货订单号,
       a.qt_lot_mstdata1,
       g.code as 甲方项目编码,
       g.name  as 甲方项目名称,
       g.ProjectManager as 项目负责人,
       a.qt_lot_string1 as 安装点,
       d.MSS_Code as 客户物料编码,
       d.MSS_Name as 客户物料名称,
       a.qt_recv_date as 入库时间,
       ROUND(TO_NUMBER(sysdate - a.qt_recv_date), 0) as 在库时间,
       a.qt_lot_mstdata2,
       i.name as 接收子库,
       a.qt_location_id,
       j.name as 储位,
       j.LOC_STOREROOM_ID,
       j.LOC_STOREAREA_ID,
       k.name as 仓间,
       m.name as 库区,
       a.qt_lot_string6 as 备注
  from wm_quant a
  left join CP_ORGANIZATION b
    on a.qt_org_id = b.id
  left join CP_OWNER c
    on a.qt_owner_id = c.id
  left join CP_Material d
    on a.qt_material_id = d.id
  left join CP_MATERIAL_CATEGORY e
    on d.MAT_CATEGORY_ID = e.id
  left join CP_MATERIAL_CATEGORY e1
    on e1.id = e.parentid
  left join CP_VENDOR_CUSTOMER f
    on a.qt_lot_mstdata0 = f.id
  left join CP_PartyAProject g
    on a.qt_lot_mstdata1 = g.id
  left join CP_ReceivingSubsystem i
    on a.qt_lot_mstdata2 = i.id
  left join CP_LOCATION j
    on j.id = a.qt_location_id
  left join CP_STOREROOM k
    on j.LOC_STOREROOM_ID = k.id
  left join CP_STOREAREA m
    on j.LOC_STOREAREA_ID = m.id
  left join CP_LOOKUP_LINE n
    on d.MAT_UNIT_ID = n.id
 where a.qt_owner_id = '113003031'
   and a.qt_onhand_qty != 0
   order by a.qt_onhand_qty * a.qt_lot_number0 desc)
WHERE 1=1 
 ${if(len(仓库) == 0,"","and 仓库 in（ '" + 仓库 + "'）")}
 ${if(len(地市) == 0,"","and 地市 in（ '" + 地市 + "'）")}

