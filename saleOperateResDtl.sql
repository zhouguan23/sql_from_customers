select solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '01',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_01,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '02',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_02,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '03',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_03,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '04',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_04,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '05',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_05,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '06',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_06,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '07',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_07,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '08',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_08,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '09',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_09,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '10',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_10,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '11',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_11,
       solar_fn_ledger.f_get_sale_out_goods_qty_cfg('${organId}',
                                                    '${year}',
                                                    '12',
                                                    '${currencyId}',
                                                    '${materieltypeCode}') as qty_12
  from dual

select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6001.01.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF')
as qty_12
from dual

select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6001.04.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_12
from dual

select 
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_01,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_02,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_03,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_04,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_05,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_06,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_07,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_08,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_09,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_10,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_11,
abs(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','1604.05.01.02','QJF')
+solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','1604.05.01.05','QJF'))
as qty_12
from dual

select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6001','DF')
as mb_income_12
from dual

select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6051','DF')
as ob_income_12
from dual

select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6401','JF')
as mb_cost_12
from dual

select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6402','JF')
as ob_cost_12
from dual

select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','1406','QY')/1000000
as qty_12
from dual

select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-01'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-02'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-03'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-04'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-05'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-06'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-07'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-08'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-09'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-10'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-11'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select t.income,
       t.gross_profit_rate,
       t.gross_profit_quota,
       t.month_end_balance,
       t.dicip,
       t.order_forecast,
       t.expectations_profit,
       t.sale_price,
       t.cost_price
from fn_sal_operate_result t
where t.status = 2000
	and t.organ_id = '${organId}'
	and t.yearmonth = '${year}'||'-12'
	and t.currency_id = '${currencyId}'
	and t.materieltype_code = '${materieltypeCode}'


select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6001.02.01.01','QDF') +
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6001.04.01.02','QDF')
as qty_12
from dual

select 
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_01,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_02,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_03,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_04,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_05,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_06,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_07,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_08,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_09,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_10,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_11,
solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','6001.03.01.01','QDF')
as qty_12
from dual

select 
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-01','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_01,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-02','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_02,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-03','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_03,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-04','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_04,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-05','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_05,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-06','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_06,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-07','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_07,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-08','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_08,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-09','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_09,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-10','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_10,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-11','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_11,
round(solar_fn_ledger.f_get_account_balance_qty('${organId}','${year}'||'-12','${currencyId}','${materieltypeCode}','1405','QY')/1000000,2)
as qty_12
from dual

