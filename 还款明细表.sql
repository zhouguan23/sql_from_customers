SELECT A.BCH_DESC,
       A.LOAN_NO,
       A.CUST_NAME,
       A.STORE_NAME,
       CASE WHEN A.ATPY_ACCT_ID_NO IS NULL THEN ''
            ELSE SUBSTR(A.ATPY_ACCT_ID_NO,1,4)||'****'||SUBSTR(A.ATPY_ACCT_ID_NO,15,4)
            END  AS ATPY_ACCT_ID_NO,  
       CASE WHEN A.ATPY_ACCT_NO IS NULL THEN '' 
            ELSE SUBSTR(A.ATPY_ACCT_NO,1,4)||'********'||SUBSTR(A.ATPY_ACCT_NO,-4) 
            END  AS ATPY_ACCT_NO,
       A.ACC_BANK_NAME,
       A.ATPY_ACCT_NAME,
       A.PERD_NO,
       (A.ATPY_PRCP_AMT+A.ATPY_INT_AMT+A.ATPY_OD_INT+A.ATPY_FEE_AMT) AS AMT,
       A.ATPY_PRCP_AMT,
       A.ATPY_INT_AMT,
       A.ATPY_COMP_INT,
       A.ATPY_OD_INT,
       A.ATPY_FEE_AMT,
       A.ATPY_INSTM_NO,
       A.ATPY_VAL_DT,
       A.ATPY_TX_AMT,
       A.PAYMENT_IND,
       A.SETL_COMP_TYP,
       CASE WHEN A.ATPY_TYP = A.SETL_MODE THEN A.SETL_MODE
            ELSE A.ATPY_TYP||'-'||A.SETL_MODE END ATPY_TYP,
       A.ATPY_STS,
       A.ATPY_ERR_DESC,
       A.CHNL_SOURCE,
       A.TEP_DESC,
       A.PRO_JECT_NAME,
       A.COOPR_NAME,
       T3.S_CODE_VAL_DESC,
       A.LOAN_TNR
    FROM T_REPY_INFO A
    LEFT JOIN E_S_CM_PUB_CODE_REL T3 
      ON A.CHNL_SOURCE = T3.S_CODE_VAL 
     AND T3.COL_NAME = 'CHL_RESOURCE' 
     AND T3.TAB_NAME = 'LM_SETLMT'
   WHERE A.ATPY_VAL_DT BETWEEN REPLACE('${KSRQ}','-','') 
                           AND REPLACE('${JSRQ}','-','')
     ${IF(LEN(KHXM) = 0, '', "AND A.CUST_NAME LIKE '%"+KHXM+"%'")} 
     ${IF(LEN(HKLX) = 0, '', "AND (A.ATPY_TYP = '"+HKLX+"' OR A.SETL_MODE = '"+HKLX+"')")} 
     ${IF(LEN(YYJG) = 0, '', "AND A. BCH_DESC IN('" +YYJG+"')")}
     ${IF(LEN(JJH)  = 0, '', "AND A.LOAN_NO = '"+JJH+"'")} 
     ${IF(LEN(HKQD) = 0, '', "AND T3.S_CODE_VAL_DESC  = '"+HKQD+"'")} 
     ${IF(LEN(DKPZ) = 0, '', "AND A.TEP_DESC = '"+DKPZ+"'")} 
     ${IF(LEN(YXZA) = 0, '', "AND A.PRO_JECT_NAME  = '"+YXZA+"'")} 
     ${IF(LEN(HZJG) = 0, '', "AND A.COOPR_NAME  = '"+HZJG+"'")} 
     ${IF(LEN(KHXM) = 0, '', "AND A.CUST_NAME LIKE '%"+KHXM+"%'")} 
     ${IF(LEN(ZT)   = 0, '', "AND A.ATPY_STS = '"+ZT+"'")} 
     ${IF(LEN(HKBS)   = 0, '', "AND A.PAYMENT_IND = '"+HKBS+"'")} 

SELECT '成功' FROM DUAL
UNION 
SELECT '失败' FROM DUAL
UNION 
SELECT '撤销' FROM DUAL

SELECT DISTINCT A.COOPR_NAME 
  FROM T_DIM_BCH A
 WHERE A.COOPR_NAME IS NOT NULL
 ${IF(LEN(YYJG)== 0,""," AND CASE WHEN A.BCH_DESC = '晋商消费金融公司' THEN  '山西运营中心'
            WHEN A.BCH_DESC = 'APP虚拟机构' THEN  '山西运营中心'
            WHEN A.BCH_DESC = '山西分公司' THEN  '山西运营中心'
            ELSE A.BCH_DESC END IN ('" +YYJG+"')")}

SELECT DISTINCT A.TEP_DESC
  FROM T_DIM_BCH A
 WHERE A.TEP_DESC IS NOT NULL
 ${IF(LEN(YYJG)== 0,""," AND CASE WHEN A.BCH_DESC = '晋商消费金融公司' THEN  '山西运营中心'
            WHEN A.BCH_DESC = 'APP虚拟机构' THEN  '山西运营中心'
            WHEN A.BCH_DESC = '山西分公司' THEN  '山西运营中心'
            ELSE A.BCH_DESC END IN ('" +YYJG+"')")}
 ${IF(LEN(HZJG)== 0,""," AND A.COOPR_NAME IN ('" +HZJG+"')")}


SELECT DISTINCT A.PRO_JECT_NAME
  FROM T_DIM_BCH A
 WHERE A.PRO_JECT_NAME IS NOT NULL
 ${IF(LEN(YYJG)== 0,""," AND CASE WHEN A.BCH_DESC = '晋商消费金融公司' THEN  '山西运营中心'
            WHEN A.BCH_DESC = 'APP虚拟机构' THEN  '山西运营中心'
            WHEN A.BCH_DESC = '山西分公司' THEN  '山西运营中心'
            ELSE A.BCH_DESC END IN ('" +YYJG+"')")}
 ${IF(LEN(HZJG)== 0,""," AND A.COOPR_NAME IN ('" +HZJG+"')")}
 ${IF(LEN(DKPZ)== 0,""," AND A.TEP_DESC IN ('" +DKPZ+"')")}


SELECT DISTINCT S_CODE_VAL_DESC
  FROM E_S_CM_PUB_CODE_REL  A
 WHERE A.COL_NAME = 'CHL_RESOURCE'
   AND TAB_NAME = 'LM_SETLMT'

SELECT '批量扣款' AS 还款类型
  FROM DUAL
UNION  
SELECT DISTINCT 
       T1.S_CODE_VAL_DESC AS 还款类型 
  FROM E_S_CM_PUB_CODE_REL T1
 WHERE COL_NAME = 'SETL_MODE'
   AND TAB_NAME = 'LM_SETLMT_T'

SELECT S_CODE_VAL_DESC
  FROM E_S_CM_PUB_CODE_REL
 WHERE COL_NAME = 'PAYMENT_IND'
   AND TAB_NAME = 'LM_SETLMT_LOG'
 ORDER BY S_CODE_VAL

