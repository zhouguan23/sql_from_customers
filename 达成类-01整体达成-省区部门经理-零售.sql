select year,month as month,dept1name,area2name,
       sum(AMOUNT)/10000 AS AMOUNT,--当月达成
       sum(AMOUNT_INDEX)/10000 AS AMONT_INDEX,--当月指标
       sum(AMOUNT_S)/10000 AS AMOUNT_S, --同期达成 
       sum(AMOUNT_YTD)/10000 AS AMOUNT_YTD,--累计达成
       sum(AMOUNT_INDEX_YTD)/10000 AS AMOUNT_INDEX_YTD,--累计指标
       sum(AMOUNT_S_YTD)/10000 AS AMOUNT_S_YTD --同期累计
from yldm.t_l1_dm_salesdata a
left join (select * from yledw.dim_yx_order WHERE DIM_TypeName='部门') b on a.dept1name=b.DIM_NAME --部门排序
left join (select * from yledw.dim_yx_order WHERE DIM_TypeName='省区') c on a.area2name=c.DIM_NAME --省区排序
where year=(select max(year) from yldm.t_l1_dm_salesdata)
${if(len(dept1name)==0,"" ,  "and a.dept1name in ('"+dept1name+"')")}
${if(len(area2name)==0,"" ,  "and a.area2name in ('"+area2name+"')")}
${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
group by year,month,dept1name,area2name,
b.order_id,c.order_id
ORDER BY month,b.order_id,c.order_id


select '日期：'||a.year||a.month as yearmonth,
       b.dept_section,
       a.dept1name,
       a.prodclass,
       a.PRODNAME, 
       a.BUSITYPE_NAME,      
       sum(a.amount_index)/10000 as amount_index,
       sum(a.amount)/10000 as amount,
       sum(a.amount_s)/10000 as amount_s,
       sum(a.amount_index_YTD)/10000 as amount_index_YTD,
       sum(a.amount_YTD)/10000 as amount_YTD,
       sum(a.amount_s_YTD)/10000 as amount_s_YTD,
       sum(a.amount_index_year)/10000 as amount_index_year,
       sum(a.amount_year)/10000 as amount_year,
       sum(a.amount_s_ytd)/10000 as amount_s_year,
       sum(a.AMOUNT_INDEX_L)/10000 as AMOUNT_INDEX_L,
       sum(a.AMOUNT_L)/10000 as AMOUNT_L            
from yldm.t_l1_dm_areadata a
left join (select * from yledw.t_l1_edw_department where is_BI_department=1) b on a.dept1name=b.deptname
left join (select * from yledw.dim_yx_order WHERE DIM_TypeName='部门') c on a.dept1name=c.DIM_NAME
left join (select * from yledw.dim_yx_order WHERE DIM_TypeName='品种') d on a.prodclass=d.DIM_NAME 
where 1=1
${if(len(dept1name)==0,"" ,  "and a.dept1name in ('"+dept1name+"')")}
${if(len(area2name)==0,"" ,  "and a.area2name in ('"+area2name+"')")}
${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
group by b.dept_section,
         a.dept1name,
         c.ORDER_ID,
         d.ORDER_ID,
         a.prodclass,
         a.BUSITYPE_NAME,
         a.PRODNAME,
         --a.area2name,
         '日期：'||a.year||a.month
order by c.ORDER_ID,d.ORDER_ID         



select 
       b.dept_section,
       a.dept1name,
       a.prodclass,
       a1.REPORTLEVEL7,
       NVL(e.PARENT_AREA2NAME,a.AREA2NAME) AS PARENT_AREA2NAME,
       a.area2name,       
       sum(a.amount_index)/10000 as amount_index,
       sum(a.amount)/10000 as amount,
       sum(a.amount_s)/10000 as amount_s,
       sum(a.amount_index_YTD)/10000 as amount_index_YTD,
       sum(a.amount_YTD)/10000 as amount_YTD,
       sum(a.amount_s_YTD)/10000 as amount_s_YTD,
       sum(a.amount_index_year)/10000 as amount_index_year,
       sum(a.amount_year)/10000 as amount_year,
       sum(a.amount_s_ytd)/10000 as amount_s_year,
       sum(a.AMOUNT_INDEX_L)/10000 as AMOUNT_INDEX_L,
       sum(a.AMOUNT_L)/10000 as AMOUNT_L          
from yldm.t_l1_dm_areadata a
left join yledw.t_l1_edw_levelmap a1 on nvl(a.YLLEVEL,'非锁')=a1.YLHOSPITALEVEL
left join (select * from yledw.t_l1_edw_department where is_BI_department=1) b on a.dept1name=b.deptname
left join (select * from yledw.dim_yx_order WHERE DIM_TypeName='部门') c on a.dept1name=c.DIM_NAME
left join (select * from yledw.dim_yx_order WHERE DIM_TypeName='品种') d on a.prodclass=d.DIM_NAME 
left join YLEDW.DIM_AREA2NAME_MAPPING e ON A.AREA2NAME = e.AREA2NAME
where 1=1
${if(len(dept1name)==0,"" ,  "and a.dept1name in ('"+dept1name+"')")}
${if(len(area2name)==0,"" ,  "and a.area2name in ('"+area2name+"')")}
${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
group by b.dept_section,
         a.dept1name,
         c.ORDER_ID,
         d.ORDER_ID,
         a.prodclass,
         a1.REPORTLEVEL7,
         a.area2name,
         NVL(e.PARENT_AREA2NAME,a.AREA2NAME)
order by c.ORDER_ID,d.ORDER_ID         



SELECT year||month as  YEARMONTH_ANALYSIS,
NVL(B.PARENT_AREA2NAME,A.AREA2NAME) AS PARENT_AREA2NAME,
C.ORDER_ID,
DEPT1NAME,
SUM(AMOUNT_INDEX)/10000 AS AMOUNT_INDEX,
SUM(AMOUNT)/10000 AS AMOUNT,
SUM(AMOUNT_INDEX_YTD)/10000 AS AMOUNT_INDEX_YTD,
SUM(AMOUNT_YTD)/10000 AS AMOUNT_YTD
from yldm.t_l1_dm_areadata a
LEFT JOIN YLEDW.DIM_AREA2NAME_MAPPING B ON A.AREA2NAME = B.AREA2NAME
LEFT JOIN (SELECT * FROM YLEDW.DIM_YX_ORDER WHERE DIM_TypeName='省区') C ON A.AREA2NAME=C.DIM_NAME 
where 1=1
--排名参数只写品种即可
${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")} 
${if(len(AREA2NAME)==0,"" ,  "and a.AREA2NAME in ('"+AREA2NAME+"')")} 
${if(len(DEPT1NAME)==0,"" ,  "and a.DEPT1NAME in ('"+DEPT1NAME+"')")} 
GROUP BY 
NVL(B.PARENT_AREA2NAME,A.AREA2NAME),
year||month,
DEPT1NAME,
C.ORDER_ID
ORDER BY C.ORDER_ID


SELECT year||month as  YEARMONTH_ANALYSIS,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end AS PARENT_AREA2NAME,
a.AREA2NAME,
DEPT1NAME,
SUM(AMOUNT_INDEX)/10000 AS AMOUNT_INDEX,
SUM(AMOUNT)/10000 AS AMOUNT,
CASE WHEN SUM(AMOUNT_INDEX)=0 THEN 0 ELSE SUM(AMOUNT)/SUM(AMOUNT_INDEX) END AS ACHIVE_RATE,
SUM(AMOUNT_INDEX_YTD)/10000 AS AMOUNT_INDEX_YTD,
SUM(AMOUNT_YTD)/10000 AS AMOUNT_YTD,
CASE WHEN SUM(AMOUNT_INDEX_YTD)=0 THEN 0 ELSE SUM(AMOUNT_YTD)/SUM(AMOUNT_INDEX_YTD) END AS ACHIVE_YTD_RATE
from yldm.t_l1_dm_areadata a
LEFT JOIN YLEDW.DIM_AREA2NAME_MAPPING B ON A.AREA2NAME = B.AREA2NAME
where 1=1
--排名参数只写品种即可
${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
${if(len(AREA2NAME)==0,"" ,  "and a.AREA2NAME in ('"+AREA2NAME+"')")}
${if(len(DEPT1NAME)==0,"" ,  "and a.DEPT1NAME in ('"+DEPT1NAME+"')")}
GROUP BY 
A.AREA2NAME,
DEPT1NAME,
year||month,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end ,
a.AREA2NAME
ORDER BY ACHIVE_RATE DESC




select *
from (
select a.*,
--省区部门排名
row_number()over(partition by dept_section,PARENT_AREA2NAME order by ACHIVE_RATE desc) rn1,
--全国排名
row_number()over(partition by DEPT1NAME order by ACHIVE_RATE desc) rn2 
from (
SELECT year||month as  YEARMONTH_ANALYSIS,
c1.dept_section,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end AS PARENT_AREA2NAME,
a.AREA2NAME,
C.ORDER_ID,
DEPT1NAME,
SUM(AMOUNT_INDEX)/10000 AS AMOUNT_INDEX,
SUM(AMOUNT)/10000 AS AMOUNT,
case when SUM(AMOUNT_INDEX)=0 then 0 else SUM(AMOUNT)/SUM(AMOUNT_INDEX) end AS ACHIVE_RATE ,
SUM(AMOUNT_INDEX_YTD)/10000 AS AMOUNT_INDEX_YTD,
SUM(AMOUNT_YTD)/10000 AS AMOUNT_YTD

from yldm.t_l1_dm_areadata a
LEFT JOIN YLEDW.DIM_AREA2NAME_MAPPING B ON A.AREA2NAME = B.AREA2NAME
LEFT JOIN (SELECT * FROM YLEDW.DIM_YX_ORDER WHERE DIM_TypeName='省区') C ON A.AREA2NAME=C.DIM_NAME
LEFT JOIN YLEDW.T_L1_EDW_DEPARTMENT C1 ON A.DEPT1NAME=C1.DEPTNAME
INNER JOIN (select distinct C.DEPT_SECTION 
           from yldm.t_l1_dm_areadata a 
           left join YLEDW.T_L1_EDW_DEPARTMENT C ON A.DEPT1NAME=C.DEPTNAME
           where 1=1 
           ${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
           ${if(len(DEPT1NAME)==0,"" ,  "and a.DEPT1NAME in ('"+DEPT1NAME+"')")}
          ) d on C1.dept_section =d.dept_section 
where 1=1
--排名参数只写品种即可
${if(len(PRODCLASS)==0,"" ,  "and A.PRODCLASS in ('"+PRODCLASS+"')")}
GROUP BY 
c1.dept_section,
a.area2name,
year||month,
DEPT1NAME,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end ,
a.AREA2NAME,
C.ORDER_ID
) a
) a
where 1=1
--排完名的筛选
${if(len(DEPT1NAME)==0,"" ,  "and A.DEPT1NAME in ('"+DEPT1NAME+"')")}



select *
from (
select a.*,
row_number()over(partition by dept_section,PARENT_AREA2NAME order by ACHIVE_RATE desc) rn1,
row_number()over(partition by DEPT1NAME order by ACHIVE_RATE desc) rn2
from (
SELECT year||month as  YEARMONTH_ANALYSIS,
c1.dept_section,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end AS PARENT_AREA2NAME,
a.AREA2NAME,
C.ORDER_ID,
DEPT1NAME,
SUM(AMOUNT_INDEX_YTD)/10000 AS AMOUNT_INDEX,
SUM(AMOUNT_YTD)/10000 AS AMOUNT,
case when SUM(AMOUNT_INDEX_YTD)=0 then 0 else SUM(AMOUNT_YTD)/SUM(AMOUNT_INDEX_YTD) end AS ACHIVE_RATE 

from yldm.t_l1_dm_areadata a
LEFT JOIN YLEDW.DIM_AREA2NAME_MAPPING B ON A.AREA2NAME = B.AREA2NAME
LEFT JOIN (SELECT * FROM YLEDW.DIM_YX_ORDER WHERE DIM_TypeName='省区') C ON A.AREA2NAME=C.DIM_NAME 
LEFT JOIN YLEDW.T_L1_EDW_DEPARTMENT C1 ON A.DEPT1NAME=C1.DEPTNAME

INNER JOIN (select distinct C.DEPT_SECTION 
           from yldm.t_l1_dm_areadata a 
           left join YLEDW.T_L1_EDW_DEPARTMENT C ON A.DEPT1NAME=C.DEPTNAME
           where 1=1 
           ${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
           ${if(len(DEPT1NAME)==0,"" ,  "and a.DEPT1NAME in ('"+DEPT1NAME+"')")}
          ) d on C1.dept_section =d.dept_section 
          
where 1=1
--排名参数只写品种即可
${if(len(PRODCLASS)==0,"" ,  "and A.PRODCLASS in ('"+PRODCLASS+"')")}  
GROUP BY 
a.area2name ,
c1.dept_section,
year||month,
DEPT1NAME,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end,
a.AREA2NAME,
C.ORDER_ID
) a
) a
where 1=1 ${if(len(DEPT1NAME)==0,"" ,  "and A.DEPT1NAME in ('"+DEPT1NAME+"')")}
order by rn1



SELECT year||month as  YEARMONTH_ANALYSIS,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end AS PARENT_AREA2NAME,
a.AREA2NAME,
DEPT1NAME,
SUM(AMOUNT_INDEX)/10000 AS AMOUNT_INDEX,
SUM(AMOUNT)/10000 AS AMOUNT,
CASE WHEN SUM(AMOUNT_INDEX)=0 THEN 0 ELSE SUM(AMOUNT)/SUM(AMOUNT_INDEX) END AS ACHIVE_RATE,
SUM(AMOUNT_INDEX_YTD)/10000 AS AMOUNT_INDEX_YTD,
SUM(AMOUNT_YTD)/10000 AS AMOUNT_YTD,
CASE WHEN SUM(AMOUNT_INDEX_YTD)=0 THEN 0 ELSE SUM(AMOUNT_YTD)/SUM(AMOUNT_INDEX_YTD) END AS ACHIVE_YTD_RATE
from yldm.t_l1_dm_areadata a
LEFT JOIN YLEDW.DIM_AREA2NAME_MAPPING B ON A.AREA2NAME = B.AREA2NAME
where 1=1
--排名参数只写品种即可
${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
${if(len(AREA2NAME)==0,"" ,  "and a.AREA2NAME in ('"+AREA2NAME+"')")}
${if(len(DEPT1NAME)==0,"" ,  "and a.DEPT1NAME in ('"+DEPT1NAME+"')")}
GROUP BY 
A.AREA2NAME,
DEPT1NAME,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end,
a.AREA2NAME,
year||month
ORDER BY ACHIVE_YTD_RATE DESC


select *
from (
select a.*,
--省区部门排名
row_number()over(partition by dept_section,PARENT_AREA2NAME order by ACHIVE_RATE desc) rn1,
--全国排名
row_number()over(partition by DEPT1NAME order by ACHIVE_RATE desc) rn2 
from (
SELECT year||month as  YEARMONTH_ANALYSIS,
c1.dept_section,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end AS PARENT_AREA2NAME,
a.AREA2NAME,
C.ORDER_ID,
DEPT1NAME,
SUM(AMOUNT_INDEX)/10000 AS AMOUNT_INDEX,
SUM(AMOUNT)/10000 AS AMOUNT,
case when SUM(AMOUNT_INDEX)=0 then 0 else SUM(AMOUNT)/SUM(AMOUNT_INDEX) end AS ACHIVE_RATE ,
SUM(AMOUNT_INDEX_YTD)/10000 AS AMOUNT_INDEX_YTD,
SUM(AMOUNT_YTD)/10000 AS AMOUNT_YTD

from yldm.t_l1_dm_areadata a
LEFT JOIN YLEDW.DIM_AREA2NAME_MAPPING B ON A.AREA2NAME = B.AREA2NAME
LEFT JOIN (SELECT * FROM YLEDW.DIM_YX_ORDER WHERE DIM_TypeName='省区') C ON A.AREA2NAME=C.DIM_NAME
LEFT JOIN YLEDW.T_L1_EDW_DEPARTMENT C1 ON A.DEPT1NAME=C1.DEPTNAME
INNER JOIN (select distinct C.DEPT_SECTION 
           from yldm.t_l1_dm_areadata a 
           left join YLEDW.T_L1_EDW_DEPARTMENT C ON A.DEPT1NAME=C.DEPTNAME
           where 1=1 
           ${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
           ${if(len(DEPT1NAME)==0,"" ,  "and a.DEPT1NAME in ('"+DEPT1NAME+"')")}
          ) d on C1.dept_section =d.dept_section 
where 1=1
--排名参数只写品种即可
${if(len(PRODCLASS)==0,"" ,  "and A.PRODCLASS in ('"+PRODCLASS+"')")}
GROUP BY 
c1.dept_section,
a.area2name,
year||month,
DEPT1NAME,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end,
a.AREA2NAME,
C.ORDER_ID
) a
) a
where 1=1
--排完名的筛选
${if(len(DEPT1NAME)==0,"" ,  "and A.DEPT1NAME in ('"+DEPT1NAME+"')")}



select *
from (
select a.*,
row_number()over(partition by dept_section,PARENT_AREA2NAME order by ACHIVE_RATE desc) rn1,
row_number()over(partition by DEPT1NAME order by ACHIVE_RATE desc) rn2
from (
SELECT year||month as  YEARMONTH_ANALYSIS,
c1.dept_section,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end AS PARENT_AREA2NAME,
a.AREA2NAME,
C.ORDER_ID,
DEPT1NAME,
SUM(AMOUNT_INDEX_YTD)/10000 AS AMOUNT_INDEX,
SUM(AMOUNT_YTD)/10000 AS AMOUNT,
case when SUM(AMOUNT_INDEX_YTD)=0 then 0 else SUM(AMOUNT_YTD)/SUM(AMOUNT_INDEX_YTD) end AS ACHIVE_RATE 

from yldm.t_l1_dm_areadata a
LEFT JOIN YLEDW.DIM_AREA2NAME_MAPPING B ON A.AREA2NAME = B.AREA2NAME
LEFT JOIN (SELECT * FROM YLEDW.DIM_YX_ORDER WHERE DIM_TypeName='省区') C ON A.AREA2NAME=C.DIM_NAME 
LEFT JOIN YLEDW.T_L1_EDW_DEPARTMENT C1 ON A.DEPT1NAME=C1.DEPTNAME

INNER JOIN (select distinct C.DEPT_SECTION 
           from yldm.t_l1_dm_areadata a 
           left join YLEDW.T_L1_EDW_DEPARTMENT C ON A.DEPT1NAME=C.DEPTNAME
           where 1=1 
           ${if(len(PRODCLASS)==0,"" ,  "and a.PRODCLASS in ('"+PRODCLASS+"')")}
           ${if(len(DEPT1NAME)==0,"" ,  "and a.DEPT1NAME in ('"+DEPT1NAME+"')")}
          ) d on C1.dept_section =d.dept_section 
          
where 1=1
--排名参数只写品种即可
${if(len(PRODCLASS)==0,"" ,  "and A.PRODCLASS in ('"+PRODCLASS+"')")}  
GROUP BY 
a.area2name ,
c1.dept_section,
year||month,
DEPT1NAME,
case when a.AREA2NAME in ('甘肃','青海') then '甘青'
     else nvl(b.PARENT_AREA2NAME,a.AREA2NAME) 
end,
a.AREA2NAME,
C.ORDER_ID
) a
) a
where 1=1 ${if(len(DEPT1NAME)==0,"" ,  "and A.DEPT1NAME in ('"+DEPT1NAME+"')")}
order by rn1


