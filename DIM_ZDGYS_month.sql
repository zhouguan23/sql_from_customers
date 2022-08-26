select a.cjmc 厂家名称,
       d.union_area_name  合并区域名称,
       
       date1, 
       sum(zyxs_tax_amount) 直营销售含税额,
       sum(jmxs_tax_amount) 加盟销售含税额,
       sum(jmps_tax_amount) 加盟配送含税额,
       sum(pfps_tax_amount) 外部配送含税额,
       sum(zyxs_tax_amount)-sum(zyxs_tax_cost) 直营销售毛利,
       sum(jmxs_tax_amount)-sum(jmxs_tax_cost) 加盟销售毛利,
       sum(jmps_tax_amount)-sum(jmps_tax_cost) 加盟配送毛利,
       sum(pfps_tax_amount)-sum(pfps_tax_cost) 外部配送毛利,

       sum(zyxs_amount) 直营销售无税额,
       sum(jmxs_amount) 加盟销售无税额,
       sum(jmps_amount) 加盟配送无税额,
       sum(pfps_amount) 外部配送无税额,
       sum(zyxs_amount)-sum(zyxs_cost) 直营销售无税毛利,
       sum(jmxs_amount)-sum(jmxs_cost) 加盟销售无税毛利,
       sum(jmps_amount)-sum(jmps_cost) 加盟配送无税毛利,
       sum(pfps_amount)-sum(pfps_cost) 外部配送无税毛利
from dim_zdgys_goods a ,DM_PURCHASE_SALE_STOCK_GOODS b, DIM_DISABLE_CODE C,dim_region d
where
a.goods_code=b.goods_code
and A.goods_code = C.disable_code
and b.area_code=d.area_code
--and date1 between to_char(sysdate,'yyyy')-1||'-01' and '${date}'
and date1 between substr('${date}',0,4)-2||'01' and '${date}'
and 
1=1 
${if(len(area)=0,""," and d.union_area_name in ('"+area+"')")}

and 
1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1
${if(len(cjmc)=0,""," and cjmc in ('"+cjmc+"')")}
--and 1=1 ${if(len(gname)=0,""," and b.goods_name in ('"+gname+"')")}
group by a.cjmc ,
        date1,d.union_area_name
order by date1 desc

select distinct cjmc from  dim_zdgys_goods

select distinct a.goods_code as goods_code,a.goods_code||'|'||b.goods_name as goods_name
from dim_zdgys_goods a ,dim_goods b, DIM_DISABLE_CODE C
where
a.goods_code=b.goods_code
and A.goods_code = C.disable_code
--and b.area_code=d.area_code
--and 1=1 ${if(len(cjmc)=0,""," and cjmc in ('"+cjmc+"')")}
--and 1=1 ${if(len(area)=0,""," and d.union_area_name in ('"+area+"')")}
order by a.goods_code




select 
      *
       
from dim_region d
order by decode(d.area_code,'00','AA',d.union_area_name),d.area_code



/*select 
       distinct d.union_area_name ,d.area_code
       
from dim_region d
where  
1=1 
${if(len(area)=0,""," and d.union_area_name in ('"+area+"')")}
order by decode(d.area_code,'00','AA',d.union_area_name),d.area_code*/

select a.cjmc 厂家名称,
       d.union_area_name  合并区域名称,
       date1, 
       d.area_code
from dim_zdgys_goods a ,DM_PURCHASE_SALE_STOCK_GOODS b, DIM_DISABLE_CODE C,dim_region d
where
a.goods_code=b.goods_code
and A.goods_code = C.disable_code
and b.area_code=d.area_code
and date1 between substr('${date}',0,4)-2||'01' and '${date}'
and 
1=1 
${if(len(area)=0,""," and d.union_area_name in ('"+area+"')")}
and 1=1
${if(len(cjmc)=0,""," and cjmc in ('"+cjmc+"')")}
order by date1 desc,a.cjmc ,decode(d.area_code,'00','AA',d.union_area_name),d.area_code

