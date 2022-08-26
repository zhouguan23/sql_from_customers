SELECT 总部门 FROM 部门

select * from 
tb职员用户表

select FNumber,FName_L2 from 
T_ORG_Admin
where FIsSealUp='0' and  FNumber like '${=E4}%'
order by 1



select CategoryItemCode,CategoryCode,CategoryCode+' '+CategoryName CategoryName,Controllable,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode,CategoryLevel  from 
TB费用科目表
where  CategoryLevel='1' and CategoryItemCode ='0000' 
order by 1,6,5,cast(CategoryCode as int)






select case when rank()  over(order by CategoryLevel)=1 then '' else  ParentCategoryCode end  F_ID,CategoryCode ID,CategoryCode, CategoryCode+' '+CategoryName  CategoryName,ParentCategoryCode,CategoryLevel,CategoryLengCode from
TB分类对照表 a 

where a.CategoryItemCode='0003'  and a.CategoryLevel>=0
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

SELECT * FROM 
tb报销单据附件表

select CategoryItemCode,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel,Controllable,FlowCode from 
TB费用科目表
where  CategoryLevel='1' and CategoryItemCode ='0003'
order by 1,6,5,cast(CategoryCode as int)






select * from 
TB费用科目表
where  CategoryLevel='0' and CategoryItemCode ='0003'
order by 1,6,5,cast(CategoryCode as int)






select CategoryCode,CategoryCode+' '+CategoryName CategoryName,case when ParentCategoryCode='0000' then '' else ParentCategoryCode end ParentCategoryCode
 from TB费用科目表 
where  CategoryLevel>='0' and CategoryItemCode ='0000' 
order by CategoryLevel

select  
b.PROC_INST_ID_ BillNumber,
AccountingUnitCode,
ItemType,
BuildDate,
BuildYM,
BuildDeptCode,
BuildManCode,
BuildManName,
BuildEmployment,
ChargePayentCode,
PayeeMan,
PayeeBank,
PayeeAccount,
InsideID,
case when CostCoding1 is not  null and len(CostCoding1)!=0 and CostCoding1 !='' then CostCoding1 else CostCoding end  CostCoding,
Participator,
ChargeDeptCode,
InvoiceType,
YearChargeMoney,
EndChargeMoney,
ChargeMoney,
CEMoney,
TaxRate,
CEMoneyExt,
ZbRemark,
Remark,
case when len(c.TEXT_)!=0 then c.TEXT_ else a.AdaltState end AdaltState,
IsSelfdriving

  from  
[TB费用报销单]A a
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.[ACT_HI_PROCINST]A b on a.BillNumber=b.BUSINESS_KEY_
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.act_hi_varinst c on c.NAME_='process_state'  
and  b.PROC_INST_ID_=c.PROC_INST_ID_  

where   a.BillNumber = '${requestid}'  or b.PROC_INST_ID_ in ('${djh}')

order by b.PROC_INST_ID_,InsideID


select * from 
[proopreateinfo]A 

 where proInstanceId='${djh}'
 order by opreateTime asc 

