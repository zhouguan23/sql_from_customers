SELECT A.ORGAN_ID,
       A.COMPANYID,
       A.MATERIAL_CLASS_ID,
       A.ACCOUNT_ID,
       SUM(A.QTY) QTY,
       SUM(A.INCOME) INCOME,
       A.QTY_SUM QTY_SUM,
       A.INCOME_SUM INCOME_SUM,
       B.IN_QTY_SUM IN_QTY_SUM,
       B.IN_AMOUNT_SUM IN_AMOUNT_SUM
  FROM (SELECT DISTINCT T.ORGAN_ID,
                        NVL(SA.CODE, B.ITEMCODE) ZT_CODE,
                        T.ACCOUNT_ID,
                        T.UNIT,
                        NVL(T.QTY, 0) QTY,
                        NVL(T.INCOME, 0) INCOME,
                        T.COMPANYID,
                        C.ITEMCODE DF_CODE,
                        T.YEAR || '-' || T.MONTH YEARMONTH,
                        NVL(A.MATERIAL_CLASS_ID, T.MATERAIL_CLASS) MATERIAL_CLASS_ID,
                        SUM(NVL(T.QTY, 0)) OVER(PARTITION BY T.ORGAN_ID, NVL(SA.CODE, B.ITEMCODE), T.COMPANYID, C.ITEMCODE, NVL(A.MATERIAL_CLASS_ID, T.MATERAIL_CLASS)) QTY_SUM,
                        SUM(NVL(T.INCOME, 0)) OVER(PARTITION BY T.ORGAN_ID, NVL(SA.CODE, B.ITEMCODE), T.COMPANYID, C.ITEMCODE, NVL(A.MATERIAL_CLASS_ID, T.MATERAIL_CLASS)) INCOME_SUM
          FROM FN_RELATED_TRANSACTION_DTL T
          LEFT JOIN VIEW_FN_MATERIAL_ITEM_CFG A
            ON T.MATERAIL_CLASS = A.ITEM_ID
           AND NVL(A.RELATED_ORGAN_ID, 0) =
               DECODE(T.COMPANYID,
                      '8A4FEA73284F8073E0530100007F578A',
                      '8A4FEA73284F8073E0530100007F578A',
                      0)
          LEFT JOIN SA_OPORG SA
            ON T.ORGAN_ID = SA.ID
          LEFT JOIN FN_ITEMINFO B
            ON T.ORGAN_ID = B.ITEMID
          LEFT JOIN FN_ITEMINFO C
            ON T.COMPANYID = C.ITEMID
         WHERE T.COMPANYID IN
               (SELECT RELATED_ORGAN_ID FROM FN_RELATED_ORG_CFG)
           AND T.YEAR || '-' || T.MONTH >=
               NVL('${YEARMONTHBEGIN}', T.YEAR || '-' || T.MONTH)
           AND T.YEAR || '-' || T.MONTH <=
               NVL('${YEARMONTHEND}', T.YEAR || '-' || T.MONTH)) A
  LEFT JOIN (SELECT SUM(NVL(IN_QTY, 0) + NVL(TD_ADJUST_QTY, 0) +
                        DECODE(A.YEARMONTH,
                               '${YEARMONTHEND}',
                               NVL(WAY_QTY, 0),
                               0)) IN_QTY_SUM,
                    SUM(NVL(IN_AMOUNT, 0) + NVL(TD_ADJUST_AMOUNT, 0) +
                        DECODE(A.YEARMONTH,
                               '${YEARMONTHEND}',
                               NVL(WAY_AMOUNT, 0),
                               0)) IN_AMOUNT_SUM,
                    B.ORGAN_ID,
                    NVL(SA.CODE, D.ITEMCODE) ZT_CODE,
                    B.VENDER_ID,
                    E.ITEMCODE DF_CODE,
                    B.MATERIELTYPE_ID
               FROM ST_BALANCE_RELA_TRANS_REG_DTL  B,
                    ST_BALANCE_RELA_TRANS_REGISTER A,
                    SA_OPORG                       SA,
                    FN_ITEMINFO                    D,
                    FN_ITEMINFO                    E
              WHERE B.MAIN_ID = A.ID
                AND B.ORGAN_ID = SA.ID(+)
                AND B.ORGAN_ID = D.ITEMID(+)
                AND B.VENDER_ID = E.ITEMID(+)
                AND A.YEARMONTH >= NVL('${YEARMONTHBEGIN}', A.YEARMONTH)
                AND A.YEARMONTH <= NVL('${YEARMONTHEND}', A.YEARMONTH)
              GROUP BY B.ORGAN_ID,
                       B.VENDER_ID,
                       B.MATERIELTYPE_ID,
                       NVL(SA.CODE, D.ITEMCODE),
                       E.ITEMCODE) B
    ON A.ZT_CODE = B.DF_CODE
   AND A.DF_CODE = B.ZT_CODE
   AND A.MATERIAL_CLASS_ID = B.MATERIELTYPE_ID
 WHERE 1 = 1
   AND A.ORGAN_ID = NVL('${organId}', A.ORGAN_ID)
   AND A.COMPANYID = NVL('${cusId}', A.COMPANYID)
 GROUP BY A.ORGAN_ID,
          A.COMPANYID,
          A.MATERIAL_CLASS_ID,
          A.ACCOUNT_ID,
          A.QTY_SUM,
          A.INCOME_SUM,
          B.IN_QTY_SUM,
          B.IN_AMOUNT_SUM

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


select id,companyname from COM_GRP_PARTY
WHERE is_internal='1'

SELECT T.ITEMID, T.ITEMNAME
  FROM FN_ITEMINFO T
 WHERE T.ITEMCLASS = 3003
UNION ALL
select t.id,  t.materieltype_name
	from view_com_materieltype_rela t
	where t.lev = 2	


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

