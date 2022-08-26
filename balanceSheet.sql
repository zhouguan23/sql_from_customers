select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1001','Y')+
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1002','Y')+
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1012','Y') 
as monetary_fund
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1101','Y')
as monetary_assets
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1121','Y')
as bill_receivable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.02.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.01.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.99.01.01','JY') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1231.01.01','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.99.01','JY')
as credit_receivable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.01.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.01.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.02.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.02.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.03.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.03.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.04.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.04.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.05.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.05.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.05.01.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.05.01.04','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.98.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.98.02.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.99.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.01.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.01.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.02.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.02.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.98.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.99.01.01','JY')
as credit_advance
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.01.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.98','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.99','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.97','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.98','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.99','JY') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1231.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.04','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.05','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.06','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.99','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.04','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.05','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.06','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.07','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.08','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.09','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.99','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.98.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.99.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.10','JY')
as other_receivable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1132','Y')
as interest_receivable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1131','Y')
as dividend_receivable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1321','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2314','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1402','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1403','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1404','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1405','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1406','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1408','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1409','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1410','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1411','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1412','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1471','Y')
as stock_goods
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.03','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.04','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.05','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.06','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.07','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.08','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.09','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.10','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.02.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.03.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.04.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.05.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.06.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.07.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.08.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.09.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.10.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.11.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.02.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.03.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.04.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.05.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.06.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.07.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.08.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.09.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.10.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.10.01.02','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.11.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.12.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.13.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.14.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.15.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.16.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.17.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.18.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.19.01.01','JY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.99.01.01','JY')
as other_floating_assets
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1503','Y')
as sale_financial_assets
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1501','Y') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1502','Y')
as maturity_investment
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1531','Y') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1532','Y')
as long_term_receivables
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1511','Y')
as equity_investments
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1521','Y') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1522','Y') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1523','Y')
as investment_property
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1601','Y') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1602','Y') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1603','Y')
as fixed_assets
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1606','Y')
as fixed_assets_clear
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1604','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1605','Y')
as cip
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1605','Y')
as project_material
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1701','Y') - 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1702','Y') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1703','Y')
as immaterial_assets
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','5301.02','Y')
as development_expenditure
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1711','Y')
as goodwill
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1801','Y')
as deferred_expenses
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1811','Y')
as deferred_tax_assets
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1901.01','JY')
as other_noncurrent_assets
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2001','Y')
as short_loan
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2101','Y')
as monetary_debt
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2201','Y')
as bill_payable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.01.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.01.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.02.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.02.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.03.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.03.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.04.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.04.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.05.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.05.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.05.01.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.05.01.04','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.98.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.98.02.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1123.99.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.01.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.01.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.02.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.02.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.98.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2202.99.01.01','DY')
as credit_payable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.01.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.02.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2203.01.99.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.01.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.02.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1122.99.01.01','DY')
as deposit_received
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2211','Y')
as accrued_payroll
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.04','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.05','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.06','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.07','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.08','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.09','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.01.10','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.02.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.03.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.04.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.05.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.06.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.07.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.08.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.09.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.10.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.01.11.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.02.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.03.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.04.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.05.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.06.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.07.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.08.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.09.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.10.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.10.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.11.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.12.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.13.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.14.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.15.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.16.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.17.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.18.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.19.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2221.99.01.01','DY')
as taxes_payable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2231','Y')
as accrued_profits
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2232','Y')
as dividend_payable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.01.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.98','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.02.01.99','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.97','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.98','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','1221.03.01.99','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.04','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.05','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.06','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.01.01.99','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.02.01.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.02','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.03','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.04','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.05','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.06','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.07','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.08','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.09','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.99','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.98.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.99.01.01','DY') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2241.03.01.10','DY')
as other_payable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2501','Y')
as long_loan
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2502','Y')
as bonds_payable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2701','Y') -
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2702','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2711','Y')
as long_term_payable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2711','Y')
as specific_payable
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2401','Y')
as deferred_income
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2801','Y')
as accrued_liabilities
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','2901','Y')
as deferred_tax_liabilities
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4001','Y')
as paid_in_capital
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4002','Y')
as capital_reserves
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4201','Y')
as treasury_stock
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4301','Y')
as special_reserve
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4101','Y')
as surplus
from dual

select 
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4104','Y') +
solar_fn_ledger.f_get_account_balance_ebs('${organId}','${yearmonth}','${currencyId}','4103','Y')
as undistributed_profits
from dual

