select ${v_cols} from data_flush_zdycx
where 1=1

-- isJustice是0（不是法律部）则查用户id下的数据，否则查企业下所有
${if(isJustice == 0,
" and 案件申报人=(select lastname from hrmresource where id = "+userid+") -- 自己建立的",
" and 案件申报企业 in (select subcompanyname from hrmsubcompany,(select getChildList("+companyid+") ids) t where FIND_IN_SET(id,ids))")} -- 本级或下级单位建立的

${if(v_fasjdy!=''," and 发案时间 >= '" + v_fasjdy+"'","")} 
${if(v_fasjxy!=''," and 发案时间 <= '" + v_fasjxy+"'","")} 
${if(v_sfsw!=''," and 是否涉外 = '" + v_sfsw+"'","")} 
${if(v_sfjw!=''," and 是否境外纠纷 = '" + v_sfjw+"'","")} 
${if(v_zgqy!=''," and 直管企业名称 in ('" + v_zgqy+"')","")} 
${if(v_tbdw!=''," and 案件申报企业 in ('" + v_tbdw+"')","")} 
${if(v_gj!=''," and 国家 in ('" + v_gj+"')","")} 
${if(v_sf!=''," and 省份 in ('" + v_sf+"')","")} 
${if(v_wfdsr!=''," and 我方当事人 in ('" + v_wfdsr+"')","")} 
${if(v_dfdsr!=''," and 对方当事人 like '%" + v_dfdsr+"%'","")} 
${if(v_dfdsrxz!=''," and 对方当事人性质 in ('" + v_dfdsrxz+"')","")} 
${if(v_aylx!=''," and 案由类型 in ('" + v_aylx+"')","")} 
${if(v_msay!=''," and 民事案由 in ('" + v_msay+"')","")} 
${if(v_fmsay!=''," and 非民事案由 like '%" + v_fmsay+"%'","")} 
${if(v_bdedy!=''," and 标的额 >= " + v_bdedy+"","")} 
${if(v_bdexy!=''," and 标的额 <= " + v_bdexy+"","")} 
${if(v_bjdy!=''," and 标的额：其中本金 >= " + v_bjdy+"","")} 
${if(v_bjxy!=''," and 标的额：其中本金 <= " + v_bjxy+"","")} 
${if(v_ajxz!=''," and 案件性质 in ('" + v_ajxz+"')","")} 
${if(v_ajdw!=''," and 诉讼地位 in ('" + v_ajdw+"')","")} 
${if(v_sfzdaj!=''," and 是否重大案件 = '" + v_sfzdaj+"'","")} 
${if(v_ajfj!=''," and 案件分级 in ('" + v_ajfj+"')","")} 
${if(v_ajfl!=''," and 案件分类 in ('" + v_ajfl+"')","")} 
${if(v_sfja!=''," and 是否结案 = '" + v_sfja+"'","")} 
${if(v_jarqdy!=''," and 结案日期 >= '" + v_jarqdy+"'","")} 
${if(v_jarqxy!=''," and 结案日期 <= '" + v_jarqxy+"'","")} 
${if(v_yjjasj!=''," and 预计结案时间 in ('" + v_yjjasj+"')","")} 
${if(v_jgyp!=''," and 结果预判 in ('" + v_jgyp+"')","")} 
${if(v_zxjd!=''," and 进展程序阶段 in ('" + v_zxjd+"')","")} 

 limit ${limitStart},${pageSize}
-- limit 7000,100


select count(1) from data_flush_zdycx
where 1=1

-- isJustice是0（不是法律部）则查用户id下的数据，否则查企业下所有
${if(isJustice == 0,
" and 案件申报人=(select lastname from hrmresource where id = "+userid+") -- 自己建立的",
" and 案件申报企业 in (select subcompanyname from hrmsubcompany,(select getChildList("+companyid+") ids) t where FIND_IN_SET(id,ids))")} -- 本级或下级单位建立的

${if(v_fasjdy!=''," and 发案时间 >= '" + v_fasjdy+"'","")} 
${if(v_fasjxy!=''," and 发案时间 <= '" + v_fasjxy+"'","")} 
${if(v_sfsw!=''," and 是否涉外 = '" + v_sfsw+"'","")} 
${if(v_sfjw!=''," and 是否境外纠纷 = '" + v_sfjw+"'","")} 
${if(v_zgqy!=''," and 直管企业名称 in ('" + v_zgqy+"')","")} 
${if(v_tbdw!=''," and 案件申报企业 in ('" + v_tbdw+"')","")} 
${if(v_gj!=''," and 国家 in ('" + v_gj+"')","")} 
${if(v_sf!=''," and 省份 in ('" + v_sf+"')","")} 
${if(v_wfdsr!=''," and 我方当事人 in ('" + v_wfdsr+"')","")} 
${if(v_dfdsr!=''," and 对方当事人 like '%" + v_dfdsr+"%'","")} 
${if(v_dfdsrxz!=''," and 对方当事人性质 in ('" + v_dfdsrxz+"')","")} 
${if(v_aylx!=''," and 案由类型 in ('" + v_aylx+"')","")} 
${if(v_msay!=''," and 民事案由 in ('" + v_msay+"')","")} 
${if(v_fmsay!=''," and 非民事案由 like '%" + v_fmsay+"%'","")} 
${if(v_bdedy!=''," and 标的额 >= " + v_bdedy+"","")} 
${if(v_bdexy!=''," and 标的额 <= " + v_bdexy+"","")} 
${if(v_bjdy!=''," and 标的额：其中本金 >= " + v_bjdy+"","")} 
${if(v_bjxy!=''," and 标的额：其中本金 <= " + v_bjxy+"","")} 
${if(v_ajxz!=''," and 案件性质 in ('" + v_ajxz+"')","")} 
${if(v_ajdw!=''," and 诉讼地位 in ('" + v_ajdw+"')","")} 
${if(v_sfzdaj!=''," and 是否重大案件 = '" + v_sfzdaj+"'","")} 
${if(v_ajfj!=''," and 案件分级 in ('" + v_ajfj+"')","")} 
${if(v_ajfl!=''," and 案件分类 in ('" + v_ajfl+"')","")} 
${if(v_sfja!=''," and 是否结案 = '" + v_sfja+"'","")} 
${if(v_jarqdy!=''," and 结案日期 >= '" + v_jarqdy+"'","")} 
${if(v_jarqxy!=''," and 结案日期 <= '" + v_jarqxy+"'","")} 
${if(v_yjjasj!=''," and 预计结案时间 in ('" + v_yjjasj+"')","")} 
${if(v_jgyp!=''," and 结果预判 in ('" + v_jgyp+"')","")} 
${if(v_zxjd!=''," and 进展程序阶段 in ('" + v_zxjd+"')","")} 

