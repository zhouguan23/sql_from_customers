with a as
 (
  --区域要货
  select dr.union_area_name,
          case when real_qty/approved_qty>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head   cwrh,
          cmx_wh_req_detail cwrd,
          dim_storage       ds,
          zux_region_ou     zro,
          dim_region        dr,
          dim_net_catalogue_general_all dcga
   where cwrh.req_no = cwrd.req_no
     and cwrh.from_wh = '10001'
     and cwrh.to_wh = ds.storage_code
     -- and ds.area_code = zro.region
     and ds.org_unit_id = zro.org_unit_id 
     and zro.brancode = dr.area_code
     and nvl(approved_qty, 0) > 0
     and cwrd.item = dcga.goods_code
     and zro.brancode = dcga.area_code
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.ma_date,-1), 'yyyy-mm') = dcga.create_month
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     ${if(len(AREA)=0,""," and dr.union_area_name in ('"+AREA+"')")}
     AND cwrh.ma_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     --and to_char(add_months(cwrh.ma_date,-1), 'yyyy-mm') = dncg.create_month  
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),3) = dncg.create_month
     and  zro.brancode=dncg.area_code)
  union all
  --外部客户配送
 select dr.union_area_name,
        case when real_qty/quantity>=0.85 then 'Y' else 'N' end  满足率,
        trunc(cwrh.approve_date) 审批日期
   from cmx_wf_order_head   cwrh,
        cmx_wf_order_detail cwrd,
        dim_net_catalogue_general_all dcga， 
        dim_wf_cus          dwc,
        dim_region          dr
  where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dr.area_code
     and cwrd.item = dcga.goods_code
     and dwc.area_code = dcga.area_code
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.approve_date,-1), 'yyyy-mm')  = dcga.create_month
     and quantity > 0
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     ${if(len(AREA)=0,""," and dr.union_area_name in ('"+AREA+"')")}
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),3) = dncg.create_month  and  dwc.area_code=dncg.area_code)
) 
 select c.num / b.num 满足率, b.审批日期, b.union_area_name
   from (select count(满足率) num,
                to_char(审批日期, 'mm/dd') 审批日期,
                union_area_name
           from a
          group by union_area_name, to_char(审批日期, 'mm/dd')) b,
        (select count(满足率) num,
                to_char(审批日期, 'mm/dd') 审批日期,
                union_area_name
           from a
          where 满足率 = 'Y'
          group by union_area_name, to_char(审批日期, 'mm/dd')) c
  where b.审批日期 = c.审批日期
    and b.union_area_name = c.union_area_name

select to_char(ddate, 'mm/dd') ddate,to_char(ddate,'yyyy-mm-dd') ydate
  from DIM_DAY
 where ddate >= trunc(to_date('${month}' || '01', 'yyyy-mm-dd'), 'mm')
   AND ddate <
       trunc(add_months(to_date('${month}' || '01', 'yyyy-mm-dd'), 1), 'mm')

 select distinct union_area_name ,area_code from dim_region 
 where area_code<>'00'
 ${if(len(AREA)=0,""," and union_area_name in ('"+AREA+"')")}
 order by 2

with a as
 (
  --区域要货
  select  
          case when real_qty/approved_qty>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head   cwrh,
          cmx_wh_req_detail cwrd,
          dim_storage       ds,
          zux_region_ou     zro,
          dim_region        dr,
          dim_net_catalogue_general_all dcga
   where cwrh.req_no = cwrd.req_no
     and cwrh.from_wh = '10001'
     and cwrh.to_wh = ds.storage_code
     --and ds.area_code = zro.region
     and ds.org_unit_id = zro.org_unit_id 
     and zro.brancode = dr.area_code
     and nvl(approved_qty, 0) > 0
     and cwrd.item = dcga.goods_code
     and zro.brancode = dcga.area_code
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),1)= dcga.create_month
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     ${if(len(AREA)=0,""," and dr.union_area_name in ('"+AREA+"')")}
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
   from cmx_wf_order_head   cwrh,
        cmx_wf_order_detail cwrd,
        dim_net_catalogue_general_all dcga， 
        dim_wf_cus          dwc,
        dim_region          dr
  where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dr.area_code
     and cwrd.item = dcga.goods_code
     and dwc.area_code = dcga.area_code
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1) = dcga.create_month
     and quantity > 0
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     ${if(len(AREA)=0,""," and dr.union_area_name in ('"+AREA+"')")}
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),3) = dncg.create_month and  dwc.area_code=dncg.area_code)
) 
 select c.num / b.num 满足率, b.审批日期 
   from (select count(满足率) num,
                to_char(审批日期, 'mm/dd') 审批日期
           from a
          group by to_char(审批日期, 'mm/dd')) b,
        (select count(满足率) num,
                to_char(审批日期, 'mm/dd') 审批日期
           from a
          where 满足率 = 'Y'
          group by  to_char(审批日期, 'mm/dd')) c
  where b.审批日期 = c.审批日期

with a as
 (
  --区域要货
  select dr.union_area_name,
          case when real_qty/approved_qty>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head   cwrh,
          cmx_wh_req_detail cwrd,
          dim_storage       ds,
          zux_region_ou     zro,
          dim_region        dr,
          dim_net_catalogue_general_all dcga
   where cwrh.req_no = cwrd.req_no
     and cwrh.from_wh = '10001'
     and cwrh.to_wh = ds.storage_code
     --and ds.area_code = zro.region
     and ds.org_unit_id = zro.org_unit_id 
     and zro.brancode = dr.area_code
     and nvl(approved_qty, 0) > 0
     and cwrd.item = dcga.goods_code
     and zro.brancode = dcga.area_code
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.ma_date,-1), 'yyyy-mm') = dcga.create_month
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     ${if(len(AREA)=0,""," and dr.union_area_name in ('"+AREA+"')")}
     AND cwrh.ma_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     --and to_char(add_months(cwrh.ma_date,-1), 'yyyy-mm') = dncg.create_month  
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),3) = dncg.create_month
     and  zro.brancode=dncg.area_code)
  union all
  --外部客户配送
 select dr.union_area_name,
        case when real_qty/quantity>=0.85 then 'Y' else 'N' end  满足率,
        trunc(cwrh.approve_date) 审批日期
   from cmx_wf_order_head   cwrh,
        cmx_wf_order_detail cwrd,
        dim_net_catalogue_general_all dcga， 
        dim_wf_cus          dwc,
        dim_region          dr
  where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dr.area_code
     and cwrd.item = dcga.goods_code
     and dwc.area_code = dcga.area_code
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.approve_date,-1), 'yyyy-mm')  = dcga.create_month
     and quantity > 0
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     ${if(len(AREA)=0,""," and dr.union_area_name in ('"+AREA+"')")}
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),3) = dncg.create_month  and  dwc.area_code=dncg.area_code)
) 
 select c.num / b.num 满足率,  b.union_area_name
   from (select count(满足率) num,
                union_area_name
           from a
          group by union_area_name) b,
        (select count(满足率) num,
                union_area_name
           from a
          where 满足率 = 'Y'
          group by union_area_name ) c
  where b.union_area_name = c.union_area_name

with a as
 (
  --区域要货
  select dr.union_area_name,
          case when real_qty/approved_qty>=0.85 then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head   cwrh,
          cmx_wh_req_detail cwrd,
          dim_storage       ds,
          zux_region_ou     zro,
          dim_region        dr,
          dim_net_catalogue_general_all dcga
   where cwrh.req_no = cwrd.req_no
     and cwrh.from_wh = '10001'
     and cwrh.to_wh = ds.storage_code
     --and ds.area_code = zro.region
     and ds.org_unit_id = zro.org_unit_id 
     and zro.brancode = dr.area_code
     and nvl(approved_qty, 0) > 0
     and cwrd.item = dcga.goods_code
     and zro.brancode = dcga.area_code
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.ma_date,-1), 'yyyy-mm') = dcga.create_month
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     ${if(len(AREA)=0,""," and dr.union_area_name in ('"+AREA+"')")}
     AND cwrh.ma_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and dcga.new_or_old in ('新品','正常')
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     --and to_char(add_months(cwrh.ma_date,-1), 'yyyy-mm') = dncg.create_month  
     and get_dncga_month(to_char(cwrh.ma_date, 'yyyy-mm'),3) = dncg.create_month
     and  zro.brancode=dncg.area_code)
  union all
  --外部客户配送
 select dr.union_area_name,
        case when real_qty/quantity>=0.85 then 'Y' else 'N' end  满足率,
        trunc(cwrh.approve_date) 审批日期
   from cmx_wf_order_head   cwrh,
        cmx_wf_order_detail cwrd,
        dim_net_catalogue_general_all dcga， 
        dim_wf_cus          dwc,
        dim_region          dr
  where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dr.area_code
     and cwrd.item = dcga.goods_code
     and dwc.area_code = dcga.area_code
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.approve_date,-1), 'yyyy-mm')  = dcga.create_month
     and quantity > 0
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     ${if(len(AREA)=0,""," and dr.union_area_name in ('"+AREA+"')")}
     and not exists (select * from dim_gifts dg where cwrd.item=dg.goods_code)
     and exists (select *  from dim_net_catalogue_general3 dncg where cp_type='总仓配送' and dncg.goods_code= cwrd.item
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),3) = dncg.create_month  and  dwc.area_code=dncg.area_code)
) 
 select c.num / b.num 满足率
   from (select count(满足率) num
           from a) b,
        (select count(满足率) num
           from a
          where 满足率 = 'Y') c
where b.num > 0
  and c.num > 0

