SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1701.01',
                                                'C',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1701.02',
                                                'C',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1701.03',
                                                'C',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 SUBSTR('${YEARMONTH}', 0, 4) ||
                                                 '-01',
                                                 '${CURRENCYID}',
                                                 '1701.04',
                                                 'C',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 SUBSTR('${YEARMONTH}', 0, 4) ||
                                                 '-01',
                                                 '${CURRENCYID}',
                                                 '1701.07',
                                                 'C',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1701.05',
                                                'C',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1701.06',
                                                'C',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.01',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.02',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.03',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1701.04',
                                                 'JL',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1701.07',
                                                 'JL',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.05',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.06',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.01',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.02',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.03',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1701.04',
                                                 'DL',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1701.07',
                                                 'DL',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.05',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1701.06',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1702.01',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1702.02',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1702.03',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 SUBSTR('${YEARMONTH}', 0, 4) ||
                                                 '-01',
                                                 '${CURRENCYID}',
                                                 '1702.04',
                                                 'DC',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 SUBSTR('${YEARMONTH}', 0, 4) ||
                                                 '-01',
                                                 '${CURRENCYID}',
                                                 '1702.07',
                                                 'DC',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1702.05',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1702.06',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.01',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.02',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.03',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1702.04',
                                                 'DL',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1702.07',
                                                 'DL',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.05',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.06',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.01',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.02',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.03',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1702.04',
                                                 'JL',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1702.07',
                                                 'JL',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.05',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1702.06',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1703.01',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1703.02',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1703.03',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 SUBSTR('${YEARMONTH}', 0, 4) ||
                                                 '-01',
                                                 '${CURRENCYID}',
                                                 '1703.04',
                                                 'DC',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 SUBSTR('${YEARMONTH}', 0, 4) ||
                                                 '-01',
                                                 '${CURRENCYID}',
                                                 '1703.07',
                                                 'DC',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1703.05',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                SUBSTR('${YEARMONTH}', 0, 4) ||
                                                '-01',
                                                '${CURRENCYID}',
                                                '1703.06',
                                                'DC',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.01',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.02',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.03',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1703.04',
                                                 'DL',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1703.07',
                                                 'DL',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.05',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.06',
                                                'DL',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.01',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT1,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.02',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT2,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.03',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT3,
       (SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1703.04',
                                                 'JL',
                                                 '${ISNAACCOUNT}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                 '${YEARMONTH}',
                                                 '${CURRENCYID}',
                                                 '1703.07',
                                                 'JL',
                                                 '${ISNAACCOUNT}')) AMOUNT4,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.05',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT5,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${ORGANID}',
                                                '${YEARMONTH}',
                                                '${CURRENCYID}',
                                                '1703.06',
                                                'JL',
                                                '${ISNAACCOUNT}') AMOUNT6
  FROM DUAL


select '编制单位：'||name bzdw from sa_oporg where id='${organId}'

