SELECT  * FROM dbo.[t_rp_fi_dcstrever]A 
where 1=1 
${if(len(核算年) == 0,"","and fiscal_year = '" + 核算年 + "'")}
${if(len(核算月) == 0,"","and fiscal_period = '" + 核算月 + "'")}
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")}
${if(len(订单号) == 0,"","and dcstorder_no = '" + 订单号 + "'")}
${if(len(成本对象) == 0,"","and id_cstobject like '%" + 成本对象 + "%'")}

