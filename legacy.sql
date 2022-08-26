select hkbh, (case when isnull(dkhbh,'')='' then khbh else dkhbh end) as khbh,
(case when isnull(dkhmc,'')='' then khmc else dkhmc end ) as khmc,jsfs,fkrq,cast((fkje/10000)as real) as fkje,cwhsqj,jsfs,pzbh,pzlb,bz from wzxt..cwhkdj 
where year(fkrq)=year(getdate()) and fkje>0 and (jsfs='${jsfs}' and (fkrq >= '${rq}'and fkrq <= '${rqt}'))

select distinct month(fkrq) as yf from wzxt..cwhkdj where year(fkrq)=year(getdate()) 

select hkbh,khbh,khmc,jsfs,fkrq,fkje,cwhsqj,pzlb,bz,editime,editrymc,cast(fdsyb as real) as fdsyb,cast(fdyw as real) as fdyw,cast(xszgs as real) as xszgs ,cast(xsyw as real)as xsyw,cast(xscb as real) as xscb,cast(xsgm as real) as xsgm,cast(xsxcp as real) as xsxcp,cast(zcyfx as real) as zcyfx,cast(lzj as real) as lzj,cast(jp as real) as jp,cast(wzgs as real) as wzgs FROM   wzxt.dbo.cwfkdj  

select distinct fkrq as rq from wzxt..cwhkdj where year(fkrq)=year(getdate()) and month(fkrq)='${yf}'

select hkbh, (case when isnull(dkhbh,'')='' then khbh else dkhbh end) as khbh,
(case when isnull(dkhmc,'')='' then khmc else dkhmc end ) as khmc,jsfs,fkrq,cast((fkje/10000)as real) as fkje,cwhsqj,jsfs,pzbh,pzlb,bz from wzxt..cwhkdj 
where year(fkrq)=year(getdate()) and fkje>0  and fkrq ='${rq}'

