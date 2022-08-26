SELECT * FROM 
(select zz.ooefl003 部门, xmdd011 日期,xmdd001 料号,zz.imaal003 品名,zz.xxx 系列,c 计划,g 预计,d -NVL((SELECT SUM(indd021) FROM indd_t
LEFT JOIN indc_t ON indcent = inddent AND indcdocno = indddocno AND indcsite = inddsite
LEFT JOIN inab_t ya ON ya.inabent = inddent AND ya.inabsite = inddsite AND ya.inab001 = indd022 AND ya.inab002 = indd023
LEFT JOIN inab_t yb ON yb.inabent = inddent AND yb.inabsite = inddsite AND yb.inab001 = indd032 AND yb.inab002 = indd033
WHERE inddent = '98' AND inddsite = 'MBG' AND indc022 = b AND indd002 = a AND (ya.inabud001 = 'N' OR ya.inabud001 IS NULL) AND yb.inabud001 = 'Y' AND indd151 IN ('10')),0)  实际,zz.num1 出货数量,oogauc001 放假日期 --AND sfda003 <> 'MBGQMSGWX' AND sfda003 <> 'MBPMSGWX' add by yangqt 19/3/8
from 
(
SELECT xmdd001,imaal003,ooefl003,substr(imaal003, 1, 4) xxx,xmdd011,SUM(num1) num1
FROM 
(
SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
FROM xmda_t
LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
WHERE xmdaent = 98 AND xmdasite = 'MBG'
AND xmdd006-xmdd014+xmdd016 > 0
AND xmdastus = 'Y'
AND xmdc045 = '1'
${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
GROUP BY xmdd001,xmdd011 
UNION ALL
SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
FROM xmda_t@SOL
LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
WHERE xmdaent = 100 AND xmdasite = 'SOL'
AND xmdd006-xmdd014+xmdd016 > 0
AND xmdastus = 'Y'
AND xmdc045 = '1'
${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
GROUP BY xmdd001,xmdd011 
) za
LEFT JOIN imaal_t ON imaalent = 98 AND imaal001 = xmdd001 AND imaal002 = 'zh_CN'
LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
LEFT JOIN ooefl_t ON ooeflent = '98' AND ooefl001 = imae034 AND ooefl002 = 'zh_CN' 
GROUP BY xmdd001,imaal003,ooefl003,xmdd011 
) zz 
LEFT JOIN 
(
    SELECT a,b, e, f, c,d,g,h
    FROM 
    (
        select yl.ooefl003 h,p.sfdauc001 a,ooga001 b, x.imaal003 e, substr(x.imaal003, 1, 4) f, SUM(p.sfdauc003) c ,NVL(SUM(aa.xa),0) d,NVL(SUM(bb.xb),0) g
        from dsdata.ooga_t 
        left join dsdata.sfdauc_t p on ooga001 = sfdauc002 and oogaent='98'
        left join dsdata.imaal_t x on p.sfdauc001 = x.imaal001 and x.imaalent = '98'  
        left join dsdata.ooefl_t yl on yl.ooeflent = '98' AND yl.ooefl001 = p.sfdauc008 AND yl.ooefl002 = 'zh_CN' ---LUO
        LEFT JOIN (SELECT faa.sfaa017,ax.sfeadocdt,az.sfec005,SUM(az.sfec009) xa FROM dsdata.sfec_t az    
          LEFT JOIN dsdata.sfea_t ax ON ax.sfeaent = az.sfecent AND ax.sfeadocno = az.sfecdocno and az.sfecsite = ax.sfeasite
          LEFT JOIN dsdata.sfaa_t faa on az.sfec001 = faa.sfaadocno and faa.sfaaent='98'
          LEFT Join imaa_t ima on ima.imaa001=sfec005 and ima.imaaent='98'
          WHERE  az.sfecent = '98' AND ax.sfeastus = 'S' 
          AND faa.sfaa010 IN (SELECT DISTINCT xmdd001
                                FROM 
                                (
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t
                                LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 98 AND xmdasite = 'MBG'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
                                GROUP BY xmdd001,xmdd011 
                                UNION ALL
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t@SOL
                                LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 100 AND xmdasite = 'SOL'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
                                GROUP BY xmdd001,xmdd011 
                                ) za )
         ${if(cbCompany == "MB", "", " AND az.sfecsite IN ('" + cbCompany + "')")}
                    and (case when (faa.sfaa003='2' and ima.imaa009='103') then 0 else 1 end)=1
          GROUP BY faa.sfaa017,ax.sfeadocdt,az.sfec005) aa ON 
          aa.sfeadocdt = ooga001 AND aa.sfec005 = p.sfdauc001 AND aa.sfaa017 = p.sfdauc008
        LEFT JOIN (SELECT fab.sfaa017,ay.sfeadocdt,aw.sfeb004,SUM(aw.sfeb008) xb FROM dsdata.sfeb_t aw
           LEFT JOIN dsdata.sfaa_t fab on aw.sfeb001 = fab.sfaadocno and fab.sfaaent='98'
           LEFT Join imaa_t imb on imb.imaa001=sfeb004 and imb.imaaent='98'
          LEFT JOIN dsdata.sfea_t ay ON ay.sfeaent = aw.sfebent AND ay.sfeadocno = aw.sfebdocno and aw.sfebsite = ay.sfeasite
           WHERE  aw.sfebent = '98' AND ay.sfeastus = 'Y'
           AND fab.sfaa010 IN (SELECT DISTINCT xmdd001
                                FROM 
                                (
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t
                                LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 98 AND xmdasite = 'MBG'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
                                GROUP BY xmdd001,xmdd011 
                                UNION ALL
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t@SOL
                                LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 100 AND xmdasite = 'SOL'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
                                GROUP BY xmdd001,xmdd011 
                                ) za )
         ${if(cbCompany == "MB", "", " AND aw.sfebsite IN ('" + cbCompany + "')")}
             and (case when (fab.sfaa003='2' and imb.imaa009='103') then 0 else 1 end)=1
            GROUP BY fab.sfaa017,ay.sfeadocdt,aw.sfeb004  ) bb ON 
          bb.sfeadocdt = ooga001 AND bb.sfeb004 = p.sfdauc001 AND bb.sfaa017 = p.sfdauc008
        where ooga001 BETWEEN add_months(last_day((SELECT MIN(xmdd011)
                                FROM 
                                (
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t
                                LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 98 AND xmdasite = 'MBG'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
                                GROUP BY xmdd001,xmdd011 
                                UNION ALL
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t@SOL
                                LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 100 AND xmdasite = 'SOL'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
                                GROUP BY xmdd001,xmdd011 
                                ) za ))+1,-1)
                                AND 
                                (SELECT MAX(xmdd011)
                                FROM 
                                (
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t
                                LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 98 AND xmdasite = 'MBG'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
                                GROUP BY xmdd001,xmdd011 
                                UNION ALL
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t@SOL
                                LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 100 AND xmdasite = 'SOL'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
                                GROUP BY xmdd001,xmdd011 
                                ) za )
        and oogaent=98
       ${if(cbCompany == "MB", "", " AND p.sfdaucsite IN ('" + cbCompany + "')")}
        ${if(LEN(ccbGroup_c) == 0, "", " AND p.sfdauc008 IN ('" + ccbGroup_c + "')")}
       ${if(LEN(ccbMatCode_c) == 0, "", " AND x.imaal001 IN ('" + ccbMatCode_c + "')")}
	   ${if(LEN(series) == 0, "", " AND substr(x.imaal003,1,4) IN ('" + series + "')")}  
	   ${if(LEN(comboCheckBox0) == 0, ""," AND REGEXP_LIKE(p.sfdauc008,'(" + comboCheckBox0 + ")')")} --add by yangqt 19/1/21 
        group by  yl.ooefl003,p.sfdauc001,ooga001, x.imaal003, substr(x.imaal003, 1, 4)
    )
) a ON zz.xmdd001 = a.a AND zz.xmdd011 = a.b
left join dsdata.oogauc_t on b = oogauc001 and oogaucent = '98'  ${if(cbCompany == "MB", "", " AND oogaucsite IN ('" + cbCompany + "')")}
--Order By 品名,日期 
UNION ALL
SELECT '',ooga001 日期,'0XXXXX','!0','',0.0001,0.0001,0.0001,0.0001,to_date('','yyyy/mm/dd') FROM ooga_t WHERE ooga001 BETWEEN add_months(last_day((SELECT MIN(xmdd011)
                                FROM 
                                (
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t
                                LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 98 AND xmdasite = 'MBG'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
                                GROUP BY xmdd001,xmdd011 
                                UNION ALL
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t@SOL
                                LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 100 AND xmdasite = 'SOL'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
                                GROUP BY xmdd001,xmdd011 
                                ) za ))+1,-1)
                                AND 
                                (SELECT MAX(xmdd011)
                                FROM 
                                (
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t
                                LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 98 AND xmdasite = 'MBG'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
                                GROUP BY xmdd001,xmdd011 
                                UNION ALL
                                SELECT xmdd001,xmdd011,SUM(xmdd006-xmdd014+xmdd016) num1
                                FROM xmda_t@SOL
                                LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
                                LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
                                WHERE xmdaent = 100 AND xmdasite = 'SOL'
                                AND xmdd006-xmdd014+xmdd016 > 0
                                AND xmdastus = 'Y'
                                AND xmdc045 = '1'
                                ${if(LEN(ccbMatCode_c) == 0, "", " AND xmdd001 IN ('" + ccbMatCode_c + "')")}
                                AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
                                GROUP BY xmdd001,xmdd011 
                                ) za )
)
Order By 品名,日期

          

SELECT zz.a 日期,zz.b 料号,imaal003 品名,
(SELECT SUM(xmdd006) FROM (
SELECT xmdd001,xmdd011,(xmdd006-xmdd014+xmdd016) xmdd006
FROM xmda_t
LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
WHERE xmdaent = 98 AND xmdasite = 'MBG'
${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
AND xmdd006-xmdd014+xmdd016 > 0
AND xmdastus = 'Y'
AND xmdc045 = '1'
${if(LEN(l_xmdd001) == 0, "", " AND xmdd001 IN ('" + l_xmdd001 + "')")}
--AND xmdd001 = '121711138900'
AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
UNION ALL
SELECT xmdd001,xmdd011,(xmdd006-xmdd014+xmdd016) xmdd006
FROM xmda_t@SOL
LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
WHERE xmdaent = 100 AND xmdasite = 'SOL'
${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
AND xmdd006-xmdd014+xmdd016 > 0
AND xmdastus = 'Y'
AND xmdc045 = '1'
${if(LEN(l_xmdd001) == 0, "", " AND xmdd001 IN ('" + l_xmdd001 + "')")}
--AND xmdd001 = '121711138900'
AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
--add by yangqt 20/01/15
UNION ALL
SELECT xmdl008 xmdd001,xmdk001 xmdd011,SUM(xmdl018) xmdd006
FROM xmdk_t
LEFT JOIN xmdl_t ON xmdlent = xmdkent AND xmdlsite = xmdksite AND xmdldocno = xmdkdocno
LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdl008
WHERE xmdkent = 98
AND xmdksite = 'MBG'
AND xmdkstus  = 'S'
AND xmdk000 = '1'
${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
${if(LEN(l_xmdd001) == 0, "", " AND xmdl008 IN ('" + l_xmdd001 + "')")}
GROUP BY xmdl008,xmdk001
--end add
) jha WHERE xmdd001 = zz.b AND xmdd011 = zz.a) 出货计划,
(SELECT sfdauc003  FROM sfdauc_t WHERE sfdaucent = 98 AND sfdaucsite = 'MBG' AND sfdauc001 = zz.b AND sfdauc002 = zz.a AND sfdauc008 =  imae034) 计划数量,(SELECT sfdauc003  FROM sfdauc_t WHERE sfdaucent = 98 AND sfdaucsite = 'MBG' AND sfdauc001 = zz.b AND sfdauc002 = zz.a-2 AND sfdauc008 =  imae034) 计划数量2,ooefl003 组别,ooag011 担当,xmaauc002 客户编码
FROM (
SELECT rq.ooga001 a,lh.xmdd001 b FROM 
(
(SELECT 1 a,ooga001 FROM ooga_t 
WHERE ooga001 BETWEEN (SELECT trunc(sysdate,'MM') FROM dual) AND (SELECT trunc(sysdate,'MM') FROM dual) ${if(l_type," + 89"," + 44")}
--add_months(last_day(
--(SELECT MIN(xmdd011) FROM (
--SELECT DISTINCT xmdd011
--FROM xmda_t
--LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
--LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
--LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
--WHERE xmdaent = 98 AND xmdasite = 'MBG' AND xmdd006-xmdd014+xmdd016 > 0 AND xmdastus = 'Y' AND xmdc045 = '1'
--${if(LEN(l_xmdd001) == 0, "", " AND xmdd001 IN ('" + l_xmdd001 + "')")}
--${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
--${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
----AND xmdd001 = '121711138900'
--AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
--UNION ALL
--SELECT DISTINCT xmdd011
--FROM xmda_t@SOL
--LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
--LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
--LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
--WHERE xmdaent = 100 AND xmdasite = 'SOL' AND xmdd006-xmdd014+xmdd016 > 0 AND xmdastus = 'Y' AND xmdc045 = '1'
--${if(LEN(l_xmdd001) == 0, "", " AND xmdd001 IN ('" + l_xmdd001 + "')")}
--${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
--${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
----AND xmdd001 = '121711138900'
--AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
--) za )
--)+1,-1)
--AND 
--add_months(last_day((SELECT MIN(xmdd011) FROM (
--SELECT DISTINCT xmdd011
--FROM xmda_t
--LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
--LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
--LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
--WHERE xmdaent = 98 AND xmdasite = 'MBG' AND xmdd006-xmdd014+xmdd016 > 0 AND xmdastus = 'Y' AND xmdc045 = '1'
--${if(LEN(l_xmdd001) == 0, "", " AND xmdd001 IN ('" + l_xmdd001 + "')")}
--${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
--${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
----AND xmdd001 = '121711138900'
--AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
--UNION ALL
--SELECT DISTINCT xmdd011
--FROM xmda_t@SOL
--LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
--LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
--LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
--WHERE xmdaent = 100 AND xmdasite = 'SOL' AND xmdd006-xmdd014+xmdd016 > 0 AND xmdastus = 'Y' AND xmdc045 = '1'
--${if(LEN(l_xmdd001) == 0, "", " AND xmdd001 IN ('" + l_xmdd001 + "')")}
--${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
--${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
----AND xmdd001 = '121711138900'
--AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
--) za ))+1,-1) 

) rq 
LEFT JOIN 
(SELECT DISTINCT 1 a,xmdd001 FROM (
SELECT DISTINCT xmdd001
FROM xmda_t
LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
WHERE xmdaent = 98 AND xmdasite = 'MBG' 
AND xmdd006-xmdd014+xmdd016 > 0 
AND xmdastus = 'Y' AND xmdc045 = '1'
${if(LEN(l_xmdd001) == 0, "", " AND xmdd001 IN ('" + l_xmdd001 + "')")}
${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
--AND xmdd001 = '121711138900'
AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
UNION ALL
SELECT DISTINCT xmdd001
FROM xmda_t@SOL
LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
WHERE xmdaent = 100 AND xmdasite = 'SOL' 
AND xmdd006-xmdd014+xmdd016 > 0 
AND xmdastus = 'Y' AND xmdc045 = '1'
${if(LEN(l_xmdd001) == 0, "", " AND xmdd001 IN ('" + l_xmdd001 + "')")}
${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
--AND xmdd001 = '121711138900'
AND substr(xmdcdocno,4,5) IN ('AY500','BY500') 
) za ) lh ON lh.a = rq.a
) ) zz
LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = zz.b
LEFT JOIN ooefl_t ON ooeflent = '98' AND ooefl001 = imae034 AND ooefl002 = 'zh_CN' 
LEFT JOIN imaal_t ON imaalent = 98 AND imaal001 = zz.b AND imaal002 = 'zh_CN' 
LEFT JOIN imaf_t ON imafent = 98 AND imafsite = 'MBG' AND imaf001 = zz.b
LEFT JOIN ooag_t ON ooagent = 98 AND ooag001 = imafud001
LEFT JOIN xmaauc_t ON xmaaucent = 98 AND xmaauc001 = zz.b
WHERE 1=1
${if(LEN(l_imafud001) == 0, "", " AND imafud001 IN ('" + l_imafud001 + "')")}
${if(LEN(l_xmaauc002) == 0, "", " AND xmaauc002 IN ('" + l_xmaauc002 + "')")}
${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}
ORDER BY zz.a,zz.b

SELECT DISTINCT imae034 组别,ooefl003 部门
FROM imae_t
LEFT JOIN ooefl_t ON ooeflent = '98' AND ooefl001 = imae034 AND ooefl002 = 'zh_CN' 
WHERE imaeent = 98 AND imaesite = 'MBG'
${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}

SELECT DISTINCT xmdd001 料号,imaal003 品名
FROM (
SELECT DISTINCT xmdd001
FROM xmda_t
LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
WHERE xmdaent = 98 AND xmdasite = 'MBG' AND xmdd006-xmdd014+xmdd016 > 0 AND xmdastus = 'Y' AND xmdc045 = '1'
AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
UNION ALL
SELECT DISTINCT xmdd001
FROM xmda_t@SOL
LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
WHERE xmdaent = 100 AND xmdasite = 'SOL' AND xmdd006-xmdd014+xmdd016 > 0 AND xmdastus = 'Y' AND xmdc045 = '1'
AND substr(xmdcdocno,4,5) IN ('AY500','BY500') )
LEFT JOIN imaal_t ON imaalent = 98 AND imaal001 = xmdd001 AND imaal002 = 'zh_CN'
LEFT JOIN imae_t ON imaeent = 98 AND imaesite = 'MBG' AND imae001 = xmdd001
LEFT JOIN ooefl_t ON ooeflent = '98' AND ooefl001 = imae034 AND ooefl002 = 'zh_CN' 
WHERE 1=1
${if(LEN(l_bumen) == 0, "", " AND substr(imae034,1,5) IN ('" + l_bumen + "')")}
${if(LEN(l_imae034) == 0, "", " AND imae034 IN ('" + l_imae034 + "')")}

SELECT inat001,inat008,inat009,SUM(inat015) inat015
FROM inat_t
LEFT JOIN inab_t ON inabent = inatent AND inabsite = inatsite AND inab001 = inat004 AND inab002 = inat005
WHERE inatent = 98
AND inatsite = 'MBG'
AND inat001 IN (SELECT DISTINCT xmdd001
FROM xmda_t
LEFT JOIN xmdc_t ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
WHERE xmdaent = 98 AND xmdasite = 'MBG' AND xmdd006-xmdd014+xmdd016 > 0 AND xmdastus = 'Y' AND xmdc045 = '1'
AND substr(xmdcdocno,4,5) IN ('YY501','YY503','GY500','HY500')
UNION ALL
SELECT DISTINCT xmdd001
FROM xmda_t@SOL
LEFT JOIN xmdc_t@SOL ON xmdcent = xmdaent AND xmdcsite = xmdasite AND xmdcdocno = xmdadocno
LEFT JOIN xmdd_t@SOL ON xmddent = xmdcent AND xmddsite = xmdcsite AND xmdddocno = xmdcdocno AND xmddseq = xmdcseq
WHERE xmdaent = 100 AND xmdasite = 'SOL' AND xmdd006-xmdd014+xmdd016 > 0 AND xmdastus = 'Y' AND xmdc045 = '1'
AND substr(xmdcdocno,4,5) IN ('AY500','BY500') )
GROUP BY inat001,inat008,inat009

SELECT DISTINCT imafud001,imafud001||'-'||ooag011
FROM imaf_t
LEFT JOIN ooag_t ON ooagent = imafent AND ooag001 = imafud001
WHERE imafent = 98 AND imafsite = 'MBG'
ORDER BY imafud001

SELECT DISTINCT xmaauc002,xmaauc002||'-'||pmaal004 客户
FROM xmaauc_t
LEFT JOIN pmaal_t ON pmaalent = xmaaucent AND pmaal001 = xmaauc002 AND pmaal002 = 'zh_CN'
WHERE xmaaucent = 98
ORDER BY xmaauc002

