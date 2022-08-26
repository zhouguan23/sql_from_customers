SELECT  * from dbo.[t_rp_sale_debitnt_acar]A a where 1=1 and a.id_com='${kid_com}'
${if(len(kname_seller)==0,""," and a.name_seller like '%" +kname_seller+"%'" )
 +if(len(kname_corr)==0,""," and a.name_corr like '%" +kname_corr+"%'" )
 +if(len(kid_corr)==0,""," and a.id_corr like '%" +kid_corr+"%'" )
 +if(len(kname_supcorr)==0,""," and a.name_supcorr like '%" +kname_supcorr+"%'" )
 +if(len(kid_supcorr)==0,""," and a.id_supcorr like '%" +kid_supcorr+"%'" )
 +" and a.date_out >= '" +kdate_begin+"'"
 +" and a.date_out <= '" +kdate_end+"'" 
 +if(len(kflag_status)==0,""," and a.flag_status like '%" +kflag_status+"%'" )
 +if(len(kname_area)==0,""," and a.name_area like '%" +kname_area+"%'" )
 }  and (a.id_seller='${fr_username}' 
or exists(select * from n9bjwt.dbo.thkp_ctlm1007 h inner join n9bjwt.dbo.thkp_ctlm1007 i on h.id_com=i.id_com
			where h.id_com=a.id_com and h.id_clerksup='${fr_username}'  and i.id_clerk=a.id_seller and charindex(h.id_dept,i.id_dept)>0)
or  exists(select * from ctlm1005_com j where j.id_com=a.id_com and j.id_user='${fr_username}' and j.id_menu='t_rp_sale_debitnt' and j.flag_grant='Y')
)
 

SELECT   * FROM dbo.[t_rp_sale_debitnt_final]A
where 1=1 and id_com='${kid_com}'
 ${if(len(kname_corr)==0,""," and name_corr like '%" +kname_corr+"%'" )}
 ${if(len(kid_corr)==0,""," and id_corr like '%" +kid_corr+"%'" )} 



SELECT   * FROM dbo.[t_rp_sale_debitnt_rcvnot]A a
where 1=1 and a.id_com='${kid_com}'
${if(len(kname_seller)==0,""," and a.name_seller like '%" +kname_seller+"%'" )
 +if(len(kname_corr)==0,""," and a.name_corr like '%" +kname_corr+"%'" )
 +if(len(kid_corr)==0,""," and a.id_corr like '%" +kid_corr+"%'" )
 }
 and (a.id_seller='${fr_username}' 
or exists(select * from n9bjwt.dbo.thkp_ctlm1007 h inner join n9bjwt.dbo.thkp_ctlm1007 i on h.id_com=i.id_com
			where h.id_com=a.id_com and h.id_clerksup='${fr_username}'  and i.id_clerk=a.id_seller and charindex(h.id_dept,i.id_dept)>0)
or  exists(select * from ctlm1005_com j where j.id_com=a.id_com and j.id_user='${fr_username}' and j.id_menu='t_rp_sale_debitnt' and j.flag_grant='Y')
)


SELECT  * FROM dbo.[t_rp_sale_debitnt_salenot]A a
 where 1=1  and a.id_com='${kid_com}'
${if(len(kname_seller)==0,""," and a.name_seller like '%" +kname_seller+"%' " )
 +if(len(kname_corr)==0,""," and a.name_corr like '%" +kname_corr+"%' " )
 +if(len(kid_corr)==0,""," and a.id_corr like '%" +kid_corr+"%' " )
 }
and (a.id_seller='${fr_username}' 
or exists(select * from n9bjwt.dbo.thkp_ctlm1007 h inner join n9bjwt.dbo.thkp_ctlm1007 i on h.id_com=i.id_com
			where h.id_com=a.id_com and h.id_clerksup='${fr_username}'  and i.id_clerk=a.id_seller and charindex(h.id_dept,i.id_dept)>0)
or  exists(select * from ctlm1005_com j where j.id_com=a.id_com and j.id_user='${fr_username}' and j.id_menu='t_rp_sale_debitnt' and j.flag_grant='Y')
)


SELECT  * FROM dbo.[t_rp_sale_debitnt_setdetail]A a
 where 1=1 and a.id_com='${kid_com}' 
  ${if(len(kname_seller)==0,""," and a.name_seller like '%" +kname_seller+"%'" )
 +if(len(kname_corr)==0,""," and a.name_corr like '%" +kname_corr+"%'" )
 +if(len(kid_corr)==0,""," and a.id_corr like '%" +kid_corr+"%'" )
 +if(len(kname_supcorr)==0,""," and a.name_supcorr like '%" +kname_supcorr+"%'" )
 +if(len(kid_supcorr)==0,""," and a.id_supcorr like '%" +kid_supcorr+"%'" )
 +" and a.date_rcv >= '" +kdate_begin+"'"
 +" and a.date_rcv <= '" +kdate_end+"'" }
and (a.id_seller='${fr_username}' 
or exists(select * from n9bjwt.dbo.thkp_ctlm1007 h inner join n9bjwt.dbo.thkp_ctlm1007 i on h.id_com=i.id_com
			where h.id_com=a.id_com and h.id_clerksup='${fr_username}'  and i.id_clerk=a.id_seller and charindex(h.id_dept,i.id_dept)>0)
or  exists(select * from ctlm1005_com j where j.id_com=a.id_com and j.id_user='${fr_username}' and j.id_menu='t_rp_sale_debitnt' and j.flag_grant='Y')
)

 order by a.date_rcv,a.date_out asc

SELECT * FROM dbo.[v_rp_sale_debitnt_overall]A a
where 1=1 and a.id_com='${kid_com}'
${if(len(kname_seller)==0,""," and a.name_seller like '%" +kname_seller+"%'" )}
 ${if(len(kname_corr)==0,""," and a.name_corr like '%" +kname_corr+"%'" )}
 ${if(len(kid_corr)==0,""," and a.id_corr like '%" +kid_corr+"%'" )}
 ${" and a.date_out <= '" +kdate_end+"'" } 
 ${if(len(kname_supcorr)==0,""," and a.name_supcorr like '%" +kname_supcorr+"%'" )}
 ${if(len(kid_supcorr)==0,""," and a.id_supcorr like '%" +kid_supcorr+"%'" )}
 and (a.id_seller='${fr_username}' 
or exists(select * from n9bjwt.dbo.thkp_ctlm1007 h inner join n9bjwt.dbo.thkp_ctlm1007 i on h.id_com=i.id_com
			where h.id_com=a.id_com and h.id_clerksup='${fr_username}'  and i.id_clerk=a.id_seller and charindex(h.id_dept,i.id_dept)>0)
or  exists(select * from ctlm1005_com j where j.id_com=a.id_com and j.id_user='${fr_username}' and j.id_menu='t_rp_sale_debitnt' and j.flag_grant='Y')
)

 

SELECT c.*,a.*,b.* FROM PUBLIC.FR_T_USER a right join PUBLIC.FR_T_CUSTOMROLE_USER b on a.id=b.userid right join PUBLIC.FR_T_CUSTOMROLE c on b.customroleid=c.id

