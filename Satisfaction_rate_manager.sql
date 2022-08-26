with a as
 (
  --区域要货
  select buyer,
          case when real_qty/approved_qty>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head               cwrh,
          cmx_wh_req_detail             cwrd,
          dim_net_catalogue_general_all dcga,
          dim_storage                   ds,
          zux_region_ou                 zro
   where cwrh.req_no = cwrd.req_no
     and cwrh.from_wh = '10001'
     and cwrh.to_wh = ds.storage_code
     and cwrd.item = dcga.goods_code
     --and ds.area_code = zro.region
     and ds.org_unit_id = zro.org_unit_id 
     and zro.brancode = dcga.area_code
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),1)= dcga.create_month
     and nvl(approved_qty, 0) > 0
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     AND cwrh.ma_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and  get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),3)= dncg.create_month  and  zro.brancode=dncg.area_code)
  union all
 --外部客户配送
  select  buyer,
          case when real_qty/quantity>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.approve_date) 审批日期
    from  cmx_wf_order_head             cwrh,
          cmx_wf_order_detail           cwrd,
          dim_net_catalogue_general_all dcga， 
          dim_wf_cus   dwc
   where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dcga.area_code
     and cwrd.item = dcga.goods_code
     and quantity > 0
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and  get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),3)= dncg.create_month  and  dwc.area_code=dncg.area_code)
)     
select c.num / b.num 满足率, b.审批日期, b.buyer
  from (select count(满足率) num, to_char(审批日期, 'mm/dd') 审批日期, buyer
          from a
         group by buyer, to_char(审批日期, 'mm/dd')) b,
       (select count(满足率) num, to_char(审批日期, 'mm/dd') 审批日期, buyer
          from a
         where 满足率 = 'Y'
         group by buyer, to_char(审批日期, 'mm/dd')) c
 where b.审批日期 = c.审批日期
   and b.buyer = c.buyer

select distinct buyer from dim_net_catalogue_general_all

select to_char(ddate, 'mm/dd') ddate,to_char(ddate,'yyyy-mm-dd') ydate
  from DIM_DAY
 where ddate >= trunc(to_date('${month}' || '01', 'yyyy-mm-dd'), 'mm')
   AND ddate <
       trunc(add_months(to_date('${month}' || '01', 'yyyy-mm-dd'), 1), 'mm')

with a as
 (
  --区域要货
  select  
          case when real_qty/approved_qty>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head               cwrh,
          cmx_wh_req_detail             cwrd,
          dim_net_catalogue_general_all dcga,
          dim_storage                   ds,
          zux_region_ou                 zro
   where cwrh.req_no = cwrd.req_no
     and cwrh.from_wh = '10001'
     and cwrh.to_wh = ds.storage_code
     and cwrd.item = dcga.goods_code
     --and ds.area_code = zro.region
     and ds.org_unit_id = zro.org_unit_id 
     and zro.brancode = dcga.area_code
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),1)= dcga.create_month
     and nvl(approved_qty, 0) > 0
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     AND cwrh.ma_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
          and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),3)= dncg.create_month  and  zro.brancode=dncg.area_code)
  union all
 --外部客户配送
  select   
          case when real_qty/quantity>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.approve_date) 审批日期
    from  cmx_wf_order_head             cwrh,
          cmx_wf_order_detail           cwrd,
          dim_net_catalogue_general_all dcga， 
          dim_wf_cus   dwc
   where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dcga.area_code
     and cwrd.item = dcga.goods_code
     and quantity > 0
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),3)= dncg.create_month  and  dwc.area_code=dncg.area_code)
)     
select c.num / b.num 满足率, b.审批日期
  from (select count(满足率) num, to_char(审批日期, 'mm/dd') 审批日期
          from a
         group by  to_char(审批日期, 'mm/dd')) b,
       (select count(满足率) num, to_char(审批日期, 'mm/dd') 审批日期
          from a
         where 满足率 = 'Y'
         group by to_char(审批日期, 'mm/dd')) c
 where b.审批日期 = c.审批日期


with a as
 (
  --区域要货
  select buyer,
          case when real_qty/approved_qty>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head               cwrh,
          cmx_wh_req_detail             cwrd,
          dim_net_catalogue_general_all dcga,
          dim_storage                   ds,
          zux_region_ou                 zro
   where cwrh.req_no = cwrd.req_no
     and cwrh.from_wh = '10001'
     and cwrh.to_wh = ds.storage_code
     and cwrd.item = dcga.goods_code
     --and ds.area_code = zro.region
     and ds.org_unit_id = zro.org_unit_id 
     and zro.brancode = dcga.area_code
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),1)= dcga.create_month
     and nvl(approved_qty, 0) > 0
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     AND cwrh.ma_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and  get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),3)= dncg.create_month  and  zro.brancode=dncg.area_code)
  union all
 --外部客户配送
  select  buyer,
          case when real_qty/quantity>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.approve_date) 审批日期
    from  cmx_wf_order_head             cwrh,
          cmx_wf_order_detail           cwrd,
          dim_net_catalogue_general_all dcga， 
          dim_wf_cus   dwc
   where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dcga.area_code
     and cwrd.item = dcga.goods_code
     and quantity > 0
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and  get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),3)= dncg.create_month  and  dwc.area_code=dncg.area_code)
)     
select c.num / b.num 满足率, b.buyer
  from (select count(满足率) num, buyer
          from a
         group by buyer) b,
       (select count(满足率) num, buyer
          from a
         where 满足率 = 'Y'
         group by buyer) c
 where b.buyer = c.buyer

with a as
 (
  --区域要货
  select buyer,
          case when real_qty/approved_qty>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head               cwrh,
          cmx_wh_req_detail             cwrd,
          dim_net_catalogue_general_all dcga,
          dim_storage                   ds,
          zux_region_ou                 zro
   where cwrh.req_no = cwrd.req_no
     and cwrh.from_wh = '10001'
     and cwrh.to_wh = ds.storage_code
     and cwrd.item = dcga.goods_code
     --and ds.area_code = zro.region
     and ds.org_unit_id = zro.org_unit_id 
     and zro.brancode = dcga.area_code
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),1)= dcga.create_month
     and nvl(approved_qty, 0) > 0
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     AND cwrh.ma_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and  get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),3)= dncg.create_month  and  zro.brancode=dncg.area_code)
  union all
 --外部客户配送
  select  buyer,
          case when real_qty/quantity>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.approve_date) 审批日期
    from  cmx_wf_order_head             cwrh,
          cmx_wf_order_detail           cwrd,
          dim_net_catalogue_general_all dcga， 
          dim_wf_cus   dwc
   where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dcga.area_code
     and cwrd.item = dcga.goods_code
     and quantity > 0
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and  get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),3)= dncg.create_month  and  dwc.area_code=dncg.area_code)
)     
select c.num / b.num 满足率
  from (select count(满足率) num
          from a) b,
       (select count(满足率) num
          from a
         where 满足率 = 'Y') c
where b.num > 0
  and c.num > 0

