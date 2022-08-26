select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1001','Y','${isNoAccount}')+
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1002','Y','${isNoAccount}')+
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1012','Y','${isNoAccount}') 
as monetary_fund,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1001','Y','${isNoAccount}')+
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1002','Y','${isNoAccount}')+
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1012','Y','${isNoAccount}') 
as monetary_fund_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1101','Y','${isNoAccount}')
as monetary_assets,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1101','Y','${isNoAccount}')
as monetary_assets_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1121','Y','${isNoAccount}')
as bill_receivable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1121','Y','${isNoAccount}')
as bill_receivable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1122.02.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1122.01.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1122.99.01.01','JY','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1231.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.02.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.02.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.02.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.99.01','JY','${isNoAccount}')
as credit_receivable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.02.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.01.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.99.01.01','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1231.01.01','Y','${isNoAccount}')
as credit_receivable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.01.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.01.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.02.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.02.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.03.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.03.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.04.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.04.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.05.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.05.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.05.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.05.01.04','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.98.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.98.02.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.99.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.01.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.01.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.02.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.02.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.98.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.99.01.01','JY','${isNoAccount}')
as credit_advance,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123','Y','${isNoAccount}')
as credit_advance_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.01.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.04','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.98','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.99','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.97','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.98','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.99','JY','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1231.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.04','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.05','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.06','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.99','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.02.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.02.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.02.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.04','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.05','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.06','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.07','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.08','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.09','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.99','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.98.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.99.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.10','JY','${isNoAccount}')
as other_receivable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.01.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.03','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.04','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.98','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.99','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.03','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.97','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.98','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.99','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1231.02','Y','${isNoAccount}')
as other_receivable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1132','Y','${isNoAccount}')
as interest_receivable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1132','Y','${isNoAccount}')
as interest_receivable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1131','Y','${isNoAccount}')
as dividend_receivable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1131','Y','${isNoAccount}')
as dividend_receivable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1321','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2314','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1402','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1403','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1404','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1405','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1406','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1408','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1409','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1410','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1411','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1412','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471','Y','${isNoAccount}')
as stock_goods,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1321','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2314','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1402','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1403','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1404','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1405','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1406','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1408','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1409','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1410','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1411','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1412','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1471','Y','${isNoAccount}')
as stock_goods_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1901.01.01.01','Y','${isNoAccount}')
as book_balance,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.04','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.05','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.06','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.07','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.08','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.09','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.10','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.02.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.03.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.04.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.05.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.06.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.07.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.08.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.09.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.10.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.11.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.02.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.03.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.04.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.05.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.06.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.07.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.08.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.09.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.10.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.10.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.11.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.12.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.13.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.14.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.15.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.16.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.17.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.18.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.19.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.99.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1901.01.01.01','Y','${isNoAccount}')
as other_floating_assets,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.03','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.04','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.05','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.06','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.07','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.08','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.09','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.10','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.02.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.03.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.04.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.05.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.06.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.07.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.08.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.09.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.10.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.11.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.02.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.03.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.04.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.05.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.06.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.07.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.08.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.09.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.10.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.10.01.02','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.11.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.12.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.13.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.14.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.15.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.16.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.17.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.18.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.19.01.01','JY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.99.01.01','JY','${isNoAccount}')
as other_floating_assets_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1503','Y','${isNoAccount}')
as sale_financial_assets,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1503','Y','${isNoAccount}')
as sale_financial_assets_ebs
from dual

SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '1501',
                                                'Y',
                                                '${isNoAccount}') -
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '1502',
                                                'Y',
                                                '${isNoAccount}') AS MATURITY_INVESTMENT,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '1501',
                                                 'Y',
                                                 '${isNoAccount}') -
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '1502',
                                                 'Y',
                                                 '${isNoAccount}') AS MATURITY_INVESTMENT_EBS
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '1531',
                                                'Y',
                                                '${isNoAccount}') -
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '1532',
                                                'Y',
                                                '${isNoAccount}') AS LONG_TERM_RECEIVABLES,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '1531',
                                                 'Y',
                                                 '${isNoAccount}') -
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '1532',
                                                 'Y',
                                                 '${isNoAccount}') AS LONG_TERM_RECEIVABLES_EBS
  FROM DUAL


SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '1511',
                                                'Y',
                                                '${isNoAccount}') AS EQUITY_INVESTMENTS,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '1511',
                                                 'Y',
                                                 '${isNoAccount}') AS EQUITY_INVESTMENTS_EBS
  FROM DUAL


select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1521','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1522','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1523','Y','${isNoAccount}')
as investment_property,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1521','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1522','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1523','Y','${isNoAccount}')
as investment_property_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1601','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1602','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1603','Y','${isNoAccount}')
as fixed_assets,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1601','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1602','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1603','Y','${isNoAccount}')
as fixed_assets_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1606','Y','${isNoAccount}')
as fixed_assets_clear,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1606','Y','${isNoAccount}')
as fixed_assets_clear_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1604','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1605','Y','${isNoAccount}')
as cip,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1604','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1605','Y','${isNoAccount}')
as cip_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1605','Y','${isNoAccount}')
as project_material,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1605','Y','${isNoAccount}')
as project_material_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1701','Y','${isNoAccount}') - 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1702','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1703','Y','${isNoAccount}')
as immaterial_assets,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1701','Y','${isNoAccount}') - 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1702','Y','${isNoAccount}') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1703','Y','${isNoAccount}')
as immaterial_assets_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','5301.02','Y','${isNoAccount}')
as development_expenditure,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','5301.02','Y','${isNoAccount}')
as development_expenditure_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1711','Y','${isNoAccount}')
as goodwill,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1711','Y','${isNoAccount}')
as goodwill_ebs
from dual

SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '1801',
                                                'Y',
                                                '${isNoAccount}') AS DEFERRED_EXPENSES,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '1801',
                                                 'Y',
                                                 '${isNoAccount}') AS DEFERRED_EXPENSES_EBS
  FROM DUAL


select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1811','Y','${isNoAccount}')
as deferred_tax_assets,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1811','Y','${isNoAccount}')
as deferred_tax_assets_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1901.01','JY','${isNoAccount}')
as other_noncurrent_assets,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1901.01','JY','${isNoAccount}')
as other_noncurrent_assets_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2001','Y','${isNoAccount}')
as short_loan,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2001','Y','${isNoAccount}')
as short_loan_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2101','Y','${isNoAccount}')
as monetary_debt,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2101','Y','${isNoAccount}')
as monetary_debt_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2201','Y','${isNoAccount}')
as bill_payable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2201','Y','${isNoAccount}')
as bill_payable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.01.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.01.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.02.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.02.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.03.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.03.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.04.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.04.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.05.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.05.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.05.01.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.05.01.04','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.98.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.98.02.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1123.99.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.01.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.01.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.02.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.02.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.98.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2202.99.01.01','DY','${isNoAccount}')
as credit_payable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.01.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.01.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.02.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.02.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.98.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.99.01.01','Y','${isNoAccount}')
as credit_payable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.01.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.02.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.02.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.02.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2203.01.99.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1122.01.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1122.02.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1122.99.01.01','DY','${isNoAccount}')
as deposit_received,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.03','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.03','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.99.01','Y','${isNoAccount}')
as deposit_received_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2211','Y','${isNoAccount}')
as accrued_payroll,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2211','Y','${isNoAccount}')
as accrued_payroll_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.04','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.05','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.06','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.07','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.08','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.09','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.01.10','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.02.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.03.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.04.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.05.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.06.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.07.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.08.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.09.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.10.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.01.11.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.02.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.03.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.04.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.05.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.06.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.07.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.08.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.09.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.10.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.10.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.11.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.12.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.13.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.14.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.15.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.16.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.17.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.18.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.19.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2221.99.01.01','DY','${isNoAccount}')
as taxes_payable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.03','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.04','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.05','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.06','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.07','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.08','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.09','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.10','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.02.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.03.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.04.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.05.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.06.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.07.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.08.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.09.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.10.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.11.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.02.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.03.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.04.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.05.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.06.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.07.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.08.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.09.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.10.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.10.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.11.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.12.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.13.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.14.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.15.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.16.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.17.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.18.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.19.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.99.01.01','Y','${isNoAccount}')
as taxes_payable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2231','Y','${isNoAccount}')
as accrued_profits,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2231','Y','${isNoAccount}')
as accrued_profits_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2232','Y','${isNoAccount}')
as dividend_payable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2232','Y','${isNoAccount}')
as dividend_payable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.01.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.04','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.98','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.02.01.99','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.97','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.98','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1221.03.01.99','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.04','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.05','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.06','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.01.01.99','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.02.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.02.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.02.01.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.02','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.03','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.04','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.05','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.06','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.07','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.08','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.09','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.99','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.98.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.99.01.01','DY','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2241.03.01.10','DY','${isNoAccount}')
as other_payable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.03','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.04','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.05','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.06','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.99','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.03','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.02','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.03','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.04','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.05','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.06','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.07','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.08','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.09','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.99','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.98.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.99.01.01','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.10','Y','${isNoAccount}')
as other_payable_ebs
from dual

SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '2501',
                                                'Y',
                                                '${isNoAccount}') AS LONG_LOAN,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '2501',
                                                 'Y',
                                                 '${isNoAccount}') AS LONG_LOAN_EBS
  FROM DUAL


select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2502','Y','${isNoAccount}')
as bonds_payable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2502','Y','${isNoAccount}')
as bonds_payable_ebs
from dual

SELECT SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '2701',
                                                'Y',
                                                '${isNoAccount}') -
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '2702',
                                                'Y',
                                                '${isNoAccount}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_NA('${organId}',
                                                '${yearmonth}',
                                                '${currencyId}',
                                                '2711',
                                                'Y',
                                                '${isNoAccount}') AS LONG_TERM_PAYABLE,
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '2701',
                                                 'Y',
                                                 '${isNoAccount}') -
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '2702',
                                                 'Y',
                                                 '${isNoAccount}') +
       SOLAR_FN_LEDGER.F_GET_ACCOUNT_BALANCE_EBS('${organId}',
                                                 '${yearmonth}',
                                                 '${currencyId}',
                                                 '2711',
                                                 'Y',
                                                 '${isNoAccount}') AS LONG_TERM_PAYABLE_EBS
  FROM DUAL


select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2711','Y','${isNoAccount}')
as specific_payable,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2711','Y','${isNoAccount}')
as specific_payable_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2401','Y','${isNoAccount}')
as deferred_income,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2401','Y','${isNoAccount}')
as deferred_income_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2801','Y','${isNoAccount}')
as accrued_liabilities,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2801','Y','${isNoAccount}')
as accrued_liabilities_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','2901','Y','${isNoAccount}')
as deferred_tax_liabilities,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2901','Y','${isNoAccount}')
as deferred_tax_liabilities_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','4001','Y','${isNoAccount}')
as paid_in_capital,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4001','Y','${isNoAccount}')
as paid_in_capital_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','4002','Y','${isNoAccount}')
as capital_reserves,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4002','Y','${isNoAccount}')
as capital_reserves_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','4201','Y','${isNoAccount}')
as treasury_stock,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4201','Y','${isNoAccount}')
as treasury_stock_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','4301','Y','${isNoAccount}')
as special_reserve,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4301','Y','${isNoAccount}')
as special_reserve_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','4101','Y','${isNoAccount}')
as surplus,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4101','Y','${isNoAccount}')
as surplus_ebs
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','4104','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','4103','Y','${isNoAccount}')
as undistributed_profits,
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4104','Y','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4103','Y','${isNoAccount}')
as undistributed_profits_ebs
from dual

select  sum(t.monetary_fund) as monetary_fund,
        sum(t.monetary_assets) as monetary_assets,
        sum(t.bill_credit_total) as bill_credit_total,
        sum(t.bill_receivable) as bill_receivable,
        sum(t.credit_receivable) as credit_receivable,
        sum(t.credit_advance) as credit_advance,
        sum(t.other_receivable_total) as other_receivable_total,
        sum(t.interest_receivable) as interest_receivable,
        sum(t.dividend_receivable) as dividend_receivable,
        sum(t.other_receivable) as other_receivable,
        sum(t.stock_goods) as stock_goods,
        sum(t.ncadwoy) as ncadwoy,
        sum(t.other_floating_assets) as other_floating_assets,
        sum(t.floating_assets_total) as floating_assets_total,
        sum(t.sale_financial_assets) as sale_financial_assets,
        sum(t.maturity_investment) as maturity_investment,
        sum(t.long_term_receivables) as long_term_receivables,
        sum(t.equity_investments) as equity_investments,
        sum(t.investment_property) as investment_property,
        sum(t.fixed_assets) as fixed_assets,
        sum(t.fixed_assets_clear) as fixed_assets_clear,
        sum(t.cip) as cip,
        sum(t.project_material) as project_material,
        sum(t.biological_assets) as biological_assets,
        sum(t.oil_gas_assets) as oil_gas_assets,
        sum(t.immaterial_assets) as immaterial_assets,
        sum(t.development_expenditure) as development_expenditure,
        sum(t.goodwill) as goodwill,
        sum(t.deferred_expenses) as deferred_expenses,
        sum(t.deferred_tax_assets) as deferred_tax_assets,
        sum(t.other_noncurrent_assets) as other_noncurrent_assets,
        sum(t.noncurrent_assets_total) as noncurrent_assets_total,
        sum(t.assets_total) as assets_total,
        sum(t.short_loan) as short_loan,
        sum(t.monetary_debt) as monetary_debt,
        sum(t.bill_credit_sum) as bill_credit_sum,
        sum(t.bill_payable) as bill_payable,
        sum(t.credit_payable) as credit_payable,
        sum(t.deposit_received) as deposit_received,
        sum(t.accrued_payroll) as accrued_payroll,
        sum(t.taxes_payable) as taxes_payable,
        sum(t.other_payable_total) as other_payable_total,
        sum(t.accrued_profits) as accrued_profits,
        sum(t.dividend_payable) as dividend_payable,
        sum(t.other_payable) as other_payable,
        sum(t.ncldwoy) as ncldwoy,
        sum(t.other_current_liability) as other_current_liability,
        sum(t.current_liability_total) as current_liability_total,
        sum(t.long_loan) as long_loan,
        sum(t.bonds_payable) as bonds_payable,
        sum(t.long_term_payable) as long_term_payable,
        sum(t.specific_payable) as specific_payable,
        sum(t.deferred_income) as deferred_income,
        sum(t.accrued_liabilities) as accrued_liabilities,
        sum(t.deferred_tax_liabilities) as deferred_tax_liabilities,
        sum(t.other_noncurrent_liability) as other_noncurrent_liability,
        sum(t.noncurrent_liability_total) as noncurrent_liability_total,
        sum(t.liability_total) as liability_total,
        sum(t.paid_in_capital) as paid_in_capital,
        sum(t.capital_reserves) as capital_reserves,
        sum(t.treasury_stock) as treasury_stock,
        sum(t.special_reserve) as special_reserve,
        sum(t.surplus) as surplus,
        sum(t.general_risk_preparation) as general_risk_preparation,
        sum(t.undistributed_profits) as undistributed_profits,
        sum(t.oci) as oci,
        sum(t.owner_equity_total) as owner_equity_total,
        sum(t.liabilities_owner_equity_total) as liabilities_owner_equity_total
from fn_bs_reclassify_adjust t
where t.status = 2000
     and t.organ_id = '${organId}'
	and t.period_code = '${yearmonth}'
	and t.currency_id = '${currencyId}'

select t.* from 
(select t.organ_id,t.period_code,t.currency_id,
       replace(to_char(wm_concat(decode(nvl(t.monetary_fund,0),0,'',o.name||'：'||t.monetary_fund))),',','||') as monetary_fund,
       replace(to_char(wm_concat(decode(nvl(t.monetary_assets,0),0,'',o.name||'：'||t.monetary_assets))),',','||') as monetary_assets,
       replace(to_char(wm_concat(decode(nvl(t.bill_credit_total,0),0,'',o.name||'：'||t.bill_credit_total))),',','||') as bill_credit_total,
        replace(to_char(wm_concat(decode(nvl(t.bill_receivable,0),0,'',o.name||'：'||t.bill_receivable))),',','||') as bill_receivable,
        replace(to_char(wm_concat(decode(nvl(t.credit_receivable,0),0,'',o.name||'：'||t.credit_receivable))),',','||') as credit_receivable,
        replace(to_char(wm_concat(decode(nvl(t.credit_advance,0),0,'',o.name||'：'||t.credit_advance))),',','||') as credit_advance,
        replace(to_char(wm_concat(decode(nvl(t.other_receivable_total,0),0,'',o.name||'：'||t.other_receivable_total))),',','||') as other_receivable_total,
        replace(to_char(wm_concat(decode(nvl(t.interest_receivable,0),0,'',o.name||'：'||t.interest_receivable))),',','||') as interest_receivable,
        replace(to_char(wm_concat(decode(nvl(t.dividend_receivable,0),0,'',o.name||'：'||t.dividend_receivable))),',','||') as dividend_receivable,
        replace(to_char(wm_concat(decode(nvl(t.other_receivable,0),0,'',o.name||'：'||t.other_receivable))),',','||') as other_receivable,
        replace(to_char(wm_concat(decode(nvl(t.stock_goods,0),0,'',o.name||'：'||t.stock_goods))),',','||') as stock_goods,
        replace(to_char(wm_concat(decode(nvl(t.ncadwoy,0),0,'',o.name||'：'||t.ncadwoy))),',','||') as ncadwoy,
        replace(to_char(wm_concat(decode(nvl(t.other_floating_assets,0),0,'',o.name||'：'||t.other_floating_assets))),',','||') as other_floating_assets,
        replace(to_char(wm_concat(decode(nvl(t.floating_assets_total,0),0,'',o.name||'：'||t.floating_assets_total))),',','||') as floating_assets_total,
        replace(to_char(wm_concat(decode(nvl(t.sale_financial_assets,0),0,'',o.name||'：'||t.sale_financial_assets))),',','||') as sale_financial_assets,
        replace(to_char(wm_concat(decode(nvl(t.maturity_investment,0),0,'',o.name||'：'||t.maturity_investment))),',','||') as maturity_investment,
        replace(to_char(wm_concat(decode(nvl(t.long_term_receivables,0),0,'',o.name||'：'||t.long_term_receivables))),',','||') as long_term_receivables,
        replace(to_char(wm_concat(decode(nvl(t.equity_investments,0),0,'',o.name||'：'||t.equity_investments))),',','||') as equity_investments,
        replace(to_char(wm_concat(decode(nvl(t.investment_property,0),0,'',o.name||'：'||t.investment_property))),',','||') as investment_property,
        replace(to_char(wm_concat(decode(nvl(t.fixed_assets,0),0,'',o.name||'：'||t.fixed_assets))),',','||') as fixed_assets,
        replace(to_char(wm_concat(decode(nvl(t.fixed_assets_clear,0),0,'',o.name||'：'||t.fixed_assets_clear))),',','||') as fixed_assets_clear,
        replace(to_char(wm_concat(decode(nvl(t.cip,0),0,'',o.name||'：'||t.cip))),',','||') as cip,
        replace(to_char(wm_concat(decode(nvl(t.project_material,0),0,'',o.name||'：'||t.project_material))),',','||') as project_material,
        replace(to_char(wm_concat(decode(nvl(t.biological_assets,0),0,'',o.name||'：'||t.biological_assets))),',','||') as biological_assets,
        replace(to_char(wm_concat(decode(nvl(t.oil_gas_assets,0),0,'',o.name||'：'||t.oil_gas_assets))),',','||') as oil_gas_assets,
        replace(to_char(wm_concat(decode(nvl(t.immaterial_assets,0),0,'',o.name||'：'||t.immaterial_assets))),',','||') as immaterial_assets,
        replace(to_char(wm_concat(decode(nvl(t.development_expenditure,0),0,'',o.name||'：'||t.development_expenditure))),',','||') as development_expenditure,
        replace(to_char(wm_concat(decode(nvl(t.goodwill,0),0,'',o.name||'：'||t.goodwill))),',','||') as goodwill,
        replace(to_char(wm_concat(decode(nvl(t.deferred_expenses,0),0,'',o.name||'：'||t.deferred_expenses))),',','||') as deferred_expenses,
        replace(to_char(wm_concat(decode(nvl(t.deferred_tax_assets,0),0,'',o.name||'：'||t.deferred_tax_assets))),',','||') as deferred_tax_assets,
        replace(to_char(wm_concat(decode(nvl(t.other_noncurrent_assets,0),0,'',o.name||'：'||t.other_noncurrent_assets))),',','||') as other_noncurrent_assets,
        replace(to_char(wm_concat(decode(nvl(t.noncurrent_assets_total,0),0,'',o.name||'：'||t.noncurrent_assets_total))),',','||') as noncurrent_assets_total,
        replace(to_char(wm_concat(decode(nvl(t.assets_total,0),0,'',o.name||'：'||t.assets_total))),',','||') as assets_total,
        replace(to_char(wm_concat(decode(nvl(t.short_loan,0),0,'',o.name||'：'||t.short_loan))),',','||') as short_loan,
        replace(to_char(wm_concat(decode(nvl(t.monetary_debt,0),0,'',o.name||'：'||t.monetary_debt))),',','||') as monetary_debt,
        replace(to_char(wm_concat(decode(nvl(t.bill_credit_sum,0),0,'',o.name||'：'||t.bill_credit_sum))),',','||') as bill_credit_sum,
        replace(to_char(wm_concat(decode(nvl(t.bill_payable,0),0,'',o.name||'：'||t.bill_payable))),',','||') as bill_payable,
        replace(to_char(wm_concat(decode(nvl(t.credit_payable,0),0,'',o.name||'：'||t.credit_payable))),',','||') as credit_payable,
        replace(to_char(wm_concat(decode(nvl(t.deposit_received,0),0,'',o.name||'：'||t.deposit_received))),',','||') as deposit_received,
        replace(to_char(wm_concat(decode(nvl(t.accrued_payroll,0),0,'',o.name||'：'||t.accrued_payroll))),',','||') as accrued_payroll,
        replace(to_char(wm_concat(decode(nvl(t.taxes_payable,0),0,'',o.name||'：'||t.taxes_payable))),',','||') as taxes_payable,
        replace(to_char(wm_concat(decode(nvl(t.other_payable_total,0),0,'',o.name||'：'||t.other_payable_total))),',','||') as other_payable_total,
        replace(to_char(wm_concat(decode(nvl(t.accrued_profits,0),0,'',o.name||'：'||t.accrued_profits))),',','||') as accrued_profits,
        replace(to_char(wm_concat(decode(nvl(t.dividend_payable,0),0,'',o.name||'：'||t.dividend_payable))),',','||') as dividend_payable,
        replace(to_char(wm_concat(decode(nvl(t.other_payable,0),0,'',o.name||'：'||t.other_payable))),',','||') as other_payable,
        replace(to_char(wm_concat(decode(nvl(t.ncldwoy,0),0,'',o.name||'：'||t.ncldwoy))),',','||') as ncldwoy,
        replace(to_char(wm_concat(decode(nvl(t.other_current_liability,0),0,'',o.name||'：'||t.other_current_liability))),',','||') as other_current_liability,
        replace(to_char(wm_concat(decode(nvl(t.current_liability_total,0),0,'',o.name||'：'||t.current_liability_total))),',','||') as current_liability_total,
        replace(to_char(wm_concat(decode(nvl(t.long_loan,0),0,'',o.name||'：'||t.long_loan))),',','||') as long_loan,
        replace(to_char(wm_concat(decode(nvl(t.bonds_payable,0),0,'',o.name||'：'||t.bonds_payable))),',','||') as bonds_payable,
        replace(to_char(wm_concat(decode(nvl(t.long_term_payable,0),0,'',o.name||'：'||t.long_term_payable))),',','||') as long_term_payable,
        replace(to_char(wm_concat(decode(nvl(t.specific_payable,0),0,'',o.name||'：'||t.specific_payable))),',','||') as specific_payable,
        replace(to_char(wm_concat(decode(nvl(t.deferred_income,0),0,'',o.name||'：'||t.deferred_income))),',','||') as deferred_income,
        replace(to_char(wm_concat(decode(nvl(t.accrued_liabilities,0),0,'',o.name||'：'||t.accrued_liabilities))),',','||') as accrued_liabilities,
        replace(to_char(wm_concat(decode(nvl(t.deferred_tax_liabilities,0),0,'',o.name||'：'||t.deferred_tax_liabilities))),',','||') as deferred_tax_liabilities,
        replace(to_char(wm_concat(decode(nvl(t.other_noncurrent_liability,0),0,'',o.name||'：'||t.other_noncurrent_liability))),',','||') as other_noncurrent_liability,
        replace(to_char(wm_concat(decode(nvl(t.noncurrent_liability_total,0),0,'',o.name||'：'||t.noncurrent_liability_total))),',','||') as noncurrent_liability_total,
        replace(to_char(wm_concat(decode(nvl(t.liability_total,0),0,'',o.name||'：'||t.liability_total))),',','||') as liability_total,
        replace(to_char(wm_concat(decode(nvl(t.paid_in_capital,0),0,'',o.name||'：'||t.paid_in_capital))),',','||') as paid_in_capital,
        replace(to_char(wm_concat(decode(nvl(t.capital_reserves,0),0,'',o.name||'：'||t.capital_reserves))),',','||') as capital_reserves,
        replace(to_char(wm_concat(decode(nvl(t.treasury_stock,0),0,'',o.name||'：'||t.treasury_stock))),',','||') as treasury_stock,
        replace(to_char(wm_concat(decode(nvl(t.special_reserve,0),0,'',o.name||'：'||t.special_reserve))),',','||') as special_reserve,
        replace(to_char(wm_concat(decode(nvl(t.surplus,0),0,'',o.name||'：'||t.surplus))),',','||') as surplus,
        replace(to_char(wm_concat(decode(nvl(t.general_risk_preparation,0),0,'',o.name||'：'||t.general_risk_preparation))),',','||') as general_risk_preparation,
        replace(to_char(wm_concat(decode(nvl(t.undistributed_profits,0),0,'',o.name||'：'||t.undistributed_profits))),',','||') as undistributed_profits,
        replace(to_char(wm_concat(decode(nvl(t.oci,0),0,'',o.name||'：'||t.bill_credit_total))),',','||') as oci,
        replace(to_char(wm_concat(decode(nvl(t.owner_equity_total,0),0,'',o.name||'：'||t.owner_equity_total))),',','||') as owner_equity_total,
        replace(to_char(wm_concat(decode(nvl(t.liabilities_owner_equity_total,0),0,'',o.name||'：'||t.liabilities_owner_equity_total))),',','||') as liabilities_owner_equity_total
from fn_bs_reclassify_adjust t,
     sa_oporg o
where t.status = 2000
      and t.created_by_id = o.id
      group by t.organ_id,t.period_code,t.currency_id) t
      where t.organ_id = '${organId}'
	       and t.period_code = '${yearmonth}'
 	       and t.currency_id = '${currencyId}'
      
    

select  sum(t.monetary_fund) as monetary_fund,
        sum(t.monetary_assets) as monetary_assets,
        sum(t.bill_credit_total) as bill_credit_total,
        sum(t.bill_receivable) as bill_receivable,
        sum(t.credit_receivable) as credit_receivable,
        sum(t.credit_advance) as credit_advance,
        sum(t.other_receivable_total) as other_receivable_total,
        sum(t.interest_receivable) as interest_receivable,
        sum(t.dividend_receivable) as dividend_receivable,
        sum(t.other_receivable) as other_receivable,
        sum(t.stock_goods) as stock_goods,
        sum(t.ncadwoy) as ncadwoy,
        sum(t.other_floating_assets) as other_floating_assets,
        sum(t.floating_assets_total) as floating_assets_total,
        sum(t.sale_financial_assets) as sale_financial_assets,
        sum(t.maturity_investment) as maturity_investment,
        sum(t.long_term_receivables) as long_term_receivables,
        sum(t.equity_investments) as equity_investments,
        sum(t.investment_property) as investment_property,
        sum(t.fixed_assets) as fixed_assets,
        sum(t.fixed_assets_clear) as fixed_assets_clear,
        sum(t.cip) as cip,
        sum(t.project_material) as project_material,
        sum(t.biological_assets) as biological_assets,
        sum(t.oil_gas_assets) as oil_gas_assets,
        sum(t.immaterial_assets) as immaterial_assets,
        sum(t.development_expenditure) as development_expenditure,
        sum(t.goodwill) as goodwill,
        sum(t.deferred_expenses) as deferred_expenses,
        sum(t.deferred_tax_assets) as deferred_tax_assets,
        sum(t.other_noncurrent_assets) as other_noncurrent_assets,
        sum(t.noncurrent_assets_total) as noncurrent_assets_total,
        sum(t.assets_total) as assets_total,
        sum(t.short_loan) as short_loan,
        sum(t.monetary_debt) as monetary_debt,
        sum(t.bill_credit_sum) as bill_credit_sum,
        sum(t.bill_payable) as bill_payable,
        sum(t.credit_payable) as credit_payable,
        sum(t.deposit_received) as deposit_received,
        sum(t.accrued_payroll) as accrued_payroll,
        sum(t.taxes_payable) as taxes_payable,
        sum(t.other_payable_total) as other_payable_total,
        sum(t.accrued_profits) as accrued_profits,
        sum(t.dividend_payable) as dividend_payable,
        sum(t.other_payable) as other_payable,
        sum(t.ncldwoy) as ncldwoy,
        sum(t.other_current_liability) as other_current_liability,
        sum(t.current_liability_total) as current_liability_total,
        sum(t.long_loan) as long_loan,
        sum(t.bonds_payable) as bonds_payable,
        sum(t.long_term_payable) as long_term_payable,
        sum(t.specific_payable) as specific_payable,
        sum(t.deferred_income) as deferred_income,
        sum(t.accrued_liabilities) as accrued_liabilities,
        sum(t.deferred_tax_liabilities) as deferred_tax_liabilities,
        sum(t.other_noncurrent_liability) as other_noncurrent_liability,
        sum(t.noncurrent_liability_total) as noncurrent_liability_total,
        sum(t.liability_total) as liability_total,
        sum(t.paid_in_capital) as paid_in_capital,
        sum(t.capital_reserves) as capital_reserves,
        sum(t.treasury_stock) as treasury_stock,
        sum(t.special_reserve) as special_reserve,
        sum(t.surplus) as surplus,
        sum(t.general_risk_preparation) as general_risk_preparation,
        sum(t.undistributed_profits) as undistributed_profits,
        sum(t.oci) as oci,
        sum(t.owner_equity_total) as owner_equity_total,
        sum(t.liabilities_owner_equity_total) as liabilities_owner_equity_total
from fn_bs_reclassify_difference t
where t.status = 2000
     and t.organ_id = '${organId}'
  and t.period_code = '${yearmonth}'
  and t.currency_id = '${currencyId}'

