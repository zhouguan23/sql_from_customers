SELECT   * FROM dbo.[t_rp_fi_inncorr_endamt]A
where 1=1 
${if(len(核算年) == 0,"","and fiscal_year = '" + 核算年 + "'")}
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")}
${if(len(核算月) == 0,"","and fiscal_period = '" + 核算月 + "'")}
${if(len(内部客户编码) == 0,"","and id_corr = '" + 内部客户编码 + "'")}

