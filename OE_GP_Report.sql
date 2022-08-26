--mwb  l1/2
select
ms.mwb as "MBL",
ms.port_of_unloading as "Dest Port",
ms.submit_chargeable_wt as "ChgWgt",
sum(decode(mc.charge_code,'OFAB',mc.local_cost,0)) as "Buying",
sum(case when cc.charge_code like '%AB' then cc.local_cost else 0 end) as "Consol AB",
(Case When ms.mwb_type='MD' Then 'Direct' Else 'Consolidation' End) As "Type",
(xzy.f_ETD(ms.mwb, 'Export','Ocean',ms.origin_city,ms.dest_city)) as "ETD",
ms.console_no as "Consol No"
from 
Mwb_Summary ms,
mwb_charge mc,
con_summary cs,
con_charge cc
where mc.carrier_waybill_tx_id(+) = ms.carrier_waybill_tx_id
and ms.carrier_waybill_tx_id = cs.carrier_waybill_tx_id(+)
and cs.consol_tx_id = cc.consol_tx_id(+)
and ms.transport_mode = 'Ocean'
and ms.business_type = 'Export'
${if(len(company)==0,""," and ms.company in ('"+company+"')")}
${if(len(terminal)==0,""," and ms.terminal in('"+terminal+"')")}
${if(len(mwb)==0,""," and ms.mwb like '%"+mwb+"%'")}
${if(len(start)==0||len(end)==0,""," and to_char(xzy.f_ETD(ms.mwb, 'Export', 'Ocean', ms.origin_city, ms.dest_city),'yyyy/mm/dd hh24:mm:ss') between '"+start+" 00:00:00' and '"+end+" 23:59:59'")}
and ms.carrier_status not in ('CAN','VD')
and ms.created_date_tz='CN1'
and (case when ms.mwb_type='M' then cs.console_status else '1' end) not in ('CAN','VD')
group by 
ms.mwb,
ms.port_of_unloading,
ms.submit_chargeable_wt,
(Case When ms.mwb_type='MD' Then 'Direct' Else 'Consolidation' End),
(xzy.f_ETD(ms.mwb, 'Export','Ocean',ms.origin_city,ms.dest_city)),
ms.console_no

select
ms.mwb as "MBL",
hs.hwb as "HBL",
hs.dest_port as "Dest Port",
hs.total_pcs_in_total_grp_box as "Pkg",
hs.chgble_wt_in_total_grp_box as "ChgWgt",
hs.rate_in_freight_charge_grp_box as "Rate",
sum(decode(hc.charge_code,'OFRV',hc.local_amt,0)) as "OFRV",
(sum(case when hc.charge_code like '%RV' then hc.local_amt else 0 end)-sum(decode(hc.charge_code,'OFRV',hc.local_amt,0))) as "Others",
sum(case when hc.charge_code like '%RV' then hc.local_amt else 0 end) as "TTL Sales",
(sum(case when hc.charge_code like '%RV' then hc.local_amt else 0 end)-
sum(case when hc.charge_code like '%AB' then hc.local_cost else 0 end) - 
sum(case when hc.charge_code like '%AL' then hc.local_cost else 0 end)) as "GP",
((sum(case when hc.charge_code like '%RV' then hc.local_amt else 0 end)-sum(case when hc.charge_code like '%AB' then hc.local_cost else 0 end) 
- sum(case when hc.charge_code like '%AL' then hc.local_cost else 0 end))/hs.chgble_wt_in_total_grp_box) as "GP/Kg",
hs.shipper_name as "Shipper Name",  --hc?
sum(decode(hc.charge_code,'OFAL',hc.local_cost,0)) as "OFAL",
(sum(case when hc.charge_code like '%AL' then hc.local_cost else 0 end)-sum(decode(hc.charge_code,'OFAL',hc.local_cost,0))) as "Consol AL",
sum(case when hc.charge_code like '%AB' then hc.local_cost else 0 end) as "Others_AB",
(sum(case when hc.charge_code like '%AB' then hc.local_cost else 0 end) + sum(case when hc.charge_code like '%AL' then hc.local_cost else 0 end)) as "TTL Costs",
hs.consignee_name as "Consignee Name" --hc?
from 
Mwb_Summary ms
,hwb_summary hs
--,hwb_detail hd
,hwb_charge hc
where 
ms.carrier_waybill_tx_id = hs.carrier_waybill_tx_id
--and hs.customer_tx_id = hd.customer_tx_id
and hc.customer_tx_id = hs.customer_tx_id
and ms.transport_mode = 'Ocean'
and ms.business_type = 'Export'
and ms.mwb in (--mwb  l1/2
select
ms.mwb as "MBL"
from 
Mwb_Summary ms,
mwb_charge mc,
con_summary cs,
con_charge cc
where mc.carrier_waybill_tx_id(+) = ms.carrier_waybill_tx_id
and ms.carrier_waybill_tx_id = cs.carrier_waybill_tx_id(+)
and cs.consol_tx_id = cc.consol_tx_id(+)
and ms.transport_mode = 'Ocean'
and ms.business_type = 'Export'
${if(len(company)==0,""," and ms.company in ('"+company+"')")}
${if(len(terminal)==0,""," and ms.terminal in('"+terminal+"')")}
${if(len(mwb)==0,""," and ms.mwb like '%"+mwb+"%'")}
${if(len(start)==0||len(end)==0,""," and to_char(xzy.f_ETD(ms.mwb, 'Export', 'Ocean', ms.origin_city, ms.dest_city),'yyyy/mm/dd hh24:mm:ss') between '"+start+" 00:00:00' and '"+end+" 23:59:59'")}
and ms.carrier_status not in ('CAN','VD')
and ms.created_date_tz='CN1'
and (case when ms.mwb_type='M' then cs.console_status else '1' end) not in ('CAN','VD')
group by 
ms.mwb
)
group by 
ms.mwb,
hs.hwb,
hs.dest_port,
hs.total_pcs_in_total_grp_box,
hs.chgble_wt_in_total_grp_box,
hs.rate_in_freight_charge_grp_box,
hs.shipper_name,
hs.consignee_name
order by hs.hwb asc

select ms.mwb,sum(md.submit_pcs) as "Pkg" from mwb_summary ms,mwb_detail md
where 
ms.carrier_waybill_tx_id = md.carrier_waybill_tx_id 
and ms.mwb in(--mwb  l1/2
select
ms.mwb as "MBL"
from 
Mwb_Summary ms,
mwb_charge mc,
con_summary cs,
con_charge cc
where mc.carrier_waybill_tx_id(+) = ms.carrier_waybill_tx_id
and ms.carrier_waybill_tx_id = cs.carrier_waybill_tx_id(+)
and cs.consol_tx_id = cc.consol_tx_id(+)
and ms.transport_mode = 'Ocean'
and ms.business_type = 'Export'
${if(len(company)==0,""," and ms.company in ('"+company+"')")}
${if(len(terminal)==0,""," and ms.terminal in('"+terminal+"')")}
${if(len(mwb)==0,""," and ms.mwb like '%"+mwb+"%'")}
${if(len(start)==0||len(end)==0,""," and to_char(xzy.f_ETD(ms.mwb, 'Export', 'Ocean', ms.origin_city, ms.dest_city),'yyyy/mm/dd hh24:mm:ss') between '"+start+" 00:00:00' and '"+end+" 23:59:59'")}
and ms.carrier_status not in ('CAN','VD')
and ms.created_date_tz='CN1'
and (case when ms.mwb_type='M' then cs.console_status else '1' end) not in ('CAN','VD')
group by 
ms.mwb
)
group by ms.mwb

