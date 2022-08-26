/*select area,
       round(avg(spts),2) as spts, --审批天数
       round(avg(mats),2) as mats, --发ma天数
       round(avg(sjts),2) as sjts, --上架天数
       round(avg(spts),2) + round(avg(mats),2) + round(avg(sjts),2) as thzq --退货周期
  from (select zro.brancode  as  area,
               trunc(csr.creation_date) as creation_date, --申请日期
               trunc(csr.approve_date) as approve_date, --审批日期
               trunc(csr.ma_creation_date) as ma_date, --已发ma日期
               trunc(ship.receive_date) as receive_date, --入库日期
               nvl(trunc(csr.approve_date) - trunc(csr.creation_date), 0) as spts, --审批天数
               nvl(trunc(csr.ma_creation_date) - trunc(csr.approve_date), 0) as mats, --发ma天数
               nvl(trunc(ship.receive_date) - trunc(csr.ma_creation_date), 0) as sjts, --上架天数
               csr.rtw_no, --单据号
               csr.ref_no, --细单号
               ship.shipment, --配送单号1
               csr.old_ref_no, --原单号
               csr.pos_no --pos退单号
          from cmx_store_rtw csr,
               (select shipsku.shipment,
                       cmx_shipsku_lot.item,
                       cmx_shipsku_lot.lot,
                       cmx_shipsku_lot.qty_received,
                       shipment.ship_date,
                       shipment.receive_date,
                       shipsku.distro_no
                  from shipment, shipsku, cmx_shipsku_lot
                 where shipsku.shipment = shipment.shipment
                   and shipsku.shipment = cmx_shipsku_lot.shipment
                   and shipsku.item = cmx_shipsku_lot.item
                   and shipsku.seq_no = cmx_shipsku_lot.seq_no
                   and shipment.ship_date between date'${start_date}' and date'${end_date}'
                   ) ship,
                  store s,
                  zux_region_ou zro
         where 1=1
           and csr.ref_no = ship.distro_no
           and csr.item = ship.item
           and csr.lot = ship.lot
           and csr.store = s.store
           and s.org_unit_id = zro.org_unit_id
           ${if(len(AREA)=0,""," and zro.brancode in ('"+AREA+"')")}           
           )
         where 1=1

 group by area
 */
 select area,
       round(avg(spts),1) as spts, --审批天数
       round(avg(mats),1) as mats, --发ma天数
       round(avg(sjts),1) as sjts, --上架天数
       round(avg(spts),1) + round(avg(mats),1) + round(avg(sjts),1) as thzq --退货周期
  from (select zro.brancode as area,
       trunc(csr.creation_date) as creation_date, --申请日期
       trunc(csr.approve_date) as approve_date, --审批日期
       trunc(csr.ma_creation_date) as ma_date, --已发ma日期
       trunc(shipment.receive_date) as receive_date, --入库日期
       nvl(trunc(csr.approve_date) - trunc(csr.creation_date), 0) as spts, --审批天数
       nvl(trunc(csr.ma_creation_date) - trunc(csr.approve_date), 0) as mats, --发ma天数
       nvl(trunc(shipment.receive_date) - trunc(csr.ma_creation_date), 0) as sjts, --上架天数
       csr.rtw_no, --单据号
       csr.ref_no, --细单号
       shipment.shipment, --配送单号1
       csr.old_ref_no, --原单号
       csr.pos_no --pos退单号
  from cmx_store_rtw   csr,
       shipment,
       shipsku,
       cmx_shipsku_lot,
       store           s,
       zux_region_ou   zro
 where csr.ref_no = shipsku.distro_no
   and csr.item = shipsku.item
   and csr.lot = cmx_shipsku_lot.lot
   and csr.store = s.store
   and s.org_unit_id = zro.org_unit_id
   and shipsku.shipment = shipment.shipment
   and shipment.shipment = cmx_shipsku_lot.shipment
   and shipsku.item = cmx_shipsku_lot.item
   and shipsku.seq_no = cmx_shipsku_lot.seq_no
   and shipment.ship_date between date'${start_date}' and date'${end_date}'
   ${if(len(AREA)=0,""," and zro.brancode in ('"+AREA+"')")}
        )
 group by area

select area,
       round(avg(spts),1) as spts, --审批天数
       round(avg(mats),1) as mats, --发MA天数
       round(avg(sjts),1) as sjts, --上架天数
       round(avg(spts),1) + round(avg(mats),1) + round(avg(sjts),1) as thzq --退货周期
  from (select o.brancode as area,
               trunc(tsfhead.create_date) approve_date, --审批时间
               trunc(cmx_area_return_head.creation_date) creation_date, --申请日期
               trunc(shipment.ship_date) ship_date, --出库日期
               trunc(shipment.receive_date) receive_date, --入库日期
               nvl(trunc(tsfhead.create_date) -trunc(cmx_area_return_head.creation_date), 0) as spts,
               nvl(trunc(shipment.ship_date) - trunc(tsfhead.create_date), 0) as mats,
               nvl(trunc(shipment.receive_date) - trunc(shipment.ship_date),0) as sjts,
               cmx_area_return_head.return_no
          from tsfhead,
               cmx_area_return_head,
               shipment,
               shipsku,
               cmx_tsfhead,
               org_unit,
               wh,
               zux_region_ou o
         where cmx_tsfhead.ref_source = 'AR_REQ'
           and cmx_tsfhead.ref_no = cmx_area_return_head.return_no
           and cmx_area_return_head.tsf_no = cmx_tsfhead.tsf_no
           and cmx_tsfhead.tsf_no = tsfhead.tsf_no
           and cmx_tsfhead.tsf_no = shipsku.distro_no
           and shipsku.shipment = shipment.shipment
           and cmx_area_return_head.source_wh = wh.wh
           and wh.org_unit_id = org_unit.org_unit_id
           and org_unit.org_unit_id = o.org_unit_id
           and cmx_area_return_head.target_wh = '10001'
           and shipment.ship_date between date'${start_date}' and date'${end_date}'
           ${if(len(AREA)=0,""," and o.brancode in ('"+AREA+"')")}           
           )
  group by area

