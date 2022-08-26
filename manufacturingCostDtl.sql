SELECT (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = '${yearmonth}'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = '${yearmonth}'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS BQ_QTY,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = '${yearmonth_h}'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = '${yearmonth_h}'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS SNTQ_QTY,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V <= '${yearmonth}'
           AND T.YEAR_MONTH_V >= SUBSTR('${yearmonth}', 1, 4) || '-01'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V <= '${yearmonth}'
           AND T.YEAR_MONTH_V >= SUBSTR('${yearmonth}', 1, 4) || '-01'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS BNLJ_QTY,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V <= '${yearmonth_h}'
           AND T.YEAR_MONTH_V >= SUBSTR('${yearmonth_h}', 1, 4) || '-01'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V <= '${yearmonth_h}'
           AND T.YEAR_MONTH_V >= SUBSTR('${yearmonth_h}', 1, 4) || '-01'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS STLJ_QTY,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-01'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-01'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_01,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-02'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-02'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_02,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-03'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-03'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_03,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-04'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-04'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_04,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-05'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-05'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_05,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-06'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-06'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_06,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-07'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-07'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_07,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-08'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-08'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_08,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-09'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-09'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_09,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-10'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-10'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_10,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-11'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-11'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_11,
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-12'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '1'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) +
       (SELECT NVL(SUM(T.NORMAL_W), 0)
          FROM FN_COST_PDT_IN T
         WHERE T.YEAR_MONTH_V = SUBSTR('${yearmonth}', 1, 4) || '-12'
           AND T.ORGAN_ID = '${ORGANID}'
           AND T.PRODUCT_CATEGORY = '2'
           AND (T.NORMAL_BZ != 0 OR T.NORMAL_RG != 0)) AS QTY_12
  FROM DUAL

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.02','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.02','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.01','JL','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.02','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.01','JL','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.02','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.01','JF','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.02','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.03','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.03','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.03','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.03','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.03','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.04','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.04','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.04','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.04','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.04','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.05','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.01','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.01','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.05.01.01','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.02','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.02','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.05.01.02','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.03','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.03','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.05.01.03','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.05','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.05','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.05.01.05','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.06','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.06','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.05.01.06','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.07','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.07','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.05.01.07','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.05.01.99','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.05.01.99','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.05.01.99','JF','${isNoAccount}')
as amount_12
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.06','JF','${isNoAccount}')
as bq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.06','JF','${isNoAccount}')
as sntq_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5001.06','JL','${isNoAccount}')
as bnlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth_h}','${currencyId}','5001.06','JL','${isNoAccount}')
as stlj_amount,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_01,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-02','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_02,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-03','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_03,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-04','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_04,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-05','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_05,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-06','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_06,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-07','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_07,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-08','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_08,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-09','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_09,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-10','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_10,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-11','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_11,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-12','${currencyId}','5001.06','JF','${isNoAccount}')
as amount_12
from dual

