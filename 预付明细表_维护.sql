select * 
from FR_T_PREPAYMENT_TEMP
--=where DJRQ BETWEEN TO_DATE('${P_S_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss') AND TO_DATE('${P_E_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss')
where 1=1
and CWZQ = '${P_S_DATE}'
and djbh like '%${P_Num}%'
${IF(LEN(P_DEPT_PATH)=0,"","AND EXISTS(SELECT DISTINCT 组织ID FROM V_FR_DEPT_INFO WHERE 组织路径 LIKE '"+P_DEPT_PATH+"'||'%' AND YWKSBM = 组织ID)")}---ZJTX_ZJTXGS_35
ORDER BY CWZQ


WITH P AS (
--用户可看部门
${IF(P_LEN = 1,"","/*")} --如果该用户不在平台内,则该用户不能查看组织
SELECT DISTINCT
组织ID
FROM V_FR_DEPT_INFO
WHERE 组织路径 LIKE (
SELECT FULLPATH FROM FR_DEPT_ROLE_USER WHERE USERNAME = '${fine_username}' AND ROWNUM = 1
)||'%'
UNION ALL
${IF(P_LEN = 1,"","*/")} --如果该用户不在平台内,则该用户不能查看组织
SELECT B.组织ID FROM (
SELECT DEPT_TYPE FROM FR_DEPT_ROLE_USER WHERE USERNAME = '${fine_username}' AND ROWNUM = 1
) A INNER JOIN (
SELECT DISTINCT 1 AS DEPT_TYPE,组织ID FROM V_FR_DEPT_INFO
)B ON A.DEPT_TYPE = B.DEPT_TYPE
)

SELECT DISTINCT
 组织ID,
 组织名称,
 上级组织ID,
 上级组织,
 组织级次,
 --是否最末级,
 组织路径,
 FULLPATH_NAME,
 case when "组织名称1" is null then "组织名称2" else "组织名称1" end as "组织名称1",
 case when "组织名称1" is null then null else "组织名称2" end as "组织名称2"
FROM (
SELECT
 P1.FNUMBER AS 组织ID,
 P1.FNAME_L2 AS 组织名称,
 P3.FNUMBER AS 上级组织ID,
 P3.FNAME_L2 上级组织,
 P1.FLEVEL AS 组织级次,
 REPLACE(P1.FLONGNUMBER,'!','_') as 组织路径,
 P1.FDISPLAYNAME_L2 FULLPATH_NAME,
SUBSTR(REPLACE(P1.FDISPLAYNAME_L2,'中捷通信有限公司_业务部门/职能支撑部门_',''),1,INSTR(REPLACE(P1.FDISPLAYNAME_L2,'中捷通信有限公司_业务部门/职能支撑部门_',''),'_',1,1)-1) as "组织名称1",
SUBSTR(REPLACE(P1.FDISPLAYNAME_L2,'中捷通信有限公司_业务部门/职能支撑部门_',''),INSTR(REPLACE(P1.FDISPLAYNAME_L2,'中捷通信有限公司_业务部门/职能支撑部门_',''),'_',1,1)+1) as "组织名称2"
FROM T_ORG_BASEUNIT P1
LEFT JOIN T_ORG_BASEUNIT P3 ON P1.FPARENTID = P3.FID AND P3.FNUMBER NOT LIKE '%作废%'
WHERE P1.FNUMBER NOT LIKE '%作废%'
and P1.FLEVEL >2
and P1.FNUMBER not like '%XX'
and P1.FNUMBER not like '%DL'
and P1.FNUMBER not like '%FW'
AND EXISTS(
SELECT * FROM P WHERE P1.FNUMBER = P.组织ID
)
AND EXISTS (SELECT P2.FID FROM T_ORG_BASEUNIT P2 WHERE P2.FNUMBER NOT LIKE '%作废%' AND P1.FID = P2.FID)
START WITH P1.FPARENTID IS NULL
CONNECT BY P1.FPARENTID = PRIOR P1.FID
--ORDER BY P1.FDISPLAYNAME_L2
)
ORDER BY 组织ID
--ORDER BY P1.FDISPLAYNAME_L2

select * 
from FR_T_PREPAYMENT_TEMP
--=where DJRQ BETWEEN TO_DATE('${P_S_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss') AND TO_DATE('${P_E_DATE}'||' 00:00:00','yyyy-MM-dd HH24:mi:ss')
where 1=1
and CWZQ = '2020-12'
and djbh like '%${P_Num}%'
${IF(LEN(P_DEPT_PATH)=0,"","AND EXISTS(SELECT DISTINCT 组织ID FROM V_FR_DEPT_INFO WHERE 组织路径 LIKE '"+P_DEPT_PATH+"'||'%' AND YWKSBM = 组织ID)")}---ZJTX_ZJTXGS_35
ORDER BY CWZQ


