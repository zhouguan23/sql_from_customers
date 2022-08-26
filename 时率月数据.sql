select distinct km from daa01  where km is not null

select to_char(add_months(to_date(a.ny,'yyyy-mm'),1),'yyyymm') as ny,round(sum((b.rq2-b.rq1)*(a.rcsl+a.rcyl))/to_char(last_day(TO_DATE(a.ny,'YYYYMM')),'dd'),2) as cye,round(sum((b.rq2-b.rq1)*a.rcyl)/to_char(last_day(TO_DATE(a.ny,'YYYYMM')),'dd'),2) as cyou from pdpmis.dba04_cn a,
(select c.jh,d.km,min(c.rq) rq1,max(c.rq)rq2 from dba01 c,daa01 d 
where c.jh=d.jh and (d.xqkdm<3000 or d.xqkdm>5000) and (c.bz like '%测压%' or c.bz like '%测静压%') and d.km='${单位}' and (to_char(c.rq,'yyyymm') between replace('${开始时间}','-') and replace('${结束时间}','-')) group by c.jh,d.km,to_char(c.rq,'yyyymm')) b
where a.jh=b.jh and a.ny=to_char(add_months(b.rq1,-1),'yyyymm') group by b.km,a.ny

select b.ny,round(sum((b.rcyl+b.rcsl)*(to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd')-b.scts))/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as cye,round(sum(b.rcyl*(to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd')-b.scts))/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as cyou from daa01 a,pdpmis.dba04_cn b where (a.xqkdm<3000 or a.xqkdm>5000) and a.km='${单位}' and a.jh=b.jh and (b.ny between replace('${开始时间}','-') and replace('${结束时间}','-')) and b.bz like '%间%' group by a.km,b.ny

select a.ny, count(a.jh) zjs,  sum(case when a.scts > 0 then 1 else 0 end) kjs,sum(a.rcyl + a.rcsl) rcye,sum(a.rcyl) rcyou from pdpmis.dba04_cn a,daa01 b where b.km='${单位}' and a.jh=b.jh and (a.ny between replace('${开始时间}','-') and replace('${结束时间}','-')) group by b.km,a.ny order by b.km,a.ny

select b.ny,round(sum((b.rcyl+b.rcsl)*(to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd')-b.scts))/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as cye,round(sum(b.rcyl*(to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd')-b.scts))/to_char(last_day(TO_DATE(b.ny,'YYYYMM')),'dd'),2) as cyou from daa01 a,pdpmis.dba04_cn b where (a.xqkdm<3000 or a.xqkdm>5000) and a.km='${单位}' and a.jh=b.jh and (b.ny between replace('${开始时间}','-') and replace('${结束时间}','-')) and b.bz like '%热洗%' group by a.km,b.ny

