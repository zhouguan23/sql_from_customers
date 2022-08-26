select v.memberno,
       fsv.insiderid,
       v.insidercardno,
       v.insidername,
       v.mobile,
       fsv.area_code,
       r.union_area_name,
       r.area_name,
     
        fsv.chronic,
        min(r.sorted) sorted,
       count(distinct tran_no) tran_num,
       sum(tax_amount) tax_amount,
       nvl(sum(fsv.tax_amount),0)-nvl(sum(fsv.tax_cost),0) TAX_PROFIT,
       count(distinct fsv.goods_code) goods_num,
       sum(fsv.sale_qty) sale_qty,
       sum(case when is_contact='否' then tax_amount else 0 end ) tax_amount_nocontact,
       sum(case when is_contact='否' then tax_amount else 0 end )-  sum(case when is_contact='否' then tax_cost else 0 end ) TAX_PROFIT_nocontact,
       count(distinct case when   is_contact='否' then  ic.goods_code else null end) goods_num_nocontact,
       sum(case when is_contact='否' then sale_qty else 0 end ) sale_qty_nocontact,
        sum(case when is_core='是' then tax_amount else 0 end ) tax_amount_iscore,
       sum(case when is_core='是' then tax_amount else 0 end )-  sum(case when is_core='是' then tax_cost else 0 end ) TAX_PROFIT_iscore,
        sum(case when is_contact='是' then tax_amount else 0 end ) tax_amount_iscontact,
       sum(case when is_contact='是' then tax_amount else 0 end )-  sum(case when is_contact='是' then tax_cost else 0 end ) TAX_PROFIT_iscontact,
        count(distinct case when is_contact='否' then tran_no else null end ) tran_num_nocontact,
          count(distinct case when is_contact='是' then tran_no else null end ) tran_num_iscontact
       
  from dm_VIP_CHRONIC_goods fsv
    join  (select  insiderid,min(member_date) member_date from  DM_VIP_CHRONIC_DETAIL 
    where    1=1  ${if(len(ill_type)=0,"","and chronic in('"+ill_type+"')")}
    group by insiderid ) cd 
    on fsv.insiderid = cd.insiderid
   and fsv.sale_date >= cd.MEMBER_DATE 
  left join (
select goods_code,is_core,is_contact,row_number () over (partition by goods_code order by create_date desc ) rn from dim_illness_catalogue) ic
    on fsv.goods_code = ic.goods_code
    and rn=1
 
 left join dim_vip v
   on fsv.insiderid = v.insiderid
   and decode(fsv.area_code,'11','10','22','20',fsv.area_code) = decode(fsv.area_code,'11','10','22','20',v.area_code)
  left join dim_region r
    on fsv.area_code = r.area_code
  left join dim_cus c
    on fsv.area_code = c.area_code
   and fsv.cus_code = c.cus_code,(select * from USER_AUTHORITY) u
  
 where  (r.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}
and   sale_date between date'${start_date}' and 
date'${end_date}'
      and  1=1  ${if(len(memberno)=0,"","and v.memberno in('"+memberno+"')")}
         and  1=1  ${if(len(insidercardno)=0,"","and v.insidercardno in('"+insidercardno+"')")}
         and  1=1  ${if(len(insidername)=0,"","and v.insidername in('"+insidername+"')")}
and  1=1  ${if(len(mobile)=0,"","and v.mobile in('"+mobile+"')")}
    
    and  1=1  ${if(len(area)=0,"","and fsv.area_code in('"+area+"')")}
        and  1=1  ${if(len(cus)=0,"","and c.cus_code in('"+cus+"')")}
   and  1=1  ${if(len(UNION_AREA)=0,"","and r.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
      and  1=1  ${if(len(attribute)=0,"","and c.attribute in('"+attribute+"')")} 
and c.attribute in ('直营','加盟')   --and not regexp_like(v.insidername, '(工卡|公卡|药店|药房)')
   
group by 
v.memberno,
fsv.insiderid,
       v.insidercardno,
       v.insidername,
       v.mobile,
       fsv.area_code,
       r.union_area_name,
       r.area_name,
      
       fsv.chronic
       order by sorted

select distinct ill_type from dim_illness_catalogue

select a.* from dim_vip a,DM_VIP_CHRONIC_DETAIL b
where a.insiderid=b.insiderid


