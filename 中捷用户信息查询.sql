--要支持这些字段的查询
select a.fnumber 用户名,a.FCELL 手机号码,b.fnumber 用户编码,case when a.ftype =20 then '职员' else '其他' end 账号分类,a.fforbidden 账号状态,a.fcreatetime 账号开通时间,a.fpweffectivedate 密码生效时间,b.fname_l2 账号使用人姓名,g.FDISPLAYNAME_l2 账号使用人部门,g.fnumber 部门编码,g.FNAME_l2 部门名称,f.fnumber 职位编码,f.FNAME_l2 职位名称  from T_PM_USER A 
LEFT JOIN T_BD_Person B ON b.FID=a.FPERSonid
LEFT JOIN T_ORG_CtrlUnit c ON b.FCONTROLUNITID=c.fid
LEFT JOIN T_ORG_PositionMember d on d.fpersonid=b.FID
LEFT JOIN T_ORG_Position f on f.fid=d.fpositionid
LEFT JOIN T_ORG_BaseUnit g on g.fid=f.fadminorgunitid
where a.fforbidden=0 and a.fisdelete =0 and a.ftype =20
order by 账号开通时间 desc

