SELECT A.ITEMNAME,
       A.ORGAN_NAME,
       A.ORGAN_ID,
       A.COMPANYNAME,
       A.ACCOUNT_CODE,
       A.FCREDITQTY,
       A.YEAR1,
       A.MONTH1||'月' MONTH1,
       '瓦' dw,
       A.SR           SR,
       B.CB           CB
  FROM (SELECT D.ITEMNAME,
               T.ORGAN_NAME,
               T.ORGAN_ID,
               C.COMPANYNAME,
               SUBSTR(T.YEARMONTH, 0, 4) YEAR1,
               A.ACCOUNT_CODE,
               T.FCREDITQTY,
               T.MONTHDEBITTOTAL * (-1) SR,
               SUBSTR(T.YEARMONTH, 6, 2) MONTH1
          FROM FN_ERP_BALANCE       T,
               V_FN_ACCOUNTINFO_NEW A,
               FN_ITEMINFO          D,
               FN_ITEMDETAILV       B,
               FN_ITEMDETAILV       B2,
               COM_GRP_PARTY        C
         WHERE T.ACCOUNTID = A.ACCOUNT_ID
           AND T.ORGAN_ID = A.ORGAN_ID
           AND T.ITEMDTLID = B.ITEMDTLID
           AND T.ITEMDTLID = B2.ITEMDTLID
           AND B2.ITEMID = C.ID
           AND B.ITEMID = D.ITEMID
           AND A.ACCOUNT_CODE LIKE '6001%'
           AND A.CHILD_NUM = 0
           AND B2.ITEMID <> '9999'
           AND B.ITEMCLASSID = '3003'
           AND T.CURRENCYID = '0'
        --AND substr(t.yearmonth,0,4)='${YEARMONTH}'
        ) A
  LEFT JOIN (SELECT D.ITEMNAME,
                    T.ORGAN_NAME,
                    T.ORGAN_ID,
                    C.COMPANYNAME,
                    SUBSTR(T.YEARMONTH, 0, 4) YEAR1,
                    A.ACCOUNT_CODE,
                    T.MONTHDEBITTOTAL CB,
                    SUBSTR(T.YEARMONTH, 6, 2) MONTH1
               FROM FN_ERP_BALANCE       T,
                    V_FN_ACCOUNTINFO_NEW A,
                    FN_ITEMINFO          D,
                    FN_ITEMDETAILV       B,
                    FN_ITEMDETAILV       B2,
                    COM_GRP_PARTY        C
              WHERE T.ACCOUNTID = A.ACCOUNT_ID
                AND T.ORGAN_ID = A.ORGAN_ID
                AND T.ITEMDTLID = B.ITEMDTLID
                AND T.ITEMDTLID = B2.ITEMDTLID
                AND B2.ITEMID = C.ID
                AND B.ITEMID = D.ITEMID
                AND A.ACCOUNT_CODE LIKE '6401%'
                AND A.CHILD_NUM = 0
                AND B2.ITEMID <> '9999'
                AND B.ITEMCLASSID = '3003'
                AND T.CURRENCYID = '0'
             --AND substr(t.yearmonth,0,4)='${YEARMONTH}'
             ) B
    ON A.ITEMNAME = B.ITEMNAME
   AND A.ORGAN_NAME = B.ORGAN_NAME
   AND A.COMPANYNAME = B.COMPANYNAME
   AND A.YEAR1 = B.YEAR1
   AND A.MONTH1 = B.MONTH1
 WHERE A.YEAR1 = NVL('${YEAR}', A.YEAR1)
   AND A.ORGAN_ID = NVL('${organId}', A.ORGAN_ID)
   ORDER BY A.YEAR1,A.MONTH1 ASC


SELECT A.MATERIELTYPE_NAME,
       A.ORGAN_NAME,
       A.COMPANYNAME,
       A.UNIT_CNAME,
       A.QTY,
       A.SR,
       B.CB,
       A.ORGAN_ID,
       A.CUS_ID,
       A.TYPE_ID,
       A.YEAR1,
       A.MONTH1||'月' MONTH1,
       '6051.01.01.01' account_code
  FROM (SELECT D.MATERIELTYPE_NAME,
               A.COMPANYNAME,
               T.ORGAN_NAME,
               B.UNIT_CNAME,
               SUM(B.QTY) QTY,
               SUM(B.OC_AMOUNT) SR,
               T.ORGAN_ID,
               A.ID CUS_ID,
               D.ID TYPE_ID,
               SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 0, 4) YEAR1,
               SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 6, 2) MONTH1
          FROM FN_AR_SALE_INVOICE     T,
               VIEW_CUSTOMER_ALL      A,
               FN_AR_SALE_INVOICE_DTL B,
               COM_MATERIEL_INFO      C,
               VIEW_COM_MATERIELTYPE  D,
               VIEW_COM_MATERIELTYPE  D2,
               FN_VOUCHERERP          E
         WHERE T.CUSTOMER_ID = A.ID
           AND A.IS_INTERNAL = '1'
           AND T.ID = B.MAIN_ID
           AND C.MATERIEL_CODE = B.PRODUCT_CODE
           AND D.ALL_CODE =
               SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_SECODE(C.MATERIELTYPE_ID)
           AND D2.ALL_CODE =
               SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_CODE(C.MATERIELTYPE_ID)
           AND D2.MATERIELTYPE_CODE != '11'
           AND E.SOURCEID(+) = T.ID
           AND T.STATUS = 2000
           AND E.STATUS = 2000
         GROUP BY A.COMPANYNAME,
                  T.ORGAN_NAME,
                  B.UNIT_CNAME,
                  D.MATERIELTYPE_NAME,
                  SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 0, 4),
                  SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 6, 2),
                  T.ORGAN_ID,
                  A.ID,
                  D.ID) A
  LEFT JOIN (SELECT G.MATERIELTYPE_NAME,
                    B.ORGAN_NAME,
                    A.COMPANYNAME,
                    D.UNIT_CNAME,
                    SUM(D.OC_AMOUNT) CB,
                    B.ORGAN_ID,
                    A.ID CUS_ID,
                    G.ID TYPE_ID,
                    SUBSTR(TO_CHAR(H.FILLIN_DATE, 'YYYY-MM'), 0, 4) YEAR1,
                    SUBSTR(TO_CHAR(H.FILLIN_DATE, 'YYYY-MM'), 6, 2) MONTH1
               FROM VIEW_QUERY_MATE_OUT    T,
                    VIEW_CUSTOMER_ALL      A,
                    ST_MATE_OUT            B,
                    FN_AR_SALE_INVOICE     C,
                    FN_AR_SALE_INVOICE_DTL D,
                    ST_MATE_OUT_DTL        E,
                    COM_MATERIEL_INFO      F,
                    VIEW_COM_MATERIELTYPE  G,
                    VIEW_COM_MATERIELTYPE  G2,
                    FN_VOUCHERERP          H
              WHERE T.ACCOUNT_CODE = '6402.01.01.01'
                AND T.ID = B.ID
                AND B.ID = E.MAIN_ID
                AND B.CUSTOMER_ID = A.ID
                AND A.IS_INTERNAL = '1'
                AND C.ID = D.MAIN_ID
                AND D.SOURCE_DTL_ID = E.ID
                AND D.PRODUCT_CODE = F.MATERIEL_CODE
                AND G.ALL_CODE =
                    SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_SECODE(F.MATERIELTYPE_ID)
                AND G2.ALL_CODE =
                    SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_CODE(F.MATERIELTYPE_ID)
                AND G2.MATERIELTYPE_CODE != '11'
                AND H.SOURCEID(+) = C.ID
                AND C.STATUS = 2000
                AND H.STATUS = 2000
              GROUP BY B.ORGAN_NAME,
                       A.COMPANYNAME,
                       G.MATERIELTYPE_NAME,
                       D.UNIT_CNAME,
                       SUBSTR(TO_CHAR(H.FILLIN_DATE, 'YYYY-MM'), 0, 4),
                       SUBSTR(TO_CHAR(H.FILLIN_DATE, 'YYYY-MM'), 6, 2),
                       B.ORGAN_ID,
                       A.ID,
                       G.ID) B
    ON A.TYPE_ID = B.TYPE_ID
   AND A.ORGAN_ID = B.ORGAN_ID
   AND A.CUS_ID = B.CUS_ID
   AND A.UNIT_CNAME = B.UNIT_CNAME
   AND A.YEAR1 = B.YEAR1
   AND A.MONTH1 = B.MONTH1
 WHERE A.YEAR1 = NVL('${YEAR}', A.YEAR1)
   AND A.ORGAN_ID = NVL('${organId}', A.ORGAN_ID)
   ORDER BY A.YEAR1,A.MONTH1 ASC

select rawtohex(sys_guid()), T.*
  from (SELECT A.ITEMNAME,
               A.ITEMID,
               A.ORGAN_NAME,
               A.ORGAN_ID,
               A.COMPANYNAME,
               A.ACCOUNT_ID,
               A.ACCOUNT_NAME,
               A.FCREDITQTY,
               A.YEAR1,
               A.MONTH1,
               'FCF4AA8135664BB9BFA03C29912C1D8F' UNIT_ID,
               '瓦' DW,
               A.SR SR,
               B.CB CB,
               A.CUS_ID,
               '' TYPE_ID
          FROM (SELECT D.ITEMNAME,
                       D.ITEMID,
                       T.ORGAN_NAME,
                       T.ORGAN_ID,
                       C.COMPANYNAME,
                       SUBSTR(T.YEARMONTH, 0, 4) YEAR1,
                       A.ACCOUNT_NAME,
                       A.ACCOUNT_ID,
                       T.FCREDITQTY,
                       T.MONTHCREDITTOTAL SR,
                       SUBSTR(T.YEARMONTH, 6, 2) MONTH1,
                       C.ID CUS_ID
                  FROM FN_ERP_BALANCE       T,
                       V_FN_ACCOUNTINFO_NEW A,
                       FN_ITEMINFO          D,
                       FN_ITEMDETAILV       B,
                       FN_ITEMDETAILV       B2,
                       COM_GRP_PARTY        C
                 WHERE T.ACCOUNTID = A.ACCOUNT_ID
                   AND T.ORGAN_ID = A.ORGAN_ID
                   AND T.ITEMDTLID = B.ITEMDTLID
                   AND T.ITEMDTLID = B2.ITEMDTLID
                   AND B2.ITEMID = C.ID
                   AND B.ITEMID = D.ITEMID
                   AND A.ACCOUNT_CODE LIKE '6001%'
                   AND A.CHILD_NUM = 0
                   AND B2.ITEMID <> '9999'
                   AND B.ITEMCLASSID = '3003'
                   AND T.CURRENCYID = '0') A
          LEFT JOIN (SELECT D.ITEMNAME,
                           D.ITEMID,
                           T.ORGAN_NAME,
                           T.ORGAN_ID,
                           C.COMPANYNAME,
                           SUBSTR(T.YEARMONTH, 0, 4) YEAR1,
                           A.ACCOUNT_NAME,
                           A.ACCOUNT_ID,
                           T.MONTHDEBITTOTAL CB,
                           SUBSTR(T.YEARMONTH, 6, 2) MONTH1,
                           C.ID CUS_ID
                      FROM FN_ERP_BALANCE       T,
                           V_FN_ACCOUNTINFO_NEW A,
                           FN_ITEMINFO          D,
                           FN_ITEMDETAILV       B,
                           FN_ITEMDETAILV       B2,
                           COM_GRP_PARTY        C
                     WHERE T.ACCOUNTID = A.ACCOUNT_ID
                       AND T.ORGAN_ID = A.ORGAN_ID
                       AND T.ITEMDTLID = B.ITEMDTLID
                       AND T.ITEMDTLID = B2.ITEMDTLID
                       AND B2.ITEMID = C.ID
                       AND B.ITEMID = D.ITEMID
                       AND A.ACCOUNT_CODE LIKE '6401%'
                       AND A.CHILD_NUM = 0
                       AND B2.ITEMID <> '9999'
                       AND B.ITEMCLASSID = '3003'
                       AND T.CURRENCYID = '0') B
            ON A.ITEMNAME = B.ITEMNAME
           AND A.ORGAN_NAME = B.ORGAN_NAME
           AND A.CUS_ID = B.CUS_ID
           AND A.YEAR1 = B.YEAR1
           AND A.MONTH1 = B.MONTH1
         WHERE A.YEAR1 = NVL(SUBSTR('${YEARMONTH}', 0, 4), A.YEAR1)
           AND A.MONTH1 = NVL(SUBSTR('${YEARMONTH}', 6, 2), A.MONTH1)
           AND A.ORGAN_ID = NVL('${organId}', A.ORGAN_ID)
           AND A.CUS_ID = NVL('${cusId}', A.CUS_ID)
           AND A.ITEMNAME LIKE NVL('%${mTypeName}%', A.ITEMNAME)
        UNION ALL
        SELECT A.ITEMNAME,
               A.ITEMID,
               A.ORGAN_NAME,
               A.ORGAN_ID,
               A.COMPANYNAME,
               A.ACCOUNT_ID,
               A.ACCOUNT_NAME,
               A.FCREDITQTY,
               A.YEAR1,
               A.MONTH1,
               '' UNIT_ID,
               '' DW,
               A.SR SR,
               NULL CB,
               A.CUS_ID,
               '' TYPE_ID
          FROM (SELECT D.ITEMNAME,
                       D.ITEMID,
                       T.ORGAN_NAME,
                       T.ORGAN_ID,
                       C.COMPANYNAME,
                       SUBSTR(T.YEARMONTH, 0, 4) YEAR1,
                       A.ACCOUNT_ID,
                       A.ACCOUNT_NAME,
                       T.FCREDITQTY,
                       T.MONTHCREDITTOTAL SR,
                       SUBSTR(T.YEARMONTH, 6, 2) MONTH1,
                       C.ID CUS_ID
                  FROM FN_ERP_BALANCE       T,
                       V_FN_ACCOUNTINFO_NEW A,
                       FN_ITEMINFO          D,
                       FN_ITEMDETAILV       B,
                       FN_ITEMDETAILV       B2,
                       COM_GRP_PARTY        C
                 WHERE T.ACCOUNTID = A.ACCOUNT_ID
                   AND T.ORGAN_ID = A.ORGAN_ID
                   AND T.ITEMDTLID = B.ITEMDTLID
                   AND T.ITEMDTLID = B2.ITEMDTLID
                   AND B2.ITEMID = C.ID
                   AND B.ITEMID = D.ITEMID
                   AND A.ACCOUNT_CODE LIKE '6051%'
                   AND A.CHILD_NUM = 0
                   AND B2.ITEMID <> '9999'
                   AND B.ITEMCLASSID = '3003'
                   AND T.CURRENCYID = '0') A
         WHERE A.YEAR1 = NVL(SUBSTR('${YEARMONTH}', 0, 4), A.YEAR1)
           AND A.MONTH1 = NVL(SUBSTR('${YEARMONTH}', 6, 2), A.MONTH1)
           AND A.ORGAN_ID = NVL('${organId}', A.ORGAN_ID)
           AND A.CUS_ID = NVL('${cusId}', A.CUS_ID)
           AND A.ITEMNAME LIKE NVL('%${mTypeName}%', A.ITEMNAME)
        UNION ALL
        SELECT A.MATERIELTYPE_NAME,
               A.ITEMID,
               A.ORGAN_NAME,
               A.ORGAN_ID,
               A.COMPANYNAME,
               A.ACCOUNT_ID,
               A.ACCOUNTNAME ACCOUNT_NAME,
               A.QTY,
               A.YEAR1,
               A.MONTH1,
               A.UNIT_ID,
               A.UNIT_CNAME,
               A.SR,
               A.DJ * A.QTY CB,
               A.CUS_ID,
               A.TYPE_ID
          FROM (SELECT D.MATERIELTYPE_NAME,
                       D.ID ITEMID,
                       A.COMPANYNAME,
                       T.ORGAN_NAME,
                       B.UNIT_ID,
                       B.UNIT_CNAME,
                       SUM(ABS(F.QTY)) QTY,
                       SUM(ABS(F.TOTAL)) SR,
                       T.ORGAN_ID,
                       A.MAINID CUS_ID,
                       D.ID TYPE_ID,
                       SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 0, 4) YEAR1,
                       SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 6, 2) MONTH1,
                       G.ID ACCOUNT_ID,
                       G.ACCOUNTNAME,
                       (SELECT B.UNITPRICE DJ
                          FROM FN_VOUCHERERP         T,
                               FN_VOUCHERERPDTL      B,
                               FN_ACCOUNTINFO        A,
                               FN_ACCOUNT_PERIOD_DTL C,
                               FN_ITEMDETAILV        D,
                               FN_ITEMINFO           E
                         WHERE T.VOUCHERERPID = B.VOUCHERERPID
                           AND B.ACCOUNTID = A.ID
                           AND A.ACCOUNTCODE = '1604.05.01.06'
                           AND T.MONTHID = C.ID
                           AND B.ITEMDTLID = D.ITEMDTLID
                           AND D.ITEMID = E.ITEMID
                           AND D.ITEMCLASSID = '3003'
                           AND ROWNUM = 1) DJ
                  FROM FN_AR_SALE_INVOICE T,
                       VIEW_CUSTOMER_ALL A,
                       (SELECT MAIN_ID, UNIT_ID, UNIT_CNAME, PRODUCT_CODE
                          FROM FN_AR_SALE_INVOICE_DTL
                         GROUP BY MAIN_ID, UNIT_ID, UNIT_CNAME, PRODUCT_CODE) B,
                       COM_MATERIEL_INFO C,
                       VIEW_COM_MATERIELTYPE D,
                       VIEW_COM_MATERIELTYPE D2,
                       FN_VOUCHERERP E,
                       FN_VOUCHERERPDTL F,
                       FN_ACCOUNTINFO G
                 WHERE T.CUSTOMER_ID = A.ID
                   AND A.IS_INTERNAL = '1'
                   AND T.ID = B.MAIN_ID
                   AND C.MATERIEL_CODE = B.PRODUCT_CODE
                   AND E.VOUCHERERPID = F.VOUCHERERPID
                   AND F.ACCOUNTID = G.ID
                   AND G.ACCOUNTCODE = '1604.05.01.05'
                   AND D.ALL_CODE =
                       SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_SECODE(C.MATERIELTYPE_ID)
                   AND D2.ALL_CODE =
                       SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_CODE(C.MATERIELTYPE_ID)
                   AND D2.MATERIELTYPE_CODE = '11'
                   AND E.SOURCEID = T.ID
                   AND T.STATUS = 2000
                   AND E.STATUS = 2000
                   AND F.ISDC = '1'
                   AND T.FILLIN_DATE BETWEEN
                       TO_DATE(SUBSTR('${YEARMONTH}', 0, 4) ||
                               '-01-01 00:00:00',
                               'YYYY-MM-DD hh24:mi:ss') AND
                       TO_DATE(SUBSTR('${YEARMONTH}', 0, 4) ||
                               '-12-31 23:59:59',
                               'YYYY-MM-DD hh24:mi:ss')
                 GROUP BY A.COMPANYNAME,
                          T.ORGAN_NAME,
                          B.UNIT_ID,
                          B.UNIT_CNAME,
                          D.MATERIELTYPE_NAME,
                          D.ID,
                          SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 0, 4),
                          SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 6, 2),
                          T.ORGAN_ID,
                          A.MAINID,
                          D.ID,
                          G.ACCOUNTNAME,
                          G.ID) A
         WHERE A.YEAR1 = NVL(SUBSTR('${YEARMONTH}', 0, 4), A.YEAR1)
           AND A.MONTH1 = NVL(SUBSTR('${YEARMONTH}', 6, 2), A.MONTH1)
           AND A.ORGAN_ID = NVL('${organId}', A.ORGAN_ID)
           AND A.MATERIELTYPE_NAME LIKE
               NVL('%${mTypeName}%', A.MATERIELTYPE_NAME)
        UNION ALL
        SELECT A.MATERIELTYPE_NAME,
               A.ITEMID,
               A.ORGAN_NAME,
               A.ORGAN_ID,
               A.COMPANYNAME,
               '309846874' ACCOUNT_ID,
               '其他业务收入_材料销售' ACCOUNT_NAME,
               A.QTY,
               A.YEAR1,
               A.MONTH1,
               '' UNIT_ID,
               '' UNIT_CNAME,
               A.SR,
               B.CB,
               A.CUS_ID,
               A.TYPE_ID
          FROM (SELECT D.MATERIELTYPE_NAME,
                       D.ID ITEMID,
                       A.COMPANYNAME,
                       T.ORGAN_NAME,
                       SUM(B.QTY) QTY,
                       SUM(B.OC_AMOUNT) SR,
                       T.ORGAN_ID,
                       A.MAINID CUS_ID,
                       D.ID TYPE_ID,
                       SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 0, 4) YEAR1,
                       SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 6, 2) MONTH1
                  FROM FN_AR_SALE_INVOICE     T,
                       VIEW_CUSTOMER_ALL      A,
                       FN_AR_SALE_INVOICE_DTL B,
                       COM_MATERIEL_INFO      C,
                       VIEW_COM_MATERIELTYPE  D,
                       VIEW_COM_MATERIELTYPE  D2,
                       FN_VOUCHERERP          E
                 WHERE T.CUSTOMER_ID = A.ID
                   AND A.IS_INTERNAL = '1'
                   AND T.ID = B.MAIN_ID
                   AND C.MATERIEL_CODE = B.PRODUCT_CODE
                   AND D.ALL_CODE =
                       SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_SECODE(C.MATERIELTYPE_ID)
                   AND D2.ALL_CODE =
                       SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_CODE(C.MATERIELTYPE_ID)
                   AND D2.MATERIELTYPE_CODE != '11'
                   AND E.SOURCEID = T.ID
                   AND T.STATUS = 2000
                   AND E.STATUS = 2000
                 GROUP BY A.COMPANYNAME,
                          T.ORGAN_NAME,
                          D.MATERIELTYPE_NAME,
                          D.ID,
                          SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 0, 4),
                          SUBSTR(TO_CHAR(E.FILLIN_DATE, 'YYYY-MM'), 6, 2),
                          T.ORGAN_ID,
                          A.MAINID,
                          D.ID) A
          LEFT JOIN (SELECT A.MATERIELTYPE_NAME,
                            A.ITEMID,
                            A.ORGAN_NAME,
                            A.COMPANYNAME,
                            SUM(A.FN_AMOUNT) CB,
                            A.ORGAN_ID,
                            A.MAINID CUS_ID,
                            A.ID TYPE_ID,
                            A.YEAR1,
                            A.MONTH1
                       FROM (SELECT DISTINCT G.MATERIELTYPE_NAME,
                                             G.ID ITEMID,
                                             B.ORGAN_NAME,
                                             A.COMPANYNAME,
                                             T.FN_AMOUNT,
                                             B.ORGAN_ID,
                                             A.MAINID,
                                             G.ID,
                                             SUBSTR(TO_CHAR(H.FILLIN_DATE,
                                                            'YYYY-MM'),
                                                    0,
                                                    4) YEAR1,
                                             SUBSTR(TO_CHAR(H.FILLIN_DATE,
                                                            'YYYY-MM'),
                                                    6,
                                                    2) MONTH1
                               FROM VIEW_QUERY_MATE_OUT    T,
                                    VIEW_CUSTOMER_ALL      A,
                                    ST_MATE_OUT            B,
                                    FN_AR_SALE_INVOICE     C,
                                    FN_AR_SALE_INVOICE_DTL D,
                                    ST_MATE_OUT_DTL        E,
                                    COM_MATERIEL_INFO      F,
                                    VIEW_COM_MATERIELTYPE  G,
                                    VIEW_COM_MATERIELTYPE  G2,
                                    FN_VOUCHERERP          H
                              WHERE T.ACCOUNT_CODE = '6402.01.01.01'
                                AND T.ID = B.ID
                                AND B.ID = E.MAIN_ID
                                AND B.CUSTOMER_ID = A.ID
                                AND A.IS_INTERNAL = '1'
                                AND C.ID = D.MAIN_ID
                                AND D.SOURCE_DTL_ID = E.ID
                                AND D.PRODUCT_CODE = F.MATERIEL_CODE
                                AND G.ALL_CODE =
                                    SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_SECODE(F.MATERIELTYPE_ID)
                                AND G2.ALL_CODE =
                                    SOLAR_SCM_QA.F_GET_COM_MATERIELTYPE_CODE(F.MATERIELTYPE_ID)
                                AND G2.MATERIELTYPE_CODE != '11'
                                AND H.SOURCEID = C.ID
                                AND C.STATUS = 2000
                                AND H.STATUS = 2000) A
                      GROUP BY A.ORGAN_NAME,
                               A.COMPANYNAME,
                               A.MATERIELTYPE_NAME,
                               A.ITEMID,
                               A.YEAR1,
                               A.MONTH1,
                               A.ORGAN_ID,
                               A.MAINID,
                               A.ID) B
            ON A.TYPE_ID = B.TYPE_ID
           AND A.ORGAN_ID = B.ORGAN_ID
           AND A.CUS_ID = B.CUS_ID
           AND A.YEAR1 = B.YEAR1
           AND A.MONTH1 = B.MONTH1
         WHERE A.YEAR1 = NVL(SUBSTR('${YEARMONTH}', 0, 4), A.YEAR1)
           AND A.MONTH1 = NVL(SUBSTR('${YEARMONTH}', 6, 2), A.MONTH1)
           AND A.ORGAN_ID = NVL('${organId}', A.ORGAN_ID)
           AND A.CUS_ID = NVL('${cusId}', A.CUS_ID)
           AND A.MATERIELTYPE_NAME LIKE
               NVL('%${mTypeName}%', A.MATERIELTYPE_NAME)
         ORDER BY YEAR1,
                  MONTH1,
                  ORGAN_NAME,
                  COMPANYNAME,
                  ITEMID,
                  ACCOUNT_ID,
                  UNIT_ID ASC) T
 WHERE 1 = 1
   AND NOT EXISTS (SELECT 1
          FROM FN_RELATED_TRANSACTION_DTL A
         WHERE T.MONTH1 = A.MONTH
           AND T.YEAR1 = A.YEAR
           AND T.ORGAN_ID = A.ORGAN_ID
           AND T.CUS_ID = A.COMPANYID
           AND T.ACCOUNT_ID = A.ACCOUNT_ID
           AND T.ITEMID = A.MATERAIL_CLASS)
   AND (SR != 0 OR CB != 0 OR FCREDITQTY != 0)
UNION ALL
SELECT *
  FROM (SELECT DTL.ID,
               NULL               ITEMNAME,
               DTL.MATERAIL_CLASS,
               DTL.ORGAN_NAME,
               DTL.ORGAN_ID,
               DTL.COMPANYNAME,
               DTL.ACCOUNT_ID,
               DTL.ACCOUNT_NAME,
               DTL.QTY,
               DTL.YEAR,
               DTL.MONTH,
               DTL.UNIT,
               NULL               DW,
               DTL.INCOME,
               DTL.COST,
               DTL.COMPANYID,
               NULL
          FROM FN_RELATED_TRANSACTION_DTL DTL
         WHERE DTL.YEAR = NVL(SUBSTR('${YEARMONTH}', 0, 4), DTL.YEAR)
           AND DTL.MONTH = NVL(SUBSTR('${YEARMONTH}', 6, 2), DTL.MONTH)
           AND DTL.ORGAN_ID = NVL('${organId}', DTL.ORGAN_ID)
           AND DTL.COMPANYID = NVL('${cusId}', DTL.COMPANYID)
           AND (DTL.QTY != 0 OR DTL.INCOME != 0 OR DTL.COST != 0)
         ORDER BY DTL.YEAR,
                  DTL.MONTH,
                  DTL.ORGAN_ID,
                  DTL.COMPANYID,
                  DTL.MATERAIL_CLASS,
                  DTL.ACCOUNT_ID,
                  DTL.UNIT)

SELECT ID, NAME
  FROM SA_OPORG
 WHERE ORG_KIND_ID = 'ogn'
UNION
SELECT ID, COMPANYNAME
  FROM COM_GRP_PARTY T
 WHERE 1 = 1
   AND T.IS_INTERNAL = '1'
   AND NOT EXISTS
 (SELECT 1 FROM SA_OPORG A WHERE A.NAME = T.COMPANYNAME)


SELECT T.ITEMID, T.ITEMNAME
  FROM FN_ITEMINFO T
 WHERE T.ITEMCLASS = 3003
UNION ALL
SELECT A.ID, A.MATERIELTYPE_NAME
  FROM VIEW_COM_MATERIELTYPE A
  WHERE A.LEV=2


select distinct
       t.account_id,
       t.account_code,
       t.names,			      
       t.is_qty_name,
       t.isqty,
       t.item_count,
       t.account_entry_dir,
       t.erp_bank
  from v_fn_accountinfo_new t
 where t.account_code is not null
   and nvl(t.fdelete, 0) != 1			   
   and nvl(t.isused,1)=1
   and t.child_num=0

select t.id,
			       t.unitcname 
			from com_unit t  
			where t.isused = 1

select DISTINCT T.main_id, T.companyname from VIEW_COM_GRP_PARTY_RELATION T


