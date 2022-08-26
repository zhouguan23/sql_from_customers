select zro.brancode,
       round(sum(decode(tran_code, '73', total_cost, '0')), 4) cost_73,
       round(sum(decode(tran_code, '72', total_cost, '0')), 4) cost_72,
       round(sum(decode(tran_code, '98', -total_cost, '0')), 4) cost_98
  from cmx_arif_history cah, dim_storage ds, zux_region_ou zro
 where tran_code in ('73', '72', '98')
   and tran_date between to_date('${start_date}', 'yyyy-mm-dd') and
       to_date('${end_date}', 'yyyy-mm-dd')
   ${if(len(area)=0,""," and zro.brancode in ('"+area+"')")}
   and cah.location = ds.storage_code
   and ds.org_unit_id = zro.org_unit_id
 group by zro.brancode
 order by brancode

select  area_code,area_name from  dim_region

