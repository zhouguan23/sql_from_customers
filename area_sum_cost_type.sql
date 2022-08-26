select * from DIM_REGION

select substr(pssg.date1,6,7) as date1,
       decode(bus_type,'集采DTP','DTP',bus_type) bus_type,
       round(sum(pssg.sum_amount)/10000,2) sum_amount,
       case when length('$buyer')=0 or length('$buyer')>=202 then  round(sum(pssg.sum_cost)/10000,2) else round((sum(pssg.sum_cost)+sum(pssg.sum_gljycost))/10000,2) end  sum_cost,
       round(sum(pssg.dckc_amount)/10000,2) dckc_amount,
       round(sum(pssg.zykc_amount)/10000,2) zykc_amount,
       round(sum(pssg.zyxs_cost)/10000,2) zyxs_cost,
       round(sum(pssg.jmps_cost)/10000,2) jmps_cost,
       round(sum(pssg.pfps_cost)/10000,2) pfps_cost,
       round(sum(pssg.sum_gljycost)/10000,2) sum_gljycost
 from dw_sum_cost_area_type pssg
where 
       ${if(len(sub_category) = 0, "1=1", "  pssg.sub_category in('" + sub_category + "')") }
   and ${if(len(buyer) = 0, "1=1", "  pssg.area_code in ('" + buyer + "')")}
   and substr(pssg.date1,1,4) = '${year}'
   and ${if(len(cg_attr) = 0, "1=1", "  pssg.bus_type in ( '" + cg_attr + "')")} 
   and ${if(len(is_dtp) = 0, "1=1", "  pssg.dtp='" + is_dtp + "'")}
 group by pssg.date1,bus_type
 order by pssg.date1

select distinct dg.sub_category from dim_goods dg
union 
select '空值' from dual

 select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

select distinct a.bus_type from dw_sum_cost_area_type a

