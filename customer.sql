select sum(a_no) a_no, sum(a_asp) a_asp, sum(a_upt) a_upt, sum(a_atv) a_atv, 
       sum(m_fov) m_fov,sum(m_no) m_no, sum(m_asp) m_asp, sum(m_upt) m_upt, sum(m_atv) m_atv,
       sum(n_no) n_no, sum(n_asp) n_asp, sum(n_upt) n_upt, sum(n_atv) n_atv
 from (
--全部
select count(distinct o.tran_no) as a_no, 
       round(sum(no_tax_amount)/sum(sale_qty),2) as a_asp, 
       round(sum(sale_qty)/count(distinct o.tran_no),2) as a_upt, 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2) as a_atv,
       0 as m_fov,0 as m_no,0 as m_asp,0 as m_upt,0 as m_atv,0 as n_no,0 as n_asp,0 as n_upt,0 as n_atv
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(o.sale_Date,'yyyy-mm-dd')>=(select DAY_ID from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
year_ID||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy/mm/dd')='${Date}')
)
AND
TO_CHAR(o.sale_Date,'yyyy-mm-dd')<=(select DAY_ID from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID)||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy/mm/dd')='${Date}')
)
and o.cus_code = '${cus}'
--会员
union all
select 0,0,0,0,
       count(distinct d.insiderid ), 
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2),
       0,0,0,0
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(o.sale_Date,'yyyy-mm-dd')>=(select DAY_ID from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
year_ID||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy/mm/dd')='${Date}')
)
AND
TO_CHAR(o.sale_Date,'yyyy-mm-dd')<=(select DAY_ID from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID)||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy/mm/dd')='${Date}')
)
and o.cus_code = '${cus}'
and is_vip ='Y'
--非会员
union all
select 0,0,0,0,0,0,0,0,0,
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2)
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(o.sale_Date,'yyyy-mm-dd')>=(select DAY_ID from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
year_ID||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy/mm/dd')='${Date}')
)
AND
TO_CHAR(o.sale_Date,'yyyy-mm-dd')<=(select DAY_ID from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID)||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy/mm/dd')='${Date}')
)
and o.cus_code = '${cus}'
and is_vip ='N'
)

select sum(a_no) a_no, sum(a_asp) a_asp, sum(a_upt) a_upt, sum(a_atv) a_atv, 
       sum(m_fov) m_fov,sum(m_no) m_no, sum(m_asp) m_asp, sum(m_upt) m_upt, sum(m_atv) m_atv,
       sum(n_no) n_no, sum(n_asp) n_asp, sum(n_upt) n_upt, sum(n_atv) n_atv
 from (
--全部
select count(distinct o.tran_no) as a_no, 
       round(sum(no_tax_amount)/sum(sale_qty),2) as a_asp, 
       round(sum(sale_qty)/count(distinct o.tran_no),2) as a_upt, 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2) as a_atv,
       0 as m_fov,0 as m_no,0 as m_asp,0 as m_upt,0 as m_atv,0 as n_no,0 as n_asp,0 as n_upt,0 as n_atv
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and o.sale_Date>=(select DDATE from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
(year_ID-1)||WEEK_ID FROM DIM_DAY WHERE DDATE=to_date('${Date}','YYYY-MM-DD'))
)
AND
o.sale_Date<=(select DDATE from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID-1)||WEEK_ID FROM DIM_DAY WHERE DDATE=to_date('${Date}','YYYY-MM-DD'))
)
and o.cus_code = '${cus}'
and o.SALE_DATE<(select b.DDATE FROM DIM_DAY a,DIM_DAY b
where a.DDATE=trunc(sysdate)  and a.WEEK_ID=b.WEEK_ID and a.WEEK_DESC=b.WEEK_DESC and a.YEAR_ID=b.YEAR_ID+1)
--会员
union all
select 0,0,0,0,
       count(distinct d.insiderid ), 
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2),
       0,0,0,0
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and o.sale_Date>=(select DDATE from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
(year_ID-1)||WEEK_ID FROM DIM_DAY WHERE DDATE=to_date('${Date}','YYYY-MM-DD'))
)
AND
o.sale_Date<=(select DDATE from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID-1)||WEEK_ID FROM DIM_DAY WHERE DDATE=to_date('${Date}','YYYY-MM-DD'))
)
and o.cus_code = '${cus}'
and o.SALE_DATE<(select b.DDATE FROM DIM_DAY a,DIM_DAY b
where a.DDATE=trunc(sysdate)  and a.WEEK_ID=b.WEEK_ID and a.WEEK_DESC=b.WEEK_DESC and a.YEAR_ID=b.YEAR_ID+1)
and is_vip ='Y'
--非会员
union all
select 0,0,0,0,0,0,0,0,0,
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2)
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and o.sale_Date>=(select DDATE from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
(year_ID-1)||WEEK_ID FROM DIM_DAY WHERE DDATE=to_date('${Date}','YYYY-MM-DD'))
)
AND
o.sale_Date<=(select DDATE from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID -1)||WEEK_ID FROM DIM_DAY WHERE DDATE=to_date('${Date}','YYYY-MM-DD'))
)
and o.cus_code = '${cus}'
and is_vip ='N'
and o.SALE_DATE<(select b.DDATE FROM DIM_DAY a,DIM_DAY b
where a.DDATE=trunc(sysdate)  and a.WEEK_ID=b.WEEK_ID and a.WEEK_DESC=b.WEEK_DESC and a.YEAR_ID=b.YEAR_ID+1)
)

select distinct large_Cate from DM_SALE_LARGE_CATE

select sum(a_no) a_no, sum(a_asp) a_asp, sum(a_upt) a_upt, sum(a_atv) a_atv, 
       sum(m_fov) m_fov,sum(m_no) m_no, sum(m_asp) m_asp, sum(m_upt) m_upt, sum(m_atv) m_atv,
       sum(n_no) n_no, sum(n_asp) n_asp, sum(n_upt) n_upt, sum(n_atv) n_atv
 from (
--全部
select count(distinct o.tran_no) as a_no, 
       round(sum(no_tax_amount)/sum(sale_qty),2) as a_asp, 
       round(sum(sale_qty)/count(distinct o.tran_no),2) as a_upt, 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2) as a_atv,
       0 as m_fov,0 as m_no,0 as m_asp,0 as m_upt,0 as m_atv,0 as n_no,0 as n_asp,0 as n_upt,0 as n_atv
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr('${Date}',1,8)||'01')
AND TO_CHAR(sale_Date,'yyyy/mm/dd')<='${Date}'
and o.cus_code = '${cus}'
--会员
union all
select 0,0,0,0,
       count(distinct d.insiderid ), 
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2),
       0,0,0,0
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr('${Date}',1,8)||'01')
AND TO_CHAR(sale_Date,'yyyy/mm/dd')<='${Date}'
and o.cus_code = '${cus}'
and is_vip ='Y'
--非会员
union all
select 0,0,0,0,0,0,0,0,0,
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2)
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr('${Date}',1,8)||'01')
AND TO_CHAR(sale_Date,'yyyy/mm/dd')<='${Date}'
and o.cus_code = '${cus}'
and is_vip ='N'
)

select sum(a_no) a_no, sum(a_asp) a_asp, sum(a_upt) a_upt, sum(a_atv) a_atv, 
       sum(m_fov) m_fov,sum(m_no) m_no, sum(m_asp) m_asp, sum(m_upt) m_upt, sum(m_atv) m_atv,
       sum(n_no) n_no, sum(n_asp) n_asp, sum(n_upt) n_upt, sum(n_atv) n_atv
 from (
--全部
select count(distinct o.tran_no) as a_no, 
       round(sum(no_tax_amount)/sum(sale_qty),2) as a_asp, 
       round(sum(sale_qty)/count(distinct o.tran_no),2) as a_upt, 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2) as a_atv,
       0 as m_fov,0 as m_no,0 as m_asp,0 as m_upt,0 as m_atv,0 as n_no,0 as n_asp,0 as n_upt,0 as n_atv
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and 
TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr(to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd'),1,8)||'01')
AND
TO_CHAR(sale_Date,'yyyy/mm/dd')<=to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')
and o.cus_code = '${cus}'
and o.SALE_DATE<trunc(add_months(sysdate,-12))
--会员
union all
select 0,0,0,0,
       count(distinct d.insiderid ), 
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2),
       0,0,0,0
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and 
TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr(to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd'),1,8)||'01')
AND
TO_CHAR(sale_Date,'yyyy/mm/dd')<=to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')
and o.cus_code = '${cus}'
and is_vip ='Y'
and o.SALE_DATE<trunc(add_months(sysdate,-12))
--非会员
union all
select 0,0,0,0,0,0,0,0,0,
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2)
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and 
TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr(to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd'),1,8)||'01')
AND
TO_CHAR(sale_Date,'yyyy/mm/dd')<=to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')
and o.cus_code = '${cus}'
and is_vip ='N'
and o.SALE_DATE<trunc(add_months(sysdate,-12))
)

select sum(a_no) a_no, sum(a_asp) a_asp, sum(a_upt) a_upt, sum(a_atv) a_atv, 
       sum(m_fov) m_fov,sum(m_no) m_no, sum(m_asp) m_asp, sum(m_upt) m_upt, sum(m_atv) m_atv,
       sum(n_no) n_no, sum(n_asp) n_asp, sum(n_upt) n_upt, sum(n_atv) n_atv
 from (
--全部
select count(distinct o.tran_no) as a_no, 
       round(sum(no_tax_amount)/sum(sale_qty),2) as a_asp, 
       round(sum(sale_qty)/count(distinct o.tran_no),2) as a_upt, 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2) as a_atv,
       0 as m_fov,0 as m_no,0 as m_asp,0 as m_upt,0 as m_atv,0 as n_no,0 as n_asp,0 as n_upt,0 as n_atv
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr('${Date}',1,5)||'01/21')
AND TO_CHAR(sale_Date,'yyyy/mm/dd')<='${Date}'
and o.cus_code = '${cus}'
--会员
union all
select 0,0,0,0,
       count(distinct d.insiderid ), 
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2),
       0,0,0,0
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr('${Date}',1,5)||'01/21')
AND TO_CHAR(sale_Date,'yyyy/mm/dd')<='${Date}'
and o.cus_code = '${cus}'
and is_vip ='Y'
--非会员
union all
select 0,0,0,0,0,0,0,0,0,
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2)
from ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr('${Date}',1,5)||'01/21')
AND TO_CHAR(sale_Date,'yyyy/mm/dd')<='${Date}'
and o.cus_code = '${cus}'
and is_vip ='N'
)

select sum(a_no) a_no, sum(a_asp) a_asp, sum(a_upt) a_upt, sum(a_atv) a_atv, 
       sum(m_fov) m_fov,sum(m_no) m_no, sum(m_asp) m_asp, sum(m_upt) m_upt, sum(m_atv) m_atv,
       sum(n_no) n_no, sum(n_asp) n_asp, sum(n_upt) n_upt, sum(n_atv) n_atv
 from (
--全部
select count(distinct o.tran_no) as a_no, 
       round(sum(no_tax_amount)/sum(sale_qty),2) as a_asp, 
       round(sum(sale_qty)/count(distinct o.tran_no),2) as a_upt, 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2) as a_atv,
       0 as m_fov,0 as m_no,0 as m_asp,0 as m_upt,0 as m_atv,0 as n_no,0 as n_asp,0 as n_upt,0 as n_atv
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and 
TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr(to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd'),1,5)||'01/22')
AND
TO_CHAR(sale_Date,'yyyy/mm/dd')<=to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')
and o.cus_code = '${cus}'
and o.SALE_DATE<trunc(add_months(sysdate,-12))
--会员
union all
select 0,0,0,0,
       count(distinct d.insiderid ), 
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2),
       0,0,0,0
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and 
TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr(to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd'),1,5)||'01/22')
AND
TO_CHAR(sale_Date,'yyyy/mm/dd')<=to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')
and o.cus_code = '${cus}'
and o.SALE_DATE<trunc(add_months(sysdate,-12))
and is_vip ='Y'
--非会员
union all
select 0,0,0,0,0,0,0,0,0,
       count(distinct o.tran_no), 
       round(sum(no_tax_amount)/sum(sale_qty),2), 
       round(sum(sale_qty)/count(distinct o.tran_no),2), 
       round(sum(no_tax_amount)/count(distinct o.tran_no),2)
from v_ods_sale_online o, gresa_sa_doc d
where o.tran_no = d.rsaid(+)
and 
TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr(to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd'),1,5)||'01/22')
AND
TO_CHAR(sale_Date,'yyyy/mm/dd')<=to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')
and o.cus_code = '${cus}'
and o.SALE_DATE<trunc(add_months(sysdate,-12))
and is_vip ='N'
)

select distinct area_code,area_name from DIM_REGION

select distinct cus_code,cus_name from DIM_CUS

