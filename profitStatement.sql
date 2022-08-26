SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6001',
                                                      'DF',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6051',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01001',
                                                       'NOW_MONEY')
       END AS REVENUE,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6001',
                                                      'DF',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6051',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01001',
                                                       'NOW_MONEY')
       END AS REVENUE_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6401',
                                                      'JF',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6402',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01002',
                                                       'NOW_MONEY')
       END AS BUSINESS_COST,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6401',
                                                      'JF',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6402',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01002',
                                                       'NOW_MONEY')
       END AS BUSINESS_COST_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6403',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01003',
                                                       'NOW_MONEY')
       END AS TAXES_SURCHARGES,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6403',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01003',
                                                       'NOW_MONEY')
       END AS TAXES_SURCHARGES_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6601',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01004',
                                                       'NOW_MONEY')
       END AS SELLING_COST,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6601',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01004',
                                                       'NOW_MONEY')
       END AS SELLING_COST_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6602',
                                                      'JF',
                                                      '${isNoAccount}') -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6602.30',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01005',
                                                       'NOW_MONEY')
       END AS OVERHEAD,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6602',
                                                      'JF',
                                                      '${isNoAccount}') -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6602.30',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01005',
                                                       'NOW_MONEY')
       END AS OVERHEAD_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6602.30',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01006',
                                                       'NOW_MONEY')
       END AS RESEARCH_EXPENSES,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6602.30',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01006',
                                                       'NOW_MONEY')
       END AS RESEARCH_EXPENSES_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01007',
                                                       'NOW_MONEY')
       END AS FINANCIAL_EXPENSES,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01007',
                                                       'NOW_MONEY')
       END AS FINANCIAL_EXPENSES_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603.02',
                                                      'JF',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603.06',
                                                      'JF',
                                                      '${isNoAccount}') -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603.02.01.03',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01008',
                                                       'NOW_MONEY')
       END AS INTEREST_EXPENSES,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603.02',
                                                      'JF',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603.06',
                                                      'JF',
                                                      '${isNoAccount}') -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603.02.01.03',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01008',
                                                       'NOW_MONEY')
       END AS INTEREST_EXPENSES_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          0 -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603.01',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01009',
                                                       'NOW_MONEY')
       END AS INTEREST_INCOME,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          0 -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603.01',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01009',
                                                       'NOW_MONEY')
       END AS INTEREST_INCOME_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6701',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01010',
                                                       'NOW_MONEY')
       END AS IMPAIRMENT_LOSS,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6701',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01010',
                                                       'NOW_MONEY')
       END AS IMPAIRMENT_LOSS_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6112',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01011',
                                                       'NOW_MONEY')
       END AS OTHER_REVENUE,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6112',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01011',
                                                       'NOW_MONEY')
       END AS OTHER_REVENUE_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6111',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01012',
                                                       'NOW_MONEY')
       END AS INVEST_REVENUE,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6111',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01012',
                                                       'NOW_MONEY')
       END AS INVEST_REVENUE_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          -1 *
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6101',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01014',
                                                       'NOW_MONEY')
       END AS FAIR_VALUE_INCOME,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          -1 *
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6101',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01014',
                                                       'NOW_MONEY')
       END AS FAIR_VALUE_INCOME_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6113',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01015',
                                                       'NOW_MONEY')
       END AS ASSET_DISPOSAL_INCOME,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6113',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01015',
                                                       'NOW_MONEY')
       END AS ASSET_DISPOSAL_INCOME_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6301',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01017',
                                                       'NOW_MONEY')
       END AS NONBUSINESS_INCOME,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6301',
                                                      'DF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01017',
                                                       'NOW_MONEY')
       END AS NONBUSINESS_INCOME_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6711',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01018',
                                                       'NOW_MONEY')
       END AS NONBUSINESS_EXPENDITURE,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6711',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01018',
                                                       'NOW_MONEY')
       END AS NONBUSINESS_EXPENDITURE_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6801',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01020',
                                                       'NOW_MONEY')
       END AS TAX_EXPENSE,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6801',
                                                      'JF',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01020',
                                                       'NOW_MONEY')
       END AS TAX_EXPENSE_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6001',
                                                      'DL',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6051',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01001',
                                                       'NOW_MONEY_SUM')
       END AS REVENUE_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6001',
                                                      'DL',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6051',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01001',
                                                       'NOW_MONEY_SUM')
       END AS REVENUE_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6401',
                                                      'JL',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6402',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01002',
                                                       'NOW_MONEY_SUM')
       END AS BUSINESS_COST_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6401',
                                                      'JL',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6402',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01002',
                                                       'NOW_MONEY_SUM')
       END AS BUSINESS_COST_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6403',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01003',
                                                       'NOW_MONEY_SUM')
       END AS TAXES_SURCHARGES_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6403',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01003',
                                                       'NOW_MONEY_SUM')
       END AS TAXES_SURCHARGES_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6601',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01004',
                                                       'NOW_MONEY_SUM')
       END AS SELLING_COST_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6601',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01004',
                                                       'NOW_MONEY_SUM')
       END AS SELLING_COST_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6602',
                                                      'JL',
                                                      '${isNoAccount}') -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6602.30',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01005',
                                                       'NOW_MONEY_SUM')
       END AS OVERHEAD_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6602',
                                                      'JL',
                                                      '${isNoAccount}') -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6602.30',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01005',
                                                       'NOW_MONEY_SUM')
       END AS OVERHEAD_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6602.30',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01006',
                                                       'NOW_MONEY_SUM')
       END AS RESEARCH_EXPENSES_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6602.30',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01006',
                                                       'NOW_MONEY_SUM')
       END AS RESEARCH_EXPENSES_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01007',
                                                       'NOW_MONEY_SUM')
       END AS FINANCIAL_EXPENSES_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01007',
                                                       'NOW_MONEY_SUM')
       END AS FINANCIAL_EXPENSES_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603.02',
                                                      'JL',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603.06',
                                                      'JL',
                                                      '${isNoAccount}') -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603.02.01.03',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01008',
                                                       'NOW_MONEY_SUM')
       END AS INTEREST_EXPENSES_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603.02',
                                                      'JL',
                                                      '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603.06',
                                                      'JL',
                                                      '${isNoAccount}') -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603.02.01.03',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01008',
                                                       'NOW_MONEY_SUM')
       END AS INTEREST_EXPENSES_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          0 -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6603.01',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01009',
                                                       'NOW_MONEY_SUM')
       END AS INTEREST_INCOME_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          0 -
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6603.01',
                                                      'DL',
                                                      '${isNoAccount}')
       
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01009',
                                                       'NOW_MONEY_SUM')
       END AS INTEREST_INCOME_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6701',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01010',
                                                       'NOW_MONEY_SUM')
       END AS IMPAIRMENT_LOSS_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6701',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01010',
                                                       'NOW_MONEY_SUM')
       END AS IMPAIRMENT_LOSS_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6112',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01011',
                                                       'NOW_MONEY_SUM')
       END AS OTHER_REVENUE_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6112',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01011',
                                                       'NOW_MONEY_SUM')
       END AS OTHER_REVENUE_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6111',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01012',
                                                       'NOW_MONEY_SUM')
       END AS INVEST_REVENUE_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6111',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01012',
                                                       'NOW_MONEY_SUM')
       END AS INVEST_REVENUE_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          -1 *
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6101',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01014',
                                                       'NOW_MONEY_SUM')
       END AS FAIR_VALUE_INCOME_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          -1 *
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6101',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01014',
                                                       'NOW_MONEY_SUM')
       END AS FAIR_VALUE_INCOME_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6113',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01015',
                                                       'NOW_MONEY_SUM')
       END AS ASSET_DISPOSAL_INCOME_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6113',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01015',
                                                       'NOW_MONEY_SUM')
       END AS ASSET_DISPOSAL_INCOME_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6301',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01017',
                                                       'NOW_MONEY_SUM')
       END AS NONBUSINESS_INCOME_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6301',
                                                      'DL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01017',
                                                       'NOW_MONEY_SUM')
       END AS NONBUSINESS_INCOME_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6711',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01018',
                                                       'NOW_MONEY_SUM')
       END AS NONBUSINESS_EXPENDITURE_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6711',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01018',
                                                       'NOW_MONEY_SUM')
       END AS NONBUSINESS_EXPENDITURE_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth}',
                                                      '${currencyId}',
                                                      '6801',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01020',
                                                       'NOW_MONEY_SUM')
       END AS TAX_EXPENSE_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                      '${organId}',
                                                      '${yearmonth_h}',
                                                      '${currencyId}',
                                                      '6801',
                                                      'JL',
                                                      '${isNoAccount}')
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01020',
                                                       'NOW_MONEY_SUM')
       END AS TAX_EXPENSE_BL_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          -1 *
          (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '${currencyId}',
                                                       '6701',
                                                       'DF',
                                                       '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '${currencyId}',
                                                       '6702',
                                                       'DF',
                                                       '${isNoAccount}'))
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01023',
                                                       'NOW_MONEY')
       END AS CREDIT_IMPAIRMENT_LOSS,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          -1 *
          (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '${currencyId}',
                                                       '6701',
                                                       'DF',
                                                       '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '${currencyId}',
                                                       '6702',
                                                       'DF',
                                                       '${isNoAccount}'))
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01023',
                                                       'NOW_MONEY')
       END AS CREDIT_IMPAIRMENT_LOSS_ST
  FROM DUAL

SELECT CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2019 THEN
          -1 *
          (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '${currencyId}',
                                                       '6701',
                                                       'DL',
                                                       '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '${currencyId}',
                                                       '6702',
                                                       'DL',
                                                       '${isNoAccount}'))
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth}',
                                                       '1',
                                                       '01023',
                                                       'NOW_MONEY_SUM')
       END AS CREDIT_IMPAIRMENT_LOSS_BL,
       CASE
         WHEN TO_NUMBER(SUBSTR('${yearmonth}', 0, 4)) > 2020 THEN
          -1 *
          (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '${currencyId}',
                                                       '6701',
                                                       'DL',
                                                       '${isNoAccount}') +
          SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '${currencyId}',
                                                       '6702',
                                                       'DL',
                                                       '${isNoAccount}'))
         ELSE
          SOLAR_FN_LEDGER.F_GET_HISTORY_REPORT_DATA_BK('${ACCOUNTBOOKID}',
                                                       '${organId}',
                                                       '${yearmonth_h}',
                                                       '1',
                                                       '01023',
                                                       'NOW_MONEY_SUM')
       END AS CREDIT_IMPAIRMENT_LOSS_BL_ST
  FROM DUAL

