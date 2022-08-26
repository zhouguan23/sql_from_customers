SELECT * FROM dbo.[t_rp_fi_income_cost]A
where 1=1 
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")}
${if(len(核算年) == 0,"","and fiscal_year = '" + 核算年 + "'")}

SELECT * FROM dbo.[t_rp_fi_income_cost]A
where 1=1 
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")}
${if(len(核算年) == 0,"","and fiscal_year = '" + (核算年-1) + "'")}

SELECT * FROM dbo.[acgl_07]A
where 1=1 
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")}
${if(len(核算年) == 0,"","and fiscal_year = '" + 核算年 + "'")}

SELECT * FROM dbo.[acgl_07]A
where 1=1 
${if(len(公司) == 0,"","and id_com = '" + 公司 + "'")}
${if(len(核算年) == 0,"","and fiscal_year = '" + (核算年-1) + "'")}

