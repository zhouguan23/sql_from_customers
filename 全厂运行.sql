select cslb,ny,sum(ycyl1) ycyl1,sum(ycyl) ycyl,sum(js) js from (select (CASE substr(a.cslb,1,2) WHEN '11' THEN '压裂' WHEN '13' THEN '补孔' WHEN '15'THEN '堵水' WHEN '1A' THEN '换泵' WHEN '1B' THEN '换泵' ELSE '其他措施' END) cslb, a.ny,sum(a.yzyl1) ycyl1,sum(a.yzyl) ycyl , 
count(a.jh) js 
from pdpmis.dba08 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and (( substr(cslb,1,2) in ('11','12','13','19','1A','1B','15','1F','1G') and a.cslb not like '11X%' and a.yzyl>0) or (a.cslb like '15%' and a.yzyl1<0))  and a.ny>=('${年份}'-1)||'01' and a.ny<='${年份}'||'12' group by a.cslb,a.ny
union all
select '合计' cslb,a.ny,sum(a.yzyl1) ycyl1,sum(a.yzyl) ycyl,count(a.jh) js from pdpmis.dba08 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and (( substr(cslb,1,2) in ('11','12','13','19','1A','1B','15','1F','1G') and a.cslb not like '11X%' and a.yzyl>0) or (a.cslb like '15%' and a.yzyl1<0))  and a.ny>=('${年份}'-1)||'01' and a.ny<='${年份}'||'12' group by a.ny) group by cslb,ny 

select a.xmdl,a.xmxl,a.blb,a.xmid,b.year,b.ny,b.shuzhi from sq_yxjh_xh a 
left join (select YEAR,xmid,case month when 'JANUARY' then YEAR||'1' when 'FEBRUARY' then YEAR||'2' when 'MARCH' then YEAR||'3' when 'APRIL' then YEAR||'4' when 'MAY' then YEAR||'5' when 'JUNE' then YEAR||'6' when 'JULY' then YEAR||'7' when 'AUGUST' then YEAR||'8' when 'SEPTEMBER' then YEAR||'9' when 'OCTOBER' then YEAR||'10' when 'NOVEMBER' then YEAR||'11' when 'DECEMBER' then YEAR||'12' else month end as NY,shuzhi from sq_yxjh unpivot (shuzhi for month in (january, february, march, april,may,june,july,august,september,october,november,december,quannian,rijun)) WHERE ((YEAR+1)>='${年份}' or YEAR='${年份}') AND KM='公司运行') b on a.xmid=b.xmid where a.blb like '公司运行%' order by a.xh



select  A.NY,sum(a.ycyl+a.ycsl) cyel,sum(a.ycyl) cyoul from dba04 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and (substr(A.ny,0,4)='${年份}' or substr(A.ny,0,4)='${年份}'-1) group by a.ny


select  A.NY,sum(a.ycyl+a.ycsl) cyel,sum(a.ycyl) cyoul from dba04 a,daa01 b where a.jh=b.jh and (B.xqkdm>3000 and B.xqkdm<5000) and (substr(A.ny,0,4)='${年份}' or substr(A.ny,0,4)='${年份}'-1) group by a.ny


select  A.NY,sum(a.ycyl+a.ycsl) cyel,sum(a.ycyl) cyoul from dba04 a,daa01 b where a.jh=b.jh and (substr(A.ny,0,4)='${年份}' or substr(A.ny,0,4)='${年份}'-1) group by a.ny

select b.ny, sum(b.ycyl+b.ycsl) cyel,sum(b.ycyl) cyoul,
SUM(CASE WHEN b.ny=to_char(a.tcrq,'yyyyMM') THEN 1 ELSE 0 END) js 
from daa01 a,dba04 b where a.jh=b.jh and substr(b.ny,0,4)=to_char(a.tcrq,'yyyy') AND (a.XQKDM<3000 or a.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny

select a.ny,count(a.jh),sum(a.yzyl1) ycyl1,sum(a.yzyl) ycyl from pdpmis.dba08 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and (( substr(a.cslb,1,2) in ('11','12','13','19','1A','1B','15','1F','1G') and a.cslb not like '11X%' and a.yzyl>0) or (a.cslb like '15%' and a.yzyl1<0))  and a.ny>=('${年份}'-1)||'01' and a.ny<='${年份}'||'12' group by a.ny

select b.ny, round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl,SUM(CASE WHEN b.ny=to_char(a.zsrq,'yyyyMM') THEN 1 ELSE 0 END) js from daa01 a,dba05 b where a.jh=b.jh and substr(b.ny,0,4)=to_char(a.zsrq,'yyyy') AND (a.XQKDM<3000 or a.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny

select (CASE substr(a.cslb,1,2) WHEN '11' THEN '压裂' WHEN '13' THEN '补孔' WHEN '12'THEN '酸化' ELSE '其他' END) cslb,a.ny,round(sum(a.yzzsl)/to_char(last_day(TO_DATE(a.ny,'YYYYMM')),'dd'),2) as yzsl,count(a.jh) js from pdpmis.dba081 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and substr(a.cslb,1,2) in ('1A','11','12','15','1G','13','1J') and a.cslb not like '11X%' and a.yzzsl>0 and (substr(a.ny,0,4)='${年份}' or substr(a.ny,0,4)='${年份}'-1) group by a.cslb,a.ny

select b.ny,round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl from daa01 a,dba05 b where (a.xqkdm<3000 or a.xqkdm>5000) and a.jh=b.jh and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny

select b.ny,round(sum(b.yzsl)/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as yzsl from daa01 a,dba05 b where (a.xqkdm>3000 and a.xqkdm<5000) and a.jh=b.jh and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny 

select a.ny,CASE substr(a.cslb,1,2) WHEN '11' THEN '压裂' WHEN '12' THEN '酸化' WHEN '13' THEN '补孔' WHEN '1J' THEN '浅调' ELSE a.cslb END cslb,
SUM(CASE WHEN A.NY=TO_CHAR(A.WGRQ,'yyyyMM') THEN 1 ELSE 0 END) gzl 
from pdpmis.dba081 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and substr(a.cslb,1,2) in ('1A','11','12','15','1G','13','1J')  and a.cslb not like '11X%' and a.ny>=('${年份}'-1)||'01' and a.ny<='${年份}'||'12' group by a.ny,a.cslb

select  t.rq,t.days,round(sum(zgyljsl)/days,2) rzsl from (
select CONVERT(varchar(6), rq, 112) rq,zgyljsl,day(dateadd(month, datediff(month, 0, dateadd(month, 1, rq)), -1)) as days From sjcszg Where YEAR(RQ)+1>='${年份}' and day(rq+1)=1 AND replace(DW,' ','')='全厂'
) t group by t.rq,t.days  

select c.ny,count(c.jh) js,sum(c.hsycyl) hsycyou from pdpmis.dba08 a,daa01 b,dba04 c where (a.jh=b.jh and a.jh=c.jh) and (b.xqkdm<3000 or b.xqkdm>5000) and ((substr(a.cslb,1,2) in ('11','12','13','19','1A','1B','15','1F','1G') and a.cslb not like '11X%' and a.yzyl>0) or (a.cslb like '15%' and a.yzyl1<0))  and a.ny=c.ny and a.ny>=('${年份}'-1)||'01' and a.ny<='${年份}'||'12' group by c.ny

select b.ny, sum(b.hsycyl) hsycy,
SUM(CASE WHEN b.ny=to_char(a.tcrq,'yyyyMM') THEN 1 ELSE 0 END) js 
from daa01 a,dba04 b where a.jh=b.jh and substr(b.ny,0,4)=to_char(a.tcrq,'yyyy') AND (a.XQKDM<3000 or a.XQKDM>5000) and (substr(b.ny,0,4)='${年份}' or substr(b.ny,0,4)='${年份}'-1) group by b.ny

select A.NY,sum(a.hsycyl) hsycyl from dba04 a,daa01 b where a.jh=b.jh and (b.xqkdm<3000 or b.xqkdm>5000) and (substr(A.ny,0,4)='${年份}' or substr(A.ny,0,4)='${年份}'-1) group by a.ny

select  A.NY,sum(a.hsycyl) hsycyl from dba04 a,daa01 b where a.jh=b.jh and (b.xqkdm>3000 and B.xqkdm<5000) and (substr(A.ny,0,4)='${年份}' or substr(A.ny,0,4)='${年份}'-1) group by a.ny

select  A.NY,sum(a.hsycyl) hsycyl from dba04 a,daa01 b where a.jh=b.jh and (substr(A.ny,0,4)='${年份}' or substr(A.ny,0,4)='${年份}'-1) group by a.ny

