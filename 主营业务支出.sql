SELECT MAX(LAST_TIME) LAST_TIME 
FROM FR_ETL_STATE WHERE TABLE_ID = 'FR_T_MAIN_BUSINESS_COST'

select * 
from FR_T_MAIN_BUSINESS_COST
where YWRQ BETWEEN TO_DATE('${P_S_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss') AND TO_DATE('${P_E_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss')
ORDER BY YWRQ

