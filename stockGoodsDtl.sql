select 
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1405.01','C','${isNoAccount}') 
as commodity_stocks_qc,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1405.01','JL','${isNoAccount}') 
as commodity_stocks_bz,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1405.01','DL','${isNoAccount}') 
as commodity_stocks_bj,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1471.04','C','${isNoAccount}') 
as commodity_stocks_qc_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.04','JL','${isNoAccount}') 
as commodity_stocks_bz_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.04','DL','${isNoAccount}') 
as commodity_stocks_bj_d
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1403','C','${isNoAccount}') 
as materials_qc,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1403','JL','${isNoAccount}') 
as materials_bz,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1403','DL','${isNoAccount}') 
as materials_bj,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1471.01','C','${isNoAccount}') 
as materials_qc_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.01','JL','${isNoAccount}') 
as materials_bz_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.01','DL','${isNoAccount}') 
as materials_bj_d
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1406.01','C','${isNoAccount}') 
as deliver_goods_qc,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1406.01','JL','${isNoAccount}') 
as deliver_goods_bz,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1406.01','DL','${isNoAccount}') 
as deliver_goods_bj
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1402.01','C','${isNoAccount}') 
as transit_materials_qc,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1402.01','JL','${isNoAccount}') 
as transit_materials_bz,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1402.01','DL','${isNoAccount}') 
as transit_materials_bj,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1471.05','C','${isNoAccount}') 
as transit_materials_qc_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.05','JL','${isNoAccount}') 
as transit_materials_bz_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.05','DL','${isNoAccount}') 
as transit_materials_bj_d
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1411.01','C','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1412.01.01.01','C','${isNoAccount}')
as turnover_materials_qc,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1411.01','JL','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1412.01.01.01','JL','${isNoAccount}') 
as turnover_materials_bz,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1411.01','DL','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1412.01.01.01','DL','${isNoAccount}') 
as turnover_materials_bj,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1471.03','C','${isNoAccount}') 
as turnover_materials_qc_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.03','JL','${isNoAccount}') 
as turnover_materials_bz_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.03','DL','${isNoAccount}') 
as turnover_materials_bj_d
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1408.01','C','${isNoAccount}') 
as process_materials_qc,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1408.01','JL','${isNoAccount}') 
as process_materials_bz,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1408.01','DL','${isNoAccount}') 
as process_materials_bj,
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1471.06','C','${isNoAccount}') 
as process_materials_qc_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.06','JL','${isNoAccount}') 
as process_materials_bz_d,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1471.06','DL','${isNoAccount}') 
as process_materials_bj_d
from dual

select 
solar_fn_ledger.f_get_account_balance_na('${organId}',substr('${yearmonth}',1,4)||'-01','${currencyId}','1412.01.01.01','C','${isNoAccount}') 
as other_qc,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1412.01.01.01','JL','${isNoAccount}') 
as other_bz,
solar_fn_ledger.f_get_account_balance_na('${organId}','${yearmonth}','${currencyId}','1412.01.01.01','DL','${isNoAccount}') 
as other_bj
from dual

