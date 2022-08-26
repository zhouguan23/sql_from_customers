with ddio as
 (select *
    from dm_delivery_in_out
   where sale_date between date'${start_date}' and date'${end_date}'
   ${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
   ),
dpio as
 (select *
    from dm_purchase_in_out
   where order_date between date'${start_date}' and date'${end_date}'
      ${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
   ),
t1 as
 (select count(decode(p_type, '配送', 1, null)) as 配送出库笔数,
         count(decode(p_type, '退货', 1, null)) as 退货入库笔数,
         area_code
    from ddio
   group by area_code),
t2 as
 (select count(decode(p_type, '采进', 1, null)) as 采购进货入库笔数,
         count(decode(p_type, '采退', 1, null)) as 采购退货出库笔数,
         area_code
    from dpio
   group by area_code),
t3 as
 (select sum(decode(p_type, '配送', d_number, 0)) as 配送出库件数,
         sum(decode(p_type, '退货', d_number, 0)) as 退货入库件数,
         sum(decode(p_type, '配送', no_tax_cost, 0)) as 配送出库成本金额,
         sum(decode(p_type, '退货', no_tax_cost, 0)) as 退货入库成本金额,
         area_code
    from ddio
   group by area_code),
t4 as
 (select sum(decode(p_type, '采进', d_number, 0)) as 采购进货入库件数,
         sum(decode(p_type, '采退', d_number, 0)) as 采购退货出库件数,
         sum(decode(p_type, '采进', no_tax_cost, 0)) as 采购进货入库库成本,
         sum(decode(p_type, '采退', abs(no_tax_cost), 0)) as 采购退货出库成本,
         area_code
    from dpio
   group by area_code)
select t1.area_code,
       t1.配送出库笔数,
       t1.退货入库笔数,
       t2.采购进货入库笔数,
       t2.采购退货出库笔数,
       t3.配送出库件数,
       t3.退货入库件数,
       t4.采购进货入库件数,
       t4.采购退货出库件数,
       t3.配送出库成本金额,
       t3.退货入库成本金额,
       t4.采购进货入库库成本,
       采购退货出库成本
  from t1, t2, t3, t4
 where t1.area_code = t2.area_code(+)
   and t1.area_code = t3.area_code(+)
   and t1.area_code = t4.area_code(+)


with ddio as
 (select *
    from dm_delivery_in_out
   where sale_date between date'${start_date}' and date'${end_date}'
      ${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
   ),
dpio as
 (select *
    from dm_purchase_in_out
   where order_date between date'${start_date}' and date'${end_date}'
      ${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
   ),
t1 as
 (select count(decode(p_type, '配送', 1, null)) as 配送出库笔数,
         count(decode(p_type, '退货', 1, null)) as 退货入库笔数,
         area_code
    from ddio
   group by area_code),
t2 as
 (select count(decode(p_type, '采进', 1, null)) as 采购进货入库笔数,
         count(decode(p_type, '采退', 1, null)) as 采购退货出库笔数,
         area_code
    from dpio
   group by area_code),
t3 as
 (select sum(decode(p_type, '配送', d_number, 0)) as 配送出库件数,
         sum(decode(p_type, '退货', d_number, 0)) as 退货入库件数,
         sum(decode(p_type, '配送', tax_cost, 0)) as 配送出库成本金额,
         sum(decode(p_type, '退货', tax_cost, 0)) as 退货入库成本金额,
         area_code
    from ddio
   group by area_code),
t4 as
 (select sum(decode(p_type, '采进', d_number, 0)) as 采购进货入库件数,
         sum(decode(p_type, '采退', d_number, 0)) as 采购退货出库件数,
         sum(decode(p_type, '采进', tax_cost, 0)) as 采购进货入库库成本,
         sum(decode(p_type, '采退', abs(tax_cost), 0)) as 采购退货出库成本,
         area_code
    from dpio
   group by area_code)
select t1.area_code,
       t1.配送出库笔数,
       t1.退货入库笔数,
       t2.采购进货入库笔数,
       t2.采购退货出库笔数,
       t3.配送出库件数,
       t3.退货入库件数,
       t4.采购进货入库件数,
       t4.采购退货出库件数,
       t3.配送出库成本金额,
       t3.退货入库成本金额,
       t4.采购进货入库库成本,
       采购退货出库成本
  from t1, t2, t3, t4
 where t1.area_code = t2.area_code(+)
   and t1.area_code = t3.area_code(+)
   and t1.area_code = t4.area_code(+)

