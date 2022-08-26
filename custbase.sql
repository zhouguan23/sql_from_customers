select c.cust_id,cust_short_name,busi_addr,order_tel, cust_seg,
case when  base_type='Z' then '食杂店'
when  base_type='B' then  '便利店'
when  base_type='N' then '商场'
when  base_type='Y' then '烟酒店'
when  base_type='F' then '娱乐服务'
when  base_type='Q' then '其他'
when  base_type='S' then  '超市'
else ''  end jyyt_name, 
case when work_port='C' then '城市' 
when work_port='X' then '乡村' end  work_port,
case when cust_type3='011' then '城区'
when cust_type3='012' then '镇区'
when cust_type3='013' then '特殊镇区'
when cust_type3='023' then '较好农村'
when cust_type3='024' then '较差农村'
else ' 其他' end dili,
 csco.domain_name,
 cop.periods_name,
 ldr.rut_name,

 case when pay_type='10' then '现金结算'
 when pay_type='20' then '电子结算'
 else  '其他'
  end paytype,sls.note
from co_cust c,
 csc_order_periods cop,
 csc_cust ct,
 csc_orderdomain csco,
 ldm_cust_dist lcd,
 ldm_dist_rut ldr,
 slsman sls 
 where c.cust_id=ct.cust_id and lcd.cust_id(+)=c.cust_id
 and ct.periods_id=cop.periods_id 
 and ct.domain_id=csco.domain_id
 and c.status='02' and c.slsman_id=sls.slsman_id
 and c.com_id='10371701'
 and lcd.rut_id=ldr.rut_id
 and sls.slsman_id='${slsman}'

select  b.position_code slsid,a.organ_name  slsname
from  pub_organ@hzyx.us.oracle.com a,pub_stru@hzyx.us.oracle.com b,pub_organ@hzyx.us.oracle.com c,
(select distinct slsman_id from co_cust@hzyx.us.oracle.com where status='02') s
where a.organ_id=b.organ_id
and b.parent_id=c.organ_id
and s.slsman_id=b.position_code
and b.stru_type='02'
and b.stru_level='5'  
and substr(c.organ_code,5,4)||'0100'='${dptno}'

select years,years2 from 
(
select to_char(sysdate,'yyyy') years from dual
),
(
SELECT  TO_CHAR(add_months(to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd'),-12),'YYYY' ) years2 FROM DUAL
)

