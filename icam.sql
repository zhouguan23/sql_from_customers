select distinct icam from  report.fw_scorecard_performance_output_fnl

select distinct username,realName,email from (
(select 
icam,
case when distributor_type='Probation'and  qtr_vol_phasing_total <0.8 
						and ytd_vol_phasing_total<1
						then 1

  when  distributor_type ='Go forward tier2'
  		 and qtr_vol_phasing_product<0.9 and ytd_vol_phasing_product<0.9 
  		  then 1
    when  distributor_type ='Go forward tier2'
  		 AND qtr_vol_phasing_total<0.9 and ytd_vol_phasing_total<1
  		 				then 1
  when  distributor_type ='Go forward tier1'
  		 and qtr_vol_phasing_product<0.9 and ytd_vol_phasing_product<0.9 
  		  then 1
    when  distributor_type ='Go forward tier1'
  		 AND qtr_vol_phasing_total<0.9 and ytd_vol_phasing_total<1
  		 				then 1
 when  distributor_type ='GFT2 Low touch'
  		 and qtr_vol_phasing_product<0.9 and ytd_vol_phasing_product<0.9
  		 then 1
  when  distributor_type ='GFT2 Low touch' 		 
  		 and qtr_vol_phasing_total<0.9 and ytd_vol_phasing_total<1
  		 				then 1

 when distributor_type='HD' and qtr_vol_phasing_total<1 
 					   and ytd_vol_phasing_total<1
  					     then 1 		 				
  				else 0	end as send
 from  report.fw_scorecard_performance_output_fnl) a
left join(SELECT description,realName,username,email FROM [report]A.[fine_user]A 
where right(description,4)='ICAM')b
on b.realName = a.icam collate Chinese_PRC_CS_AS
)
where send=1
and username !=''
and realName !=''
and email !=''

