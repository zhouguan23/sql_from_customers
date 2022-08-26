SELECT A.BCH_DESC,
       A.COOPR_NAME,
       A.STORE_NAME,
       A.LOAN_NO,
       A.TEP_DESC,
       A.LOAN_TNR,
       A.PRO_JECT_NAME,
       A.CUST_NAME,
       CASE WHEN ID_NO IS NULL THEN ''
       ELSE SUBSTR (ID_NO, 1, 4) || '****' || SUBSTR (ID_NO, 15, 4) END ID_NO,
       A.PAYM_ACCT_CARD_NO,
       A.ACC_BANK_NAME,
       A.PAYM_ACCT_NAM,
       A.SETL_RECV_AMT,
       A.TRUE_SETL_VAL_DT,
       A.CHNL_SOURCE_REPAY,
       A.FAIL_REASON
  FROM T_E_ATPY_FAIL A
 WHERE A.TRUE_SETL_VAL_DT >=SUBSTR('${KSRQ}',1,4)||SUBSTR('${KSRQ}',6,2)||SUBSTR('${KSRQ}',9,2)
   AND A.TRUE_SETL_VAL_DT <=SUBSTR('${JSRQ}',1,4)||SUBSTR('${JSRQ}',6,2)||SUBSTR('${JSRQ}',9,2)
   ${IF(LEN(DKPZ) = 0,'',"AND A.TEP_DESC = '"+DKPZ+"'")} 
   ${IF(LEN(YXZA) = 0,'',"AND A.PRO_JECT_NAME  = '"+YXZA+"'")} 
   ${IF(LEN(HKQD) = 0,'',"AND T3.S_CODE_VAL_DESC  = '"+HKQD+"'")} 
   ${IF(LEN(JJH) = 0,'',"AND A.LOAN_NO = '"+JJH+"'")} 
   ${IF(LEN(KHXM) = 0,'',"AND A.CUST_NAME LIKE '%"+KHXM+"%'")} 

SELECT DISTINCT A.TEP_DESC
  FROM T_DIM_BCH A
 WHERE A.TEP_DESC IS NOT NULL
   AND A.COOPR_NAME = '中移电子商务有限公司'

SELECT DISTINCT A.PRO_JECT_NAME
  FROM T_DIM_BCH A
 WHERE A.PRO_JECT_NAME IS NOT NULL
   AND A.COOPR_NAME = '中移电子商务有限公司'

SELECT DISTINCT 
       A.CHNL_SOURCE_REPAY 
  FROM CS.T_E_ATPY_FAIL A

select '批量扣款' 还款类型
  from dual
union  
select  distinct t1.s_code_val_desc 还款类型 from 
E_S_CM_PUB_CODE_REL T1
       where COL_NAME = 'SETL_MODE'
       AND TAB_NAME = 'LM_SETLMT_T'

