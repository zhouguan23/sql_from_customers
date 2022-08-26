      SELECT SUM(sfec009)
      FROM sfec_t
      LEFT JOIN sfea_t ON sfeaent = sfecent AND sfeadocno = sfecdocno
      LEFT JOIN sfaa_t ON sfaaent = sfecent AND sfaadocno = sfec001
      LEFT JOIN sfda_t ON sfdaent = sfecent AND sfdadocno = sfea005 
      WHERE sfecent = g_enterprise
         AND sfec005 = l_sfdauc001
         AND (sfeastus = 'S'OR (sfeastus = 'Y' AND sfea005 IS NOT NULL AND sfdastus = 'S' ))
         AND sfea001 BETWEEN to_date(l_mfisrt,'yy/mm/dd') AND to_date(g_today,'yy/mm/dd')
         AND sfaa003 = '1'  


Select * From
(
SELECT '计划' 类型,a,b,c
FROM (select p.sfdauc001 a,ooga001 b, SUM(p.sfdauc003) c
from ooga_t   
left join sfdauc_t p on ooga001 = sfdauc002
where ooga001>=to_date('2018-09-01','YY-MM-DD') 
and ooga001<=to_date('2018-09-30','YY-MM-DD')
and oogaent=98 and oogastus='Y' 
group by p.sfdauc001,ooga001)
Union all
SELECT '实际' 类型,a,b,NVL((SELECT SUM(sfec009)
      FROM sfec_t
      LEFT JOIN sfea_t ON sfeaent = sfecent AND sfeadocno = sfecdocno
      LEFT JOIN sfaa_t ON sfaaent = sfecent AND sfaadocno = sfec001
      LEFT JOIN sfda_t ON sfdaent = sfecent AND sfdadocno = sfea005
      WHERE sfecent = '98'
         AND sfec005 = a
         AND (sfeastus = 'S' OR (sfeastus = 'Y' AND sfea005 IS NOT NULL AND sfdastus = 'S' ))
         AND sfea001 = b --BETWEEN to_date('2018-09-01','YY-MM-DD')  AND to_date('2018-09-30','YY-MM-DD')
         AND sfaa003 = '1'   ),0) c
FROM (select p.sfdauc001 a,ooga001 b
from ooga_t   
left join sfdauc_t p on ooga001 = sfdauc002
where ooga001>=to_date('2018-09-01','YY-MM-DD') 
and ooga001<=to_date('2018-09-30','YY-MM-DD')
and oogaent=98 and oogastus='Y' 
group by p.sfdauc001,ooga001)
) x
Order By b

select b 日期,sum(c) 计划,sum(d) 实际 from (SELECT a,b,c,NVL((SELECT SUM(sfec009)
      FROM sfec_t
      LEFT JOIN sfea_t ON sfeaent = sfecent AND sfeadocno = sfecdocno
      LEFT JOIN sfaa_t ON sfaaent = sfecent AND sfaadocno = sfec001
      LEFT JOIN sfda_t ON sfdaent = sfecent AND sfdadocno = sfea005
      WHERE sfecent = '98'
         AND sfec005 = a
         AND (sfeastus = 'S' OR (sfeastus = 'Y' AND sfea005 IS NOT NULL AND sfdastus = 'S' ))
         AND sfea001 = b
         AND sfaa003 = '1'   ),0) d
FROM (select p.sfdauc001 a,ooga001 b, SUM(p.sfdauc003) c
from ooga_t   
left join sfdauc_t p on ooga001 = sfdauc002
where ooga001>=to_date('2018-09-01','YY-MM-DD') 
and ooga001<=to_date('2018-09-30','YY-MM-DD')
and oogaent=98 and oogastus='Y' 
group by p.sfdauc001,ooga001))
group by b
order by b

select ooga001 from ooga_t
where ooga001 >= ${today()}


SELECT * FROM 
(select h 部门, b 日期,a 料号, e 品名, f 系列,c 计划,g 预计,d -NVL((SELECT SUM(indd021) FROM indd_t
LEFT JOIN indc_t ON indcent = inddent AND indcdocno = indddocno AND indcsite = inddsite
LEFT JOIN inab_t ya ON ya.inabent = inddent AND ya.inabsite = inddsite AND ya.inab001 = indd022 AND ya.inab002 = indd023
LEFT JOIN inab_t yb ON yb.inabent = inddent AND yb.inabsite = inddsite AND yb.inab001 = indd032 AND yb.inab002 = indd033
LEFT JOIN sfaauc_t ON sfaaucent = inddent AND sfaaucsite = inddsite AND sfaauc002 = indd032 AND sfaauc003 = indd033 --add by yangqt 19/12/05
WHERE inddent = '98' AND inddsite = 'MBG' AND indcstus = 'S' AND indc022 = b AND indd002 = a AND sfaauc001 = z AND (ya.inabud001 = 'N' OR ya.inabud001 IS NULL) AND yb.inabud001 = 'Y' AND indd151 IN ('10','03','13')),0)  实际,oogauc001 放假日期 --AND sfda003 <> 'MBGQMSGWX' AND sfda003 <> 'MBPMSGWX' add by yangqt 19/3/8
from 
(
    SELECT a,b, e, f, c,d,g,h,z
    FROM 
    (
        select yl.ooefl003 h,p.sfdauc001 a,ooga001 b, x.imaal003 e, substr(x.imaal003, 1, 4) f, SUM(p.sfdauc003) c ,NVL(SUM(aa.xa),0) d,NVL(SUM(bb.xb),0) g,p.sfdauc008 z
        from dsdata.ooga_t 
        left join dsdata.sfdauc_t p on ooga001 = sfdauc002 and oogaent='98'
        left join dsdata.imaal_t x on p.sfdauc001 = x.imaal001 and x.imaalent = '98'  
        left join dsdata.ooefl_t yl on yl.ooeflent = '98' AND yl.ooefl001 = p.sfdauc008 AND yl.ooefl002 = 'zh_CN' ---LUO
        --LEFT JOIN (SELECT faa.sfaa017,ax.sfeadocdt,az.sfec005,SUM(az.sfec009) xa FROM dsdata.sfec_t az    
        LEFT JOIN (SELECT faa.sfaa017,ax.sfea001,az.sfec005,SUM(az.sfec009) xa FROM dsdata.sfec_t az   
          LEFT JOIN dsdata.sfea_t ax ON ax.sfeaent = az.sfecent AND ax.sfeadocno = az.sfecdocno and az.sfecsite = ax.sfeasite
          LEFT JOIN dsdata.sfaa_t faa on az.sfec001 = faa.sfaadocno and faa.sfaaent='98'
          LEFT Join imaa_t ima on ima.imaa001=sfec005 and ima.imaaent='98'
          WHERE  az.sfecent = '98' AND ax.sfeastus = 'S' 
         ${if(cbCompany == "MB", "", " AND az.sfecsite IN ('" + cbCompany + "')")}
                    and (case when (faa.sfaa003='2' and ima.imaa009='103') then 0 else 1 end)=1
          --GROUP BY faa.sfaa017,ax.sfeadocdt,az.sfec005) aa ON 
          GROUP BY faa.sfaa017,ax.sfea001,az.sfec005) aa ON 
          --aa.sfeadocdt = ooga001 AND aa.sfec005 = p.sfdauc001 AND aa.sfaa017 = p.sfdauc008
          aa.sfea001 = ooga001 AND aa.sfec005 = p.sfdauc001 AND aa.sfaa017 = p.sfdauc008
        LEFT JOIN (SELECT fab.sfaa017,ay.sfeadocdt,aw.sfeb004,SUM(aw.sfeb008) xb FROM dsdata.sfeb_t aw
           LEFT JOIN dsdata.sfaa_t fab on aw.sfeb001 = fab.sfaadocno and fab.sfaaent='98'
           LEFT Join imaa_t imb on imb.imaa001=sfeb004 and imb.imaaent='98'
          LEFT JOIN dsdata.sfea_t ay ON ay.sfeaent = aw.sfebent AND ay.sfeadocno = aw.sfebdocno and aw.sfebsite = ay.sfeasite
           WHERE  aw.sfebent = '98' AND ay.sfeastus = 'Y'
         ${if(cbCompany == "MB", "", " AND aw.sfebsite IN ('" + cbCompany + "')")}
             and (case when (fab.sfaa003='2' and imb.imaa009='103') then 0 else 1 end)=1
            GROUP BY fab.sfaa017,ay.sfeadocdt,aw.sfeb004  ) bb ON 
          bb.sfeadocdt = ooga001 AND bb.sfeb004 = p.sfdauc001 AND bb.sfaa017 = p.sfdauc008
        where to_char(ooga001,'YYYYMM') = '${deYM}'
        and oogaent=98
        AND p.sfdauc008 LIKE 'MBG%'
       ${if(cbCompany == "MB", "", " AND p.sfdaucsite IN ('" + cbCompany + "')")}
        ${if(LEN(ccbGroup_c) == 0, "", " AND p.sfdauc008 IN ('" + ccbGroup_c + "')")}
       ${if(LEN(ccbMatCode_c) == 0, "", " AND x.imaal001 IN ('" + ccbMatCode_c + "')")}
 --      ${if(LEN(M_code) == 0, "", " AND x.imaal001 IN ('" + M_code + "')")}
	   ${if(LEN(series) == 0, "", " AND substr(x.imaal003,1,4) IN ('" + series + "')")}  
	   ${if(LEN(comboCheckBox0) == 0, ""," AND REGEXP_LIKE(p.sfdauc008,'(" + comboCheckBox0 + ")')")} --add by yangqt 19/1/21 
        group by  yl.ooefl003,p.sfdauc001,ooga001, x.imaal003, substr(x.imaal003, 1, 4),p.sfdauc008
    )
) a
left join dsdata.oogauc_t on b = oogauc001 and oogaucent = '98'  ${if(cbCompany == "MB", "", " AND oogaucsite IN ('" + cbCompany + "')")}
--Order By 品名,日期 
UNION ALL
SELECT '',ooga001 日期,'0XXXXX','!0','',0.0001,0.0001,0.0001,to_date('','yyyy/mm/dd') FROM ooga_t WHERE to_char(ooga001,'YYYYMM') = '${deYM}' 
UNION ALL
--外协
select h 部门,b 日期,a 料号, e 品名, f 系列,c 计划,g 预计,d -NVL((SELECT SUM(indd021) FROM indd_t
LEFT JOIN indc_t ON indcent = inddent AND indcdocno = indddocno AND indcsite = inddsite
LEFT JOIN inab_t ya ON ya.inabent = inddent AND ya.inabsite = inddsite AND ya.inab001 = indd022 AND ya.inab002 = indd023
LEFT JOIN inab_t yb ON yb.inabent = inddent AND yb.inabsite = inddsite AND yb.inab001 = indd032 AND yb.inab002 = indd033
--LEFT JOIN sfaauc_t ON sfaaucent = inddent AND sfaaucsite = inddsite AND sfaauc002 = indd032 AND sfaauc003 = indd033 --add by yangqt 19/12/05
WHERE inddent = '98' AND inddsite = 'MBG' AND indcstus = 'S' AND indc022 = b AND indd002 = a  AND (ya.inabud001 = 'N' OR ya.inabud001 IS NULL) AND yb.inabud001 = 'Y' AND indd151 IN ('10','03','13')),0) + NVL((SELECT SUM(indd021) FROM indd_t
LEFT JOIN indc_t ON indcent = inddent AND indcdocno = indddocno AND indcsite = inddsite
LEFT JOIN inab_t ya ON ya.inabent = inddent AND ya.inabsite = inddsite AND ya.inab001 = indd022 AND ya.inab002 = indd023
LEFT JOIN inab_t yb ON yb.inabent = inddent AND yb.inabsite = inddsite AND yb.inab001 = indd032 AND yb.inab002 = indd033
--LEFT JOIN sfaauc_t ON sfaaucent = inddent AND sfaaucsite = inddsite AND sfaauc002 = indd032 AND sfaauc003 = indd033 --add by yangqt 19/12/05
WHERE inddent = '98' AND inddsite = 'MBG' AND indcstus = 'S' AND indc022 = b AND indd002 = a  AND (yb.inabud001 = 'N' OR yb.inabud001 IS NULL) AND ya.inabud001 = 'Y' AND indd151 IN ('11')),0) 实际,oogauc001 放假日期 --AND sfda003 <> 'MBGQMSGWX' AND sfda003 <> 'MBPMSGWX' add by yangqt 19/3/8
from 
(
    SELECT a,b, e, f, c,d,g,h,z
    FROM 
    (
        select yl.ooefl003 h,p.sfdauc001 a,ooga001 b, x.imaal003 e, substr(x.imaal003, 1, 4) f, SUM(p.sfdauc003) c ,NVL(SUM(aa.xa),0) d,0 g,p.sfdauc008 z
        from dsdata.ooga_t 
        left join dsdata.sfdauc_t p on ooga001 = sfdauc002 and oogaent='98'
        left join dsdata.imaal_t x on p.sfdauc001 = x.imaal001 and x.imaalent = '98'  
        left join dsdata.ooefl_t yl on yl.ooeflent = '98' AND yl.ooefl001 = p.sfdauc008 AND yl.ooefl002 = 'zh_CN' ---LUO
        LEFT JOIN (SELECT pmds007 sfaa017,pmds001 sfeadocdt,pmdt006 sfec005,SUM(pmdt020) xa
          FROM (
          SELECT pmds007,pmds001,pmdt006,pmdt020 FROM pmds_t
          LEFT JOIN pmdt_t ON pmdtent = pmdsent AND pmdtdocno = pmdsdocno
          WHERE pmdsent = 98 AND pmdsstus = 'S' AND pmds000 = '12'
          ${if(cbCompany == "MB", "", " AND pmdssite IN ('" + cbCompany + "')")}
          UNION ALL
          SELECT pmds007,pmds001,pmdt006,pmdt020*-1 FROM pmds_t
          LEFT JOIN pmdt_t ON pmdtent = pmdsent AND pmdtdocno = pmdsdocno
          WHERE pmdsent = 98 AND pmdsstus = 'S' AND pmds000 = '14'
          ${if(cbCompany == "MB", "", " AND pmdssite IN ('" + cbCompany + "')")}
          )
          GROUP BY pmds007,pmds001,pmdt006) aa ON 
          aa.sfeadocdt = ooga001 AND aa.sfec005 = p.sfdauc001 AND aa.sfaa017 = p.sfdauc008
          LEFT JOIN (SELECT DISTINCT sfaa010,sfaa017,sfaa068 FROM sfaa_t WHERE sfaaent = 98 AND sfaa068 = 'MBGPMSGWX'--AND sfaa068 LIKE 'MBGPM%'  
          ${if(cbCompany == "MB", "", " AND sfaasite IN ('" + cbCompany + "')")}) zx ON zx.sfaa017 = p.sfdauc008 AND zx.sfaa010 = p.sfdauc001
        where to_char(ooga001,'YYYYMM') = '${deYM}'
        and oogaent=98
        AND p.sfdauc008 NOT LIKE 'MBG%'
       ${if(cbCompany == "MB", "", " AND p.sfdaucsite IN ('" + cbCompany + "')")}
        ${if(LEN(ccbGroup_c) == 0, "", " AND p.sfdauc008 IN ('" + ccbGroup_c + "')")}
       ${if(LEN(ccbMatCode_c) == 0, "", " AND x.imaal001 IN ('" + ccbMatCode_c + "')")}
 --      ${if(LEN(M_code) == 0, "", " AND x.imaal001 IN ('" + M_code + "')")}
	   ${if(LEN(series) == 0, "", " AND substr(x.imaal003,1,4) IN ('" + series + "')")}  
	   ${if(LEN(comboCheckBox0) == 0, ""," AND (REGEXP_LIKE(zx.sfaa068,'(" + comboCheckBox0 + ")') OR zx.sfaa068 IS NULL )")} --add by yangqt 19/1/21 
        group by  yl.ooefl003,p.sfdauc001,ooga001, x.imaal003, substr(x.imaal003, 1, 4),p.sfdauc008
    )
) a
left join dsdata.oogauc_t on b = oogauc001 and oogaucent = '98'  ${if(cbCompany == "MB", "", " AND oogaucsite IN ('" + cbCompany + "')")})

WHERE --计划+预计+实际<>0 -- OR (计划+预计+实际=0 AND 放假日期 IS NOT NULL)
计划 <> 0 OR 预计 <> 0 OR 实际 <> 0
Order By 品名,日期
          

select distinct substr(x.imaal003,1,4) 系列,x.imaal001||'/'||x.imaal003 品名,x.imaal001 物料编号
from dsdata.ooga_t   
left join dsdata.sfdauc_t p on ooga001 = sfdauc002
left join dsdata.imaal_t x on p.sfdauc001 = x.imaal001 and x.imaalent = '98'
where to_char(ooga001,'YYYYMM') = '${deYM}' 
${if(LEN(ccbGroup_c) == 0, "", " AND p.sfdauc008 IN ('" + ccbGroup_c + "')")}
and oogaent=98 and oogastus='Y' 
Order By 物料编号

SELECT 编码,编码||'-'||组别 说明 FROM 
(
select distinct  p.sfdauc008 编码, yl.ooefl003 组别
from dsdata.ooga_t   
left join dsdata.sfdauc_t p on ooga001 = sfdauc002
left join dsdata.imaal_t x on p.sfdauc001 = x.imaal001 and x.imaalent = '98'
left join dsdata.ooefl_t yl on yl.ooeflent = '98' AND yl.ooefl001 = p.sfdauc008 AND yl.ooefl002 = 'zh_CN' 
where to_char(ooga001,'YYYYMM') = '${deYM}' 
and oogaent=98 and oogastus='Y' 
and  p.sfdauc008 is not null
AND  p.sfdauc008 LIKE 'MBG%'
${if(LEN(comboCheckBox0) == 0, ""," AND REGEXP_LIKE(p.sfdauc008,'(" + comboCheckBox0 + ")')")}
UNION ALL
select distinct  p.sfdauc008 编码, yl.pmaal004 组别
from dsdata.ooga_t   
left join dsdata.sfdauc_t p on ooga001 = sfdauc002
left join dsdata.imaal_t x on p.sfdauc001 = x.imaal001 and x.imaalent = '98'
LEFT JOIN pmaal_t yl ON yl.pmaalent = oogaent AND yl.pmaal001 = p.sfdauc008 AND yl.pmaal002 = 'zh_CN'
where to_char(ooga001,'YYYYMM') = '${deYM}' 
and oogaent=98 and oogastus='Y' 
and  p.sfdauc008 is not null
AND  p.sfdauc008 NOT LIKE 'MBG%'
${if(comboCheckBox0 == "MBGPM", " ", " AND 1 = 2 ")}
)
Order By  编码

SELECT DISTINCT SUBSTR(sfaa068,0,5),ooefl003 
FROM sfdauc_t 
LEFT JOIN sfaa_t ON  sfaaent = sfdaucent AND sfaa017 = sfdauc008
LEFT JOIN ooefl_t ON ooeflent = sfdaucent AND ooefl001 = SUBSTR(sfaa068,0,5) AND ooefl002 = 'zh_CN'
WHERE sfdaucent = 98
AND sfaastus = 'F'
${if(cbCompany == "MB", "", " AND sfdaucsite IN ('" + cbCompany + "')")}




