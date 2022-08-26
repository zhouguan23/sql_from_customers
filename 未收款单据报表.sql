SELECT a.id,a.username,a.realname,b.roleid,c.description,
       left(c.description,4) as bukrs2,
       right(c.description,1) as price_autho2,
       D.BUKRS,D.WERKS,D.price
FROM fine_user a
INNER JOIN fine_user_role_middle b on a.id = b.userid
inner join fine_custom_role c on c.id = b.roleid
left join PUBLIC.CUSTOM_ROLE_PARAMETER as d on d.role_id = c.name 
where a.username='${fine_username}'

SELECT bukrs,BUTXT 
FROM "SAPHANADB"."T001" 
WHERE BUKRS IN ( '${IV_BUKRS2}' ) 
order by bukrs

SELECT
A.KUNNR,
B.NAME1
FROM "SAPHANADB"."KNB1" AS A
LEFT JOIN "SAPHANADB"."KNA1" AS B ON A.KUNNR = B.KUNNR
where BUKRS in ( '${IV_BUKRS}' ) 
order by name1



SELECT 	
	A.VKGRP,
	B.BEZEI
FROM "SAPHANADB"."TVBVK" AS A
left join "SAPHANADB"."TVGRT" as B on A.VKGRP =B.VKGRP and B.spras = '1'
where VKBUR IN ( '${IV_VKBUR_T}' ) 


SELECT 	
	A.VKBUR,
	B.BEZEI
FROM "SAPHANADB"."TVKBZ" AS A
left join "SAPHANADB"."TVKBT" as B on A.VKBUR =B.VKBUR and B.spras = '1'
where vkorg in ( '${IV_BUKRS}' ) 

select 
bukrs, --公司代码
butxt, --公司名称
budat, --开票日期
vbeln, --发票号码
belnr, --凭证编码
blart, --单据类型A
BLART_N, --单据类型
LTRIM( KUNNR,'0' ) as KUNNR, --客户编码
name1, --客户名称
dmbtr, --含税金额
DMBTR2, --已清账金额
dmbtr-DMBTR2 ,--未清帐金额
--ZWHK,  --
hkont, --成本中心
rebzg, --手工凭证
gjahr, --年度
zterm, --付款条件
wavwr, --成本
netwr, --净值  毛利 = 净值 -成本   （汇总净值-汇总成本）/汇总净值*100% = 毛利率
netwr-wavwr,
LTRIM( KUNNR2,'0' ) as KUNNR2, ----终端客户编码
name2, --终端客户名称
zzdkhje,--终端客户含税金额
vkbur_t, --销售办事处编码
vkgrp_t, --销售组编码
zkfyxm, --单据客服员
zywymc, --单据业务员
name_last, --凭证创建人
bktxt, --凭证备注
sgtxt --行备注
from "SAPHANADB"."ZFIV_AR_BSID_D"
where BUKRS = '${IV_BUKRS}'
and hkont = '1122010000'
and zwhk <> 0
${if(len(BEGINDATE)  == 0,"","and BUDAT >= '" + BEGINDATE + "'")} 
${if(len(ENDDATE)  == 0,"","and BUDAT <= '" + ENDDATE + "'")} 
${if(len(IV_BLART)  == 0,"","and BLART IN ( '" + IV_BLART + "' )")} 
${if(len(IV_VKBUR_T)  == 0,"","and VKBUR IN ( '" + IV_VKBUR_T + "' )")} 
${if(len(IV_VKGRP_T)  == 0,"","and VKGRP IN ( '" + IV_VKGRP_T + "' )")} 
--${if(len(IV_KUNNR)  == 0,"","and LTRIM( KUNNR,'0' ) = '" + IV_KUNNR + "'")} 
${if(len(IV_KUNNR)  == 0,"","and KUNNR IN ( '" + IV_KUNNR + "' )")} 
--${if(len(IV_KUNNR)  == 0,"","and LTRIM( KUNNR3,'0' ) IN ( '" + IV_VKBUR_T + "' )")}



SELECT
     ZTYPE,	
	BLART,
	BLART_N
FROM "SAPHANADB"."ZFIV_AR_BSID_G"
ORDER BY ZTYPE,BLART


