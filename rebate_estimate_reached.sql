select 返利头ID,返利年度,公司名称,采购经理,供应商地点代码,供应商名称,协议条款,协议口径实际达成,
实际应收返利,预计年度达成额,预计年度返利金额,差标额,协议标的1,差标1,预估完成率1,
协议标的2,差标2,预估完成率2,协议标的3,差标3,预估完成率3,返利含税实收,协议标的1完成金额,协议标的2完成金额,协议标的3完成金额,下阶段达成差距 from (
-- 线上-手工计算
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       (select region_name from region where region=ccm.region)as 公司名称,
       su.realname as 采购经理,
       nvl(ccm.supplier_site_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款 ,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       nvl(crl_real.amount_received,0) as 返利含税实收,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 预计年度达成额,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 预计年度返利金额 ,
       '-' as 差标额,
       to_char(0) as 协议标的1, to_char(0) as 差标1, to_char(1) as 预估完成率1,
       '-' as 协议标的2, '-' as 差标2, '-' as 预估完成率2,
       '-' as 协议标的3, '-' as 差标3, '-' as 预估完成率3,
       0 as 协议标的1完成金额,0 as 协议标的2完成金额,0 as 协议标的3完成金额,'-',0 as 下阶段达成差距
from (select su.username,su.realname,sd.depart_name,sd.area_code
from sam.sys_user su,  sam.sys_user_depart sud, sam.sys_depart sd
where su.id = sud.user_id
and sud.dep_id = sd.id)a,sam.cmx_contract_main ccm
left join sups s3 on ccm.supplier_code = s3.supplier
join sam.cmx_rebate_head crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
left join (select crl.head_id,sum(crll.amount_received) as amount_received
             from sam.cmx_rebate_line crl,sam.cmx_rebate_line_real crll 
             where crl.id = crll.line_id
              and to_date(crll.receive_period,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
             group by crl.head_id
          ) crl_real on crl_real.head_id = crl.head_id
join sam.cmx_rebate_terms crt on crh.id = crt.rebate_id and crt.is_line = 1
where crt.auto_cal_flag = 0
and crh.rebate_year = '${year}' --返利年度
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_site_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
and 1=1 ${if(len(area)=0,""," and ccm.region in ('"+area +"')")}
and ccm.region=(case when a.area_code<>100 then to_char(a.area_code) else to_char( ccm.region) end)
and ${"a.username='"+$fr_username+"'"}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year,ccm.region, su.realname,
      ccm.supplier_site_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause),nvl(crl_real.amount_received,0)
union all      
      
-- 线上-自动计算-退货率不足返利(%)\按数量统签分采补差(Qty)\按区域配送数量补差(Qty)\平衡值返利(%)\平衡值返利(Qty)\按月末库存数量固定金额返利(Qty)
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       (select region_name from region where region=ccm.region)as 公司名称,
       su.realname as 采购经理,
       nvl(ccm.supplier_site_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款 ,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       nvl(crl_real.amount_received,0) as 返利含税实收,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 预计年度达成额,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 预计年度返利金额,
       '-' as 差标额,
       to_char(0) as 协议标的1, to_char(0) as 差标1, to_char(1) as 预估完成率1,
       '-' as 协议标的2, '-' as 差标2, '-' as 预估完成率2,
       '-' as 协议标的3, '-' as 差标3, '-' as 预估完成率3,
       0 as 协议标的1完成金额,0 as 协议标的2完成金额,0 as 协议标的3完成金额,'-',0 as 下阶段达成差距
from (select su.username,su.realname,sd.depart_name,sd.area_code
from sam.sys_user su,  sam.sys_user_depart sud, sam.sys_depart sd
where su.id = sud.user_id
and sud.dep_id = sd.id)a,sam.cmx_contract_main ccm
left join sups s3 on ccm.supplier_code = s3.supplier
join sam.cmx_rebate_head crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
left join (select crl.head_id,sum(crll.amount_received) as amount_received
             from sam.cmx_rebate_line crl,sam.cmx_rebate_line_real crll 
             where crl.id = crll.line_id
              and to_date(crll.receive_period,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
             group by crl.head_id
          ) crl_real on crl_real.head_id = crl.head_id
join sam.cmx_rebate_terms crt on crh.id = crt.rebate_id and crt.is_line = 1
where crt.auto_cal_flag = 1
and crt.formula_type in ('RETURN_RATIO_RT','QTY_DIFF_REGION_PSIP','QTY_DIFF_REGION_DISTRIBUTION'
                        ,'BALANCE_MIN_RATIO','BALANCE_MIN_FIXED_PRICE','QTY_STOCK_FIXED_PRICE')
and crh.rebate_year = '${year}' --返利年度
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_site_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
--and 1=1 ${if(len(areaname)=0,""," and (select region_name from region where region=ccm.region)  in ('"+areaname +"')")}
and 1=1 ${if(len(area)=0,""," and ccm.region in ('"+area +"')")}
and ccm.region=(case when a.area_code<>100 then to_char(a.area_code) else to_char( ccm.region) end)
and ${"a.username='"+$fr_username+"'"}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year,ccm.region, su.realname,
      ccm.supplier_site_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause),nvl(crl_real.amount_received,0)
   union all     
-- 线上-自动计算-回款金额按账期天数
select t.返利头ID,t.返利年度,t.公司名称,t.采购经理,t.供应商地点代码,t.供应商名称,t.协议条款 ,t.协议口径实际达成,t.实际应收返利,t.返利含税实收,
(case when t.search_months=0 then 0 else (t.协议口径实际达成/t.search_months*t.all_months)end)as 预计年度达成额,
(case when t.search_months=0 then 0 else (t.协议口径实际达成/t.search_months*t.all_months)*nvl(b1.settlemeent_param,0) end)as 预计年度返利金额,
'-' as 差标额,
       '-' as 协议标的1, '-' as 差标1, '-' as 预估完成率1,
       '-' as 协议标的2, '-' as 差标2, '-' as 预估完成率2,
       '-' as 协议标的3, '-' as 差标3, '-' as 预估完成率3,
       0 as 协议标的1完成金额,0 as 协议标的2完成金额,0 as 协议标的3完成金额,'-',0 as 下阶段达成差距

/*nvl(b1.settlemeent_param,0) as 协议标的1计算参数,
nvl(b2.settlemeent_param,0) as 协议标的2计算参数,
nvl(b3.settlemeent_param,0) as 协议标的3计算参数,
t.all_months as 规则期间长度,
t.search_months as 统计月份*/
from (
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       (select region_name from region where region=ccm.region)as 公司名称,
       su.realname as 采购经理,
       nvl(ccm.supplier_site_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       nvl(crl_real.amount_received,0) as 返利含税实收,
       crt.id as terms_id,crt.all_months,crt.search_months
from (select su.username,su.realname,sd.depart_name,sd.area_code
from sam.sys_user su,  sam.sys_user_depart sud, sam.sys_depart sd
where su.id = sud.user_id
and sud.dep_id = sd.id)a,sam.cmx_contract_main ccm
left join sups s3 on ccm.supplier_code = s3.supplier
join sam.cmx_rebate_head crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
left join (select crl.head_id,sum(crll.amount_received) as amount_received
             from sam.cmx_rebate_line crl,sam.cmx_rebate_line_real crll 
             where crl.id = crll.line_id
              and to_date(crll.receive_period,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
             group by crl.head_id
          ) crl_real on crl_real.head_id = crl.head_id
join (select crt2.id,crt2.rebate_id,crt2.formula_type,crt2.all_months,crt2.terms_contents,
       (case when crt2.search_months < 0 then 0 else crt2.search_months end) as search_months
from (
select id,rebate_id,formula_type,terms_contents,
       months_between(to_Date(effective_end_month,'yyyy-mm'),to_Date(effective_start_month,'yyyy-mm'))+1 as all_months,
       months_between((case when to_Date(effective_end_month,'yyyy-mm')<=to_date('${date}','yyyy-mm') 
             then to_Date(effective_end_month,'yyyy-mm') else to_date('${date}','yyyy-mm') end)
         ,to_Date(effective_start_month,'yyyy-mm'))+1 as search_months
from sam.cmx_rebate_terms  
where is_line = 1 and auto_cal_flag = 1
) crt2)crt on crh.id = crt.rebate_id
where crt.formula_type in ('PERIOD_DAYS_STEP','PERIOD_DAYS_STEP_SEG')
and crh.rebate_year = '${year}' --返利年度
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_site_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
and 1=1 ${if(len(area)=0,""," and ccm.region in ('"+area +"')")}
and ccm.region=(case when a.area_code<>100 then to_char(a.area_code) else to_char( ccm.region) end)
and ${"a.username='"+$fr_username+"'"}
--and 1=1 ${if(len(areaname)=0,""," and (select region_name from region where region=ccm.region)  in ('"+areaname +"')")}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year,ccm.region, su.realname,
      ccm.supplier_site_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause),crt.id,crt.all_months,crt.search_months,nvl(crl_real.amount_received,0)
)t
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/100 as settlemeent_param,rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition  ) as rownums
from sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
where crtr.id = crtrc.terms_reached_id
) b1 on b1.terms_id = t.terms_id and b1.rownums = 1
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/100 as settlemeent_param,rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition  ) as rownums
from sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
where crtr.id = crtrc.terms_reached_id
) b2 on b2.terms_id = t.terms_id and b2.rownums = 2
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/100 as settlemeent_param,rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition  ) as rownums
from sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
where crtr.id = crtrc.terms_reached_id
) b3 on b3.terms_id = t.terms_id and b2.rownums = 3 
union all
-- 线上-自动计算-其他
select t.返利头ID,t.返利年度,t.公司名称,t.采购经理,t.供应商地点代码,t.供应商名称,t.协议条款 ,t.协议口径实际达成,t.实际应收返利,t.返利含税实收,
(case when t.search_months=0 then 0 else(t.协议口径实际达成/t.search_months*t.all_months)end)as 预计年度达成额,
(case when t.search_months=0 then 0 when nvl(b1.condition,0)=0 then (t.协议口径实际达成/t.search_months*t.all_months)*nvl(b1.settlemeent_param,0) when (case when t.search_months=0 or nvl(b1.condition,0)<0 then 0  else((t.协议口径实际达成/t.search_months*t.all_months)-nvl(b1.condition,0))end)/nvl(b1.condition,0)<=-0.2 then 0 else (t.协议口径实际达成/t.search_months*t.all_months)*nvl(b1.settlemeent_param,0) end)as 预计年度返利金额,

to_char(case when t.search_months=0 then 0 else(t.协议口径实际达成-(t.协议口径实际达成/t.search_months*t.all_months))end) as 差标额,
to_char(case when nvl(b1.condition,0)<0 then 0 else nvl(b1.condition,0) end) as 协议标的1,
to_char(case when t.search_months=0 or nvl(b1.condition,0)<0 or nvl(b1.condition,0)=0 then 0  else((t.协议口径实际达成/t.search_months*t.all_months)-nvl(b1.condition,0))end) as 差标1,
to_char(case when t.search_months=0 then 0 when nvl(b1.condition,0)=0 then 1 when nvl(b1.condition,0)<0 then 1 else ((t.协议口径实际达成/t.search_months*t.all_months)/nvl(b1.condition,0) )end) as 预估完成率1,
to_char(case when nvl(b1.condition,0)<0 then '-' else to_char(nvl(b2.condition,0)) end) as 协议标的2, 
to_char((case when nvl(b1.condition,0)<0 then '-' when t.search_months=0 or nvl(b2.condition,0)=0 then to_char(0)   else to_char((t.协议口径实际达成/t.search_months*t.all_months)-nvl(b2.condition,0))end)) as 差标2,
to_char((case when nvl(b1.condition,0)<0 then '-' when t.search_months=0 or nvl(b2.condition,0)=0 then to_char(0)   else to_char((t.协议口径实际达成/t.search_months*t.all_months)/nvl(b2.condition,0))end)) as 预估完成率2,
to_char(case when nvl(b1.condition,0)<0 then '-' else to_char(nvl(b3.condition,0))end) as 协议标的3, 
to_char((case when nvl(b1.condition,0)<0 then '-' when t.search_months=0 or nvl(b3.condition,0)=0 then to_char(0) when nvl(b1.condition,0)=0 then to_char(0) else to_char((t.协议口径实际达成/t.search_months*t.all_months)-nvl(b3.condition,0))end)) as 差标3,
to_char((case when nvl(b1.condition,0)<0 then '-' when t.search_months=0 or nvl(b3.condition,0)=0 then to_char(0) else to_char((t.协议口径实际达成/t.search_months*t.all_months)/nvl(b3.condition,0))end)) as 预估完成率3,
case when nvl(b1.condition,0) >0 then nvl(b1.condition,0) * b1.settlemeent_param
            else 0 end as 协议标的1完成金额,
case when nvl(b2.condition,0) >0 then nvl(b2.condition,0) * b2.settlemeent_param
            else 0 end as 协议标的2完成金额,
case when nvl(b3.condition,0) >0 then nvl(b3.condition,0) * b3.settlemeent_param
            else 0 end as 协议标的3完成金额,
t.formula_type,
case when (nvl(b3.condition,0) > 0 and t.协议口径实际达成 >= nvl(b3.condition,0))
                 or (nvl(b3.condition,0) = 0 and nvl(b2.condition,0) > 0 and t.协议口径实际达成 >= nvl(b2.condition,0))
                 or (nvl(b2.condition,0) = 0 and t.协议口径实际达成 >= nvl(b1.condition,0)) 
                 then (nvl(t.协议口径实际达成,0)*
                       nvl(b3.settlemeent_param,nvl(b2.settlemeent_param,nvl(b1.settlemeent_param,0)))
                       *t.all_months/decode(t.search_months,0,1,t.search_months)) - t.返利含税实收
            when nvl(b3.condition,0) > 0 and t.协议口径实际达成 >= nvl(b2.condition,0)
                 then nvl(b3.condition,0)*b3.settlemeent_param - t.返利含税实收
            when nvl(b2.condition,0) > 0 and t.协议口径实际达成 >= nvl(b1.condition,0)
                 then nvl(b2.condition,0)*b2.settlemeent_param - t.返利含税实收
            when nvl(b1.condition,0) > 0 and t.协议口径实际达成 < nvl(b1.condition,0)
                 then nvl(b1.condition,0)*b1.settlemeent_param - t.返利含税实收
            else 0 end as 下阶段达成差距
/*nvl(b1.settlemeent_param,0) as 协议标的1计算参数,
nvl(b2.settlemeent_param,0) as 协议标的2计算参数,
nvl(b3.settlemeent_param,0) as 协议标的3计算参数,
t.all_months as 规则期间长度,
t.search_months as 统计月份*/
from (
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       (select region_name from region where region=ccm.region)as 公司名称,
       su.realname as 采购经理,
       nvl(ccm.supplier_site_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       nvl(crl_real.amount_received,0) as 返利含税实收, 
       crt.id as terms_id,crt.all_months,crt.search_months,
       crt.formula_type
from (select su.username,su.realname,sd.depart_name,sd.area_code
from sam.sys_user su,  sam.sys_user_depart sud, sam.sys_depart sd
where su.id = sud.user_id
and sud.dep_id = sd.id)a,sam.cmx_contract_main ccm
left join sups s3 on ccm.supplier_code = s3.supplier
join sam.cmx_rebate_head crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
left join (select crl.head_id,sum(crll.amount_received) as amount_received
             from sam.cmx_rebate_line crl,sam.cmx_rebate_line_real crll 
             where crl.id = crll.line_id
              and to_date(crll.receive_period,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
             group by crl.head_id
          ) crl_real on crl_real.head_id = crl.head_id
join (select crt2.id,crt2.rebate_id,crt2.formula_type,crt2.all_months,crt2.terms_contents,
       (case when crt2.search_months < 0 then 0 else crt2.search_months end) as search_months
from (
select id,rebate_id,formula_type,terms_contents,
       months_between(to_Date(effective_end_month,'yyyy-mm'),to_Date(effective_start_month,'yyyy-mm'))+1 as all_months,
       months_between((case when to_Date(effective_end_month,'yyyy-mm')<=to_date('${date}','yyyy-mm') 
             then to_Date(effective_end_month,'yyyy-mm') else to_date('${date}','yyyy-mm') end)
         ,to_Date(effective_start_month,'yyyy-mm'))+1 as search_months
from sam.cmx_rebate_terms  
where is_line = 1 and auto_cal_flag = 1
) crt2)crt on crh.id = crt.rebate_id
where not crt.formula_type in ('RETURN_RATIO_RT','QTY_DIFF_REGION_PSIP','QTY_DIFF_REGION_DISTRIBUTION',
                               'BALANCE_MIN_RATIO','BALANCE_MIN_FIXED_PRICE','QTY_STOCK_FIXED_PRICE',
                               'PERIOD_DAYS_STEP','PERIOD_DAYS_STEP_SEG')
and crh.rebate_year = '${year}' --返利年度
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_site_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
and 1=1 ${if(len(area)=0,""," and ccm.region in ('"+area +"')")}
and ccm.region=(case when a.area_code<>100 then to_char(a.area_code) else to_char( ccm.region) end)
and ${"a.username='"+$fr_username+"'"}
--and 1=1 ${if(len(areaname)=0,""," and (select region_name from region where region=ccm.region)  in ('"+areaname +"')")}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year,ccm.region, su.realname,
      ccm.supplier_site_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause),crt.id,crt.all_months,crt.search_months,crt.formula_type,nvl(crl_real.amount_received,0)
)t
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/decode(terms.formula_type,
                  'AMOUNT_FIXED_RATIO',100,'AMOUNT_RT_FIXED_RATIO',100,'AMOUNT_RT_STEP_RATIO',100,
                  'AMOUNT_RT_STEP_SEG_RATIO',100,'QTY_RT_FIXED_RATIO',100,'QTY_RT_STEP_RATIO',100,
                  'QTY_RT_STEP_SEG_RATIO',100,1) as settlemeent_param,
                   rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition ) as rownums
             from sam.cmx_rebate_terms terms,sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
            where terms.id = crtr.terms_id and crtr.id = crtrc.terms_reached_id
) b1 on b1.terms_id = t.terms_id and b1.rownums = 1
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/decode(terms.formula_type,
                  'AMOUNT_FIXED_RATIO',100,'AMOUNT_RT_FIXED_RATIO',100,'AMOUNT_RT_STEP_RATIO',100,
                  'AMOUNT_RT_STEP_SEG_RATIO',100,'QTY_RT_FIXED_RATIO',100,'QTY_RT_STEP_RATIO',100,
                  'QTY_RT_STEP_SEG_RATIO',100,1) as settlemeent_param,
                   rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition ) as rownums
             from sam.cmx_rebate_terms terms,sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
            where terms.id = crtr.terms_id and crtr.id = crtrc.terms_reached_id
) b2 on b2.terms_id = t.terms_id and b2.rownums = 2
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/decode(terms.formula_type,
                  'AMOUNT_FIXED_RATIO',100,'AMOUNT_RT_FIXED_RATIO',100,'AMOUNT_RT_STEP_RATIO',100,
                  'AMOUNT_RT_STEP_SEG_RATIO',100,'QTY_RT_FIXED_RATIO',100,'QTY_RT_STEP_RATIO',100,
                  'QTY_RT_STEP_SEG_RATIO',100,1) as settlemeent_param,
                   rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition ) as rownums
             from sam.cmx_rebate_terms terms,sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
            where terms.id = crtr.terms_id and crtr.id = crtrc.terms_reached_id
) b3 on b3.terms_id = t.terms_id and b2.rownums = 3 
union all    
-- 线下-手工计算
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       (select region_name from zux_region_ou where org_unit_id is null and  region=ccm.region )as 公司名称,
       su.realname as 采购经理,
       nvl(ccm.supplier_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款 ,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       nvl(crl_real.amount_received,0) as 返利含税实收,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as I,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as J,
       '-'as C,
       to_char(0) as K, to_char(0) as L, to_char(1) as M,
       '-' as N, '-' as O, '-' as P,
       '-' as R, '-' as S, '-' as T,
       0 as 协议标的1完成金额,0 as 协议标的2完成金额,0 as 协议标的3完成金额,'-',0 as 下阶段达成差距
from (select su.username,su.realname,sd.depart_name,sd.area_code
from sam.sys_user su,  sam.sys_user_depart sud, sam.sys_depart sd
where su.id = sud.user_id
and sud.dep_id = sd.id)a,sam.cmx_contract_main_offline ccm
left join sam.sys_depart_supplier_offline s3 on ccm.supplier_code = s3.sup_id
join sam.cmx_rebate_head_offline crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line_offline crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
left join (select crl.head_id,sum(crll.amount_received) as amount_received
             from sam.cmx_rebate_line_offline crl,sam.cmx_rebate_line_real_offline crll 
             where crl.id = crll.line_id
              and to_date(crll.receive_period,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
             group by crl.head_id
          ) crl_real on crl_real.head_id = crl.head_id
join sam.cmx_rebate_terms crt on crh.id = crt.rebate_id and crt.is_line = 0
where crt.auto_cal_flag = 0
and crh.rebate_year = '${year}' --返利年度
and ccm.region not in ('140','141')
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
and 1=1 ${if(len(area)=0,""," and ccm.region in ('"+area +"')")}
and ccm.region=(case when a.area_code<>100 then to_char(a.area_code) else to_char( ccm.region) end)
and ${"a.username='"+$fr_username+"'"}
--and 1=1 ${if(len(areaname)=0,""," and (select region_name from zux_region_ou where org_unit_id is null and  region=ccm.region)  in ('"+areaname +"')")}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year,ccm.region, su.realname,
      ccm.supplier_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause),nvl(crl_real.amount_received,0)
union all      
-- 线下-自动计算-退货率不足返利(%)\按数量统签分采补差(Qty)\按区域配送数量补差(Qty)\平衡值返利(%)\平衡值返利(Qty)\按月末库存数量固定金额返利(Qty)
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       (select region_name from zux_region_ou where org_unit_id is null and  region=ccm.region )as 公司名称,
       su.realname as 采购经理,
       nvl(ccm.supplier_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款 ,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       nvl(crl_real.amount_received,0) as 返利含税实收,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as I,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as J,
       '-'as C,
       to_char(0) as K, to_char(0) as L, to_char(1) as M,
       '-' as N, '-' as O, '-' as P,
       '-' as R, '-' as S, '-' as T,
       0 as 协议标的1完成金额,0 as 协议标的2完成金额,0 as 协议标的3完成金额,'-',0 as 下阶段达成差距
from (select su.username,su.realname,sd.depart_name,sd.area_code
from sam.sys_user su,  sam.sys_user_depart sud, sam.sys_depart sd
where su.id = sud.user_id
and sud.dep_id = sd.id)a,sam.cmx_contract_main_offline ccm
left join sam.sys_depart_supplier_offline s3 on ccm.supplier_code = s3.sup_id
join sam.cmx_rebate_head_offline crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line_offline crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
left join (select crl.head_id,sum(crll.amount_received) as amount_received
             from sam.cmx_rebate_line_offline crl,sam.cmx_rebate_line_real_offline crll 
             where crl.id = crll.line_id
              and to_date(crll.receive_period,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
             group by crl.head_id
          ) crl_real on crl_real.head_id = crl.head_id
join sam.cmx_rebate_terms crt on crh.id = crt.rebate_id and crt.is_line = 0
where crt.auto_cal_flag = 1
and crt.formula_type in ('RETURN_RATIO_RT','QTY_DIFF_REGION_PSIP','QTY_DIFF_REGION_DISTRIBUTION'
                        ,'BALANCE_MIN_RATIO','BALANCE_MIN_FIXED_PRICE','QTY_STOCK_FIXED_PRICE')
and crh.rebate_year = '${year}' --返利年度
and ccm.region not in ('140','141')
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
and 1=1 ${if(len(area)=0,""," and ccm.region in ('"+area +"')")}
and ccm.region=(case when a.area_code<>100 then to_char(a.area_code) else to_char( ccm.region) end)
and ${"a.username='"+$fr_username+"'"}
--and 1=1 ${if(len(areaname)=0,""," and (select region_name from zux_region_ou where org_unit_id is null and  region=ccm.region)  in ('"+areaname +"')")}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year,ccm.region, su.realname,
      ccm.supplier_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause),nvl(crl_real.amount_received,0)
union all
-- 线下-自动计算-其他
select t.返利头ID,t.返利年度,t.公司名称,t.采购经理,t.供应商地点代码,t.供应商名称,t.协议条款 ,t.协议口径实际达成,t.实际应收返利,t.返利含税实收,
(case when t.search_months=0 then 0 else(t.协议口径实际达成/t.search_months*t.all_months)end)as 预计年度达成额,
(case when t.search_months=0 or nvl(b1.condition,0)=0 then 0 when (case when t.search_months=0 or nvl(b1.condition,0)<0 then 0  else((t.协议口径实际达成/t.search_months*t.all_months)-nvl(b1.condition,0))end)/nvl(b1.condition,0)<=-0.2 then 0 else (t.协议口径实际达成/t.search_months*t.all_months)*nvl(b1.settlemeent_param,0) end)as 预计年度返利金额,
to_char(case when t.search_months=0 then 0 else(t.协议口径实际达成-(t.协议口径实际达成/t.search_months*t.all_months))end) as 差标额,
to_char(case when nvl(b1.condition,0)<0 then 0 else nvl(b1.condition,0) end) as 协议标的1,
to_char(case when t.search_months=0 or nvl(b1.condition,0)<0 then 0  else((t.协议口径实际达成/t.search_months*t.all_months)-nvl(b1.condition,0))end) as 差标1,
to_char(case when t.search_months=0 or nvl(b1.condition,0)=0 then 0 when nvl(b1.condition,0)<0 then 1 else ((t.协议口径实际达成/t.search_months*t.all_months)/nvl(b1.condition,0) )end) as 预估完成率1,
to_char(case when nvl(b1.condition,0)<0 then '-' else to_char(nvl(b2.condition,0)) end) as 协议标的2, 
to_char((case when nvl(b1.condition,0)<0 then '-' when t.search_months=0 or nvl(b2.condition,0)=0 then to_char(0)   else to_char((t.协议口径实际达成/t.search_months*t.all_months)-nvl(b2.condition,0))end)) as 差标2,
to_char((case when nvl(b1.condition,0)<0 then '-' when t.search_months=0 or nvl(b2.condition,0)=0 then to_char(0)   else to_char((t.协议口径实际达成/t.search_months*t.all_months)/nvl(b2.condition,0))end)) as 预估完成率2,
to_char(case when nvl(b1.condition,0)<0 then '-' else to_char(nvl(b3.condition,0))end) as 协议标的3, 
to_char((case when nvl(b1.condition,0)<0 then '-' when t.search_months=0 or nvl(b3.condition,0)=0 then to_char(0) else to_char((t.协议口径实际达成/t.search_months*t.all_months)-nvl(b3.condition,0))end)) as 差标3,
to_char((case when nvl(b1.condition,0)<0 then '-' when t.search_months=0 or nvl(b3.condition,0)=0 then to_char(0) else to_char((t.协议口径实际达成/t.search_months*t.all_months)/nvl(b3.condition,0))end)) as 预估完成率3,
       /*nvl(b1.condition,0) as 协议标的1, nvl(b1.settlemeent_param,0) as 协议标的1计算参数,
       nvl(b2.condition,0) as 协议标的2, nvl(b2.settlemeent_param,0) as 协议标的2计算参数,
       nvl(b3.condition,0) as 协议标的3, nvl(b3.settlemeent_param,0) as 协议标的3计算参数,
       t.all_months as 规则期间长度,
       t.search_months as 统计月份*/
case when nvl(b1.condition,0) >0 then nvl(b1.condition,0) * b1.settlemeent_param
            else 0 end as 协议标的1完成金额,
case when nvl(b2.condition,0) >0 then nvl(b2.condition,0) * b2.settlemeent_param
            else 0 end as 协议标的2完成金额,
case when nvl(b3.condition,0) >0 then nvl(b3.condition,0) * b3.settlemeent_param
            else 0 end as 协议标的3完成金额,
t.formula_type,
case when (nvl(b3.condition,0) > 0 and t.协议口径实际达成 >= nvl(b3.condition,0))
                 or (nvl(b3.condition,0) = 0 and nvl(b2.condition,0) > 0 and t.协议口径实际达成 >= nvl(b2.condition,0))
                 or (nvl(b2.condition,0) = 0 and t.协议口径实际达成 >= nvl(b1.condition,0)) 
                 then (nvl(t.协议口径实际达成,0)*
                       nvl(b3.settlemeent_param,nvl(b2.settlemeent_param,nvl(b1.settlemeent_param,0)))
                       *t.all_months/decode(t.search_months,0,1,t.search_months)) - t.返利含税实收
            when nvl(b3.condition,0) > 0 and t.协议口径实际达成 >= nvl(b2.condition,0)
                 then nvl(b3.condition,0)*b3.settlemeent_param - t.返利含税实收
            when nvl(b2.condition,0) > 0 and t.协议口径实际达成 >= nvl(b1.condition,0)
                 then nvl(b2.condition,0)*b2.settlemeent_param - t.返利含税实收
            when nvl(b1.condition,0) > 0 and t.协议口径实际达成 < nvl(b1.condition,0)
                 then nvl(b1.condition,0)*b1.settlemeent_param - t.返利含税实收
            else 0 end as 下阶段达成差距              
from (
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       (select region_name from zux_region_ou where org_unit_id is null and  region=ccm.region )as 公司名称,
       su.realname as 采购经理,
       nvl(ccm.supplier_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       nvl(crl_real.amount_received,0) as 返利含税实收,
       crt.id as terms_id,crt.all_months,crt.search_months,
       crt.formula_type
from (select su.username,su.realname,sd.depart_name,sd.area_code
from sam.sys_user su,  sam.sys_user_depart sud, sam.sys_depart sd
where su.id = sud.user_id
and sud.dep_id = sd.id)a,sam.cmx_contract_main_offline ccm
left join sam.sys_depart_supplier_offline s3 on ccm.supplier_code = s3.sup_id
join sam.cmx_rebate_head_offline crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line_offline crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
left join (select crl.head_id,sum(crll.amount_received) as amount_received
             from sam.cmx_rebate_line_offline crl,sam.cmx_rebate_line_real_offline crll 
             where crl.id = crll.line_id
              and to_date(crll.receive_period,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
             group by crl.head_id
          ) crl_real on crl_real.head_id = crl.head_id
join (select crt2.id,crt2.rebate_id,crt2.formula_type,crt2.all_months,crt2.terms_contents,
       (case when crt2.search_months < 0 then 0 else crt2.search_months end) as search_months
from (
select id,rebate_id,formula_type,terms_contents,
       months_between(to_Date(effective_end_month,'yyyy-mm'),to_Date(effective_start_month,'yyyy-mm'))+1 as all_months,
       months_between((case when to_Date(effective_end_month,'yyyy-mm')<=to_date('${date}','yyyy-mm') 
             then to_Date(effective_end_month,'yyyy-mm') else to_date('${date}','yyyy-mm') end)
         ,to_Date(effective_start_month,'yyyy-mm'))+1 as search_months
from sam.cmx_rebate_terms  
where is_line = 0 and auto_cal_flag = 1
) crt2)crt on crh.id = crt.rebate_id
where not crt.formula_type in ('RETURN_RATIO_RT','QTY_DIFF_REGION_PSIP','QTY_DIFF_REGION_DISTRIBUTION',
                               'BALANCE_MIN_RATIO','BALANCE_MIN_FIXED_PRICE','QTY_STOCK_FIXED_PRICE')
and crh.rebate_year = '${year}' --返利年度
and ccm.region not in ('140','141')
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
and 1=1 ${if(len(area)=0,""," and ccm.region in ('"+area +"')")}
and ccm.region=(case when a.area_code<>100 then to_char(a.area_code) else to_char( ccm.region) end)
and ${"a.username='"+$fr_username+"'"}
--and 1=1 ${if(len(areaname)=0,""," and (select region_name from zux_region_ou where org_unit_id is null and  region=ccm.region)  in ('"+areaname +"')")}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year,ccm.region, su.realname,
      ccm.supplier_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause),crt.id,crt.all_months,crt.search_months,crt.formula_type,nvl(crl_real.amount_received,0)
)t
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/decode(terms.formula_type,
                  'AMOUNT_FIXED_RATIO',100,'AMOUNT_RT_FIXED_RATIO',100,'AMOUNT_RT_STEP_RATIO',100,
                  'AMOUNT_RT_STEP_SEG_RATIO',100,'QTY_RT_FIXED_RATIO',100,'QTY_RT_STEP_RATIO',100,
                  'QTY_RT_STEP_SEG_RATIO',100,1) as settlemeent_param,
                   rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition ) as rownums
             from sam.cmx_rebate_terms terms,sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
            where terms.id = crtr.terms_id and crtr.id = crtrc.terms_reached_id
) b1 on b1.terms_id = t.terms_id and b1.rownums = 1
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/decode(terms.formula_type,
                  'AMOUNT_FIXED_RATIO',100,'AMOUNT_RT_FIXED_RATIO',100,'AMOUNT_RT_STEP_RATIO',100,
                  'AMOUNT_RT_STEP_SEG_RATIO',100,'QTY_RT_FIXED_RATIO',100,'QTY_RT_STEP_RATIO',100,
                  'QTY_RT_STEP_SEG_RATIO',100,1) as settlemeent_param,
                   rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition ) as rownums
             from sam.cmx_rebate_terms terms,sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
            where terms.id = crtr.terms_id and crtr.id = crtrc.terms_reached_id
) b2 on b2.terms_id = t.terms_id and b2.rownums = 2
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/decode(terms.formula_type,
                  'AMOUNT_FIXED_RATIO',100,'AMOUNT_RT_FIXED_RATIO',100,'AMOUNT_RT_STEP_RATIO',100,
                  'AMOUNT_RT_STEP_SEG_RATIO',100,'QTY_RT_FIXED_RATIO',100,'QTY_RT_STEP_RATIO',100,
                  'QTY_RT_STEP_SEG_RATIO',100,1) as settlemeent_param,
                   rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition ) as rownums
             from sam.cmx_rebate_terms terms,sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
            where terms.id = crtr.terms_id and crtr.id = crtrc.terms_reached_id
) b3 on b3.terms_id = t.terms_id and b2.rownums = 3 

)order by 返利头ID


select * from (select distinct rebate_year from sam.cmx_rebate_head 
union 
select distinct rebate_year from sam.cmx_rebate_head_offline)
order by 1 desc

select distinct supplier_site_code from(select distinct to_char(supplier_code)as supplier_site_code  from sam.cmx_contract_main_offline
union all
select distinct to_char(ccm.supplier_site_code)as supplier_site_code from sam.cmx_contract_main ccm)
order by 1

select distinct sup_name from (select distinct nvl(s3.sup_name,ccm.factory_name)as sup_name from sam.cmx_contract_main ccm
left join sups s3 on ccm.supplier_code = s3.supplier
union all
select distinct nvl(s3.sup_name,ccm.factory_name)as sup_name from sam.cmx_contract_main_offline ccm
left join sam.sys_depart_supplier_offline s3 on ccm.supplier_code = s3.sup_id)

--select  distinct su.realname from sam.sys_user su



select * from (
select distinct ccm.region,su.realname  from sam.cmx_contract_main ccm
left join sups s3 on ccm.supplier_code = s3.supplier
join sam.cmx_rebate_head crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line crl on crh.id = crl.head_id 
where 1=1 ${if(len(area)=0,""," and ccm.region  in ('"+area+"')")}
and realname!='管理员'
union all
select distinct ccm.region,su.realname  from sam.cmx_contract_main_offline ccm
left join sam.sys_depart_supplier_offline s3 on ccm.supplier_code = s3.sup_id
join sam.cmx_rebate_head_offline crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line_offline crl on crh.id = crl.head_id
where 1=1 ${if(len(area)=0,""," and ccm.region  in ('"+area+"')")}
)
order by region

select distinct id from (select distinct crh.id from sam.cmx_rebate_head crh
union all 
select distinct crh.id from sam.cmx_rebate_head_offline crh)
order by 1

-- 线下-手工计算
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       su.realname as 采购经理,
       nvl(ccm.supplier_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款 ,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       --nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       --sum(crl.attribute4),
       --nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as I,
       --nvl(sum(nvl(crl.attribute4,crl.amount)),0) as J,
       '-'as C,
       0 as K, 0 as L, 1 as M,
       '-' as N, '-' as O, '-' as P,
       '-' as R, '-' as S, '-' as T
from sam.cmx_contract_main_offline ccm
left join sam.sys_depart_supplier_offline s3 on ccm.supplier_code = s3.sup_id
join sam.cmx_rebate_head_offline crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line_offline crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
join sam.cmx_rebate_terms crt on crh.id = crt.rebate_id and crt.is_line = 0
where crt.auto_cal_flag = 0
and crh.rebate_year = '${year}' --返利年度
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year, su.realname,
      ccm.supplier_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause)

select * from (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/decode(terms.formula_type,
                  'AMOUNT_FIXED_RATIO',100,'AMOUNT_RT_FIXED_RATIO',100,'AMOUNT_RT_STEP_RATIO',100,
                  'AMOUNT_RT_STEP_SEG_RATIO',100,'QTY_RT_FIXED_RATIO',100,'QTY_RT_STEP_RATIO',100,
                  'QTY_RT_STEP_SEG_RATIO',100,1) as settlemeent_param,
                   rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition ) as rownums
             from sam.cmx_rebate_terms terms,sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
            where terms.id = crtr.terms_id and crtr.id = crtrc.terms_reached_id
) b3 where b3.rownums = 3 and b3.terms_id='937'

-- 线上-自动计算-回款金额按账期天数
select t.返利头ID,t.返利年度,t.采购经理,t.供应商地点代码,t.供应商名称,t.协议条款 ,t.协议口径实际达成,t.实际应收返利,
(case when t.search_months=0 then 0 else (t.协议口径实际达成/t.search_months*t.all_months)end)as 预计年度达成额,
(case when t.search_months=0 then 0 else (t.协议口径实际达成/t.search_months*t.all_months)*nvl(b1.settlemeent_param,0) end)as 预计年度返利金额,
'-' as 差标额,
       '-' as 协议标的1, '-' as 差标1, '-' as 预估完成率1,
       '-' as 协议标的2, '-' as 差标2, '-' as 预估完成率2,
       '-' as 协议标的3, '-' as 差标3, '-' as 预估完成率3

/*nvl(b1.settlemeent_param,0) as 协议标的1计算参数,
nvl(b2.settlemeent_param,0) as 协议标的2计算参数,
nvl(b3.settlemeent_param,0) as 协议标的3计算参数,
t.all_months as 规则期间长度,
t.search_months as 统计月份*/
from (
select crh.id as 返利头ID, 
       crh.rebate_year as 返利年度,
       su.realname as 采购经理,
       nvl(ccm.supplier_site_code||'','厂家') as 供应商地点代码,
       nvl(s3.sup_name,ccm.factory_name) as 供应商名称,
       --crh.rebate_clause as 协议条款,
       nvl(crt.terms_contents,crh.rebate_clause)as 协议条款,
       nvl(sum(nvl(crl.attribute3,crl.base_amount)),0) as 协议口径实际达成,
       nvl(sum(nvl(crl.attribute4,crl.amount)),0) as 实际应收返利,
       crt.id as terms_id,crt.all_months,crt.search_months
from sam.cmx_contract_main ccm
left join sups s3 on ccm.supplier_code = s3.supplier
join sam.cmx_rebate_head crh on crh.contract_id = ccm.id
left join sam.sys_user su on crh.create_by = su.username
left join sam.cmx_rebate_line crl on crh.id = crl.head_id 
     and to_date(crl.year||'-'||crl.month,'yyyy-mm') <= to_date('${date}','yyyy-mm') --查询年月
join (select crt2.id,crt2.rebate_id,crt2.formula_type,crt2.all_months,crt2.terms_contents,
       (case when crt2.search_months < 0 then 0 else crt2.search_months end) as search_months
from (
select id,rebate_id,formula_type,terms_contents,
       months_between(to_Date(effective_end_month,'yyyy-mm'),to_Date(effective_start_month,'yyyy-mm'))+1 as all_months,
       months_between((case when to_Date(effective_end_month,'yyyy-mm')<=to_date('${date}','yyyy-mm') 
             then to_Date(effective_end_month,'yyyy-mm') else to_date('${date}','yyyy-mm') end)
         ,to_Date(effective_start_month,'yyyy-mm'))+1 as search_months
from sam.cmx_rebate_terms  
where is_line = 1 and auto_cal_flag = 1
) crt2)crt on crh.id = crt.rebate_id
where crt.formula_type in ('PERIOD_DAYS_STEP','PERIOD_DAYS_STEP_SEG')
and crh.rebate_year = '${year}' --返利年度
and 1=1 ${if(len(id)=0,""," and crh.id  in ('"+id +"')")}
and 1=1 ${if(len(supplier_code)=0,""," and ccm.supplier_site_code  in ('"+supplier_code +"')")}
and 1=1 ${if(len(sup_name)=0,""," and nvl(s3.sup_name,ccm.factory_name)  in ('"+sup_name +"')")}
and 1=1 ${if(len(realname)=0,""," and su.realname  in ('"+realname +"')")}
-- and crh.id = 5166 -- 返利头ID
--and ccm.supplier_code = -- 供应商地点代码
--and nvl(s3.sup_name,ccm.factory_name) -- 供应商名称
--and su.realname -- 采购经理
group by crh.id,crh.rebate_year, su.realname,
      ccm.supplier_site_code,nvl(s3.sup_name,ccm.factory_name),
      nvl(crt.terms_contents,crh.rebate_clause),crt.id,crt.all_months,crt.search_months
)t
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/100 as settlemeent_param,rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition  ) as rownums
from sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
where crtr.id = crtrc.terms_reached_id
) b1 on b1.terms_id = t.terms_id and b1.rownums = 1
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/100 as settlemeent_param,rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition  ) as rownums
from sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
where crtr.id = crtrc.terms_reached_id
) b2 on b2.terms_id = t.terms_id and b2.rownums = 2
left join (select crtr.terms_id,crtrc.condition,crtrc.settlemeent_param/100 as settlemeent_param,rank()over(partition by crtr.terms_id order by crtr.terms_id,crtrc.condition  ) as rownums
from sam.cmx_rebate_terms_reached crtr,sam.cmx_rebate_terms_reach_cond crtrc 
where crtr.id = crtrc.terms_reached_id
) b3 on b3.terms_id = t.terms_id and b2.rownums = 3  

select * from zux_region_ou 
where region_name='内蒙巴彦淖尔'

select region,region||'-'||region_name from (select region,region_name from region
union all
select region,region_name from zux_region_ou
where org_unit_id is null)b,(select su.username,su.realname,sd.depart_name,sd.area_code
from sam.sys_user su,  sam.sys_user_depart sud, sam.sys_depart sd
where su.id = sud.user_id
and sud.dep_id = sd.id)a
where --a.area_code=b.region
b.region=(case when a.area_code<>100 then to_char(a.area_code) else to_char( b.region) end)
and ${"a.username='"+$fr_username+"'"}
order by region

select distinct region from region order by 1

