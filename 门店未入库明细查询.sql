----开始
SELECT 
    D.INVOICE_TYPE,
    D.ORDER_YEAR,
       D.ORDER_MONTH,
       D.SYS_ORDER_TYPE_ID,
       D.ORDER_TYPE,
       D.SSC_ORDER_ID,
       D.ORDER_NO,
       D.SYS_PAYMENT_ID,
       D.CREATION_DATE,
       D.CREATED_BY,
       D.INV_OWNER,
       D.INV_USER,
       D.SALE_BRANCH,
       D.COM_WAREHOUSE_ID,
       D.COM_SALER_ID,
       D.COM_CLIENT_ID,
       D.CHECK_DATE,
       D.ORDER_OP_FLAG,
       D.ORDER_LG_FLAG,
       DECODE(D.ORDER_FN_FLAG,'NEW','新增','ACCEPT','已开单','2IS','已勾对','SETTLE','已结算','COST','已记账','CANCEL','已作废','ADJUST','金额修正','COST','已记账') AS ORDER_FN_FLAG,
       D.ADDRESS,
       D.SYS_PRIOR,
       D.SYS_ORDER_RETURN_REASON_ID,
       D.CASH_AFF_DATE,
       D.TERMINAL_BILL_NO,
       D.TERMINAL_CLIENT_ID,
       D.MEMO,
       D.SSC_ORDER_LINES_ID,
       D.TAX_FREE_PRICE,
       D.TAX_PRICE,
       D.DISCOUNT,
       D.COM_GOODS_ID,
       D.COM_INVENTORY_TYPE_ID,
       D.ORDER_QTY,
       NVL(D.LOT_QTY,D.MEET_QTY) AS MEET_QTY,
       D.COST_QTY,
       D.TAX_FREE_AMOUNT,
       D.TAX_AMOUNT,
       D.ORDER_TAX_FEE as tax_fee,
       D.TAX_RATE,
       D.BILL_AVGPRC,
       D.CURRENT_PUR_PRICE,
       D.CURRENT_LOWER_PRICE,
       D.SYS_CHANNEL_ID,
       D.CHANNEL_OPCODE,
       D.CHANNEL_NAME,
       D.VENDER_ID,
       D.CHANNEL_PARTY_ID,
       D.CHANNEL_PARTY_NAME,
       D.SYS_PRICE_RULE_COMPOUND_ID,
       D.DEFAULT_PRICE,
       D.WHOLESALE_PRICE,
       D.RETAILSALE_PRICE,
       D.GOODS_MAKER,
       D.SEND_DATE,
       D.TARGET_TAX_PRICE,
       D.TARGET_TAX_FREE_PRICE,
       D.PAY_TAX_AMOUNT,
       D.PRO_DIFF_AMOUNT,
       D.PROTOCOL_RTN_AMOUNT,
       D.CHANNEL_DIFF_AMOUNT,
       D.CHANNEL_RTN_AMOUNT,
       D.SPECIAL_DIFF1_AMOUNT,
       D.SPECIAL_DIFF2_AMOUNT,
       D.SPECIAL_PROFIT_AMOUNT,
       D.SALE_RTN_AMOUNT,
       D.PUR_SALE_RTN_AMOUNT,
       D.CLIENT_RTN_AMOUNT,
       D.SPECIAL_LIMIT_PRICE,
       D.BUDGET_PROFIT_RATE,
       D.GPO_ACTUALLY_AMOUNT,
       D.BILL_COST,
       D.BILL_PROFIT,
       D.ORDER_COST,
       D.ORDER_PROFIT,
       D.REAL_COST,
       D.REAL_PROFIT,
       D.BC_PRICE_DIFF,
       D.BC_PRICE_DIFF_AMOUNT,
       D.SSC_ORDER_LINES_LOTS_ID,
       D.COM_LOT_ID,
       D.LOT_NO,
       D.PROD_DATE,
       D.EXPIRE_DATE,
       DECODE(NVL(D.LOT_QTY,0),0,D.ORDER_QTY,D.LOT_QTY) 
       AS LOT_QTY,
       NVL(D.LOT_TAX_FREE_AMOUNT,D.TAX_FREE_AMOUNT) AS LOT_TAX_FREE_AMOUNT,
       NVL(D.LOT_TAX_AMOUNT,D.TAX_AMOUNT) AS LOT_TAX_AMOUNT,
       NVL(D.LOT_TAX_FEE,D.ORDER_TAX_FEE) AS LOT_TAX_FEE,
       D.COM_GOODS_BATCH_ID,
       CG.GOODS_OPCODE,
       CG.GOODS_NAME,
       CG.GOODS_DESC,
       --CG.PRODUCT_LOCATION,
       CL.PRODUCT_LOCATION,
       CPF.PARTY_NAME AS FACTORY_NAME,
       CPC.PARTY_NAME AS CLIENT_NAME,
       CPC.PARTY_OPCODE AS CLIENT_OPCODE,
       CPO.PARTY_NAME AS INV_OWNER_NAME,
       CPU.PARTY_NAME AS INV_USER_NAME,
       CPB.PARTY_NAME AS SALE_BRANCH_NAME,
       CPW.PARTY_NAME AS COM_WAREHOUSE_NAME,
       SORR.REASON AS SYS_ORDER_RETURN_REASON,
       CPS.PARTY_NAME AS COM_SALER_NAME,
       CPCR.PARTY_NAME AS CREATED_BY_NAME,
       SP.PAYMENT_TYPE,
       SSP.PRIORITY_NAME,
       CIT.INVENTORY_TYPE,
       D.INVOICE_NO,
       D.COST_DATE,--记账日期
       DECODE(D.INVOICE_FN_FLAG,'NEW','未记账','COST','已记账','SETTLE','可记账','INTERFACE','转接口')as INVOICE_FN_FLAG,--记账状态
       DECODE(D.OMS_FLAG,'FINISH','已结算','FALSE','未结算')as OMS_FLAG,--结算状态
       DECODE(D.ORDER_LG_FLAG,'ACCEPT','正常','CHECKED','已理货','CANCEL','已取消') as ORDER_LG_FLAG2,--物流状态
       CU.UNIT_NAME,
       D.invoice_code,--发票编码
       D.PRINT_DATE,  --发票打印时间
       CC.CLIENT_CLASS,
       D.PACKAGE_NUM,  --包装数
       CM.COM_CLIENT_CLASS_ID,
       D.INVOICE_COST_AMOUNT,
       D.INVOICE_TAX_FREE_AMOUNT - D.INVOICE_COST_AMOUNT jzml,
       d.profit,       --批次毛利
       CL.REGISTRATION_NO,     --注册证号
       d.SETTLE_ID,       --月结单号
       KB.ORDER_NO AS OOLD_ORDER_NO,        --原销退单号
        (SELECT CPC.PASS_NO FROM Com_party_certificate CPC WHERE CPC.COM_PARTY_ID = D.COM_CLIENT_ID AND CPC.COM_PARTY_CTFC_TYPE_ID = '467') AS JYXK, --*医疗器械经营许可证  客户
       (SELECT CPC.PASS_NO FROM Com_party_certificate CPC WHERE CPC.COM_PARTY_ID = D.COM_CLIENT_ID AND CPC.COM_PARTY_CTFC_TYPE_ID = '468') AS JYBA,--第二类医疗器械经营备案  客户
        (SELECT CPC.PASS_NO FROM Com_party_certificate CPC WHERE CPC.COM_PARTY_ID = CG.FACTORY_ID AND CPC.COM_PARTY_CTFC_TYPE_ID = '456') AS CJSCXK,--*医疗器械生产许可证   生厂企业
       (SELECT CPC.PASS_NO FROM Com_party_certificate CPC WHERE CPC.COM_PARTY_ID = CG.FACTORY_ID AND CPC.COM_PARTY_CTFC_TYPE_ID = '457') AS CJSCBA,--*第一类医疗器械生产备案凭证  生产企业  
       nvl(VGS.MEDI_CODE, (select WEB_GOODS_CODE
                  from sys_goods_middle sgm
                 where d.com_goods_id = sgm.com_goods_id
                   and d.inv_owner = sgm.inv_owner
                   and sgm.order_source_id in (5000, 20000)
                   and sgm.status = 'TRUE'
                   and rownum = 1)) as MEDI_CODE,--医保代码
       C.CREATE_DATE,    --采购订单日期
       C.invoice_no as purchase_invoice_no,    --采购发票号
       C.PUR_ORDER_NO,     --采购单号
       CL.STERILIZATION_NO,    --灭菌号
       d.PATIENT_NO,         --住院号
       d.PATIENT_NAME,       --病人姓名
       (select oso.order_no from ssc_order oso where oso.ssc_order_id = d.ref_bill_id and d.sys_order_type_id in (2,12)) as old_order_no,--修正原单号
       (SELECT PARTY_NAME FROM COM_PARTY WHERE COM_PARTY_ID = CGB.VENDER_ID) AS VENDERNAME,    --供应商
       d.ORDER_LOWER_PROFIT
  FROM V_SALE_SUM D
  LEFT JOIN COM_GOODS CG ON D.COM_GOODS_ID = CG.COM_GOODS_ID
  LEFT JOIN COM_PARTY CPF ON CG.FACTORY_ID = CPF.COM_PARTY_ID
  LEFT JOIN COM_PARTY CPC ON D.COM_CLIENT_ID = CPC.COM_PARTY_ID
  LEFT JOIN COM_PARTY CPO ON D.INV_OWNER = CPO.COM_PARTY_ID
  LEFT JOIN COM_PARTY CPU ON D.INV_USER = CPU.COM_PARTY_ID
  LEFT JOIN COM_PARTY CPB ON D.SALE_BRANCH = CPB.COM_PARTY_ID
  LEFT JOIN COM_PARTY CPW ON D.COM_WAREHOUSE_ID = CPW.COM_PARTY_ID
  LEFT JOIN COM_PARTY CPS ON D.COM_SALER_ID = CPS.COM_PARTY_ID
  LEFT JOIN COM_PARTY CPCR ON D.CREATED_BY = CPCR.COM_PARTY_ID 
  LEFT JOIN SYS_ORDER_RETURN_REASON SORR ON D.SYS_ORDER_RETURN_REASON_ID =
                                            SORR.SYS_ORDER_RETURN_REASON_ID
 LEFT JOIN SYS_PAYMENT SP ON D.SYS_PAYMENT_ID = SP.SYS_PAYMENT_ID  
 LEFT JOIN SYS_SEND_PRIORITY SSP ON D.SYS_PRIOR = SSP.SYS_SEND_PRIORITY_ID
 LEFT JOIN COM_INVENTORY_TYPE CIT ON D.COM_INVENTORY_TYPE_ID = CIT.COM_INVENTORY_TYPE_ID
 LEFT JOIN COM_UNIT CU ON CG.COM_UNIT_ID = CU.COM_UNIT_ID
 left JOIN COM_LOT CL ON D.COM_LOT_ID = CL.COM_LOT_ID
 LefT JOIN com_goods_batch  CGB ON CGB.COM_GOODS_BATCH_ID = D.COM_GOODS_BATCH_ID
 LEFT JOIN V_PURCHASE_INVOICE C ON D.COM_GOODS_BATCH_ID = C.Com_Goods_Batch_Id  AND d.COM_LOT_ID = c.Com_Lot_Id
 
 LEFT JOIN V_GOODS_SJ1 VGS ON VGS.com_goods_id = D.COM_GOODS_ID
 --LEFT JOIN (SELECT B.ORDER_NO,B.SSC_ORDER_ID
  --FROM SSC_ORDER_LINES C,SSC_ORDER_LINES_LOTS A
  --INNER JOIN SSC_order B ON A.SSC_ORDER_ID = B.SSC_ORDER_ID 
  --WHERE A.SSC_ORDER_LINES_LOTS_ID = C.ORIGINAL_LINES_LOTS_ID) KB ON KB.SSC_ORDER_ID = D.SSC_ORDER_ID
 LEFT JOIN (select V3.Order_No,V1.Ssc_Order_Id from ssc_order_lines V2,ssc_order V3,
  (SELECT t3.Ssc_Order_Lines_Id, T1.Ssc_Order_Id FROM ssc_order T1 ,ssc_order_lines T2,ssc_order_lines_lots T3
  WHERE T1.SYS_ORDER_TYPE_ID = 3 
  AND T1.SSC_ORDER_ID = T2.SSC_ORDER_ID
  AND T2.ORIGINAL_LINES_LOTS_ID = T3.ssc_order_lines_lots_id
  ) V1
  where V1.Ssc_Order_lines_Id = V2.Ssc_Order_lines_Id
  and V2.Ssc_Order_Id = V3.Ssc_Order_Id)KB ON KB.SSC_ORDER_ID = D.SSC_ORDER_ID
 LEFT JOIN SYS_CLIENT_ORG_MAPPING CM ON D.COM_CLIENT_ID = CM.COM_PARTY_ID AND D.INV_OWNER = CM.OU_ID
 LEFT JOIN COM_CLIENT_CLASS CC ON CM.COM_CLIENT_CLASS_ID = CC.COM_CLIENT_CLASS_ID AND CM.OU_ID = CC.OU_ID
 where 1=1
 -- and (exists(select 1 from sys_client_def scddd where d.COM_CLIENT_ID = scddd.com_client_id --and scddd.com_saler_id = '${operatorId}') or  not exists(select 1 from sys_client_def scddd --where scddd.com_saler_id = '${operatorId}')) 
 
 ${if(len(clientClassId)==0,"","and CM.COM_CLIENT_CLASS_ID in ("+clientClassId+")")}
 ${if(len(ls_order_no)==0,"","and d.ORDER_NO like '" + ls_order_no + "%'")}
 ${if(len(ldt_creation_date1)==0,"","and d.CREATION_DATE >= to_date('" + ldt_creation_date1 + "','yyyy-mm-dd')")}
 ${if(len(ldt_creation_date2)==0,"","and d.CREATION_DATE < to_date('" + ldt_creation_date2 + "','yyyy-mm-dd') + 1")}
 ${if(len(ll_sys_order_type_id)==0,"","and d.SYS_ORDER_TYPE_ID in (" + ll_sys_order_type_id + ")")}

 ${if(len(ls_fn_flag)==0,"","and d.ORDER_FN_FLAG in ('" + ls_fn_flag + "')")}
 ${if(ls_fn_flag_cancel," and d.ORDER_FN_FLAG <> 'CANCEL'","")}
 ${if(len(ls_client)==0,"","and (CPC.PARTY_NAME like '%" + ls_client + "%' or CPC.PARTY_OPCODE like '"+ ls_client + "%' OR to_char(CPC.COM_PARTY_ID) = '"+ ls_client + "' or upper(CPC.SPELL) LIKE '%" + UPPER(ls_client) + "%')")}
 ${if(len(ls_goods)==0,"","and (cg.goods_name like '%" + ls_goods + "%' or cg.goods_opcode like '"+ ls_goods + "%' OR to_char(cg.com_goods_id) = '"+ ls_goods + "' or upper(cg.goods_spell) LIKE '%" + UPPER(ls_goods) + "%')")}
 ${if(len(ll_sys_payment_id)==0,"","and d.SYS_PAYMENT_ID in (" + ll_sys_payment_id + ")")}
 ${if(thenBlend," and D.INVOICE_NO is not null and D.INVOICE_NO<>' '","")}
  ${if(noThenBlend," and D.INVOICE_NO is  null","")}
  
 ${if(len(ll_invoice_no)==0,"","and d.invoice_no like '%" + ll_invoice_no + "%'")}
  ${if(len(invOwner)==0,"","and D.INV_OWNER = "+invOwner)}
 -- ${if(len(invoiceFnFlag)==0,"","and D.INVOICE_FN_FLAG = '"+invoiceFnFlag+"'")}
 ${if(len(invoiceFnFlag)==0,"","and D.INVOICE_FN_FLAG in("+invoiceFnFlag+")")}
   ${if(len(cost_date1)==0,"","and D.COST_DATE >= to_date('"+cost_date1+"','yyyy-mm-dd')")}
 ${if(len(cost_date2)==0,"","and D.COST_DATE < to_date('"+cost_date2+"','yyyy-mm-dd') + 1")}
 ${if(len(omsFlag)==0,"","and D.OMS_FLAG = '"+omsFlag+"'")}
 ${if(len(orderLgFlag) ==0,"","and D.ORDER_LG_FLAG = '"+orderLgFlag+"'")}
 ${if(quantityCompare,"and NVL(D.LOT_QTY,D.ORDER_QTY)>NVL(D.LOT_QTY,D.MEET_QTY)","")}
${if(len(startPrintDate)==0,"","and D.PRINT_DATE >= to_date('"+startPrintDate+"','yyyy-mm-dd')")}
  ${if(len(endPrintDate)==0,"","and D.PRINT_DATE < to_date('"+endPrintDate+"','yyyy-mm-dd')+1")}
  ${if(len(taxRate)==0,"","and D.tax_rate = "+taxRate)}
  ${if(len(clientId)==0,"","and D.COM_CLIENT_ID in("+clientId+")")}
  ${if(len(clientSet)==0,"","and D.COM_CLIENT_ID in(select c.com_party_id from sys_party_sets_lines c where c.sys_party_sets_id="+clientSet+")")}
  ${if(len(goodsSet)==0,"","and d.COM_GOODS_ID in (select sgsl.com_goods_id from sys_goods_sets_lines sgsl where sgsl.sys_goods_sets_id="+goodsSet+")")}
   ${if(len(lotNo)==0,"","and D.lot_no = '"+lotNo+"'")}
   ${if(len(factoryName)==0,"","and CPF.party_name like  '%"+factoryName+"%'")}
   ${if(len(bacth_vender_id)==0,"","and cgb.VENDER_ID = '"+bacth_vender_id+"'")}
   
   --${if((filterData) == "1","and d.COM_SALER_ID = '"+operatorId+"'","")}
   --根据销售员关键过滤数据
   ${if((positionKeyword) == "SALER","
     and d.COM_SALER_ID = '"+operatorId+"'","")}
   -- ${if((positionKeyword) == "SALER",
   -- "AND EXISTS(SELECT 1 FROM SYS_CLIENT_DEF S 
  --  WHERE S.COM_CLIENT_ID = D.COM_CLIENT_ID 
    --AND S.COM_SALER_ID = '"+operatorId+"')","")}
    
   ${if(len(inv_user)==0,"","and D.INV_USER = " + inv_user)}
   ${if((positionKeyword) == "SALER"," and exists
     (select 1
          from sys_client_def
         where d.COM_CLIENT_ID = sys_client_def.com_client_id
           and d.INV_OWNER = sys_client_def.inv_owner
           and sys_client_def.com_saler_id = '"+operatorId+"')","")}
   ${if(len(inv_user)==0,"","and D.INV_USER = " + inv_user)}
  
order by d.ssc_order_id,d.ssc_order_lines_id

----结束

select a.sys_order_type_id,a.order_type from sys_order_type a 
 order by sys_order_type_id asc

select d.sys_payment_id,d.payment_type from sys_payment d order by d.sys_payment_id

select t.goods_rate as id, 
	  t.goods_rate as tax_rate
  from com_goods_rate t
  where  t.goods_keyword = 'TAX_RATE'

SELECT v_clients.com_party_id,    
       v_clients.party_name
      FROM v_clients 
inner join sys_client_org_mapping b on v_clients.COM_PARTY_ID = b.COM_PARTY_ID
where  1=1
${if(len(invOwner)==0,"","and b.INV_OWNER_ID = "+invOwner)}

select sps.sys_party_sets_id,
       sps.party_set_name
from sys_party_sets sps
where --sps.keyword in( 'DISTRIBUTION_DEPT','2333745','2465636','2470040','2470104')
 sps.private_org = '${invOwner}'
-- and sps.sys_party_sets_id in (189,190,191,315,323,318,316)

select sg.sys_goods_sets_id,sg.goods_set_name from sys_goods_sets sg

select a.com_client_class_id,a.client_class from com_client_class a
where 1=1
${if(len(invOwner)==0,"","and a.INV_OWNER = "+invOwner)}
order by a.com_client_class_id

--ivd 限定批次毛利列只能给财务查看
select distinct 
                s.keyword,
                s.EFFECT_VALUE,
                (select v.effect_name
                   from pf_keyword_effect v
                  where a.pf_keyword_effect_id = v.pf_keyword_effect_id) as effect_name,
                  op.positionid
  from SYS_PARTY_RULES_NEW s
  left join Pf_Keyword_List_New a on s.keyword = a.keyword
  inner join ORG_POSITION op on s.effect_value = op.orgid AND S.KEYWORD_VALUE = OP.POSICODE
 where 1 = 1 and s.keyword = 'FINANCE_SEE_ORDER'
 and s.EFFECT_VALUE = '${invOwner}'  and op.positionid = '${positionId}' 

--如果维护了关键字需要隐藏列：开单成本，开单毛利，业务成本，业务毛利，几张成本，记账毛利
select
       a.keyword_value
from SYS_PARTY_RULES_NEW a,Pf_Keyword_List_New b,ORG_POSITION c
where a.keyword = b.keyword
  and c.keyword = b.default_value
  and c.positionid = '${positionid}'
  and a.effect_value = '${invOwner}'

--(根据岗位关键字与页面维护关键字过滤数据)
  SELECT NVL(NEW1.KEYWORD_VALUE,PN.DEFAULT_VALUE) as KEYWORD_VALUE
			FROM PF_KEYWORD_LIST_NEW PN,SYS_PARTY_RULES_NEW NEW1
			WHERE PN.KEYWORD = NEW1.KEYWORD(+) AND
			PN.KEYWORD = 'FILTER_DATA_SALE' 
			AND NEW1.EFFECT_VALUE ='${invOwner}'

 SELECT c.keyword FROM ORG_POSITION C where c.positionid = '${positionId}'

 select  a.com_party_id,a.party_name
from com_party a 
inner join com_goods_batch b on a.com_party_id = b.vender_id
where 1=1
${if(len(invOwner)==0,"","and b.inv_owner_id = "+invOwner)}
group by a.party_name,a.com_party_id



 

SELECT C.ORGID AS INV_USER,
       C.ORGCODE || '-' || C.ORGNAME AS INV_USER_NAME
  FROM COM_ACCOUNTABLITY A
   INNER JOIN COM_ACCOUNTABLITY_TYPE B ON A.COM_ACCOUNTABLITY_TYPE_ID =
                                          B.COM_ACCOUNTABLITY_TYPE_ID
                                      AND B.KEYWORD = 'INV_OWN_USER_REF'
   INNER JOIN ORG_ORGANIZATION C ON A.SUBPARTY_ID = C.ORGID
   INNER JOIN ORG_ORGANIZATION D ON A.COM_PARTY_ID = D.ORGID
   WHERE 1 = 1   
    AND EXISTS (SELECT 1 FROM COM_DEPT_EMP_DEF DED WHERE A.SUBPARTY_ID = DED.INV_USER 
    AND   a.com_party_id  = '${invOwner}')  and C.ORGID <> a.com_party_id
    
    ${if((positionKeyword) == "SALER","AND EXISTS (SELECT 1 FROM COM_DEPT_EMP_DEF DED WHERE A.SUBPARTY_ID = DED.INV_USER AND DED.EMPLOYEE_ID = '"+operatorId+"')","")}

