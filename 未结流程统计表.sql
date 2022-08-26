select distinct credate 
from it_oa_wjlc
union
select '当日数据' credate
order by credate desc



with t1 as(
select
credate,
level2,
level3,
sum(lcs) lcs, 
max(lcsc) lcsc,
sum(jds) jds,
max(jdsc) jdsc
from it_oa_wjlc
where level2 is not null 
and level2 <>'其他'
${if(len(isimp)=0,"","and flow_level in ('"+isimp+"')")} 
and date(credate) = '${version}' 		
group BY
credate,
level2,
level3
order by lcs desc
),

t2 as(     -- 最长流程名  发起人
select 
level3,
zclc,ZCLCID,
zclcren,
row_number() over(PARTITION by  level3 order by lcsc desc) num
from it_oa_wjlc
where level2 is not null 
and level2 <>'其他'
${if(len(isimp)=0,"","and flow_level in ('"+isimp+"')")} 
and date(credate) = '${version}' 	
),
t3 as(
select 
level3,
zcjd,ZCJDID,
zcjdren,
row_number() over(PARTITION by  level3 order by jdsc desc) num
from it_oa_wjlc
where level2 is not null 
and level2 <>'其他'
${if(len(isimp)=0,"","and flow_level in ('"+isimp+"')")} 
and date(credate) = '${version}' 	
)

select 
credate,
level2,
t1.level3,
lcs, 
lcsc,
jds,
jdsc,
zclc,zclcren,ZCLCID,
zcjd,zcjdren,ZCJDID

from t1 
left join (select * from t2 where num =1 ) t4 on  t1.level3=t4.level3 
left join (select * from t3 where num =1 ) t5 on  t1.level3=t5.level3 
order by 
lcs desc






