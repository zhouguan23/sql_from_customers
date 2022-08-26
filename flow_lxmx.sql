select t.*,t.ProductName+'-'+t.ProductSpecification yp from ImportFlowDataMonthlySum t
where 1=1 and t.quantity<>0
${if(len(dateBegin)==0,""," and  t.yearmonth>='"+dateBegin+"'")}
${if(len(dateEnd)==0,""," and t.yearmonth<='"+dateEnd+"'")}
--and t.yearmonth>='${dateBegin}' and t.yearmonth<='${dateEnd}'
--产品权限
${if(sjqx<>'all' && ryfl=0," and  t.ProductName in ('"+xxt_cp+"')","")} --销售权限
${if(sjqx<>'all' && ryfl=1," and  t.ProductName in ('"+xxt_cp+"')","")} --商务权限
${if(sjqx<>'all' && ryfl=2," and  t.ProductName in ('"+tg_cp+"')","")} --推广权限
--省份权限
${if(sjqx<>'all' && ryfl=0," and  t.province in ('"+xxt_sf+"')","")} --销售权限
${if(sjqx<>'all' && ryfl=1," and  t.province in ('"+xxt_sf+"')","")} --商务权限
${if(sjqx<>'all' && ryfl=2," and  t.province in ('"+tg_sf+"')","")} --推广权限

${if(len(cbMater) == 0,""," and t.ProductName='"+cbMater+"'")}--药品
${if(len(termname)==0,""," and t.TerminalName like '%"+termname+"%'")}--医院名称
${if(len(sf)==0,""," and t.province like '%"+sf+"%'")}--省份
${if(len(cs)==0,""," and t.city like '%"+cs+"%'")}--城市
${if(len(qx)==0,""," and t.county like '%"+qx+"%'")}--区县
${if(len(csjl) == 0,""," and t.Manager_City='"+csjl+"'")}--城市经理
${if(len(dls) == 0,""," and t.agent_name='"+dls+"'")}--代理商
${if(sjqx<>'all' && ryfl=0,
       " and  (t.Manager_City='"+username+"' or t.Manager_Province='"+username+"'  
               or t.Manager_Region='"+username+"'  or t.Manager_Branch='"+username+"'  
               or t.Manager_Division='"+username+"') and t.TerminalCode not in (select TerminalCode from  import_Naturalflow_Terminal)","")}--人员权限
--order by t.yearmonth

select distinct b.Province sf ,c.MaterName cp from formtable_main_246 a
left join formtable_main_75 b on b.id=a.sf
left join formtable_main_10 c on c.id=a.yp
where 1=1 and a.sfyx=1 and a.ryfl=2
${if(sjqx == 'all',"","and  a.csjl='"+userid+"'")}--人员权限
order by b.Province

select distinct t.oa_user_code,t.user_name,t.fcid,a.territory_code,
z.product_name cp,n.region_name sf
from tq_user t
left join tq_territory_user a on  a.user_code=t.user_code and a.is_active=1 and a.is_del=0
left join tq_territory b on b.territory_code=a.territory_code
left join tq_territory_product c on c.territory_code=a.territory_code
left join tq_product z on z.product_code=c.product_code
left join tq_territory_region d on d.territory_fcid=a.territory_fcid
left join tq_region m on m.region_code=d.region_code
left join tq_region n on n.region_code=m.parent_code
where t.oa_user_code='${sjqx}'
order by n.region_name,z.product_name
/*select  distinct c.region_name sf,z.product_name cp from tq_territory  t
left join tq_territory_region a on t.fcid=a.territory_fcid
left join tq_region b on b.region_code=a.region_code
left join tq_region c on c.region_code=b.parent_code
left join tq_territory_product x on x.territory_code=t.territory_code
left join tq_product z on z.product_code=x.product_code
where t.territory_code='gwcode'
order by c.region_name,z.product_name*/

select distinct t.name from DDProduct t
where t.ProductTypeName='sku' and t.Status=1
${if(sjqx<>'all' && ryfl=0," and  t.name in ('"+xxt_cp+"')","")} --销售权限
${if(sjqx<>'all' && ryfl=1," and  t.name in ('"+xxt_cp+"')","")} --商务权限
${if(sjqx<>'all' && ryfl=2," and  t.name in ('"+tg_cp+"')","")} --推广权限

select t.name sf  from DDRegion t
where t.level=1
${if(sjqx<>'all' && ryfl=0," and  t.name in ('"+xxt_sf+"')","")} --销售权限
${if(sjqx<>'all' && ryfl=1," and  t.name in ('"+xxt_sf+"')","")} --商务权限
${if(sjqx<>'all' && ryfl=2," and  t.name in ('"+tg_sf+"')","")} --推广权限
order by t.name

