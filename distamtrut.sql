  select    b.dname,b.rut_id,b.rut_name,b.car_id,b.car_name,b.qty_bar,y.sums  yz,n.sums  nx,gs.sums  gs,xy.sums  xy ,xywx.sums xywx,qtfxj.sums  qtfxj ,jhs.sums  jhs,
  b.amt-y.sums-n.sums-gs.sums-xy.sums-xywx.sums-qtfxj.sums-jhs.sums,b.amt
  from 
   ( SELECT  CASE  LD.DELIVER_ID  
         WHEN '17010100'  then '直送' 
         WHEN '17030100'  then '曹县'
         WHEN '17040100'  then '成武'
         WHEN '17050100' then '单县'
         WHEN '17070100' then '东明'
         WHEN '17080100' then '巨野'
         WHEN '17090100' then '鄄城'
         WHEN '17110100' then '郓城'  end  dname,   ld.deliver_id,ld.rut_id,ODR.Rut_name,LD.CAR_ID,ODR.CAR_NAME,sum(LD.QTY_BAR) qty_bar,sum(ld.amt_sum)  amt
         FROM   v6user.O_DIST_RUT_V@HEZEXLYH  ODR,LDM_DIST  LD
         WHERE ODR.CAR_ID=LD.CAR_ID
         AND ODR.RUT_ID=LD.RUT_ID
  AND LD.DIST_DATE>=(select to_char(to_date('${date1}','yyyy-mm-dd')+1,'yyyymmdd')  from dual)
  AND LD.DIST_DATE<=(select to_char(to_date('${date2}','yyyy-mm-dd')+1,'yyyymmdd')  from dual)
  AND ODR.ORDER_DATE>='${date1}'
  AND ODR.ORDER_DATE<='${date2}'
  and ld.deliver_id='${deliverid}'
  group by ld.deliver_id,ld.rut_id,ODR.rut_name, LD.CAR_ID,ODR.CAR_NAME) b   
  
         left join  
                        
      (select  ld.deliver_id,ld.rut_id,ld.car_id,sum(cf.qty_trade) sums
          from co_trans_flow cf,  ldm_dist ld,ldm_dist_line ldl
           where cf.co_num = ldl.co_num
           and cf.trade_flag = '0' 
           and cf.trade_date>='${date1}'
           and cf.trade_date<='${date2}'
           and ld.dist_num = ldl.dist_num
           and ld.deliver_id='${deliverid}'
           and cf.bank_id = 'HZ1005'           
            group by   ld.deliver_id,ld.rut_id,ld.car_id) y on(b.deliver_id=y.deliver_id and b.car_id=y.car_id and b.rut_id=y.rut_id) 
            
            left join
            
           (select  ld.deliver_id,ld.rut_id,ld.car_id,sum(cf.qty_trade) sums
          from co_trans_flow cf,  ldm_dist ld,ldm_dist_line ldl
           where cf.co_num = ldl.co_num
           and cf.trade_flag = '0' 
          and cf.trade_date>='${date1}'
           and cf.trade_date<='${date2}'
           and ld.dist_num = ldl.dist_num
           and ld.deliver_id='${deliverid}'
           and cf.bank_id = 'HZ1011'
            group by   ld.deliver_id,ld.rut_id,ld.car_id) n  on(b.deliver_id=n.deliver_id and b.car_id=n.car_id  and b.rut_id=n.rut_id)          
       
              left join        
                      
          (select  ld.deliver_id,ld.rut_id,ld.car_id,sum(cf.qty_trade) sums
          from co_trans_flow cf, ldm_dist ld,ldm_dist_line ldl
           where cf.co_num = ldl.co_num
           and cf.trade_flag = '0' 
          and cf.trade_date>='${date1}'
           and cf.trade_date<='${date2}'
           and ld.dist_num = ldl.dist_num
           and ld.deliver_id='${deliverid}'
           and cf.bank_id in( '9558816','HZGHH5','9558808','HZGHWX')
            group by   ld.deliver_id,ld.rut_id,ld.car_id) gs  on(b.deliver_id=gs.deliver_id and b.car_id=gs.car_id  and b.rut_id=gs.rut_id )
                          
            left join                
          (select  ld.deliver_id,ld.rut_id,ld.car_id,sum(cf.qty_trade) sums
          from co_trans_flow cf,  ldm_dist ld,ldm_dist_line ldl
           where cf.co_num = ldl.co_num
           and cf.trade_flag = '0' 
          and cf.trade_date>='${date1}'
           and cf.trade_date<='${date2}'
           and ld.dist_num = ldl.dist_num
           and ld.deliver_id='${deliverid}'
           and cf.bank_id in( 'epay','HZXY')
            group by   ld.deliver_id,ld.rut_id,ld.car_id) xy  on(b.deliver_id=xy.deliver_id and b.car_id=xy.car_id  and b.rut_id=xy.rut_id)
            
            left join 
                   (select  ld.deliver_id,ld.rut_id,ld.car_id,sum(cf.qty_trade) sums
          from co_trans_flow cf,  ldm_dist ld,ldm_dist_line ldl
           where cf.co_num = ldl.co_num
           and cf.trade_flag = '0' 
          and cf.trade_date>='${date1}'
           and cf.trade_date<='${date2}'
           and ld.dist_num = ldl.dist_num
           and ld.deliver_id='${deliverid}'
           and cf.bank_id in('WFT','HZXYWX')
            group by   ld.deliver_id,ld.rut_id,ld.car_id) xywx  on(b.deliver_id=xywx.deliver_id and b.car_id=xywx.car_id   and b.rut_id=xywx.rut_id)                     
                    left join                
          (select  ld.deliver_id,ld.rut_id,ld.car_id,sum(cf.qty_trade) sums
          from co_trans_flow cf,  ldm_dist ld,ldm_dist_line ldl
           where cf.co_num = ldl.co_num
           and cf.trade_flag = '0' 
         and cf.trade_date>='${date1}'
           and cf.trade_date<='${date2}'
           and ld.dist_num = ldl.dist_num
           and ld.deliver_id='${deliverid}'
           and cf.bank_id = 'NO'
            group by   ld.deliver_id,ld.rut_id,ld.car_id) qtfxj on(b.deliver_id=qtfxj.deliver_id and b.car_id=qtfxj.car_id  and b.rut_id=qtfxj.rut_id)               
           LEFT JOIN            
            (select  ld.deliver_id,ld.rut_id,ld.car_id,sum(cf.qty_trade) sums
          from co_trans_flow cf,  ldm_dist ld,ldm_dist_line ldl
           where cf.co_num = ldl.co_num
           and cf.trade_flag = '0' 
           and cf.trade_date>='${date1}'
           and cf.trade_date<='${date2}'
           and ld.dist_num = ldl.dist_num
           and ld.deliver_id='${deliverid}'
           and (cf.bank_id = 'HZJSEPAY' or cf.bank_id='95533')
            group by   ld.deliver_id,ld.rut_id,ld.car_id) jhs on(b.deliver_id=jhs.deliver_id and b.car_id=jhs.car_id  and b.rut_id=jhs.rut_id)   
      order by b.car_id

