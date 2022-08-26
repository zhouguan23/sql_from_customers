select t.地市,
       t.仓库,
       n.接单机构,
       t.项目,
       n.物料编码,
       t.物料名称,
       t.规格型号,
       t.单位,
       t.物料大类,
       t.三级大类,
       t.待入数量,
       t.待出数量,
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
       t.库区,
       t.储位,
       t.备注
       from (
select k.*,
       case
       when k.下单时间 is not null
       then 
       floor(sysdate-to_date(to_char(k.下单时间,'yyyy-mm-dd'),'yyyy-mm-dd'))
       else k.在库时间
       end as 停置天数
from (
select  t.地市,
        t.仓库,
        t.接单机构,
        t.项目,
        t.物料编码,
        t.物料名称,
        t.规格型号,
        t.单位,
        t.物料大类,
        t.三级大类,
        t.待入数量,
        t.待出数量,
        t.数量,
        t.不含税单价,
        t.合计金额,
        t.供应商,
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
        t.接收子库,
        t.备注,
        t.库区,
        t.储位,
        max(t1.最新下单时间) as 下单时间
        from (
select   p.*,
       case when p.在库时间 >= 0
             and p.在库时间 <= 90 
            then '3个月以内'
            when p.在库时间 >90
             and p.在库时间 <= 180
            then '3个月-6个月'
            when p.在库时间 >180
             and p.在库时间 <= 365
            then '6个月-1年'
            when p.在库时间 >365
             and p.在库时间 <=730
            then '1年-2年'
            when p.在库时间 >730
             and p.在库时间 <=1095
            then '2年-3年'
       else '3年以上' end as 库龄区间,
       e1.name as 物资目录二级,
       e2.name as 三级大类
       from (
select a.WAREHOUSECENTERID,
       a.DictUserDef2,
       b.name as 接单机构,
       case when b.name like '%直属%' then '直属单位'
            when b.name like '%配送中心%' then substr(b.name,1,6)
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%直属%' then b.name
            when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.OwnerId,
       c.name as 项目,
       a.MaterialId,
       d.code as 物料编码,
       d.Spec as 规格型号,
       d.MAT_CATEGORY_ID,
       d.MAT_UNIT_ID,
       n.name as 单位,
       e.name as 物料大类,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,6)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,6)
       else '无' end as 三级编码,
       d.name as 物料名称,
       a.ExpectInQty as 待入数量,
       a.ExpectOutQty as 待出数量,
       a.OnhandQty as 数量,
       a.NumUserDef1 as 不含税单价,
       round(a.OnhandQty * a.NumUserDef1,2) as 合计金额,
       a.DictUserDef3,
       f.name as 供应商,
       a.StrUserDef2 as 需求单号,
       a.StrUserDef3 as 采购订单号,
       a.StrUserDef4 as 备货订单号,
       a.DictUserDef4,
       g.code as 甲方项目编码,
       g.name as 甲方项目名称,
       g.ProjectManager as 项目负责人,
       a.StrUserDef1  as 安装点,
       d.MSS_Code as 客户物料编码,
       d.MSS_Name as 客户物料名称,
       a.RECVDATE as 入库时间,
       a.DateUserDef2 as 分屯库首次入库日期,
       case 
       when to_char(a.DateUserDef2,'yyyy-mm-dd') != '1980-01-01'
       then 
       ROUND(TO_NUMBER(sysdate - a.DateUserDef2), 0)
       when to_char(a.DateUserDef2,'yyyy-mm-dd') = '1980-01-01'
       then 
       ROUND(TO_NUMBER(sysdate - a.RECVDATE), 0)
       end as 在库时间,
       a.DictUserDef5,
       i.name as 接收子库,
       a.LocationId,
       j.name as 储位,
       a.StoreroomId,
       a.StoreareaId,
       k.name as 仓间,
       m.name as 库区,
       a.StrUserDef6 as 备注,
       imp.name as 重点项目分类,
       case when o.name = '是' then '是'
            else '否' end as 共享库
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
  left join LRP_Owner c
    on a.OwnerId = c.oid
  left join LRP_Material d
    on a.MaterialId = d.oid
  left join LRP_MaterialCategory e
    on d.MAT_CATEGORY_ID = e.oid
  left join LRP_VendorCustomer f
    on a.DictUserDef3 = f.oid
  left join LRP_PartyAProject g
    on a.DictUserDef4 = g.oid
  left join ReceivingSubsystem i
    on a.DictUserDef5 = i.oid
  left join LRP_Location j
    on j.oid = a.LocationId
  left join LRP_Storeroom k
    on j.StoreroomId = k.oid
  left join LRP_Storearea m
    on j.StoreareaId = m.oid
  left join lrp_lookup_l n
    on d.MAT_UNIT_ID = n.oid
  left join importanceproject imp
    on imp.oid = a.DictUserDef7
  left join LRP_Lookup_L o 
    on a.DictUserDef2=o.oid
 where a.OwnerId = '113003031'
   and a.OnhandQty != 0
   order by a.OnhandQty * a.NumUserDef1 desc) p
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '3'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e1
    on p.二级编码 = e1.code
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '4'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e2
    on p.三级编码 = e2.code) t
   left join (
       (select a.WarehouseCenterId,
               b.MaterialId, 
               b.SrcDictUserDef3, 
               b.SrcDictUserDef5,
               max(a.RH_RECV_DATETIME) as 最新下单时间
          from LRP_WMTx_H a
          left join LRP_WMTx_L b
            on a.oid = b.soid
         where a.WarehouseCenterId = '113003031' and a.TXTYPECODE = 201
         group by a.WarehouseCenterId,
                  b.MaterialId, 
                  b.SrcDictUserDef3,
                  b.SrcDictUserDef5)
        union
        (select a.WarehouseCenterId,
                b.MaterialId,
                b.DestDictUserDef3 as SrcDictUserDef3,
                b.DestDictUserDef5 as SrcDictUserDef5,
                max(a.RH_RECV_DATETIME) as 最新下单时间
          from LRP_WMTx_H a
          left join LRP_WMTx_L b
            on a.oid = b.soid
         where a.OwnerId = '113003031' and a.TXTYPECODE = 101
         group by a.WarehouseCenterId,
                  b.MaterialId, 
                  b.DestDictUserDef3,
                  b.DestDictUserDef5)
) t1
 on t.WAREHOUSECENTERID = t1.WarehouseCenterId
and t.MaterialId = t1.MaterialId
and t.DictUserDef3 = t1.SrcDictUserDef3
and t.DictUserDef5 = t1.SrcDictUserDef5
group by t.地市,
           t.仓库,
           t.接单机构,
           t.项目,
           t.物料编码,
           t.物料名称,
           t.规格型号,
           t.单位,
           t.物料大类,
           t.三级大类,
           t.待入数量,
           t.待出数量,
           t.数量,
           t.不含税单价,
           t.合计金额,
           t.供应商,
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
           t.接收子库,
           t.库区,
           t.储位,
           t.备注) k
           ) n
       left join 
(select   p.*,
       case when p.在库时间 >= 0
             and p.在库时间 <= 90 
            then '3个月以内'
            when p.在库时间 >90
             and p.在库时间 <= 180
            then '3个月-6个月'
            when p.在库时间 >180
             and p.在库时间 <= 365
            then '6个月-1年'
            when p.在库时间 >365
             and p.在库时间 <=730
            then '1年-2年'
            when p.在库时间 >730
             and p.在库时间 <=1095
            then '2年-3年'
       else '3年以上' end as 库龄区间,
       e1.name as 物资目录二级,
       e2.name as 三级大类
       from (
select a.WAREHOUSECENTERID,
       a.DictUserDef2,
       b.name as 接单机构,
       case when b.name like '%直属%' then '直属单位'
            when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%直属%' then b.name
            when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.OwnerId,
       c.name as 项目,
       a.MaterialId,
       d.code as 物料编码,
       d.Spec as 规格型号,
       d.MAT_CATEGORY_ID,
       d.MAT_UNIT_ID,
       n.name as 单位,
       e.name as 物料大类,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,6)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,6)
       else '无' end as 三级编码,
       d.name as 物料名称,
       a.ExpectInQty as 待入数量,
       a.ExpectOutQty as 待出数量,
       a.OnhandQty as 数量,
       a.NumUserDef1 as 不含税单价,
       round(a.OnhandQty * a.NumUserDef1,2) as 合计金额,
       a.DictUserDef3,
       f.name as 供应商,
       a.StrUserDef2 as 需求单号,
       a.StrUserDef3 as 采购订单号,
       a.StrUserDef4 as 备货订单号,
       a.DictUserDef4,
       g.code as 甲方项目编码,
       g.name as 甲方项目名称,
       g.ProjectManager as 项目负责人,
       a.StrUserDef1  as 安装点,
       d.MSS_Code as 客户物料编码,
       d.MSS_Name as 客户物料名称,
       a.RECVDATE as 入库时间,
       a.DateUserDef2 as 分屯库首次入库日期,
       case 
       when to_char(a.DateUserDef2,'yyyy-mm-dd') != '1980-01-01'
       then 
       ROUND(TO_NUMBER(sysdate - a.DateUserDef2), 0)
       when to_char(a.DateUserDef2,'yyyy-mm-dd') = '1980-01-01'
       then 
       ROUND(TO_NUMBER(sysdate - a.RECVDATE), 0)
       end as 在库时间,
       a.DictUserDef5,
       i.name as 接收子库,
       a.LocationId,
       j.name as 储位,
       a.StoreroomId,
       a.StoreareaId,
       k.name as 仓间,
       m.name as 库区,
       a.StrUserDef6 as 备注,
       imp.name as 重点项目分类,
       case when o.name = '是' then '是'
            else '否' end as 共享库
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
  left join LRP_Owner c
    on a.OwnerId = c.oid
  left join LRP_Material d
    on a.MaterialId = d.oid
  left join LRP_MaterialCategory e
    on d.MAT_CATEGORY_ID = e.oid
  left join LRP_VendorCustomer f
    on a.DictUserDef3 = f.oid
  left join LRP_PartyAProject g
    on a.DictUserDef4 = g.oid
  left join ReceivingSubsystem i
    on a.DictUserDef5 = i.oid
  left join LRP_Location j
    on j.oid = a.LocationId
  left join LRP_Storeroom k
    on j.StoreroomId = k.oid
  left join LRP_Storearea m
    on j.StoreareaId = m.oid
  left join lrp_lookup_l n
    on d.MAT_UNIT_ID = n.oid
  left join importanceproject imp
    on imp.oid = a.DictUserDef7
  left join LRP_Lookup_L o 
    on a.DictUserDef2=o.oid
 where a.OwnerId = '113003031'
   and a.OnhandQty != 0
   order by a.OnhandQty * a.NumUserDef1 desc) p
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '3'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e1
    on p.二级编码 = e1.code
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '4'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e2
    on p.三级编码 = e2.code) t
on n.接单机构 = t.接单机构
and n.物料编码 = t.物料编码
and n.供应商 = t.供应商
and n.接收子库 = t.接收子库
 WHERE 1=1
 ${if(len(项目) == 0,"","and t.项目 in（ '" + 项目 + "'）")}
 ${if(len(接单机构) == 0,"","and n.接单机构 in（ '" + 接单机构 + "'）")}
 ${if(len(三级大类) == 0,"","and t.三级大类 in（ '" + 三级大类 + "'）")}
 ${if(len(供应商) == 0,"","and t.供应商 in（ '" + 供应商 + "'）")}
 ${if(len(接收子库) == 0,"","and t.接收子库 in（ '" + 接收子库 + "'）")}
 ${if(len(入库时间) == 0,"","and t.入库时间 in（ '" + 入库时间 + "'）")}
 ${if(len(备注) == 0,"","and t.备注 in（ '" + 备注 + "'）")}
 ${if(len(需求单号) == 0,"","and t.需求单号 in（ '" + 需求单号 + "'）")}
 ${if(len(地市) == 0,"","and t.地市 in（ '" + 地市 + "'）")}
 ${if(len(仓库) == 0,"","and t.仓库 in（ '" + 仓库 + "'）")}
 ${if(len(停置天数) == 0,"","and n.停置天数 <（ '" + 停置天数 + "'）")}
 group by t.地市,
          t.仓库,
          n.接单机构,
          t.项目,
          n.物料编码,
          t.物料名称,
          t.规格型号,
          t.单位,
          t.物料大类,
          t.三级大类,
          t.待入数量,
          t.待出数量,
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
          t.库区,
          t.储位,
          t.备注
order by n.供应商,
         n.物料编码

select distinct 供应商 from
(select
       p.地市,
       p.仓库,
       p.供应商,
       e2.name as 三级大类
       from (
select a.WAREHOUSECENTERID,
       b.name as 接单机构,
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,6)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,6)
       else '无' end as 三级编码,
       f.name as 供应商
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
  left join LRP_Material d
    on a.MaterialId = d.oid
  left join LRP_VendorCustomer f
    on a.DictUserDef3 = f.oid
 where a.OwnerId = '113003031'
   and a.OnhandQty != 0
   order by a.OnhandQty * a.NumUserDef1 desc) p
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '3'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e1
    on p.二级编码 = e1.code
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '4'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e2
    on p.三级编码 = e2.code)
WHERE 1=1 
 ${if(len(仓库) == 0,"","and 仓库 in（ '" + 仓库 + "'）")}
 ${if(len(地市) == 0,"","and 地市 in（ '" + 地市 + "'）")}
 ${if(len(三级大类) == 0,"","and 三级大类 in（ '" + 三级大类 + "'）")}

select distinct 三级大类 from 
(select
       p.地市,
       p.仓库,
       e2.name as 三级大类
       from (
select a.WAREHOUSECENTERID,
       b.name as 接单机构,
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,6)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,6)
       else '无' end as 三级编码
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
  left join LRP_Material d
    on a.MaterialId = d.oid
 where a.OwnerId = '113003031'
   and a.OnhandQty != 0
   order by a.OnhandQty * a.NumUserDef1 desc) p
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '3'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e1
    on p.二级编码 = e1.code
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '4'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e2
    on p.三级编码 = e2.code)
WHERE 1=1 
 ${if(len(仓库) == 0,"","and 仓库 in（ '" + 仓库 + "'）")}
 ${if(len(地市) == 0,"","and 地市 in（ '" + 地市 + "'）")}

select distinct 接收子库 from
(select
       p.地市,
       p.仓库,
       p.供应商,
       p.接收子库,
       e2.name as 三级大类
       from (
select a.WAREHOUSECENTERID,
       b.name as 接单机构,
       case when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       case when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       case when d.code like 'GD.ZB%' then substr(d.code,6,4)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,4)
       else '无' end as 二级编码,
       case when d.code like 'GD.ZB%' then substr(d.code,6,6)
            when d.code like 'GD.J%' or d.code like 'GD.L%' 
            then substr(d.code,5,6)
       else '无' end as 三级编码,
       f.name as 供应商,
       a.DictUserDef5,
       i.name as 接收子库
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
  left join LRP_Material d
    on a.MaterialId = d.oid
  left join LRP_VendorCustomer f
    on a.DictUserDef3 = f.oid
  left join ReceivingSubsystem i
    on a.DictUserDef5 = i.oid
 where a.OwnerId = '113003031'
   and a.OnhandQty != 0
   order by a.OnhandQty * a.NumUserDef1 desc) p
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '3'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e1
    on p.二级编码 = e1.code
  left join (
   select t.oid, t.NAME, t.CODE
   from LRP_MaterialCategory t
   where level = '4'
   start with t.oid = '22470'
   connect by prior t.oid = t.PARENTID) e2
    on p.三级编码 = e2.code)
WHERE 1=1 
 ${if(len(仓库) == 0,"","and 仓库 in（ '" + 仓库 + "'）")}
 ${if(len(地市) == 0,"","and 地市 in（ '" + 地市 + "'）")}
 ${if(len(三级大类) == 0,"","and 三级大类 in（ '" + 三级大类 + "'）")}
 ${if(len(供应商) == 0,"","and 供应商 in（ '" + 供应商+ "'）")}

select distinct 地市 from 
(select 
       case when b.name like '%直属%' then '直属单位'
            when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市,
       a.WAREHOUSECENTERID,
       b.name as 接单机构
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
 where a.OwnerId = '113003031'
)
order by decode(地市,'广州配送中心',1,'深圳配送中心',2,'茂名配送中心',3,'汕头配送中心',4,'深圳',5,'广州',6,'东莞',7,'佛山',8,'中山',9,'惠州',10,'江门',11,'汕头',12,'珠海',13,'湛江',14,'茂名',15,'揭阳',16,'肇庆',17,'清远',18,'梅州',19,'潮州',20,'韶关',21,'河源',22,'汕尾',23,'阳江',24,'云浮',25)

select distinct 仓库 from 
(select
       case when b.name like '%直属%' then '直属单位'
            when b.name like '%配送中心%' then substr(b.name,1,6) 
            else substr(b.name,1,2) end as 地市, 
       case when b.name like '%直属%' then b.name
            when b.name like '%配送中心%' then substr(b.name,7,12) 
            else substr(b.name,6,14) end as 仓库,
       a.WAREHOUSECENTERID,
       b.name as 接单机构
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
 where a.OwnerId = '113003031')
WHERE 1=1 
 ${if(len(地市) == 0,"","and 地市 in（ '" + 地市 + "'）")}

select t.接单机构,
       t.项目,
       t.供应商,
       t.物料编码,
       t.物料名称,
       t.规格型号,
       t.接收子库,
       t.项目负责人,
       sum(t.数量) as 汇总数量 from
(select 
       a.WAREHOUSECENTERID,
       a.DictUserDef2,
       b.name as 接单机构,
       a.OwnerId,
       c.name as 项目,
       a.MaterialId,
       d.code as 物料编码,
       d.name as 物料名称,
       d.Spec as 规格型号,
       a.OnhandQty as 数量,
       a.DictUserDef3,
       f.name as 供应商,
       a.DictUserDef4,
       g.ProjectManager as 项目负责人,
       a.DictUserDef5,
       i.name as 接收子库
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
  left join LRP_Owner c
    on a.OwnerId = c.oid
  left join LRP_Material d
    on a.MaterialId = d.oid
  left join LRP_VendorCustomer f
    on a.DictUserDef3 = f.oid
  left join LRP_PartyAProject g
    on a.DictUserDef4 = g.oid
  left join ReceivingSubsystem i
    on a.DictUserDef5 = i.oid
 where a.OwnerId = '113003031'
   and a.OnhandQty != 0) t
     group by t.接单机构,
              t.项目,
              t.供应商,
              t.物料编码,
              t.物料名称,
              t.规格型号,
              t.接收子库,
              t.项目负责人
     order by 物料编码,供应商

