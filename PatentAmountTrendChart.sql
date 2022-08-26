select t.*
  from (select t.organ_name,
               t.year,
               sum(nvl(t.apply_count, 0) + nvl(t.grant_count, 0)) count
          from ipr_patent_amount_report t
         where 1 = 1
          ${if(len(fullId) == 0,"","and t.full_id like '%"+ fullId +"%' ")} 
          ${if(len(yearMonthBegin) == 0,"","and t.year_month >'"+ yearMonthBegin +"' ")}
          ${if(len(yearMonthEnd) == 0,"","and t.year_month <= '"+ yearMonthEnd +"' ")}
         group by t.organ_name, t.year) t
 order by t.year


