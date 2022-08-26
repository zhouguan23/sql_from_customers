select * from (
select 
scorecard_code,
scorecard_name,
distributor_type,
qtr_vol_phasing_total,
qtr_vol_phasing_product,
ytd_vol_phasing_total,
ytd_vol_phasing_product
,icam,
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
 from  ext.fw_scorecard_performance_output_fnl
	)a
	where send =1		
and icam=N'${name}'


select 
scorecard_code,
scorecard_name,
distributor_type,
qtr_vol_phasing_total,
qtr_vol_phasing_product,
ytd_vol_phasing_total,
ytd_vol_phasing_product
,icam
from ext.fw_scorecard_performance_output_fnl

select * from report.fine_user


select scorecard_code,
scorecard_name,
distributor_type

,icam from report.fw_scorecard_performance_output_fnl


select distinct distributor_type from ext.fw_scorecard_performance_output_fnl

select * from ext.fw_scorecard_performance_output_fnl
where scorecard_code = '12259651'

