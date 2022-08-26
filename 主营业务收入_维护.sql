select * 
from FR_T_MAIN_BUSINESS_INCOME_TEMP
where YWRQ BETWEEN TO_DATE('${P_S_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss') AND TO_DATE('${P_E_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss')
${IF(LEN(P_UPDATE_TIME)=0,"","AND TO_CHAR(UPDATE_TIME,'yyyy-MM-dd') = '"+P_UPDATE_TIME+"'")}
ORDER BY YWRQ


