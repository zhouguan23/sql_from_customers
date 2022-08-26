select '抖音' name
union all
select '天猫' name
union all
select '置业通微信' name
union all
select '房天下' name
union all
select '乐居' name
union all
select '壹直播' name
union all
select '零距离' name
union all
select '搜狐' name
union all
select '365淘房' name

select distinct area_name from dim_mkt_project

select distinct city_name 
from dim_mkt_project
where 1=1
${if(len(g3)=0,"","and area_name in ('"+g3+"')")}

select distinct proj_name 
from dim_mkt_project
where 1=1
${if(len(g3)=0,"","and area_name in ('"+g3+"')")}
${if(len(h3)=0,"","and city_name in ('"+h3+"')")}

select
live_stime  
,live_etime                            
,live_name                              
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
${if(INARRAY("S-股份信息部营销小组", fine_role)>0||fine_username='huafa',"","and insert_person ='"+fine_username+"'")}
ORDER BY live_stime DESC


