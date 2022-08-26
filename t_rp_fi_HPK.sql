SELECT  * FROM dbo.[t_rp_fi_HPK]A
where 1=1 
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")
+if(len(客户代码) == 0,"","and id_corr like '%" + 客户代码 + "%'")
+if(len(客户名称) == 0,"","and name_corr like '%" + 客户名称 + "%'")
+if(len(经销商代码) == 0,"","and id_supcorr like '%" + 经销商代码 + "%'")
+if(len(经销商名称) == 0,"","and name_corr like '%" + 经销商名称 + "%'")
+" and date_out >= '" +kdate_begin+"'"
 +" and date_out <= '" +kdate_end+"'"}

 order by id_corr desc

SELECT * FROM dbo.[t_rp_fi_HPKdetail1]A
where 1=1 
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")
+if(len(客户代码) == 0,"","and id_corr like '%" + 客户代码 + "%'")
+if(len(客户名称) == 0,"","and name_corr like '%" + 客户名称 + "%'")
+if(len(经销商代码) == 0,"","and id_supcorr like '%" + 经销商代码 + "%'")
+if(len(经销商名称) == 0,"","and name_corr like '%" + 经销商名称 + "%'")
+" and date_out >= '" +kdate_begin+"'"
 +" and date_out <= '" +kdate_end+"'"}

 order by id_corr desc

SELECT * FROM dbo.[t_rp_fi_HPKdetail2]A
where 1=1 
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")
+if(len(客户代码) == 0,"","and id_corr like '%" + 客户代码 + "%'")
+if(len(客户名称) == 0,"","and name_corr like '%" + 客户名称 + "%'")
+if(len(经销商代码) == 0,"","and id_supcorr like '%" + 经销商代码 + "%'")
+if(len(经销商名称) == 0,"","and name_corr like '%" + 经销商名称 + "%'")
+" and date_rcv >= '" +kdate_begin+"'"
 +" and date_rcv <= '" +kdate_end+"'"}

 order by id_corr desc

