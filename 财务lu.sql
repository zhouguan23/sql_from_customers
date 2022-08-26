select DISTINCT  dd.fname_l2 "事业部",SUBSTR(cc.fnumber,0,2) "科室编码"
from 
T_DXQ_ProjectItem aa
left join T_BD_Person bb on aa.FPROJECTMANAGERID=bb.fid
left join T_ORG_BaseUnit cc on aa.cfbizorgid=cc.fid
left join T_ORG_BaseUnit dd on aa.cfadminorunitid=dd.fid
where
SUBSTR(cc.fnumber,0,2) in ('31','32','33','34','35','36','37','91')


select   aa.fname_l2 "项目名称",aa.fnumber "项目编码",bb.fname_l2 "项目经理",cc.fname_l2 "科室名称",cc.fnumber "科室编码",dd.fname_l2 "事业部",dd.fnumber "事业部编码"
from 
T_DXQ_ProjectItem aa
left join T_BD_Person bb on aa.FPROJECTMANAGERID=bb.fid
left join T_ORG_BaseUnit cc on aa.cfbizorgid=cc.fid
left join T_ORG_BaseUnit dd on aa.cfadminorunitid=dd.fid
where 
dd.fname_l2 in ('${事业部}')
and bb.fname_l2 in ('${项目经理}')
order by aa.fnumber desc

select  bb.fname_l2 "项目经理"
from 
T_DXQ_ProjectItem aa
left join T_BD_Person bb on aa.FPROJECTMANAGERID=bb.fid
left join T_ORG_BaseUnit cc on aa.cfbizorgid=cc.fid
left join T_ORG_BaseUnit dd on aa.cfadminorunitid=dd.fid
where
dd.fname_l2 = '${事业部}'

SELECT 
 a.FNumber AS "单据编号",
 a.FBizDate AS "业务日期",
  case when a.FBillStatus in ('4') then '成本确认单'
 else '成本确认单' end  AS "单据类型",
 b.FNumber AS "往来户编码",
 b.FName_l2 AS "往来户名称",
 c.CFNTAmount AS "不含税金额",
 c.CFTax AS "税额",
 j.cftaxrateval AS "税率",
 c.CFTAmount AS "价税合计",
 d.FNumber AS "项目编码",
 d.FName_l2 AS "项目",
 e.FNumber AS "部门编码",
 e.FName_l2 AS "部门",
 f.FNumber AS "业务科室编码",
 f.FName_l2 AS "业务科室",
 g.FNumber AS "项目经理编码",
 g.FName_l2 AS "项目经理",
 h.fnumber AS "项目类型编码",
 h.FName_l2 AS "项目类型",
 a.FDescription AS "摘要",
 a.FBillStatus AS "单据状态"
FROM CT_ZJT_CostConfirm  a 
 LEFT JOIN T_BD_Supplier  b ON a.CFSupplierID=b.FID
 LEFT JOIN CT_ZJT_CostConfirmEntry  c ON a.FID=c.FParentID
 LEFT JOIN T_DXQ_ProjectItem  d ON c.CFProNumberID=d.FID
 LEFT JOIN T_SM_PurContract  i ON a.CFPurContractNumID=i.FID
 LEFT JOIN  CT_BD_Taxrate  j ON c.CFTaxRateID=j.FID
 LEFT JOIN CT_BD_ProjectType  h ON d.CFProjectTypeID=h.FID
 LEFT JOIN T_BD_Person  g ON d.FProjectManagerID=g.FID
 LEFT JOIN T_ORG_BaseUnit  e ON d.CFADMINORUNITID=e.FID
 LEFT JOIN T_ORG_BaseUnit  f ON d.CFBIZORGID=f.FID
WHERE  a.FBillStatus IN ('4','7')
and  d.FName_l2 in ('${项目名称}')

 select * from
( SELECT 
 a.FNumber AS "单据编号",
 a.FBizDate AS "业务日期",
   case when a.FBASESTATUS in ('4') then '成本调整单'
 else '成本调整单' end  AS "单据类型",
 b.FNumber AS "往来户编码",
 b.FName_l2 AS "往来户名称",
 c.FAmount AS "不含税金额",
   case when a.FBASESTATUS in ('4') then 0
 else 0 end  AS "税额",
    case when a.FBASESTATUS in ('4') then 0
 else 0 end  AS "税率",
 c.FAmount AS "价税合计",
  d.FNumber AS "项目编码",
 d.FName_l2 AS "项目",
 e.FNumber AS "部门编码",
 e.FName_l2 AS "部门",
 f.FNumber AS "业务科室编码",
 f.FName_l2 AS "业务科室",
 g.FNumber AS "项目经理编码",
 g.FName_l2 AS "项目经理",
 h.fnumber AS "项目类型编码",
 h.FName_l2 AS "项目类型",
  a.FDescription AS "摘要",
 a.FBASESTATUS AS "单据状态"
FROM
 T_CL_CostAdjustBill  a 
 LEFT JOIN T_CL_CostAdjustBillEntry  c ON a.FID=c.FPARENTID
 LEFT JOIN T_BD_Supplier  b ON a.FSupplierID=b.FID
 LEFT JOIN T_DXQ_ProjectItem  d  ON a.CFProjectItemID=d.FID
 LEFT JOIN T_BD_Person  g ON d.FProjectManagerID=g.FID
 LEFT JOIN T_ORG_BaseUnit  e ON d.CFADMINORUNITID=e.FID
 LEFT JOIN T_ORG_BaseUnit  f ON d.CFBIZORGID=f.FID
 LEFT JOIN CT_BD_ProjectType  h ON d.CFProjectTypeID=h.FID
WHERE    a.FBASESTATUS in ('4')
and (a.FNumber like '%EXP%' OR a.FNumber like '%CA%')

union all
 
   SELECT 
    i.FNumber AS "单据编号",
 i.FBizDate AS "业务日期",
    case when i.FBaseStatus in ('4') then '销售出库单'
 else '销售出库单' end  AS "单据类型",
 j.FNumber AS "往来户编码",
 j.FName_l2 AS "往来户名称",
 k.FActualCost AS "不含税金额",
 k.FLocalTax AS "税额",
 k.FTaxRate AS "税率",
 k.FLocalAmount AS "价税合计",
 d.FNumber AS "项目编码",
 d.FName_l2 AS "项目",
 e.FNumber AS "部门编码",
 e.FName_l2 AS "部门",
 f.FNumber AS "业务科室编码",
 f.FName_l2 AS "业务科室",
 g.FNumber AS "项目经理编码",
 g.FName_l2 AS "项目经理",
 h.fnumber AS "项目类型编码",
 h.FName_l2 AS "项目类型",
 i.FZhaiyao AS "摘要",
 i.FBaseStatus AS "单据状态"
FROM
 T_IM_SaleIssueBill  i 
 LEFT JOIN T_IM_SaleIssueEntry  k ON i.FID=k.FParentID
 LEFT JOIN T_BD_Customer  j ON i.FCustomerID=j.FID
 LEFT JOIN T_DXQ_ProjectItem  d  ON i.CFProjectitemID=d.FID
 LEFT JOIN CT_BD_KSType  m ON d.CFCusSupTypeID=m.FID
 LEFT JOIN CT_BD_ProjectType  h ON d.CFProjectTypeID=h.FID
 LEFT JOIN T_BD_Province  n ON d.CFProvinceID=n.FID
 LEFT JOIN T_BD_Currency  o ON i.FCurrencyID=o.FID
 LEFT JOIN T_BD_Material  p ON k.FMaterialID=p.FID
 LEFT JOIN T_BD_City  r ON d.CFCityID=r.FID
 LEFT JOIN CT_BD_KSType  s ON d.CFCusSupTypeChildI=s.FID
 LEFT JOIN T_SD_SaleOrder  u ON k.FSaleOrderID=u.FID
 LEFT JOIN CT_BD_ContractProType  "CT_BD_ContractProType" ON u.CFExContrProTypeID="CT_BD_ContractProType".FID
 LEFT JOIN T_BD_Person  g ON d.FProjectManagerID=g.FID
 LEFT JOIN T_ORG_BaseUnit  e ON d.CFADMINORUNITID=e.FID
 LEFT JOIN T_ORG_BaseUnit  f ON d.CFBIZORGID=f.FID
 LEFT JOIN T_ORG_BaseUnit  v ON k.FSaleOrgUnitID=v.FID
WHERE   i.FBaseStatus in ('4','7')
 AND v.FNUMBER NOT LIKE '%DL%'
)
where 项目 in ('${项目名称}')

select * from 
(SELECT 
  a.FNumber AS "单据编号",
     case when a.FState in ('70') then '费用报销单'
 else  '费用报销单' end  AS "单据类型",
 b.fcreatetime AS "业务日期",
 c.Fname_l2 AS "申请人姓名",
 d.FNumber AS "费用支付科室编码",
 d.FName_l2 AS "费用支付科室名称",
 e.FNumber AS "费用类型编码",
 e.FName_l2 AS "费用类型名称",
 f.FAmountApprovedWithoutTax AS "不含税金额",
  f.FTaxApproved AS "增值税金额",
 g.FNumber AS "项目编码",
 g.FName_l2 AS "项目",
 h.FNumber AS "部门编码",
 h.FName_l2 AS "部门",
 d.FNumber AS "业务科室编码",
 d.FName_l2 AS "业务科室",
 i.FNumber AS "项目经理编码",
 i.FName_l2 AS "项目经理",
 j.fnumber AS "项目类型编码",
 j.FName_l2 AS "项目类型",
  a.FCause AS "事由",
 k.FName_l2 AS "支付类型",
 a.FState AS "单据状态",
 NULL   AS "交通工具",
NULL AS "出发地点",
NULL AS "目标地点",
NULL AS "开始日期",
NULL AS "结束日期",
NULL AS "飞机票价",
NULL AS "民航发展基金",
NULL AS "燃油附加费",
NULL AS "长途交通费",
NULL AS "长途交通费税率",
NULL AS "长途交通费税额",
NULL AS "不含税长途交通费",
NULL AS "市内交通费",
NULL AS "不含税住宿费",
NULL AS "税率",
NULL AS "税额",
NULL AS "住宿费",
NULL AS "其他",
NULL AS "出差补助费"


FROM
 T_BC_BizAccountBill  a 
 LEFT JOIN T_BC_BizAccountBillEntry  f ON a.FID=f.FBillID
 LEFT JOIN T_DXQ_ProjectItem  g ON f.CFExProjectItemID=g.FID
 LEFT JOIN T_BC_ExpenseType  e ON f.FExpenseTypeID=e.FID
 LEFT JOIN CT_BD_PaymentType  k ON a.CFEXPAYMENTTYPEID=k.FID
 LEFT JOIN T_BOT_Relation  m ON a.FID=m.FSrcObjectID
 INNER JOIN T_GL_VOUCHER  b ON b.FID=m.FDestObjectID
 LEFT JOIN CT_BD_ProjectType  j ON g.CFProjectTypeID=j.FID
 LEFT JOIN T_BD_Person  i ON g.FProjectManagerID=i.FID
 LEFT JOIN T_ORG_BaseUnit  h ON g.CFADMINORUNITID=h.FID
 LEFT JOIN T_ORG_BaseUnit  d ON g.CFBIZORGID=d.FID
 LEFT JOIN T_BD_Person  c ON a.FApplierID=c.FID
WHERE   (( a.FState='70' and k.Fnumber='01') or ( a.FState='80' and k.Fnumber='03')or ( a.FState='60' and k.Fnumber='03'))

 

 union all
 
 SELECT 
 n.FNumber AS "单据编号",
     case when n.FState in ('70') then '差旅费报销单'
 else  '差旅费报销单' end  AS "单据类型",
 b.fcreatetime AS "业务日期",
 c.Fname_l2 AS "申请人姓名",
 d.FNumber AS "费用支付科室编码",
 d.FName_l2 AS "费用支付科室名称",
 e.FNumber AS "费用类型编码",
 e.FName_l2 AS "费用类型名称",
 o.FAMOUNTAPPROVEDORIWITHOUTTAX AS "不含税金额",
 o.FTaxApproved AS "增值税金额",
 g.FNumber AS "项目编码",
 g.FName_l2 AS "项目",
 h.FNumber AS "部门编码",
 h.FName_l2 AS "部门",
 d.FNumber AS "业务科室编码",
 d.FName_l2 AS "业务科室",
 i.FNumber AS "项目经理编码",
 i.FName_l2 AS "项目经理",
 j.fnumber AS "项目类型编码",
 j.FName_l2 AS "项目类型",
  n.FCause AS "事由",
  k.FName_l2 AS "支付类型",
   n.FState AS "单据状态",
 o.FVehicle AS "交通工具",
 o.FFROM AS "出发地点",
 o.FTO AS "目标地点",
 o.FSTARTDATE AS "开始日期",
 o.FENDDATE AS "结束日期",
 o.CFAIRFAREEX AS "飞机票价",
 o.CFDEVELAMTEX AS "民航发展基金",
 o.CFFUELSURCHARGEEX AS "燃油附加费",
 o.FBUSSESEXPENSE AS "长途交通费",
 o.CFCTTAXRATEEX AS "长途交通费税率",
 o.CFCTTAXEX AS "长途交通费税额",
 o.CFCTNOTAXAMTEX AS "不含税长途交通费",
 o.FTAXIEXPENSE AS "市内交通费",
 o.FHOTELEXPENAPPWITHOUTTAX AS "不含税住宿费",
 o.FTAXRATE AS "税率",
 o.FTAXAPPROVED AS "税额",
 o.FHOTELEXPENSE AS "住宿费",
 o.FOTHEREXPENSE AS "其他",
 o.FEVENTIONSUBSIDY AS "出差补助费"

FROM
 T_BC_TravelAccountBill  n 
 LEFT JOIN CT_BD_PaymentType  k ON n.cfexpaymenttypeid=k.FID
 LEFT JOIN T_BC_TravelAccountBillEntry  o ON n.FID=o.FBillID
 LEFT JOIN T_DXQ_ProjectItem  g  ON o.CFProInitBillID=g.FID
 LEFT JOIN T_BC_ExpenseType  e ON o.FExpenseTypeID=e.FID
 LEFT JOIN T_BOT_Relation  m ON n.FID=m.FSrcObjectID
 INNER JOIN T_GL_VOUCHER  b ON b.FID=m.FDestObjectID
 LEFT JOIN CT_BD_ProjectType  j ON g.CFProjectTypeID=j.FID
 LEFT JOIN T_BD_Person  i ON g.FProjectManagerID=i.FID
 LEFT JOIN T_ORG_BaseUnit  h ON g.CFADMINORUNITID=h.FID
 LEFT JOIN T_ORG_BaseUnit  d ON g.CFBIZORGID=d.FID
 LEFT JOIN T_BD_Person  c ON n.FApplierID=c.FID
WHERE  
  (( n.FState='70' and k.Fnumber='01') or ( n.FState='80' and k.Fnumber='03')or ( n.FState='60' and k.Fnumber='03'))
)
where 项目 in ('${项目名称}')

select * from
(SELECT 
 a.FNumber AS "单据编号",
 a.FBizDate AS "业务日期",
 case when  a.FBaseStatus in (4) then '销售出库单'
 else '销售出库单' end  AS "单据类型",
 b.FNumber AS "往来户编码",
 b.FName_l2 AS "往来户名称",
 c.FLocalNonTaxAmount AS "不含税金额",
 c.FLocalTax AS "税额",
 c.FTaxRate AS "税率",
 c.FLocalAmount AS "价税合计",
 d.FName_l2 AS "专业类型",
 e.FNumber AS "项目编码",
 e.FName_l2 AS "项目",
 f.FNumber AS "部门编码",
 f.FName_l2 AS "部门",
 g.FNumber AS "业务科室编码",
 g.FName_l2 AS "业务科室",
 h.FNumber AS "项目经理编码",
 h.FName_l2 AS "项目经理",
 i.fnumber AS "项目类型编码",
 i.FName_l2 AS "项目类型",
 a.FContractNumber AS "合同编号",
 a.FZhaiyao AS "摘要",
 a.FBaseStatus AS "单据状态"
FROM
 T_IM_SaleIssueBill  a 
 LEFT JOIN T_IM_SaleIssueEntry  c ON a.FID=c.FParentID
 LEFT JOIN T_BD_Customer  b ON a.FCustomerID=b.FID
 LEFT JOIN T_DXQ_ProjectItem  e  ON a.CFProjectitemID=e.FID
 LEFT JOIN CT_BD_KSType  j ON e.CFCusSupTypeID=j.FID
 LEFT JOIN CT_BD_ProjectType  i ON e.CFProjectTypeID=i.FID
 LEFT JOIN T_BD_Province  k ON e.CFProvinceID=k.FID
 LEFT JOIN T_BD_Currency  l ON a.FCurrencyID=l.FID
 LEFT JOIN T_BD_Material  m ON c.FMaterialID=m.FID
 LEFT JOIN T_BD_City  n ON e.CFCityID=n.FID
 LEFT JOIN CT_BD_KSType  o ON e.CFCusSupTypeChildI=o.FID
 LEFT JOIN T_SD_SaleOrder  p ON c.FSaleOrderID=p.FID
 LEFT JOIN CT_BD_ContractProType  d ON p.CFExContrProTypeID=d.FID
 LEFT JOIN T_BD_Person  h ON e.FProjectManagerID=h.FID
 LEFT JOIN T_ORG_BaseUnit  f ON e.CFADMINORUNITID=f.FID
 LEFT JOIN T_ORG_BaseUnit  g ON e.CFBIZORGID=g.FID
 LEFT JOIN T_ORG_BaseUnit  q ON c.FSALEORGUNITID=q.FID
 WHERE  
  a.FBaseStatus in ('4','7')
 AND q.FNUMBER NOT LIKE '%DL%'

 
union all

SELECT 
 r.FNumber AS "单据编号",
 r.FBizDate AS "业务日期",
 case when r.FBillStatus in (4) then '收入确认单'
 else '收入确认单' end  AS "单据类型",
 b.FNumber AS "往来户编码",
 b.FName_l2 AS "往来户名称",
 u.CFIncConNoTax AS "不含税金额",
 u.CFIncConTaxMon AS "税额",
 x.CFTaxrateval AS "税率",
 u.CFIncConHasTaxMon AS "价税合计",
 d.FName_l2 AS "专业类型",
 e.FNumber AS "项目编码",
 e.FName_l2 AS "项目",
 f.FNumber AS "部门编码",
 f.FName_l2 AS "部门",
 g.FNumber AS "业务科室编码",
 g.FName_l2 AS "业务科室",
 h.FNumber AS "项目经理编码",
 h.FName_l2 AS "项目经理",
 i.fnumber AS "项目类型编码",
 i.FName_l2 AS "项目类型",
 y.FNumber AS "合同编号",
 r.FDescription AS "摘要",
 r.FBillStatus AS "单据状态"
FROM
 CT_RM_IncRecBill  r 
 LEFT JOIN T_BD_Customer  b ON r.CFCustomerID=b.FID
 LEFT JOIN T_SD_SaleContract  y ON r.CFSaleContracNumID=y.FID
 LEFT JOIN CT_RM_IncRecBillEntry  u  ON r.FID=u.FParentID
 LEFT JOIN T_BD_Material  m ON u.CFMaterielNumID=m.FID
 LEFT JOIN T_DXQ_ProjectItem  e  ON r.CFProNumID=e.FID
 LEFT JOIN CT_BD_KSType  j ON e.CFCusSupTypeID=j.FID
 LEFT JOIN CT_BD_ProjectType  i ON e.CFProjectTypeID=i.FID
 LEFT JOIN T_BD_Province  k ON e.CFProvinceID=k.FID
 LEFT JOIN CT_BD_KSType  o ON e.CFCusSupTypeChildI=o.FID
 LEFT JOIN T_BD_City  n ON e.CFCityID=n.FID
 LEFT JOIN T_BD_Currency  l ON r.CFCurrencyID=l.FID
 LEFT JOIN CT_BD_Taxrate  x ON u.CFTaxRateID=x.FID
 LEFT JOIN T_ORG_BaseUnit  f ON e.CFADMINORUNITID=f.FID
 LEFT JOIN T_ORG_BaseUnit  g ON e.CFBIZORGID=g.FID
 LEFT JOIN T_BD_Person  h ON e.FProjectManagerID=h.FID
 LEFT JOIN CT_BD_ContractProType  d ON u.CFMajorTypeID=d.FID
WHERE   r.FBillStatus IN ('4','7')
 and d.fnumber  in ('A1001','A1003')
union all
select 

TAP.单据编号 AS "单据编号",
TAP.核销日期 AS "业务日期",
 case when  TAP.单据编号 is not null then '出库应收核销表'
 else '出库应收核销表' end  AS "单据类型",
 TAP.往来户编码 AS "往来户编码",
 TAP.往来户名称 AS "往来户名称",
 ROUND(TAP.金额本位币 -TIS.金额本位币,2) AS "不含税金额",
 TAP.税额本位币 AS "税额",
 TAP.税率 AS "税率",
 TAP.应收金额本位币 AS "价税合计",
 TIS.项目类型 AS "专业类型",
 TAP.项目编码 AS "项目编码",
 TAP.项目 AS "项目",
 TAP.部门编码 AS "部门编码",
 TAP.部门 AS "部门",
 TAP.业务科室编码 AS "业务科室编码",
 TAP.业务科室 AS "业务科室",
 TAP.项目经理编码 AS "项目经理编码",
 TAP.项目经理 AS "项目经理",
 TAP.项目类型编码 AS "项目类型编码",
 TAP.项目类型 AS "项目类型",
 TIS.合同编号 AS "合同编号",
 TIS.摘要 AS "摘要",
 TIS.单据状态 AS "单据状态"

 
from 
(SELECT distinct
z.fnumber AS "单据编号",
z.FWriteOffDate AS "核销日期",
m.FNumber AS  "物料编码",
m.fname_l2 AS  "物料名称",
aa.FNumber AS "应收单编号",
case when z.FNumber IS NOT null then '应收单' else '应收单' end  AS "单据类型",
ab.FCOREBILLNUMBER AS "核心单据编号",
ab.FCOREBILLENTRYSEQ AS "核心单据分录行号",
ab.FPRICE AS "单价",
ab.FTAXPRICE AS "含税单价",
ab.FQUANTITY AS "数量",
ab.FTAXRATE AS "税率",
ab.FTaxAmountLocal AS "税额本位币",
ab.FAmountLocal AS "金额本位币",
ab.FRECIEVEPAYAMOUNTLOCAL AS "应收金额本位币",
e.FNumber AS "项目编码",
 e.FName_l2 AS "项目",
 b.FNumber AS "往来户编码",
 b.FName_l2 AS "往来户名称", 
f.FNumber AS "部门编码",
 f.FName_l2 AS "部门",
 g.FNumber AS "业务科室编码",
 g.FName_l2 AS "业务科室",
 h.FNumber AS "项目经理编码",
 h.FName_l2 AS "项目经理",
  i.fnumber AS "项目类型编码",
  i.FName_l2 AS "项目类型",
 case when z.FNumber IS NOT null then '' else '' end AS "合同编号",
 aa.FAbstractName AS "摘要",
 aa.FBillStatus AS "单据状态",
  case when z.FNumber IS NOT null then '' else '' end  AS "合同专业类型"
FROM
 T_AR_OtherBill  aa 
 LEFT JOIN T_AR_OtherBillentry  ab ON aa.FID=ab.FPARENTID
 LEFT JOIN T_CL_WriteOffRecord  ac ON ab.FID=ac.FBillEntryID
 LEFT JOIN T_CL_WriteOffGroup  z ON ac.FParentID=z.FID 
 LEFT JOIN T_BD_Material  m ON ab.FMATERIALID=m.FID 
 LEFT JOIN T_DXQ_ProjectItem  e ON aa.CFProjectItemID=e.FID
 LEFT JOIN T_ORG_BaseUnit  f ON e.CFADMINORUNITID=f.FID
 LEFT JOIN T_ORG_BaseUnit  g ON e.CFBIZORGID=g.FID
 LEFT JOIN T_BD_Person  h ON e.FProjectManagerID=h.FID
 LEFT JOIN T_BD_Customer  b ON aa.FAsstActID=b.FID
 LEFT JOIN CT_BD_ProjectType  i ON e.CFProjectTypeID=i.FID
where z.fnumber is not null
)  TAP

LEFT JOIN 

(
SELECT distinct
z.fnumber AS "单据编号",
z.FWriteOffDate AS "核销日期",
m.FNumber AS  "物料编码",
m.fname_l2 AS  "物料名称",
a.FNumber AS "应收单编号",
case when z.FNumber IS NOT null then '销售出库单' else '销售出库单' end  AS "单据类型",
c.FSALEORDERNUMBER AS "核心单据编号",
c.FSALEORDERENTRYSEQ AS "核心单据分录行号",
c.FSalePrice AS "单价",
c.FTAXPRICE AS "含税单价",
ac.FCURRWRITTENOFFQTY AS "数量",
c.FTAXRATE AS "税率",
ac.FCURRWRITTENOFFQTY*(c.FTAXPRICE-c.FSalePrice) AS "税额本位币",
c.FSalePrice*ac.FCURRWRITTENOFFQTY AS "金额本位币",
c.FTAXPRICE*ac.FCURRWRITTENOFFQTY AS "应收金额本位币",
e.FNumber AS "项目编码",
 e.FName_l2 AS "项目",
 b.FNumber AS "往来户编码",
 b.FName_l2 AS "往来户名称", 
f.FNumber AS "部门编码",
 f.FName_l2 AS "部门",
 g.FNumber AS "业务科室编码",
 g.FName_l2 AS "业务科室",
 h.FNumber AS "项目经理编码",
 h.FName_l2 AS "项目经理",
   i.fnumber AS "项目类型编码",
    i.FName_l2 AS "项目类型",
	 a.FContractNumber AS "合同编号",
	  a.FZhaiyao AS "摘要",
 a.FBaseStatus AS "单据状态",
 d.FName_l2  AS "合同专业类型"

FROM
 T_IM_SaleIssueBill  a 
 LEFT JOIN T_IM_SaleIssueEntry  c ON a.FID=c.FPARENTID
 LEFT JOIN T_CL_WriteOffRecord  ac ON c.FID=ac.FBillEntryID
 LEFT JOIN T_CL_WriteOffGroup  z ON ac.FParentID=z.FID 
 LEFT JOIN T_BD_Material  m ON c.FMATERIALID=m.FID 
LEFT JOIN T_DXQ_ProjectItem  e ON a.CFProjectitemID=e.FID
LEFT JOIN T_BD_Customer  b ON a.FCustomerID=b.FID
  LEFT JOIN T_SD_SaleOrder  p ON c.FSaleOrderID=p.FID
 LEFT JOIN CT_BD_ContractProType  d ON p.CFExContrProTypeID=d.FID
  LEFT JOIN T_BD_Person  h ON e.FProjectManagerID=h.FID
 LEFT JOIN T_ORG_BaseUnit  f ON e.CFADMINORUNITID=f.FID
 LEFT JOIN T_ORG_BaseUnit  g ON e.CFBIZORGID=g.FID
 LEFT JOIN T_ORG_BaseUnit  q ON c.FSALEORGUNITID=q.FID
  LEFT JOIN CT_BD_ProjectType  i ON e.CFProjectTypeID=i.FID
where z.fnumber is not null

) TIS  ON  TAP.单据编号 =TIS.单据编号 AND TAP.物料编码 =TIS.物料编码 AND TAP.核心单据编号 =TIS.核心单据编号  AND TAP.核心单据分录行号 =TIS.核心单据分录行号

where ROUND(TAP.金额本位币 -TIS.金额本位币,2) !=0
)
where 项目 in ('${项目名称}')

select * from
(SELECT 
 a.FNumber AS "单据编号",
 a.FBizDate AS "业务日期",
 case when a.FBillStatus in (4) then '收入确认单'
 else '收入确认单' end  AS "单据类型",
 b.FNumber AS "往来户编码",
 b.FName_l2 AS "往来户名称",
 c.CFIncConNoTax AS "不含税金额",
 c.CFIncConTaxMon AS "税额",
 d.CFTaxrateval AS "税率",
 c.CFIncConHasTaxMon AS "价税合计",
 e.FName_l2 AS "专业类型",
 f.FNumber AS "项目编码",
 f.FName_l2 AS "项目",
 g.FNumber AS "部门编码",
 g.FName_l2 AS "部门",
 h.FNumber AS "业务科室编码",
 h.FName_l2 AS "业务科室",
 i.FNumber AS "项目经理编码",
 i.FName_l2 AS "项目经理",
 j.fnumber AS "项目类型编码",
 j.FName_l2 AS "项目类型",
 k.FNumber AS "合同编号",
 a.FDescription AS "摘要",
 a.FBillStatus AS "单据状态"
FROM
 CT_RM_IncRecBill  a 
 LEFT JOIN T_BD_Customer  b ON a.CFCustomerID=b.FID
 LEFT JOIN T_SD_SaleContract  k ON a.CFSaleContracNumID=k.FID
 LEFT JOIN CT_RM_IncRecBillEntry  c  ON a.FID=c.FParentID
 LEFT JOIN T_BD_Material  m ON c.CFMaterielNumID=m.FID
 LEFT JOIN T_DXQ_ProjectItem  f  ON a.CFProNumID=f.FID
 LEFT JOIN CT_BD_KSType  n ON f.CFCusSupTypeID=n.FID
 LEFT JOIN CT_BD_ProjectType  j ON f.CFProjectTypeID=j.FID
 LEFT JOIN T_BD_Province  o ON f.CFProvinceID=o.FID
 LEFT JOIN CT_BD_KSType  p ON f.CFCusSupTypeChildI=p.FID
 LEFT JOIN T_BD_City  q ON f.CFCityID=q.FID
 LEFT JOIN T_BD_Currency  r ON a.CFCurrencyID=r.FID
 LEFT JOIN CT_BD_Taxrate  d ON c.CFTaxRateID=d.FID
 LEFT JOIN T_ORG_BaseUnit  g ON f.CFADMINORUNITID=g.FID
 LEFT JOIN T_ORG_BaseUnit  h ON f.CFBIZORGID=h.FID
 LEFT JOIN T_BD_Person  i ON f.FProjectManagerID=i.FID
 LEFT JOIN CT_BD_ContractProType  e ON c.CFMajorTypeID=e.FID
WHERE  a.FBillStatus IN ('4','7')
 and e.fnumber not in ('A1001','A1003')
)
where 项目 in ('${项目名称}')

