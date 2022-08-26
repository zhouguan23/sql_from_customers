SELECT
dm.dept01_cd,
dm.dept01_nm,
dm.dept02_cd,
dm.dept02_nm,
dm.dept03_cd,
dm.dept03_nm,
dm.dept04_cd,
dm.dept04_nm,
dm.dept05_cd,
dm.dept05_nm,
dm.kostl,
dm.general_nm,
LOAD_USER,
dm.employee_nm emp_nm,
LOAD_DATE,
bxzt, 
z1.bxdh,
C_FPZT, 
INV_CODE,
INV_NUM,
item,
KPRQ,
FPLX ,
MONEY, 
TAX_MONEY,
TAX_TOTAL,
sm,
BZ,
SELL_TAX_NUM,
SELL_NAME,
sfhmd, 
cje,
BUY_TAX_NUM,
BUY_NAME,
sfz,
zdz,
cc,
xb,
inv_place,
pas_name,
sfzhm,
case when pzh is null then '未入账' else '入账' end as rzzt,
doctypcnm,
pzrq,
pzh
from 
(SELECT  -- 增值票部分
  LOAD_USER,
  LOAD_DATE,
  case when bxzt = 0 then '未报销'  
       when  bxzt = 1 then '报销' else null end bxzt, 
  bxdh,
  case when C_FPZT = '0' then '正常'
        when  C_FPZT = '1' then '失控'
        when   C_FPZT = '2' then '作废'
        when   C_FPZT = '3' then '红冲'
        when  C_FPZT = '4' then '异常'
           else C_FPZT end as C_FPZT, 
  a.INV_CODE,
  a.INV_NUM,
  b.item,
  KPRQ,
  case when FPLX = '01' then '增值税专用发票'
          when FPLX = '04'then '增值税普通发票' 
            when FPLX = '03' then '机动车销售统一发票'
          when FPLX = '10' then '增值税电子普通发票' 
          when FPLX = '11' then '增值税普通发票（卷票）'
          else FPLX end as FPLX ,
  MONEY, 
  a.TAX_MONEY,
  TAX_TOTAL,
  sm,
  BZ,
  SELL_TAX_NUM,
  SELL_NAME,
  case when sfhmd = 0 then '正常'
      when sfhmd = 2 then '国家黑名单'
       when sfhmd = 1 then '企业黑名单' else null end as sfhmd, 
  cje,
null  BUY_TAX_NUM,
null  BUY_NAME,
null  sfz,
null zdz,
null cc,
null xb,
null inv_place,
null pas_name,
null sfzhm
from
ods_batch_prd.ypp_tax_input_zzsfp as a
left join
 (
SELECT DISTINCT inv_code,inv_num,item
from ods_batch_prd.ypp_tax_input_zzsfp_mx 
 ) b
 on  a.inv_num = b.inv_num
 and a.INV_CODE = b.INV_CODE
where 1=1 ${IF(LEN(KBEGDA) = 0,"","AND left(kprq,10) >='"+KBEGDA+"'")}
${IF(LEN(KENDDA) = 0,"","AND left(kprq,10) <= '"+KENDDA+"'")}
 union all 
 
 
SELECT --非增值票部分
load_user,
c.load_date,
  case when bxzt = 0 then '未报销'  
        when  bxzt = 1 then '报销' else null end bxzt,
        bxdh,
        null fpzt,
         fpdm,
         fphm,
         fpmx,
         kprq,
           case when fptype = 1 then '火车票'
          when fptype = 2 then '打车票' 
          when fptype = 3 then '其他发票'
          when fptype = 4 then '机打发票' 
          when fptype = 5 then '定额发票'
           when fptype = 6 then '过路费'
            when fptype = 7 then '客运汽车'
             when fptype = 8 then '航空运输电子客票行程单'
          else null end as FPLX ,
          null MONEY,
         null TAX_MONEY,
         je,
         sm,
         null BZ,
         kpdwsh,
         kpdwmc,
         null sfhmd,
         null cje,
         gmf_nsrsbh,
         gmfmc,
         sfz,
         zdz,
         cc,
         xb,
         inv_place,
         pas_name,
         sfzhm
from ods_batch_prd.ypp_tax_inpt_wyzfp c
where 1=1 ${IF(LEN(KBEGDA) = 0,"","AND left(kprq,10) >='"+KBEGDA+"'")}
${IF(LEN(KENDDA) = 0,"","AND left(kprq,10) <= '"+KENDDA+"'")}
) as z1

LEFT JOIN
(
select 
a.cmpy_cd,
a.cmpy_nm,
a.dept01_cd,
a.dept01_nm,
a.dept02_cd,
a.dept02_nm,
a.dept03_cd,
a.dept03_nm,
a.dept04_cd,
a.dept04_nm,
a.dept05_cd,
a.dept05_nm,
a.personnel_num,
a.employee_nm,
b.kostl,
b.general_nm
from edw_cttq_prd.dim_cttq_employee_dept a
--获取成本中心
left join
(
select a.objid,a.kostl,b.general_nm
from
(
select distinct a.objid,b.kostl
from
(
select mandt,objid,tabnr
from ods_cttq_prd.hrp9510
where mandt = '800'
and begda <= from_unixtime(unix_timestamp(),'yyyyMMdd')
and endda >= from_unixtime(unix_timestamp(),'yyyyMMdd')
) a

join ods_cttq_prd.hrt9510 b
on a.mandt = b.mandt
and a.tabnr = b.tabnr
where b.bukrs = '1000'
) a
left join
(
select cost_ctr,general_nm
from ods_batch_prd.sap_co_cskt_cost_ctr_texts
where lang_key = '1'
and ctrl_area = 'CTTQ'
and valid_to_date = '99991231'
) b
on a.kostl = b.cost_ctr
) as b
on a.dept04_cd = b.objid
where a.start_date <= from_unixtime(unix_timestamp(),'yyyyMMdd')
and a.end_date >= from_unixtime(unix_timestamp(),'yyyyMMdd')
) as dm
on dm.personnel_num = lpad(z1.load_user,8,'0')
     
left join --添加凭证数据
(
SELECT --嗨报销数据
    left(a.cost_voucher_no,10) as pzh, --凭证号
    --a.cost_voucher_time as pzrq, ---凭证日期
    b.budat as pzrq,
    a.order_number as bxdh, --报销单号
    a.business_type_name as doctypcnm,
    concat(left(b.budat,4),'-',right(left(b.budat,6),2),'-',right(b.budat,2)) 
    as budat 
from 
(
select case when cost_voucher_no is null then provisional_voucher_no
        else cost_voucher_no end as cost_voucher_no,
        order_number,
        business_type_name
from ods_batch_prd.hbx_exp_order 
) a  
left join ods_cttq_prd.bkpf b
on left(a.cost_voucher_no,10) = b.belnr
and right(a.cost_voucher_no,4) = b.gjahr
and right(left(a.cost_voucher_no,14),4) = b.bukrs
    
UNION ALL
SELECT -- em数据
    b.belnr as pzh, --凭证号
    concat(LEFT(CAST(to_timestamp(b.BLDAT,'yyyyMMdd') AS string),10),' ',concat(LEFT(b.BUTIM,2),':',substring(b.BUTIM,3,2),':',RIGHT(b.BUTIM,2))) AS pzrq,
    b.docno bxdh, --报销单号
    c.doctypnm as doctypcnm,
    concat(left(d.budat,4),'-',right(left(d.budat,6),2),'-',right(d.budat,2)) 
    as budat 
from ods_batch_prd.sap_em_zbcm_fpstdraft b 
left join ods_batch_prd.sap_em_zbcm_expense c 
   on b.docno = c.expno   
left join  ods_cttq_prd.bkpf d
   on b.belnr = d.belnr
  and b.gjahr = d.gjahr
  and b.bukrs = d.bukrs
    where b.docno != '' 
) pzsj on pzsj.bxdh = z1.bxdh         
where  1=1
--部门筛选
${IF(LEN(DEPTID) =0,"", " and ( dm.cmpy_cd in ("+"'"+ treelayer(DEPTID,true,"\',\'") +"'"+")"+ 
                        " OR dm.dept01_cd in ("+"'"+treelayer(DEPTID,true,"\',\'")+"'"+")" +
                        " OR dm.dept02_cd in ("+"'"+treelayer(DEPTID,true,"\',\'")+"'"+")" +
                        " OR dm.dept03_cd in ("+"'"+treelayer(DEPTID,true,"\',\'")+"'"+")" +
                        " OR dm.dept04_cd in ("+"'"+treelayer(DEPTID,true,"\',\'")+"'"+")" +
                        " OR dm.dept05_cd in ("+"'"+treelayer(DEPTID,true,"\',\'")+"'"+")" + ")"
)}
${IF(LEN(PBEGDA) = 0,"","AND pzsj.budat >= '"+PBEGDA+"'")}
${IF(LEN(PENDDA) = 0,"","AND pzsj.budat <= '"+PENDDA+"'")}
${IF(LEN(RBEGDA) = 0,"","AND left(load_date,10) >='"+RBEGDA+"'")}
${IF(LEN(RENDDA) = 0,"","AND left(load_date,10) <= '"+RENDDA+"'")}
${if(BXZT = "('')",""," and bxzt in "+BXZT+"")}
${if(HMD = "('')",""," and sfhmd  in "+HMD+"")}
${if(FYLX = "('')",""," and doctypcnm  in "+FYLX+"")}
${if(FPZT = "('')",""," and C_FPZT  in "+FPZT+"")}
${IF(LEN(FPDM)=0,"","AND inv_code = '"+FPDM+"' ")}
${IF(LEN(FPHM)=0,"","AND inv_num = '"+FPHM+"' ")}
${IF(LEN(RLYG)=0,"","AND load_user = '"+RLYG+"' ")}
${IF(LEN(BXDH)=0,"","AND z1.bxdh = '"+BXDH+"' ")}
${IF(LEN(PZH)=0,"","AND pzh = '"+PZH+"' ")}
${IF(LEN(RLYGN)=0,"","AND emp_nm = '"+RLYGN+"' ")}
and (sell_name like '%${KPDW}%')
order by LOAD_USER


select a.doctypcnm
from
(
SELECT
distinct doctypcnm,'EM' as source
FROM edw_cttq_prd.tmp_dim_zbcm_floaninft
union all

select distinct business_type_name as doctypcnm,'HI' as source
from ods_batch_prd.hbx_exp_order 
) a
order by a.source,a.doctypcnm


