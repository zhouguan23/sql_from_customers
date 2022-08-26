select * from DIM_ZDGYS_CJ where 
1=1 ${if(len(cjmc)=0,""," and  CJMC in('"+cjmc+"')" )}
and 1=1 ${if(len(xyhskj)=0,""," and  XYHSKJ in ('"+xyhskj+"')" )}
and 1=1 ${if(len(year)=0,""," and  create_year in ('"+year+"')" )}
order by create_year desc

select distinct cjmc from DIM_ZDGYS_CJ


select distinct xyhskj from DIM_ZDGYS_CJ
where 1=1 ${if(len(cjmc)=0, "", " and cjmc in ('" + cjmc + "')")}

select distinct create_year from DIM_ZDGYS_CJ

