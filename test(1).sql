select 
SUM(goodsqty),
SUM(costingpriceqty),
SUM(examcostpriceqty)
from
(
-----每月1号更新高去化
select 
buid,
entryid,
goodsqty,
salenum,
costingprice,
examcostprice/(salestaxrate+1) examcostprice,
costingpriceqty,
examcostpriceqty
from high_ui
where
to_char(updatetime,'yyyy')='${LYEAR}'
AND extract(month from updatetime)='${LMONTH}'
AND extract(day from updatetime)='${LDAY}'
${if(len(company) == 0,"","and buid in ('" + company + "')")}
${if(len(level1) == 0,"","and level1 in ('" + level1 + "')")}  ----品规结构
${if(len(qhts_section) == 0,"","and qhts_section in ('" + qhts_section + "')")}  ---去化结构
${if(len(employeename) == 0,"","and employeename in ('" + employeename + "')")}   ----业务员
${if(len(isnew) == 0,"","and isnew in ('" + isnew + "')")}   -----是否新品
${if(len(entryid) == 0,"","and entryid in ('" + entryid + "')")}

union all
------每天更新高去化，除1号
select 
buid,
entryid,
goodsqty,
salenum,
costingprice,
examcostprice/(salestaxrate+1) examcostprice,
costingpriceqty,
examcostpriceqty
from high_ui_day
where
to_char(updatetime,'yyyy')='${LYEAR}'
AND extract(month from updatetime)='${LMONTH}'
AND extract(day from updatetime)='${LDAY}'
${if(len(company) == 0,"","and buid in ('" + company + "')")}
${if(len(level1) == 0,"","and level1 in ('" + level1 + "')")}  ----品规结构
${if(len(qhts_section) == 0,"","and qhts_section in ('" + qhts_section + "')")}  ---去化结构
${if(len(employeename) == 0,"","and employeename in ('" + employeename + "')")}   ----业务员
${if(len(isnew) == 0,"","and isnew in ('" + isnew + "')")}   -----是否新品
${if(len(entryid) == 0,"","and entryid in ('" + entryid + "')")}
)

select distinct to_char(updatetime,'yyyy') year
from high_ui
order by to_char(updatetime,'yyyy')

select distinct extract(month from updatetime) month

from high_ui
where to_char(updatetime,'yyyy')='${LYEAR}'
order by extract(month from updatetime)

select
distinct to_char(updatetime,'dd') day
from high_ui
where to_char(updatetime,'yyyy')='${LYEAR}'
and extract(month from updatetime)='${LMONTH}'
union all

select
distinct to_char(updatetime,'dd') day
from high_ui_day
where to_char(updatetime,'yyyy')='${LYEAR}'
and extract(month from updatetime)='${LMONTH}'

select 
buid,
busimname,
entryid,
entryname,
deptname,
employeename,
goodsid,
goodsname,
goodstype,
prodarea,
goodsunit,
goodsqty,
salenum,
costingprice,
examcostprice,
costingpriceqty,
examcostpriceqty,
qhts,
level1,
companyname,
qhtype,
isnew,
updatetime
from
(
-----每月1号更新高去化
select 
buid,
busimname,
entryid,
entryname,
deptname,
employeename,
goodsid,
goodsname,
goodstype,
prodarea,
goodsunit,
goodsqty,
salenum,
costingprice,
examcostprice/(salestaxrate+1) examcostprice,
costingpriceqty,
examcostpriceqty,
qhts,
level1,
companyname,
qhtype,
isnew,
updatetime
from high_ui
where
to_char(updatetime,'yyyy')='${LYEAR}'
AND extract(month from updatetime)=${LMONTH}
AND extract(day from updatetime)=${LDAY}
${if(len(company) == 0,"","and buid in ('" + company + "')")}
${if(len(level1) == 0,"","and level1 in ('" + level1 + "')")}  ----品规结构
--${if(len(qhtype) == 0,"","and qhtype in ('" + qhtype + "')")}
--${if(len(high_section) == 0,"","and high_section in ('" + high_section + "')")}
${if(len(qhts_section) == 0,"","and qhts_section in ('" + qhts_section + "')")}  ---去化结构
${if(len(employeename) == 0,"","and employeename in ('" + employeename + "')")}   ----业务员
${if(len(isnew) == 0,"","and isnew in ('" + isnew + "')")}   -----是否新品
${if(len(entryid) == 0,"","and entryid in ('" + entryid + "')")}

union all
------每天更新高去化，除1号
select 
buid,
busimname,
entryid,
entryname,
deptname,
employeename,
goodsid,
goodsname,
goodstype,
prodarea,
goodsunit,
goodsqty,
salenum,
costingprice,
examcostprice/(salestaxrate+1) examcostprice,
costingpriceqty,
examcostpriceqty,
qhts,
level1,
companyname,
qhtype,
isnew,
updatetime
from high_ui_day
where
to_char(updatetime,'yyyy')='${LYEAR}'
AND extract(month from updatetime)=${LMONTH}
AND extract(day from updatetime)=${LDAY}
${if(len(company) == 0,"","and buid in ('" + company + "')")}
${if(len(level1) == 0,"","and level1 in ('" + level1 + "')")}  ----品规结构
--${if(len(qhtype) == 0,"","and qhtype in ('" + qhtype + "')")}
--${if(len(high_section) == 0,"","and high_section in ('" + high_section + "')")}
${if(len(qhts_section) == 0,"","and qhts_section in ('" + qhts_section + "')")}  ---去化结构
${if(len(employeename) == 0,"","and employeename in ('" + employeename + "')")}   ----业务员
${if(len(isnew) == 0,"","and isnew in ('" + isnew + "')")}   -----是否新品
${if(len(entryid) == 0,"","and entryid in ('" + entryid + "')")}
)
order by examcostpriceqty desc

