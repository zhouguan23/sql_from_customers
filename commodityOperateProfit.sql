select
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','QJF','1101','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','QJF','1101','${isNoAccount}')
as sal_qty_m_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','JF','1101','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','JF','1101','${isNoAccount}')
as sal_amount_m_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.01.01.01','JF','1101','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.01','JF','1101','${isNoAccount}')
as sal_cost_m_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','QJF','1201','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','QJF','1201','${isNoAccount}')
as sal_qty_s_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','JF','1201','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','JF','1201','${isNoAccount}')
as sal_amount_s_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.01.01.01','JF','1201','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.01','JF','1201','${isNoAccount}')
as sal_cost_s_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','QJF','1301','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','QJF','1301','${isNoAccount}')
as sal_qty_l_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','JF','1301','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','JF','1301','${isNoAccount}')
as sal_amount_l_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.01.01.01','JF','1301','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.01','JF','1301','${isNoAccount}')
as sal_cost_l_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','QJF','1101','${isNoAccount}')
as sal_qty_m_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','JF','1101','${isNoAccount}')
as sal_amount_m_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.03.01.01','JF','1101','${isNoAccount}')
as sal_cost_m_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','QJF','1201','${isNoAccount}')
as sal_qty_s_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','JF','1201','${isNoAccount}')
as sal_amount_s_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.03.01.01','JF','1201','${isNoAccount}')
as sal_cost_s_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','QJF','1301','${isNoAccount}')
as sal_qty_l_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','JF','1301','${isNoAccount}')
as sal_amount_l_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.03.01.01','JF','1301','${isNoAccount}')
as sal_cost_l_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','QJF','1101','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','QJF','1101','${isNoAccount}')
as sal_qty_m_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','JF','1101','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','JF','1101','${isNoAccount}')
as sal_amount_m_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.02.01.01','JF','1101','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.02','JF','1101','${isNoAccount}')
as sal_cost_m_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','QJF','1201','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','QJF','1201','${isNoAccount}')
as sal_qty_s_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','JF','1201','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','JF','1201','${isNoAccount}')
as sal_amount_s_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.02.01.01','JF','1201','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.02','JF','1201','${isNoAccount}')
as sal_cost_s_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','QJF','1301','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','QJF','1301','${isNoAccount}')
as sal_qty_l_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.02.01.01','JF','1801','${isNoAccount}')+
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.02','JF','1801','${isNoAccount}')
as sal_cost_y_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','JF','1801','${isNoAccount}')+
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','JF','1801','${isNoAccount}')
as sal_amount_y_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','QJF','1801','${isNoAccount}')+
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','QJF','1801','${isNoAccount}')
as sal_qty_y_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','JF','1301','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','JF','1301','${isNoAccount}')
as sal_amount_l_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.02.01.01','JF','1301','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.02','JF','1301','${isNoAccount}')
as sal_cost_l_w
from dual

select
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','QJF','1401','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','QJF','1401','${isNoAccount}')
as sal_qty_m_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','JF','1401','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','JF','1401','${isNoAccount}')
as sal_amount_m_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.01.01.01','JF','1401','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.01','JF','1401','${isNoAccount}')
as sal_cost_m_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','QJF','1501','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','QJF','1501','${isNoAccount}')
as sal_qty_s_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','JF','1501','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','JF','1501','${isNoAccount}')
as sal_amount_s_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.01.01.01','JF','1501','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.01','JF','1501','${isNoAccount}')
as sal_cost_s_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','QJF','1701','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','QJF','1701','${isNoAccount}')
as sal_qty_l_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','JF','1701','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','JF','1701','${isNoAccount}')
as sal_amount_l_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.01.01.01','JF','1701','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.01','JF','1701','${isNoAccount}')
as sal_cost_l_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','QJF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','QJF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','QJF','1605','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','QJF','1605','${isNoAccount}')
as sal_qty_d_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','JF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','JF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.01.01.01','JF','1605','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.01','JF','1605','${isNoAccount}') 
as sal_amount_d_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.01.01.01','JF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.01','JF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.01.01.01','JF','1605','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.01','JF','1605','${isNoAccount}') 
as sal_cost_d_z,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','QJF','1401','${isNoAccount}')
as sal_qty_m_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','JF','1401','${isNoAccount}')
as sal_amount_m_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.03.01.01','JF','1401','${isNoAccount}')
as sal_cost_m_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','QJF','1501','${isNoAccount}')
as sal_qty_s_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','JF','1501','${isNoAccount}')
as sal_amount_s_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.03.01.01','JF','1501','${isNoAccount}')
as sal_cost_s_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','QJF','1701','${isNoAccount}')
as sal_qty_l_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','JF','1701','${isNoAccount}')
as sal_amount_l_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.03.01.01','JF','1701','${isNoAccount}')
as sal_cost_l_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','QJF','1601','${isNoAccount}')
as sal_qty_d_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.03.01.01','JF','1601','${isNoAccount}')
as sal_amount_d_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.03.01.01','JF','1601','${isNoAccount}')
as sal_cost_d_d,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','QJF','1401','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','QJF','1401','${isNoAccount}')
as sal_qty_m_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','JF','1401','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','JF','1401','${isNoAccount}')
as sal_amount_m_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.02.01.01','JF','1401','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.02','JF','1401','${isNoAccount}')
as sal_cost_m_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','QJF','1501','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','QJF','1501','${isNoAccount}')
as sal_qty_s_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','JF','1501','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','JF','1501','${isNoAccount}')
as sal_amount_s_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.02.01.01','JF','1501','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.02','JF','1501','${isNoAccount}')
as sal_cost_s_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','QJF','1701','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','QJF','1701','${isNoAccount}')
as sal_qty_l_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','JF','1701','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','JF','1701','${isNoAccount}')
as sal_amount_l_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.02.01.01','JF','1701','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.02','JF','1701','${isNoAccount}')
as sal_cost_l_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','QJF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','QJF','1601','${isNoAccount}')
as sal_qty_d_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.02.01.01','JF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6001.04.01.02','JF','1601','${isNoAccount}')
as sal_amount_d_w,
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.02.01.01','JF','1601','${isNoAccount}') +
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6401.04.01.02','JF','1601','${isNoAccount}')
as sal_cost_d_w
from dual

select
solar_fn_ledger.f_get_account_balance_qora('${organId}','${yearmonthB}','${yearmonthE}','${currencyId}','6601','JF','','${isNoAccount}')
as sale_fee
from dual

