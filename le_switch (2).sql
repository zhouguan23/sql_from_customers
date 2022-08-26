select distinct cast(year as int) year from report.[onepage_overview_monthly_tracking]A
order by cast(year as int) DESC

select distinct concat('${year}-',cast(month as int)) year,cast(month as int) month from report.[onepage_overview_monthly_tracking]A
where 1=1
${if(len(year)=0,'and 1=2','')}
order by cast(month as int)

select distinct year,month,concat(year,concat('-',month)) year_month from (select distinct year from report.[onepage_overview_monthly_tracking]A) tt
left join (select distinct month from report.[onepage_overview_monthly_tracking]A) tt1
on 1=1
where 1=1
${if(len(year)=0,"and 1=2","and year="+year)}
order by year desc,month

select * from report.onepage_fr_le_switch

select code from report.onepage_fr_le_switch where startdate is not null and enddate is not null and startdate<=GETDATE() and enddate>=getdate()

