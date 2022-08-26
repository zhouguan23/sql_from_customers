select km,kxh from jhk_dpakm where kxh IN ('1','2','3','4','5','7','8') order by kxh

select * from jhk_dpa05 where YEAR(RQ)+1>='${年份}'

(select CASE a.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE a.km END KM,b.ny, sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul from daa01 a,pdpmis.dba04_cn b where a.jh=b.jh and b.cyfs<>'1G' and b.cyfs<>'1G1' and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by a.km,b.ny )
union 
(select '提捞队' KM,ny, sum(ycyl+ycsl) cyel,sum(ycyl) cyoul from pdpmis.dba04_cn where cyfs='1G1' and (substr(ny,0,4)='${年份}' or substr(ny,0,4)='${年份}'-1) group by ny )
union 
(select '全厂' KM,ny, sum(ycyl+ycsl) cyel,sum(ycyl) cyoul from pdpmis.dba04_cn where substr(ny,0,4)='${年份}' or substr(ny,0,4)='${年份}'-1 group by ny )

(select CASE a.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE a.km END KM,b.ny, sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul,
SUM(CASE WHEN b.ny=to_char(a.tcrq,'yyyyMM') THEN 1 ELSE 0 END) js 
from daa01 a,pdpmis.dba04_cn b where a.jh=b.jh and b.cyfs<>'1G' and b.cyfs<>'1G1' and substr(b.ny,0,4)=to_char(a.tcrq,'yyyy') AND (a.XQKDM<3000 or a.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by a.km,b.ny)
union 
(select '全厂' KM,b.ny, sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul,
SUM(CASE WHEN b.ny=to_char(a.tcrq,'yyyyMM') THEN 1 ELSE 0 END) js 
from daa01 a,pdpmis.dba04_cn b where a.jh=b.jh and substr(b.ny,0,4)=to_char(a.tcrq,'yyyy') AND (a.XQKDM<3000 or a.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny) 

(select CASE a.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE a.km END KM,b.ny, sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul from daa01 a,pdpmis.dba04_cn b where a.jh=b.jh and b.cyfs<>'1G' and b.cyfs<>'1G1' and a.xqkdm>5000 and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by a.km,b.ny )
union 
(select '全厂' KM,b.ny,sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul from daa01 a,pdpmis.dba04_cn b where a.jh=b.jh and b.cyfs<>'1G' and b.cyfs<>'1G1' and a.xqkdm>5000 and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny)

(select CASE c.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE c.km END KM,b.ny,substr(cslb,1,2) cs,sum(a.yzyl1) ycyl1,sum(a.yzyl) ycyl,
SUM(CASE WHEN A.NY=TO_CHAR(A.WGRQ,'yyyyMM') THEN 1 ELSE 0 END) js 
from pdpmis.dba08 a,pdpmis.dba04_cn b,daa01 c where a.jh=b.jh and b.jh=c.jh and SUBSTR(B.CYFS,1,2)<>'1G' and a.ny=b.ny AND (c.XQKDM<3000 or c.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by c.km,b.ny,substr(cslb,1,2)) 
union 
(select '全厂' KM,b.ny,substr(a.cslb,1,2) cs,sum(a.yzyl1) ycyl1,sum(a.yzyl) ycyl,
SUM(CASE WHEN A.NY=TO_CHAR(A.WGRQ,'yyyyMM') THEN 1 ELSE 0 END) js 
from pdpmis.dba08 a,pdpmis.dba04_cn b,daa01 c where a.jh=b.jh and b.jh=c.jh and SUBSTR(B.CYFS,1,2)<>'1G' and a.ny=b.ny AND (c.XQKDM<3000 or c.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny,substr(a.cslb,1,2))

--select CASE c.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE c.km END KM,b.ny,sum(a.yzyl1) ycyl1,sum(a.yzyl) ycyl,SUM(CASE WHEN A.NY=TO_CHAR(A.WGRQ,'yyyyMM') THEN 1 ELSE 0 END) js from pdpmis.dba08 a,pdpmis.dba04_cn b,daa01 c where a.jh=b.jh and b.jh=c.jh and SUBSTR(B.CYFS,1,2)<>'1G' and a.ny=b.ny AND (c.XQKDM<3000 or c.XQKDM>5000) and substr(cslb,1,2) ='15' and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by c.km,b.ny order by c.km,b.ny

(select CASE a.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE a.km END KM,b.ny, sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul from daa01 a,pdpmis.dba04_cn b where a.jh=b.jh and b.cyfs<>'1G' and b.cyfs<>'1G1' and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) AND (A.XQKDM<3000 or A.XQKDM>5000) group by a.km,b.ny )
union 
(select '提捞队' KM,b.ny, sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul from daa01 a,pdpmis.dba04_cn b where a.jh=b.jh and b.cyfs='1G1' and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) AND (A.XQKDM<3000 or A.XQKDM>5000) group by b.ny )
union 
(select '全厂' KM,b.ny, sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul from daa01 a,pdpmis.dba04_cn b where a.jh=b.jh and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) AND (A.XQKDM<3000 or A.XQKDM>5000) group by b.ny )

(select CASE a.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE a.km END KM,b.ny, round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl,SUM(CASE WHEN b.ny=to_char(a.zsrq,'yyyyMM') THEN 1 ELSE 0 END) js 
from daa01 a,pdpmis.dba05 b where a.jh=b.jh and substr(b.ny,0,4)=to_char(a.zsrq,'yyyy') AND (a.XQKDM<3000 or a.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by a.km,b.ny ) 
union 
(select '全厂' KM,b.ny, round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl,SUM(CASE WHEN b.ny=to_char(a.zsrq,'yyyyMM') THEN 1 ELSE 0 END) js from daa01 a,pdpmis.dba05 b where a.jh=b.jh and substr(b.ny,0,4)=to_char(a.zsrq,'yyyy') AND (a.XQKDM<3000 or a.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny )

(select CASE b.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE b.km END KM,a.ny,count(a.jh),round(sum(a.yzzsl)/to_char(last_day(TO_DATE(a.ny,'YYYYMM')),'dd'),2) as yzsl from pdpmis.dba081 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and substr(a.cslb,1,2) in ('1A','11','12','15','1G','13','1J') and a.cslb not like '11X%' and a.yzzsl>0 and (substr(a.ny,0,4)='${年份}' or substr(a.ny,0,4)='${年份}'-1) group by b.km,a.ny)  
union 
(select '全厂' KM,a.ny,count(a.jh),round(sum(a.yzzsl)/to_char(last_day(TO_DATE(a.ny,'YYYYMM')),'dd'),2) as yzsl from pdpmis.dba081 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and substr(a.cslb,1,2) in ('1A','11','12','15','1G','13','1J') and a.cslb not like '11X%' and a.yzzsl>0 and (substr(a.ny,0,4)='${年份}' or substr(a.ny,0,4)='${年份}'-1) group by a.ny) 

(select CASE a.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE a.km END KM,b.ny,round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl from daa01 a,pdpmis.dba05 b where (a.xqkdm>3000 and a.xqkdm<5000) and a.jh=b.jh and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by a.km,b.ny ) 
union 
(select '全厂' KM,b.ny,round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl from daa01 a,pdpmis.dba05 b where (a.xqkdm>3000 and a.xqkdm<5000) and a.jh=b.jh and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny )

(select CASE a.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE a.km END KM,b.ny,round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl from daa01 a,pdpmis.dba05 b where (a.xqkdm<3000 or a.xqkdm>5000) and a.jh=b.jh and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by a.km,b.ny) 
union 
(select '全厂' KM,b.ny,round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl from daa01 a,pdpmis.dba05 b where (a.xqkdm<3000 or a.xqkdm>5000) and a.jh=b.jh and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny)

--SELECT * FROM "PDPMIS"."CSMC" order by csdm
(select CASE b.km WHEN '采油一矿' THEN '第一油矿' WHEN '采油二矿' THEN '第二油矿' WHEN '采油三矿' THEN '第三油矿' WHEN '采油五矿' THEN '第五油矿' ELSE b.km END KM,
a.ny,CASE substr(a.cslb,1,2) WHEN '11' THEN '压裂' WHEN '12' THEN '酸化' WHEN '13' THEN '补孔' WHEN '1J' THEN '浅调' ELSE a.cslb END cslb,
SUM(CASE WHEN A.NY=TO_CHAR(A.WGRQ,'yyyyMM') THEN 1 ELSE 0 END) gzl 
from pdpmis.dba081 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and substr(a.cslb,1,2) in ('1A','11','12','15','1G','13','1J')  and a.cslb not like '11X%' and a.ny>=('${年份}'-1)||'01' and a.ny<='${年份}'||'12' group by b.km,a.ny,a.cslb )
union 
(select '全厂' KM,a.ny,CASE substr(a.cslb,1,2) WHEN '11' THEN '压裂' WHEN '12' THEN '酸化' WHEN '13' THEN '补孔' WHEN '1J' THEN '浅调' ELSE a.cslb END cslb,
SUM(CASE WHEN A.NY=TO_CHAR(A.WGRQ,'yyyyMM') THEN 1 ELSE 0 END) gzl 
from pdpmis.dba081 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and substr(a.cslb,1,2) in ('1A','11','12','15','1G','13','1J')  and a.cslb not like '11X%' and a.ny>=('${年份}'-1)||'01' and a.ny<='${年份}'||'12' group by a.ny,a.cslb )





select t.KM,t.rq,t.days,round(sum(zgyljsl)/days,2) yzsl from (
select CASE dw WHEN '一  矿' THEN '第一油矿' WHEN '二  矿' THEN '第二油矿' WHEN '三  矿' THEN '第三油矿' WHEN '四  矿' THEN '第四油矿' WHEN '五  矿' THEN '第五油矿'  WHEN '全  厂' THEN '全厂' ELSE dw END KM, CONVERT(varchar(6), rq, 112) rq,zgyljsl,day(dateadd(month, datediff(month, 0, dateadd(month, 1, rq)), -1)) as days From sjcszg Where YEAR(RQ)+1>='${年份}' and day(rq+1)=1
) t group by t.km,t.rq,t.days  

select YEAR,km,xmid,case month when 'JANUARY' then YEAR||'1' when 'FEBRUARY' then YEAR||'2' when 'MARCH' then YEAR||'3' when 'APRIL' then YEAR||'4' when 'MAY' then YEAR||'5' when 'JUNE' then YEAR||'6' 
when 'JULY' then YEAR||'7' when 'AUGUST' then YEAR||'8' when 'SEPTEMBER' then YEAR||'9' when 'OCTOBER' then YEAR||'10' when 'NOVEMBER' then YEAR||'11' when 'DECEMBER' then YEAR||'12' else month end as NY,
shuzhi from sq_yxjh unpivot (shuzhi for month in (january, february, march, april,may,june,july,august,september,october,november,december,quannian,rijun)) WHERE (YEAR+1)='${年份}' or YEAR='${年份}'

