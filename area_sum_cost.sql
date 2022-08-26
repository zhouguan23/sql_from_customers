select dsca.area_code,
       substr(dsca.sale_date,6,7) as sale_date,
       dsca.bus_type,
       round(sum(dsca.no_cost_amount)/10000,2) no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type='大仓库存额'
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by dsca.area_code, dsca.sale_date, dsca.bus_type

select * from DIM_REGION where ${if(len(region) = 0, "1=1", " area_code in ('" + region + "')")}

select dsca.area_code,
       substr(dsca.sale_date,6,7) as sale_date,
       round(sum(dsca.no_cost_amount)/10000,2)  no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type in('大仓库存额','直营库存额')
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in ('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by dsca.area_code, dsca.sale_date

select dsca.area_code,
       substr(dsca.sale_date,6,7) as sale_date,
       round(sum(dsca.no_cost_amount)/10000,2) no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type in('外部客户批发成本','直营销售成本','加盟配送成本','关联销售成本')
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in ('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by dsca.area_code, dsca.sale_date

select dsca.area_code,
       substr(dsca.sale_date,6,7) as sale_date,
       round(sum(dsca.no_cost_amount)/10000,2) no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type in('直营库存额')
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by dsca.area_code, dsca.sale_date

select dsca.area_code,
       substr(dsca.sale_date,6,7) as sale_date,
       round(sum(dsca.no_cost_amount)/10000,2) no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type in('直营销售成本')
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by dsca.area_code, dsca.sale_date

  select dsca.area_code,
       substr(dsca.sale_date,6,7) as sale_date,
       round(sum(dsca.no_cost_amount)/10000,2) no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type in('加盟配送成本')
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in ('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by dsca.area_code, dsca.sale_date

select dsca.area_code,
       substr(dsca.sale_date,6,7) as sale_date,
       round(sum(dsca.no_cost_amount)/10000,2) no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type in('外部客户批发成本')
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by dsca.area_code, dsca.sale_date

 select dsca.area_code,
       substr(dsca.sale_date,6,7) as sale_date,
       round(sum(dsca.no_cost_amount)/10000,2) no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type in('关联销售成本')
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in ('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by dsca.area_code, dsca.sale_date

select distinct dsca.sub_category from DW_SUM_COST_AREA dsca

 select distinct dsca.Buyer from DW_SUM_COST_AREA dsca

 select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

select 
       substr(dsca.sale_date,6,7) as sale_date,
       sum(dsca.no_cost_amount) no_cost_amount
  from DW_SUM_COST_AREA dsca
where bus_type in('外部客户批发成本','直营销售成本','加盟配送成本')
   and ${if(len(sub_category) = 0, "1=1", "  dsca.sub_category in ('" + sub_category + "')") }
   and ${if(len(is_dtp) = 0, "1=1", "  dsca.is_dtp='" + is_dtp + "'")}
   and ${if(len(buyer) = 0, "1=1", "  dsca.buyer in ('" + buyer + "')")}
   and substr(sale_date,1,4) = '${year}'
 group by  dsca.sale_date

