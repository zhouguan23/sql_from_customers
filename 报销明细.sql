select  
case when len(b.PROC_INST_ID_)!=0 then b.PROC_INST_ID_ else a.BillNumber end  BillNumber,
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
CostCoding,
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
case when len( a.AdaltState)=0 then c.TEXT_ else a.AdaltState end AdaltState,
IsSelfdriving

  from  
[TB费用报销单]A a
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.[ACT_HI_PROCINST]A b on a.BillNumber=b.BUSINESS_KEY_
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.act_hi_varinst c on c.NAME_='process_state'  
and  b.PROC_INST_ID_=c.PROC_INST_ID_   
where c.TEXT_ in ('0','1','2','3','4','5','6','8')
and 1=1 ${if(len(bm) == 0,   "",   "and a.ChargeDeptCode in ('" + replace(bm,",","','")+"')") } 
AND   1=1 ${if(len(XM) == 0,   "",   "and a.CostCoding in ('" + replace(XM,",","','")+"')") } 
AND   1=1 ${if(zt=="6","and c.TEXT_ in ('6') and CONVERT(varchar(6),b.END_TIME_,112)='"+YM+"'",   "and c.TEXT_ not in ('6')  ") } 

select * from 
tb职员用户表

select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryCode+' '+CategoryName CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryLevel between 1 and 2



select CategoryItemCode,CategoryCode,CategoryCode+''+CategoryName CategoryName,Controllable,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode,CategoryLevel  from 
TB费用科目表
where  CategoryLevel='1' and CategoryItemCode ='0000' 
order by 1,6,5,cast(CategoryCode as int)





