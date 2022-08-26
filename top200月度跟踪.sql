select a.area_code,a.area_name from dim_region a 
where 
 1=1  ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
--order by decode(area_code,'00','AA',union_area_name),area_code
order by a.sorted

with a as
 (
  --区域要货
  select dr.union_area_name,
          case when real_qty/approved_qty>=0.85 or  cwrd.satisfy_flag='Y'  then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head   cwrh,
          cmx_wh_req_detail cwrd,
          dim_storage       ds,
          zux_region_ou     zro,
          dim_region        dr,
          dim_net_catalogue_general_all dcga,
          
          dim_goods_top200         dgt
          
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
     
     and cwrd.item=dgt.goods_code
     
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
	 --instr('code_attr','多码')=0
     --and dgt.code_attr not  like  '%多码%'
	 and nvl(dgt.code_attr,' ') not  like  '%多码%'
     ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
     and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
     AND cwrh.ma_date >= trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
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
        dim_region          dr,
        
        dim_goods_top200         dgt
        
  where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dr.area_code
     and cwrd.item = dcga.goods_code
     and dwc.area_code = dcga.area_code
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.approve_date,-1), 'yyyy-mm')  = dcga.create_month
     
     and cwrd.item=dgt.goods_code
     
     and quantity > 0
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     and nvl(dgt.code_attr,' ') not  like  '%多码%'
     ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
     and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
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

select  a.union_area_name from dim_region a,(select * from USER_AUTHORITY) b
where area_code!='00' 
and (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
group by a.union_area_name
order by min(a.sorted)

select distinct  dgt.goods_code,substr(dgt.goods_code||'|'||b.goods_name||'|'||item_desc_secondary|| '|' ||b.specification || '|' || b.manufacturer,1,40)  as goods_name 
from dim_goods_top200 dgt,dim_goods b
where dgt.goods_code=b.goods_code
order by dgt.goods_code 


select a.union_area_name,round(销售额/10000,2)as 直营店销售,
(销售额/上月销售额)-1 as 销售环比,(销售额/去年同期销售额)-1 as 销售同比,
毛利额/销售额 as 毛利率,(毛利额/销售额)-(去年同期毛利额/去年同期销售额)as 毛利率同比 from (
select dr.union_area_name,sum(no_tax_amount) as 销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 毛利额 from dim_goods_top200 dgt,fact_sale fs
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where   fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_month}'||'01','yyyy-mm-dd') end)
and dgt.goods_code=fs.goods_code
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}


and fs.sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and fs.sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)

and dc.attribute='直营'
group by dr.union_area_name)a left join
(
select dr.union_area_name,sum(no_tax_amount) as 上月销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 上月毛利额 from dim_goods_top200 dgt,fact_sale fs
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-1) end)
and dgt.goods_code=fs.goods_code
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}

and fs.sale_date>=add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-1)
and fs.sale_date<add_months(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),-1)

and dc.attribute='直营'
group by dr.union_area_name)b on a.union_area_name=b.union_area_name
left join
(
select dr.union_area_name,sum(no_tax_amount) as 去年同期销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 去年同期毛利额 from dim_goods_top200 dgt,fact_sale fs
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where  fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-12) end)
and dgt.goods_code=fs.goods_code
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}

and fs.sale_date>=add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-12)
and fs.sale_date<add_months(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),-12)

and dc.attribute='直营'
group by dr.union_area_name)c on a.union_area_name=c.union_area_name


select  dr.union_area_name,
       sum(crd.req_qty) req_qty,
       sum(crd.real_qty) real_qty,
       sum(crd.real_qty) / sum(crd.req_qty)  as 区域对门店要货满足率    

from   cmx_req_head             crh,
       cmx_req_detail           crd，
       dim_goods_top200         dgt，
       dim_cus                  dc,
       dim_region               dr       
where crh.req_no = crd.req_no
and crd.item=dgt.goods_code
and to_char(crh.store) = dc.cus_code
and dc.area_code=dr.area_code
and crd.req_qty <> 0
and crd.status in('MA', 'S', 'C', 'P')
and dr.type='ONLINE'
and crh.approved_by is not null
and nvl(dgt.code_attr,' ') not  like  '%多码%'
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and crh.approve_date>=trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
and crh.approve_date<trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
 group by dr.union_area_name

select union_area_name,count(distinct goods_code)品规数 from (
select    dr.union_area_name,
        fs.goods_code

from          
              dim_region               dr,
              dim_goods_top200         dgt,
              fact_sale                fs
left join     dim_cus           dc 
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code              
where fs.goods_code=dgt.goods_code
and fs.area_code=dr.area_code
and dc.attribute = '直营'
and fs.sale_qty >0
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by dr.union_area_name,fs.goods_code
union all
select  dr.union_area_name,
       fss.goods_code

from 
              dim_region               dr,
              dim_goods_top200         dgt,
              fact_stock_shop          fss
left join     dim_cus           dc 
on fss.area_code=dc.area_code
and fss.cus_code=dc.cus_code
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code
and dc.attribute = '直营'
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by dr.union_area_name,fss.goods_code
union all
select  dr.union_area_name,
       fss.goods_code

from 
              fact_stock_general          fss,
              dim_goods_top200         dgt,
              dim_region               dr  
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by dr.union_area_name,fss.goods_code
)
group by union_area_name



select union_area_name,
       count(distinct cus_code)门店数,
       sum(goods_code)品规数,
       sum(goods_code)/count(distinct cus_code)单店在营品规数 from (
select union_area_name,
       cus_code,
       count(distinct goods_code)goods_code
       from (
select  dr.union_area_name,
        fs.cus_code,  
        fs.goods_code

from          
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_sale                fs
left join dim_cus           dc 
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code                
where fs.goods_code=dgt.goods_code
and fs.area_code=dr.area_code

and dc.attribute = '直营'
and fs.sale_qty >0
and 1=1 ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by dr.union_area_name,fs.cus_code,fs.goods_code
union all
select dr.union_area_name,
        fss.cus_code, 
        fss.goods_code

from 
              
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_stock_shop          fss
left join dim_cus           dc
on fss.area_code=dc.area_code
and fss.cus_code=dc.cus_code               
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code

and dc.attribute = '直营'
and 1=1 ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by  dr.union_area_name,fss.cus_code,fss.goods_code
) 
group by union_area_name,cus_code
)group by union_area_name

with a as
 (
  --区域要货
  select dr.union_area_name,
          case when real_qty/approved_qty>=0.85 or  cwrd.satisfy_flag='Y'  then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head   cwrh,
          cmx_wh_req_detail cwrd,
          dim_storage       ds,
          zux_region_ou     zro,
          dim_region        dr,
          dim_net_catalogue_general_all dcga,
          
          dim_goods_top200         dgt
          
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
     
     and cwrd.item=dgt.goods_code
     and nvl(dgt.code_attr,' ') not  like  '%多码%'
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
     and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
     AND cwrh.ma_date >= trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
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
        dim_region          dr,
        
        dim_goods_top200         dgt
        
  where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dr.area_code
     and cwrd.item = dcga.goods_code
     and dwc.area_code = dcga.area_code
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.approve_date,-1), 'yyyy-mm')  = dcga.create_month
     
     and cwrd.item=dgt.goods_code
     and nvl(dgt.code_attr,' ') not  like  '%多码%'
     and quantity > 0
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
     and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
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

select  
       sum(crd.req_qty) req_qty,
       sum(crd.real_qty) real_qty,
       sum(crd.real_qty) / sum(crd.req_qty)  as 区域对门店要货满足率    

from   cmx_req_head             crh,
       cmx_req_detail           crd，
       dim_goods_top200         dgt，
       dim_cus                  dc,
       dim_region               dr       
where crh.req_no = crd.req_no
and crd.item=dgt.goods_code
and to_char(crh.store) = dc.cus_code
and dc.area_code=dr.area_code
and crd.req_qty <> 0
and crd.status in('MA', 'S', 'C', 'P')
and dr.type='ONLINE'
and crh.approved_by is not null
and nvl(dgt.code_attr,' ') not  like  '%多码%'
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and crh.approve_date>=trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
and crh.approve_date<trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
 

select count(distinct goods_code)品规数 from (
select    dr.union_area_name,
        fs.goods_code

from          
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_sale                fs 
left join     dim_cus           dc
on  fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code        
where fs.goods_code=dgt.goods_code
and fs.area_code=dr.area_code
and dc.attribute = '直营'
and fs.sale_qty >0
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by dr.union_area_name,fs.goods_code
union all
select  dr.union_area_name,
       fss.goods_code

from 
              
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_stock_shop          fss
left join     dim_cus           dc
on fss.area_code=dc.area_code
and fss.cus_code=dc.cus_code                
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code

and dc.attribute = '直营'
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by dr.union_area_name,fss.goods_code
union all
select  dr.union_area_name,
       fss.goods_code

from 
              fact_stock_general          fss,
              dim_goods_top200         dgt,
              dim_region               dr  
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by dr.union_area_name,fss.goods_code
)

select 
       count(cus_code)门店数,
       sum(goods_code)品规数,
       sum(goods_code)/count(cus_code)单店在营品规数 from (
select union_area_name,
       cus_code,
       count(distinct goods_code)goods_code
       from (
select  dr.union_area_name,
        fs.cus_code,  
        fs.goods_code

from          
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_sale                fs 
left join dim_cus           dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code              
where fs.goods_code=dgt.goods_code
and fs.area_code=dr.area_code

and dc.attribute = '直营'
and fs.sale_qty >0
and 1=1 ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by dr.union_area_name,fs.cus_code,fs.goods_code
union all
select dr.union_area_name,
        fss.cus_code, 
        fss.goods_code

from 
              
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_stock_shop          fss 
left join dim_cus           dc 
on fss.area_code=dc.area_code
and fss.cus_code=dc.cus_code
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code

and dc.attribute = '直营'
and 1=1 ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
group by  dr.union_area_name,fss.cus_code,fss.goods_code
) 
group by union_area_name,cus_code
)


select  round(sum(销售额)/10000,2)as 直营店销售,
(sum(销售额)/sum(上月销售额))-1 as 销售环比,(sum(销售额)/sum(去年同期销售额))-1 as 销售同比,
sum(毛利额)/sum(销售额) as 毛利率,(sum(毛利额)/sum(销售额))-(sum(去年同期毛利额)/sum(去年同期销售额))as 毛利率同比 from (
select dr.union_area_name,sum(no_tax_amount) as 销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 毛利额 from fact_sale fs
join dim_goods_top200 dgt
on dgt.goods_code=fs.goods_code
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_month}'||'01','yyyy-mm-dd') end)
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and fs.sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and fs.sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)

and dc.attribute='直营'
group by dr.union_area_name)a left join
(
select dr.union_area_name,sum(no_tax_amount) as 上月销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 上月毛利额 from fact_sale fs
join dim_goods_top200 dgt
on dgt.goods_code=fs.goods_code
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-1) end)
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}

and fs.sale_date>=add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-1)
and fs.sale_date<add_months(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),-1)

and dc.attribute='直营'
group by dr.union_area_name)b on a.union_area_name=b.union_area_name
left join
(
select dr.union_area_name,sum(no_tax_amount) as 去年同期销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 去年同期毛利额 from fact_sale fs
join dim_goods_top200 dgt
on dgt.goods_code=fs.goods_code
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-12) end)
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}

and fs.sale_date>=add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-12)
and fs.sale_date<add_months(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),-12)

and dc.attribute='直营'
group by dr.union_area_name)c on a.union_area_name=c.union_area_name

with a as
 (
  --区域要货
  select dr.union_area_name,
          case when real_qty/approved_qty>=0.85 or  cwrd.satisfy_flag='Y'  then 'Y' else 'N' end  满足率,
          trunc(cwrh.ma_date) 审批日期
    from cmx_wh_req_head   cwrh,
          cmx_wh_req_detail cwrd,
          dim_storage       ds,
          zux_region_ou     zro,
          dim_region        dr,
          dim_net_catalogue_general_all dcga,
          
          dim_goods_top200         dgt
          
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
     
     and cwrd.item=dgt.goods_code
     and nvl(dgt.code_attr,' ') not  like  '%多码%'
     and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
     and dr.area_code!='31'
     
     and cwrd.status in ('P', 'MA', 'C', 'SE', 'AE')
     ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
     and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
     AND cwrh.ma_date >= trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.ma_date < trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
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
        dim_region          dr,
        
        dim_goods_top200         dgt
        
  where cwrh.wf_order_no = cwrd.wf_order_no
     AND cwrh.approve_date >= trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
     AND cwrh.approve_date < trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
     and cwrh.store = to_char(dwc.wf_customer_id)
     and dwc.area_code = dr.area_code
     and cwrd.item = dcga.goods_code
     and dwc.area_code = dcga.area_code
     and get_dncga_month(to_char(cwrh.approve_date, 'yyyy-mm'),1)= dcga.create_month
     --and to_char(add_months(cwrh.approve_date,-1), 'yyyy-mm')  = dcga.create_month
     
     and cwrd.item=dgt.goods_code
     and nvl(dgt.code_attr,' ') not  like  '%多码%'
     and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
     and dr.area_code!='31'
     
     and quantity > 0
     and cwrd.status in ('P', 'C', 'MA', 'S')
     and dcga.new_or_old in ('新品','正常')
     ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
     and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
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

select  
       sum(crd.req_qty) req_qty,
       sum(crd.real_qty) real_qty,
       sum(crd.real_qty) / sum(crd.req_qty)  as 区域对门店要货满足率    

from   cmx_req_head             crh,
       cmx_req_detail           crd，
       dim_goods_top200         dgt，
       dim_cus                  dc,
       dim_region               dr       
where crh.req_no = crd.req_no
and crd.item=dgt.goods_code
and to_char(crh.store) = dc.cus_code
and dc.area_code=dr.area_code
and crd.req_qty <> 0
and crd.status in('MA', 'S', 'C', 'P')
and dr.type='ONLINE'
and crh.approved_by is not null
and nvl(dgt.code_attr,' ') not  like  '%多码%'
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
and dr.area_code!='31'
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and crh.approve_date>=trunc(to_date('${start_month}'||'01','yyyy-mm-dd'),'mm')
and crh.approve_date<trunc(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),'mm')
 

select count(distinct goods_code)品规数 from (
select    dr.union_area_name,
        fs.goods_code

from          
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_sale                fs 
left join  dim_cus           dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code             
where fs.goods_code=dgt.goods_code
and fs.area_code=dr.area_code
and dc.attribute = '直营'
and fs.sale_qty >0
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)
and nvl(dgt.code_attr,' ') not  like  '%多码%'
and dr.area_code!='31'
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
group by dr.union_area_name,fs.goods_code
union all
select  dr.union_area_name,
       fss.goods_code

from 
              
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_stock_shop          fss
left join  dim_cus           dc 
on fss.area_code=dc.area_code
and fss.cus_code=dc.cus_code               
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code
and dc.attribute = '直营'
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
and dr.area_code!='31'
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
group by dr.union_area_name,fss.goods_code
union all
select  dr.union_area_name,
       fss.goods_code

from 
              fact_stock_general          fss,
              dim_goods_top200         dgt,
              dim_region               dr  
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
and dr.area_code!='31'
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
group by dr.union_area_name,fss.goods_code
)

select 
       count(cus_code)门店数,
       sum(goods_code)品规数,
       sum(goods_code)/count(cus_code)单店在营品规数 from (
select union_area_name,
       cus_code,
       count(distinct goods_code)goods_code
       from (
select  dr.union_area_name,
        fs.cus_code,  
        fs.goods_code

from          
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_sale                fs
left join dim_cus           dc 
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code             
where fs.goods_code=dgt.goods_code
and fs.area_code=dr.area_code

and dc.attribute = '直营'
and fs.sale_qty >0
and 1=1 ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)
and nvl(dgt.code_attr,' ') not  like  '%多码%'
and dr.area_code!='31'
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
group by dr.union_area_name,fs.cus_code,fs.goods_code
union all
select dr.union_area_name,
        fss.cus_code, 
        fss.goods_code

from 
              
              dim_goods_top200         dgt,
              dim_region               dr,
              fact_stock_shop          fss
left join dim_cus           dc 
on fss.area_code=dc.area_code
and fss.cus_code=dc.cus_code  
where   fss.goods_code=dgt.goods_code
and fss.area_code=dr.area_code

and dc.attribute = '直营'
and 1=1 ${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and ddate=last_day(to_date('${end_month}','yyyy-mm'))
and stock_qty>0
and nvl(dgt.code_attr,' ') not  like  '%多码%'
and dr.area_code!='31'
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
group by  dr.union_area_name,fss.cus_code,fss.goods_code
) 
group by union_area_name,cus_code
)


select  round(sum(销售额)/10000,2)as 直营店销售,
(sum(销售额)/sum(上月销售额))-1 as 销售环比,(sum(销售额)/sum(去年同期销售额))-1 as 销售同比,
sum(毛利额)/sum(销售额) as 毛利率,(sum(毛利额)/sum(销售额))-(sum(去年同期毛利额)/sum(去年同期销售额))as 毛利率同比 from (
select dr.union_area_name,sum(no_tax_amount) as 销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 毛利额 from fact_sale fs
join dim_goods_top200 dgt
on dgt.goods_code=fs.goods_code
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_month}'||'01','yyyy-mm-dd') end)
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and fs.sale_date>=to_date('${start_month}'||'01','yyyy-mm-dd')
and fs.sale_date<add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1)
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
and dc.attribute='直营'
and dr.area_code!='31'
group by dr.union_area_name)a left join
(
select dr.union_area_name,sum(no_tax_amount) as 上月销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 上月毛利额 from fact_sale fs
join dim_goods_top200 dgt
on dgt.goods_code=fs.goods_code
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-1) end)
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
and fs.sale_date>=add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-1)
and fs.sale_date<add_months(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),-1)

and dc.attribute='直营'
and dr.area_code!='31'
group by dr.union_area_name)b on a.union_area_name=b.union_area_name
left join
(
select dr.union_area_name,sum(no_tax_amount) as 去年同期销售额,sum(nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)) as 去年同期毛利额 from fact_sale fs
join dim_goods_top200 dgt
on dgt.goods_code=fs.goods_code
left join dim_cus dc
on fs.area_code=dc.area_code
and fs.cus_code=dc.cus_code
left join dim_region dr
on fs.area_code=dr.area_code
where fs.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-12) end)
${if(len(UNION_AREA)=0,""," and dr.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and dgt.goods_code in ('"+goods+"')")}

and fs.sale_date>=add_months(to_date('${start_month}'||'01','yyyy-mm-dd'),-12)
and fs.sale_date<add_months(add_months(to_date('${end_month}'||'01','yyyy-mm-dd'),1),-12)
and (dr.combination_time is null or dr.combination_time<trunc(to_date('${end_month}','yyyy-mm'),'yyyy'))
and dc.attribute='直营'
and dr.area_code!='31'
group by dr.union_area_name)c on a.union_area_name=c.union_area_name

