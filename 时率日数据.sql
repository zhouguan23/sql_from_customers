select distinct km from daa01 where km is not null

select to_char(b.rq,'dd') as day,count(b.jh) js,sum((c.rcyl+c.rcsl)-(b.rcyl1+b.rcyl)) as cye,sum(c.rcyl-b.rcyl) as cyou from daa01 a, dba01 b, pdpmis.dba04_cn c where (a.xqkdm<3000 or a.xqkdm>5000) and a.km='${矿名}' and a.jh=b.jh and c.jh=b.jh and c.ny=to_char(add_months(b.rq,-1),'yyyymm') and (to_char(b.rq,'yyyymmdd') between concat(substr(replace('${时间}','-',''),0,6),'01') and replace('${时间}','-')) and b.bz like '%间%' group by a.km,b.rq

select to_char(b.rq,'dd') as day,count(b.jh) js,sum((c.rcyl+c.rcsl)-(b.rcyl1+b.rcyl)) as cye,sum(c.rcyl-b.rcyl) as cyou from daa01 a, dba01 b, pdpmis.dba04_cn c where (a.xqkdm<3000 or a.xqkdm>5000) and a.km='${矿名}' and a.jh=b.jh and c.jh=b.jh and c.ny=to_char(add_months(b.rq,-1),'yyyymm') and (to_char(b.rq,'yyyymmdd') between concat(substr(replace('${时间}','-',''),0,6),'01') and replace('${时间}','-')) and b.bz like '%测静压%' group by a.km,b.rq

select to_char(b.rq,'dd') day,count(b.jh) js,sum((c.rcyl+c.rcsl)-(b.rcyl+b.rcsl)) as cye,sum(c.rcyl-b.rcyl) as cyou from daa01 a,dba01 b, pdpmis.dba04_cn c where (a.xqkdm<3000 or a.xqkdm>5000) and a.km='${矿名}' and a.jh=b.jh and c.jh=a.jh and 
c.ny=to_char(add_months(b.rq,-1),'yyyymm') and
(to_char(b.rq,'yyyymmdd') between concat(substr(replace('${时间}','-',''),0,6),'01') and replace('${时间}','-')) and b.bz like '%热洗%' group by a.km,b.rq

--select b.rq,b.jh,b.scsj,b.rcyl1,b.rcyl,b.bz,c.ny,(c.rcyl+c.rcsl),c.rcyl from daa01 a,dba01 b, pdpmis.dba04_cn c where (a.xqkdm<3000 or a.xqkdm>5000) and a.km='${矿名}' and a.jh=b.jh and c.jh=a.jh and c.ny=to_char(add_months(b.rq,-1),'yyyymm') and(to_char(b.rq,'yyyymmdd') between concat(substr(replace('${时间}','-',''),0,6),'01') and replace('${时间}','-')) and b.bz like '%热洗%'

select to_char(a.rq,'dd') day,count(a.jh) zjs,  sum(case when a.scsj > 0 then 1 else 0 end) kjs,sum(a.rcyl + a.rcsl) rcye,sum(a.rcyl) rcyou from dba01 a,daa01 b where b.km='${单位}' and a.jh=b.jh and to_char(a.rq,'yyyymmdd') between concat(substr(replace('${时间}','-',''),0,6),'01') and replace('${时间}','-','') group by b.km,a.rq order by b.km,a.rq

select day,sum(js),sum(cye),sum(cyou),bz from (select to_char(b.rq,'dd') as day,count(b.jh) js,sum((c.rcyl+c.rcsl)-(b.rcsl+b.rcyl)) as cye,sum(c.rcyl-b.rcyl) as cyou,(case when b.bz like '%测静压%' then '测静压影响' when b.bz like '%间%' then '间抽影响' when b.bz like '%热洗%' then '热洗影响' else '' end) as bz from daa01 a, dba01 b, pdpmis.dba04_cn c where (a.xqkdm<3000 or a.xqkdm>5000) and a.km='${单位}' and a.jh=b.jh and c.jh=b.jh and c.ny=to_char(add_months(b.rq,-1),'yyyymm') and (to_char(b.rq,'yyyymmdd') between concat(substr(replace('${时间}','-',''),0,6),'01') and replace('${时间}','-')) and (b.bz like '%测静压%' or b.bz like '%间%' or b.bz like '%热洗%') group by a.km,b.rq,b.bz) group by day,bz

