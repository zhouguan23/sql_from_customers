SELECT SUBSTR(A.YEAR_MONTH_V, 6, 2) || '月' MONTH1,
       A.COST_ITEM_TYPE,
       A.COST_ITEM_TYPE_NAME,
       A.FNCOST_TYPE,
       A.FNCOST_TYPE_NAME,
       A.TOTAL YF,
       B.TOTAL SF
  FROM (SELECT T.YEAR_MONTH_V,
               DECODE(A.COST_ITEM_TYPE,
                      '2',
                      '9999',
                      '3',
                      '9999',
                      '12',
                      '8888',
                      '13',
                      '8888',
                      '15',
                      '7777',
                      '16',
                      '7777',
                      A.COST_ITEM_TYPE) COST_ITEM_TYPE,
               DECODE(C.NAME,
                      '工资-工会经费',
                      '工资',
                      '绩效-工会经费',
                      '绩效',
                      '年终奖-工会经费',
                      '年终奖',
                      C.NAME) COST_ITEM_TYPE_NAME,
               A.FNCOST_TYPE,
               D.NAME FNCOST_TYPE_NAME,
               SUM(A.TOTAL) TOTAL
          FROM FN_COST_BS_SHARE T
          LEFT JOIN FN_COST_FN_ORG_TOTAL A
            ON T.ID = A.SOURCE_MAIN_ID
          LEFT JOIN COM_FNORG B
            ON A.TARGET_COST_ID = B.ID
          LEFT JOIN V_SA_DICTIONARY C
            ON A.COST_ITEM_TYPE = C.VALUE
          LEFT JOIN V_SA_DICTIONARY D
            ON A.FNCOST_TYPE = D.VALUE
         WHERE 1 = 1
           AND C.CODE = 'costShareItemType'
           AND D.CODE = 'fnCostOrgType'
           AND T.COST_ITEM IN ('4', '2')
           AND A.COST_ITEM_TYPE IN ('2', '3', '12', '13', '15', '16')
           AND T.STATUS = 2000
           AND T.ORGAN_ID IN
               (SELECT COLUMN_VALUE AS ID FROM TABLE(SPLIT('${organId}')))
         GROUP BY T.YEAR_MONTH_V,
                  DECODE(A.COST_ITEM_TYPE,
                         '2',
                         '9999',
                         '3',
                         '9999',
                         '12',
                         '8888',
                         '13',
                         '8888',
                         '15',
                         '7777',
                         '16',
                         '7777',
                         A.COST_ITEM_TYPE),
                  DECODE(C.NAME,
                         '工资-工会经费',
                         '工资',
                         '绩效-工会经费',
                         '绩效',
                         '年终奖-工会经费',
                         '年终奖',
                         C.NAME),
                  A.FNCOST_TYPE,
                  D.NAME) A
  LEFT JOIN (SELECT T.YEAR_MONTH_V,
                    DECODE(A.COST_ITEM_TYPE,
                           '2',
                           '9999',
                           '3',
                           '9999',
                           '12',
                           '8888',
                           '13',
                           '8888',
                           '15',
                           '7777',
                           '16',
                           '7777',
                           A.COST_ITEM_TYPE) COST_ITEM_TYPE,
                    DECODE(C.NAME,
                           '工资-工会经费',
                           '工资',
                           '绩效-工会经费',
                           '绩效',
                           '年终奖-工会经费',
                           '年终奖',
                           C.NAME) COST_ITEM_TYPE_NAME,
                    A.FNCOST_TYPE,
                    D.NAME FNCOST_TYPE_NAME,
                    SUM(A.TOTAL) TOTAL
               FROM FN_COST_BS_SHARE     T,
                    FN_COST_FN_ORG_TOTAL A,
                    COM_FNORG            B,
                    V_SA_DICTIONARY      C,
                    V_SA_DICTIONARY      D
              WHERE T.ID = A.SOURCE_MAIN_ID
                AND A.TARGET_COST_ID = B.ID
                AND A.COST_ITEM_TYPE = C.VALUE
                AND C.CODE = 'costShareItemType'
                AND A.FNCOST_TYPE = D.VALUE
                AND D.CODE = 'fnCostOrgType'
                AND T.COST_ITEM IN ('44', '22')
                AND A.COST_ITEM_TYPE IN ('2', '3', '12', '13', '15', '16')
                AND T.STATUS = 2000
                AND A.COST_CHECK_TYPE = '1'
                AND T.ORGAN_ID IN
                    (SELECT COLUMN_VALUE AS ID
                       FROM TABLE(SPLIT('${organId}')))
              GROUP BY T.YEAR_MONTH_V,
                       DECODE(A.COST_ITEM_TYPE,
                              '2',
                              '9999',
                              '3',
                              '9999',
                              '12',
                              '8888',
                              '13',
                              '8888',
                              '15',
                              '7777',
                              '16',
                              '7777',
                              A.COST_ITEM_TYPE),
                       DECODE(C.NAME,
                              '工资-工会经费',
                              '工资',
                              '绩效-工会经费',
                              '绩效',
                              '年终奖-工会经费',
                              '年终奖',
                              C.NAME),
                       A.FNCOST_TYPE,
                       D.NAME) B
    ON A.COST_ITEM_TYPE = B.COST_ITEM_TYPE
   AND A.FNCOST_TYPE = B.FNCOST_TYPE
   AND A.YEAR_MONTH_V = B.YEAR_MONTH_V
 WHERE SUBSTR(A.YEAR_MONTH_V, 0, 4) =
       NVL('${YEAR}', SUBSTR(A.YEAR_MONTH_V, 0, 4))
   AND A.COST_ITEM_TYPE = NVL(DECODE('${costItemType}',
                                     '2',
                                     '9999',
                                     '3',
                                     '9999',
                                     '12',
                                     '8888',
                                     '13',
                                     '8888',
                                     '15',
                                     '7777',
                                     '16',
                                     '7777',
                                     '${costItemType}'),
                              A.COST_ITEM_TYPE)
   AND A.FNCOST_TYPE = NVL('${fncostType}', A.FNCOST_TYPE)
 ORDER BY SUBSTR(A.YEAR_MONTH_V, 6, 2) ASC


