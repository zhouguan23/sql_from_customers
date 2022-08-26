select b.organ_name ,
case when b.REGION_NAME ='-1' then '合计' else b.car_id end ch, dlvman ,nvl(b.qty,0) sl,
nvl(u.sums, 0) yzje,  
 nvl(g.sums, 0) ghje, nvl(n.sums, 0) nxje,   
nvl(y.sums, 0) nhje,
nvl(yy.sumsh, 0) sysh,
nvl(zz.sum1532, 0) sys1532,
nvl(sanx.sumsanx, 0) syssanx,
nvl(AA.NHEPAY, 0) NHEPAY,
nvl(hzsj.sjEPAY, 0) sjEPAY,
nvl(b.pri, 0) - nvl(u.sums, 0) -
       nvl(n.sums, 0) - nvl(g.sums, 0)-nvl(y.sums, 0)-nvl(yy.sumsh, 0)-nvl(zz.sum1532, 0)-nvl(sanx.sumsanx, 0) -nvl(AA.NHEPAY, 0) -nvl(hzsj.sjEPAY, 0)   xj,
        nvl(b.pri, 0) tsum
       
  from 
   (select     e.organ_name,f.car_id,po.organ_name dlvman,
             case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME,
               d.region_id region_id,
               sum(g.qty_sum) qty,
               sum(g.amt_sum) pri
          from  co_cust b, ldm_dist c, ldm_dist_rut d, 
          co_co g, ldm_dist_line h,pub_organ e,ldm_dist_car f,pub_stru ps,pub_organ po
         where (g.born_date between '${date1}' and '${date2}')
           and g.co_num = h.co_num and c.is_mrb=1
           and c.dist_num = h.dist_num
           and g.cust_id = b.cust_id
           and c.rut_id = d.rut_id
           and c.region_id=f.region_id
           and f.dlvman_id=ps.position_code and ps.stru_type='03'
           and ps.organ_id=po.organ_id
           and g.status in ('40', '50','60')
           and (g.com_id = '10371701')
           and d.deliver_id=e.organ_code
           and (d.deliver_id='${rutid}')
         group by grouping sets ((e.organ_name,c.group_num||d.RUT_NAME, d.region_id,f.car_id,po.organ_name),())) b
                   left join 
       (select  case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) sums
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h
         where a.co_num = b.co_num
           and a.trade_flag = '0' and c.is_mrb=1
           and (b.born_date between '${date1}' and '${date2}')
          and a.co_num = h.co_num
           and c.dist_num = h.dist_num
           and a.bank_id = 'HZ1005'
           and c.rut_id = d.rut_id
           and (d.deliver_id='${rutid}')
         group by grouping sets((c.group_num||d.RUT_NAME),())) u on b.REGION_NAME = u.REGION_NAME
         left join
       (select  case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) sums
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h
         where a.co_num = b.co_num
           and a.trade_flag = '0'
           and (b.born_date between '${date1}' and '${date2}')
          and a.co_num = h.co_num
           and c.dist_num = h.dist_num and c.is_mrb=1
           and a.bank_id = 'HZ1011'
           and c.rut_id = d.rut_id
           and (d.deliver_id='${rutid}')
        group by grouping sets ((c.group_num||d.RUT_NAME),())) n on b.REGION_NAME = n.REGION_NAME
              left join  
       (select case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) sums
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h
         where a.co_num = b.co_num and c.is_mrb=1
          and a.trade_flag = '0'
            and (b.born_date between '${date1}' and '${date2}')
           and a.co_num = h.co_num
           and c.dist_num = h.dist_num
           and （a.bank_id = 'HZ1012' or a.bank_id='HZ95588')
           and c.rut_id = d.rut_id and (d.deliver_id='${rutid}')
         group by grouping sets ((c.group_num||d.RUT_NAME),())) G on b.REGION_NAME = G.REGION_NAME
         LEFT JOIN 
         (select case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) sums
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h
         where a.co_num = b.co_num and c.is_mrb=1
          and a.trade_flag = '0'
            and (b.born_date between '${date1}' and '${date2}')
           and a.co_num = h.co_num
           and c.dist_num = h.dist_num
           and (a.bank_id = 'HZ1511' or a.bank_id='HZ95599' or a.bank_id='95599')
           and c.rut_id = d.rut_id and (d.deliver_id='${rutid}')
         group by grouping sets ((c.group_num||d.RUT_NAME),())) Y on b.REGION_NAME = Y.REGION_NAME
LEFT JOIN 
         (select case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) sumsh
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h,co_cust cc
         where a.co_num = b.co_num and c.is_mrb=1
          and a.trade_flag = '0'
            and (b.born_date between '${date1}' and '${date2}')
           and a.co_num = h.co_num and b.cust_id=cc.cust_id
           and c.dist_num = h.dist_num
           and (cc.tax_account='372901777743705X' or cc.tax_account='372901724812645')
           and c.rut_id = d.rut_id and (d.deliver_id='${rutid}')
         group by grouping sets ((c.group_num||d.RUT_NAME),())) YY on b.REGION_NAME = YY.REGION_NAME

         
LEFT JOIN 
         (select case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) sum1532
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h,co_cust cc
         where a.co_num = b.co_num and c.is_mrb=1
          and a.trade_flag = '0'
            and (b.born_date between '${date1}' and '${date2}')
           and a.co_num = h.co_num and b.cust_id=cc.cust_id
           and c.dist_num = h.dist_num
           and (cc.tax_account='91371700056224644Q' )
           and c.rut_id = d.rut_id and (d.deliver_id='${rutid}')
         group by grouping sets ((c.group_num||d.RUT_NAME),()))  zz  on b.REGION_NAME = zz.REGION_NAME

LEFT JOIN 
         (select case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) sumsanx
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h,co_cust cc
         where a.co_num = b.co_num and c.is_mrb=1
          and a.trade_flag = '0'
            and (b.born_date between '${date1}' and '${date2}')
           and a.co_num = h.co_num and b.cust_id=cc.cust_id
           and c.dist_num = h.dist_num
           and (cc.tax_account='91371700793904535W' )
           and c.rut_id = d.rut_id and (d.deliver_id='${rutid}')
         group by grouping sets ((c.group_num||d.RUT_NAME),())) sanx on b.REGION_NAME =sanx.REGION_NAME

           LEFT JOIN 
         (select case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) NHEPAY
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h
         where a.co_num = b.co_num and c.is_mrb=1
          and a.trade_flag = '0'
            and (b.born_date between '${date1}' and '${date2}')
           and a.co_num = h.co_num
           and c.dist_num = h.dist_num
           and (a.bank_id = 'HZEPAY' or a.bank_id='HZNH' or a.bank_id='HZ95599' or a.bank_id='95599'  or a.bank_id='epay')
           and c.rut_id = d.rut_id and (d.deliver_id='${rutid}')
         group by grouping sets ((c.group_num||d.RUT_NAME),())) AA on b.REGION_NAME = AA.REGION_NAME

         
           LEFT JOIN 
         (select case when c.group_num||d.RUT_NAME is null then '-1' else c.group_num||d.RUT_NAME end REGION_NAME, sum(a.qty_trade) sjEPAY
          from co_trans_flow a, co_co b, ldm_dist c, ldm_dist_rut d, ldm_dist_line h
         where a.co_num = b.co_num and c.is_mrb=1
          and a.trade_flag = '0'
            and (b.born_date between '${date1}' and '${date2}')
           and a.co_num = h.co_num
           and c.dist_num = h.dist_num
           and (a.bank_id = 'HZJSEPAY' or bank_id='95533')
           and c.rut_id = d.rut_id and (d.deliver_id='${rutid}')
         group by grouping sets ((c.group_num||d.RUT_NAME),())) hzsj on b.REGION_NAME =hzsj.REGION_NAME

      order by b.car_id

