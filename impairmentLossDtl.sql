SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE('${ORGANID}',
                                             '${YEARMONTH}',
                                             '${CURRENCYID}',
                                             '1231.01',
                                             'C') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE('${ORGANID}',
                                             '${YEARMONTH}',
                                             '${CURRENCYID}',
                                             '1231.02',
                                             'C') AMOUNT2
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE('${ORGANID}',
                                             '${YEARMONTH}',
                                             '${CURRENCYID}',
                                             '1231.01.01.01',
                                             'DL') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE('${ORGANID}',
                                             '${YEARMONTH}',
                                             '${CURRENCYID}',
                                             '1231.02',
                                             'DL') AMOUNT2
  FROM DUAL


