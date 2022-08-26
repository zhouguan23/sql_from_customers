SELECT * FROM tb职员用户表 where 职员编码='${gh}'

select a.FNumber 工号 ,a.FName_L2 姓名,g.FImageData 照片,FCell 手机号码,FIDCardNO 证件号码,FGender 性别,FBirthday 出生日期,FEMail 邮箱
,FHeight 身高,a.FNativePlace_L2 籍贯,d.FName_L2 政治面貌,f.FName_L2 民族,c.FName_L2 婚姻状况,a.FOfficePhone

 from 
T_BD_Person a
left join 
T_HR_PersonPosition b on a.FID =b.FPersonID
left join 
T_BD_HRWed c on a.FWedID =c.FID --婚姻状况
left join 
T_BD_HRPolitical d on a.FPoliticalFaceID=d.FID  --政治面貌

LEFT join 
T_BD_HRFolk f on  a.FFolkID=f.fid  --民族
left join 
T_HR_PersonPhoto g on a.FID =g.FPersonID
where a.FEmployeeTypeID in (select a.FID  from 
T_HR_BDEmployeeType a
left join 
T_BD_EmployeeModle b on a.FEmployeeModleID=b.fid
where b.FName_l2 ='在职') and  a.FNumber ='${gh}'

