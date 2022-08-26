select 
	INSERT_TIME as 更新时间,
	DEPT_CODE as 部门编码,
	DEPT_NAME as 部门名称,
	CAPITAL_INFLOW as 本年资金流入,
	CAPITAL_OUTFLOW as 本年资金流出,
	PAYMENT_BALANCE_Y	as 本年收支差,
	PAYMENT_BALANCE_BY as 年初收支差,
	WORKING_PAYMENT_BALANCE as 滚动累计收支差,
	FUNDS_INTERESTS_D as 每天资金利息
from FR_T_CASH_DAILY_REPORT
where INSERT_TIME BETWEEN TO_DATE('${P_S_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss') AND TO_DATE('${P_E_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss')
order by 更新时间,decode(部门编码, '35', 1, '32', 2, '31', 3, '33', 4, '34', 5, '36', 6, '37', 7, '91', 8)

