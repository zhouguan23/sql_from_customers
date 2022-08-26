--副卡功能费销售品订购信息(起始开户时间2019年9月7日，新订单库)
select g.*
  from
(select 
  k.prod_id 用户编码,
  k.accnbr 号码,
  k.prod_spec_name 产品名称,
  k.status 状态,
  k.cust_name 客户姓名,
  k.open_date 入网时间,
  k.stop_date 停机时间,
  k.close_date 拆机时间,
  k.main_offer 主销售品,
  k.tariff_name  销售品,
  k.if_zb_30 是否主副卡,
  k.other_role_id 副卡成员编码,
  k.other_role_name 副卡成员名称,
  k.if_rh 是否融合,
  k.rh_type_name 融合类型,
  k.rh_offer_name 融合销售品,
  k.zone_name 用户归属一级网格,
  k.group_name 用户归属二级网格,
  k.sell_num 用户对应协销人工号,
  k.sell_name 用户对应协销人,
  k.offer_id 副卡功能费销售编码,
  k.offer_name 副卡功能费销售品,
  k.eff_date 副卡功能费销售品生效时间,
  k.exp_date 副卡功能费销售品失效时间,
  k.offer_so_date 副卡功能费销售品订购时间,
  s.staff_num 副卡功能费销售品受理员工号,
  s.staff_name 副卡功能费销售品受理员,
  s.channel_id,
  s.channel_name 副卡功能费销售品营业厅,
  s.y_org_name 副卡功能费销售品营业厅归属一级网格,
  s.e_org_name 副卡功能费销售品营业厅归属二级网格

  from
(
select 
  to_char(p.offer_so_date,'yyyymmdd')||zl.prod_id||p.offer_id p_id,
  zl.prod_id,
  zl.accnbr,
  zl.prod_spec_name,
  zl.status,
  zl.cust_name,
  zl.open_date,
  zl.stop_date,
  zl.close_date,
  zl.main_offer,
  zl.exp_offer_name||zl.alr_offer_name||zl.eff_offer_name  tariff_name,
  zl.if_zb_30,
  zl.other_role_id,
  zl.other_role_name,
  zl.if_rh,
  zl.rh_type_name,
  zl.rh_offer_name,
  zl.zone_name,
  zl.group_name,
  zl.sell_num,
  zl.sell_name,
  p.offer_id,
  p.offer_name,
  p.eff_date,
  p.exp_date,
  p.offer_so_date

from  
  (select * from dsaus.det_crm_info_now 
    where status_id not in (110000,110001,110002,140002,140003)
      and other_role_id in (581,582)
      and to_char(open_date,'yyyymmdd')>=${DATE1}
      and to_char(open_date,'yyyymmdd')<=${DATE2}
  )zl,

  (select * from dsaus.det_prod_offer
   where offer_id in 
   (973402,65001401,77122,73401,73402,77123,70880,69980,67660,67560,473001,
282301,73740,78002,64260,67580,58160,9928003,66440,68680,71900,71540,283355)
   ) p
where zl.prod_id=p.prod_id(+)
) k,

(
 select 
        to_char(d.so_date,'yyyymmdd')||d.prod_id||d.offer_id p_id,
        d.acct_date,
        d.prod_id,
        d.accnbr,
        d.offer_id,
        d.offer_name,
        d.so_date,
        d.staff_num,
        d.staff_name,
        d.channel_id,
        d.channel_name,
        ch.e_org_name,
        ch.y_org_name
  
   from dsaus.det_co_order_offer d,
        dsaus.det_channel_info ch
  where d.bo_action_type_cd in ('S1','3010100000','3020400001')
    and d.channel_id=ch.channel_id
    and d.offer_id in 
     (973402,65001401,77122,73401,73402,77123,70880,69980,67660,67560,473001,
282301,73740,78002,64260,67580,58160,9928003,66440,68680,71900,71540,283355)
) s
where k.p_id=s.p_id(+)
) g,
  dsaus.jh_sys_channel_staff h
 where g.channel_id = h.channel_id(+)
 ${if(inarray(sql("dsaus","select class_id from dsaus.jh_sys_role where role_name = '"+fr_authority+"'",1,1),[1,2]A)==0,"and 1=0",
switch(sql("dsaus","select class_id from dsaus.jh_sys_role where role_name = '"+fr_authority+"'",1,1)
,2,"and 1=1"
,1,"and user_num = '"+fr_username+"'"))} 


