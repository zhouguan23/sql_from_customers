SELECT   * FROM dbo.[t_rp_mrpres_out_in]A where 1=1 and planm_no > '2017' 
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")} 
${if(len(核算年) == 0,"","and fiscal_year = '" + 核算年 + "'")} 
${if(len(核算月) == 0,"","and fiscal_period = '" + 核算月 + "'")}
${if(len(生产计划号) == 0,"","and planm_no = '" + 生产计划号 + "'")}
${if(len(物料代码) == 0,"","and id_item = '" + 物料代码 + "'")}
${if(len(领料人) == 0,"","and name_user = '" + 领料人 + "'")}
${if(len(入库物料) == 0,"","and id_initem = '" + 入库物料 + "'")}
${if(len(指令类型) == 0,"","and plan_type = '" + 指令类型 + "'")}


