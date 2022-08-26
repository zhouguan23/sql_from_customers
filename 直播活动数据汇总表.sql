select '抖音' name
union all
select '天猫' name
union all
select '置业通微信' name
union all
select '方天下' name
union all
select '乐居' name
union all
select '壹直播' name

select distinct area_name from dim_mkt_project

select distinct city_name 
from dim_mkt_project
where 1=1
${if(len(f3)=0,"","and area_name in ('"+f3+"')")}

select distinct proj_name 
from dim_mkt_project
where 1=1
${if(len(f3)=0,"","and area_name in ('"+f3+"')")}
${if(len(g3)=0,"","and city_name in ('"+g3+"')")}

select
concat(live_stime,'-',ifnull(right(live_etime,8),'-'))live_time                            ,live_name                              
,platform                               
,area_id                              
,area_name                           
,city_id                              
,city_name                            
,proj_id                           
,proj_name                              
,watch_pcount                         
,watch_tcount                         
,clima_online_count                    
,avg_watchtime                       
,like_pcount                           
,like_tcount                          
,comment_pcount                       
,comment_tcount                      
,share_pcount                          
,share_tcount                         
,subscribe_scount                        
,subscribe_lcount                        
,purchase_count                          
,product_pclick                          
,product_tclick                          
,lottery_times                           
,lottery_ecount                        
,lottery_wcount                          
,insertime                             
,insert_person                           
from ipt_mkt_activity
where 1=1
${if(len(area_name)=0,"","and area_name in('"+area_name+"')")}
order by 
live_stime  desc                          
,live_name                              
,platform   


select distinct area_name from ipt_mkt_activity

