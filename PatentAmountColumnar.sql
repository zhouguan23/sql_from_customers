select t.*
  from (select t.organ_name,
               '专利申请总量' statistics_type,
               sum(t.apply_count) count
          from ipr_patent_amount_report t
          where 1=1
          ${if(len(fullId) == 0,"","and t.full_id like '%"+ fullId +"%' ")} 
          ${if(len(yearMonthBegin) == 0,"","and t.year_month >'"+ yearMonthBegin +"' ")}
          ${if(len(yearMonthEnd) == 0,"","and t.year_month <= '"+ yearMonthEnd +"' ")}
         group by t.organ_name
        union all
        select t.organ_name, '专利授权总量', sum(t.grant_count) count
          from ipr_patent_amount_report t
          where 1=1
          ${if(len(fullId) == 0,"","and t.full_id like '%"+ fullId +"%' ")} 
          ${if(len(yearMonthBegin) == 0,"","and t.year_month >'"+ yearMonthBegin +"' ")}
          ${if(len(yearMonthEnd) == 0,"","and t.year_month <= '"+ yearMonthEnd +"' ")} 
         group by t.organ_name) t
 order by t.organ_name


