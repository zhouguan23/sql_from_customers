select a.area_code, --区域id
	   dr.area_name,--区域名称
	   case when '${ld}' = '门店'  then a.cus_code else '00' end cus_code,--门店id
	   case when '${ld}' = '门店'  then a.cus_name else '空' end cus_name,--门店名称
	   to_char(max(a.ddate),'yyyymmdd')||'月末库存' ddate,
	   a.goods_code,--商品编码
	   b.goods_name,--品名
	   b.specification,--规格
	   b.manufacturer,--厂家
	  (case when '${ld}' = '区域' and c.new_attribute is null then '地采' 
	        when '${ld}' = '区域' and c.new_attribute is not null then c.new_attribute
	  else '空' end ) new_attribute,--采购属性
	  (case when '${ld}' = '区域' and d.goods_Code is not null then '是' 
	        when '${ld}' = '区域' and d.goods_Code is  null then '否'
	        else '空' end ) as dtp,--dtp
	   case when '${ld}'='区域' then '空' else
	   (case when a.effective_period<a.ddate then '过效期'
			when a.ddate<=(a.effective_period)  and (a.effective_period-a.ddate) <=30 then '一个月效期'
			when 30<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=60 then '2个月效期'
			when 60<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=90 then '3个月效期'
			when 90<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=180 then '4-6个月效期'
			else '正常效期' end ) end as effective_period, --期效
	   min(dr.sorted) as sorted,--排序
	   sum(case when a.ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 and '${ld}' <> '门店'
	   then stock_qty_DC else 0 end) as dq_stock_qty_DC,--大仓库存数量
	   sum(case when a.ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 and '${ld}' <> '门店'
	   then no_tax_cost_DC else 0 end) as dq_no_tax_cost_DC,--大仓库存无税成本
	   sum(case when a.ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 then stock_qty_MD else 0 end) as dq_stock_qty_MD,--直营库存数量
	   sum(case when a.ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 then no_tax_cost_MD else 0 end) as dq_no_tax_cost_MD--直营库存无税成本
from ( select a1.area_code,
			   '00' as cus_code,
			   '空' as cus_name,
			   a1.ddate,
			   a1.goods_code,
			   a1.effective_period,
			   a1.stock_qty as stock_qty_dc,
			   a1.no_tax_cost as no_tax_cost_dc,
			   0 as stock_qty_md,
			   0 as no_tax_cost_md
		  from fact_stock_general a1 --大仓库存
		  where a1.ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
			union all	
		select a2.area_code,
			   a2.cus_code,
			   cus.cus_name,
			   a2.ddate,
			   a2.goods_code,
			   a2.effective_period,
			   0 as stock_qty_dc,
			   0 as no_tax_cost_dc,
			   a2.stock_qty as stock_qty_md,
			   a2.no_tax_cost as no_tax_cost_md
		  from fact_stock_shop a2 --直营库存
		inner join dim_cus cus 
			on a2.area_code=cus.area_code and a2.cus_code=cus.cus_Code 
		  where a2.ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
			and cus.attribute='直营'
	 ) a
inner join dim_region dr on a.area_code=dr.area_code
inner join USER_AUTHORITY ua on (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') and ${"ua.user_id='"+$fr_username+"'"}
left join dim_goods b on a.goods_code = b.goods_code
inner join dim_disable_code dc on a.goods_code=dc.disable_code
left join dim_net_catalogue_general_all c on a.area_code = c.area_code and a.goods_code = c.goods_code and to_char(A.ddate, 'yyyy-mm') = C.Create_MONTH
left join dim_dtp d on a.area_code = d.area_code and a.goods_code = d.goods_code 
and to_char(add_months(A.ddate, -1), 'yyyy-mm') =
                               d.create_month
where 1=1
${if(len(area)=0,"", "and a.area_code in ('"+area+"')")} --区域
${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")} --门店
${if(len(DTP)=0,""," and (case when d.goods_code is null then '否' else '是' end) = '"+DTP+"'")} --DTP
${if(len(JC)=0,"","and (case when c.new_attribute is null then '地采' else c.new_attribute end ) in ('"+JC+"')")}  --采购属性
${if(len(GCODE)=0,"", "and dc.GOODS_CODE in ('"+GCODE+"')")} --商品
${if(len(eff)=0,""," and case when a.effective_period<a.ddate then '过效期'
							  when a.ddate<=(a.effective_period)  and (a.effective_period-a.ddate) <=30 then '一个月效期'
							  when 30<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=60 then '2个月效期'
							  when 60<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=90 then '3个月效期'
							  when 90<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=180 then '4-6个月效期'
							  else '正常效期' end in('"+eff+"')")} --效期
and (('${ld}' = '门店' and a.stock_qty_MD+a.no_tax_cost_MD>0) or '${ld}' <> '门店')							  
group by a.area_code, --区域id
	   dr.area_name,--区域名称
	   --${if(len(is_cus),"00","a.cus_code")}
	   case when '${ld}' = '门店'  then a.cus_code else '00' end,--门店id
	   case when '${ld}' = '门店' then a.cus_name else '空' end,--门店名称
	   --${if(len(cus)=0,"'空'","a.cus_name")},--门店名称
	   a.goods_code,--商品编码
	   b.goods_name,--品名
	   b.specification,--规格
	   b.manufacturer,--厂家
	  (case when '${ld}' = '区域' and c.new_attribute is null then '地采' 
	        when '${ld}' = '区域' and c.new_attribute is not null then c.new_attribute
	  else '空' end ) ,--采购属性
	  (case when '${ld}' = '区域' and d.goods_Code is not null then '是' 
	        when '${ld}' = '区域' and d.goods_Code is  null then '否'
	        else '空' end ),--DTP
      case when '${ld}'='区域' then '空' else
	   (case when a.effective_period<a.ddate then '过效期'
			when a.ddate<=(a.effective_period)  and (a.effective_period-a.ddate) <=30 then '一个月效期'
			when 30<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=60 then '2个月效期'
			when 60<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=90 then '3个月效期'
			when 90<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=180 then '4-6个月效期'
			else '正常效期' end ) end
ORDER BY a.area_code, --区域id
	   dr.area_name,--区域名称
	   case when '${ld}' = '门店'  then a.cus_code else '00' end,--门店id
	   case when '${ld}' = '门店' then a.cus_name else '空' end,--门店名称
	   a.goods_code--商品编码
			


select distinct NEW_ATTRIBUTE from DIM_NET_CATALOGUE_GENERAL_ALL where CREATE_MONTH='${Date}' 
union select '地采' from  dual

select distinct dc.cus_code,dc.cus_code||'|'||dc.cus_name cus_name from DIM_CUS dc
where 1=1 ${if(len(area)=0,""," and dc.area_code in ('"+area+"')")}

select A.AREA_CODE,C.GOODS_CODE,A.DTP,A.NEW_ATTRIBUTE,C.GOODS_NAME,C.SPECIFICATION,C.MANUFACTURER,SUM(STOCK_QTY_DC) as STOCK_QTY_DC,SUM(STOCK_QTY_MD) as STOCK_QTY_MD,
SUM(NO_TAX_COST_DC) as NO_TAX_COST_DC, SUM(NO_TAX_COST_MD) as NO_TAX_COST_MD from DM_STOCK_GOODS A ,DIM_DISABLE_CODE B,DIM_GOODS C
where  A.goods_code = B.disable_code and  
1=1 ${if(len(area)=0,"", "and Area_code in ('"+area+"')")}  and to_char(add_months(ddate,1),'yyyy-mm')='${Date}' and
1=1 ${if(len(DTP)=0,"", "and DTP in ('"+DTP+"')")}  AND 
1=1 ${if(len(JC)=0,"","and NEW_ATTRIBUTE in ('"+JC+"')")} 
AND 
1=1 ${if(len(GCODE)=0,"", "and B.GOODS_CODE in ('"+GCODE+"')")} 
and C.GOODS_CODE=B.GOODS_CODE
GROUP BY C.GOODS_CODE,A.DTP,A.NEW_ATTRIBUTE,C.GOODS_NAME,C.SPECIFICATION,C.MANUFACTURER,A.AREA_CODE


select A.AREA_CODE,C.GOODS_CODE,A.DTP,A.NEW_ATTRIBUTE,C.GOODS_NAME,C.SPECIFICATION,C.MANUFACTURER,SUM(STOCK_QTY_DC) as STOCK_QTY_DC,SUM(STOCK_QTY_MD) as STOCK_QTY_MD,
SUM(NO_TAX_COST_DC) as NO_TAX_COST_DC, SUM(NO_TAX_COST_MD) as NO_TAX_COST_MD from DM_STOCK_GOODS A ,DIM_DISABLE_CODE B,DIM_GOODS C
where  A.goods_code = B.disable_code and  
1=1 ${if(len(area)=0,"", "and Area_code in ('"+area+"')")}  and to_char(add_months(ddate,12),'yyyy-mm')='${Date}' and
1=1 ${if(len(DTP)=0,"", "and DTP in ('"+DTP+"')")}  AND 
1=1 ${if(len(JC)=0,"","and NEW_ATTRIBUTE in ('"+JC+"')")} 
AND 
1=1 ${if(len(GCODE)=0,"", "and B.GOODS_CODE in ('"+GCODE+"')")} 
and C.GOODS_CODE=B.GOODS_CODE
GROUP BY C.GOODS_CODE,A.DTP,A.NEW_ATTRIBUTE,C.GOODS_NAME,C.SPECIFICATION,C.MANUFACTURER,A.AREA_CODE


