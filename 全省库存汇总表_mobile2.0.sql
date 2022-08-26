select a.仓库,
       a.接收子库,
       sum(case
           when a.在库时间 between 0 and 180
           then a.合计金额
           else 0
           end)/10000 as 六个月以下,
       sum(case
           when a.在库时间 between 181 and 365
           then a.合计金额
           else 0
           end)/10000 as 六个月至一年,
       sum(case
           when a.在库时间 > 365
           then a.合计金额
           else 0
           end)/10000 as 一年以上  
from (select 
       z.name as 仓库,
       a.OnhandQty as 数量,
       a.NumUserDef1 as 不含税单价,
       a.OnhandQty * a.NumUserDef1 as 合计金额,
       a.RECVDATE as 入库时间,
       a.DateUserDef2 as 分屯库首次入库日期,
       case 
       when to_char(a.DateUserDef2,'yyyy-mm-dd') != '1980-01-01'
       then 
       ROUND(TO_NUMBER(sysdate - a.DateUserDef2), 0)
       when to_char(a.DateUserDef2,'yyyy-mm-dd') = '1980-01-01'
       then 
       ROUND(TO_NUMBER(sysdate - a.RECVDATE), 0)
       end as 在库时间,
       i.name as 接收子库
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
  left join LRP_WarehouseCenter z 
    on b.parentid=z.oid
  left join ReceivingSubsystem i
    on a.DictUserDef5 = i.oid
 where a.OwnerId = '113003031'
   and a.OnhandQty != 0
   and b.oid != '13559'
   and i.code in ('GD.JYH0001','GD.JYH0002','GD.JYH0003','GD.JYH0004','GD.JYH0005','GD.JYH0006','GD.JYH0007','GD.JYH0008','GD.JYH0009')
   and to_char(b.name) in (select name from (SELECT ID,name FROM (zjtx.FINE_DEPARTMENT@BILINK)
START WITH ID 
IN 
(
select id
from (zjtx.fine_department@BILINK)
where id in 
(
select departmentid from (zjtx.fine_dep_role@BILINK)
where id in 
( 
select roleid from (zjtx.fine_user_role_middle@BILINK)
where userid in 
(
select id from (zjtx.fine_user@BILINK)
where userName='${fine_username}' 
)
)
)
)
CONNECT BY PARENTID = PRIOR ID
) 
where name not like '%供应链%')
) a
  group by a.仓库,a.接收子库


select distinct a.仓库,a.接收子库
from (select 
       z.name as 仓库,
       a.OnhandQty as 数量,
       a.NumUserDef1 as 不含税单价,
       a.OnhandQty * a.NumUserDef1 as 合计金额,
       a.RECVDATE as 入库时间,
       a.DateUserDef2 as 分屯库首次入库日期,
       case 
       when to_char(a.DateUserDef2,'yyyy-mm-dd') != '1980-01-01'
       then 
       ROUND(TO_NUMBER(sysdate - a.DateUserDef2), 0)
       when to_char(a.DateUserDef2,'yyyy-mm-dd') = '1980-01-01'
       then 
       ROUND(TO_NUMBER(sysdate - a.RECVDATE), 0)
       end as 在库时间,
       i.name as 接收子库
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
  left join LRP_WarehouseCenter z 
    on b.parentid=z.oid
  left join ReceivingSubsystem i
    on a.DictUserDef5 = i.oid
 where a.OwnerId = '113003031'
   and a.OnhandQty != 0
   and b.oid != '13559'
   and i.code in ('GD.JYH0001','GD.JYH0002','GD.JYH0003','GD.JYH0004','GD.JYH0005','GD.JYH0006','GD.JYH0007','GD.JYH0008','GD.JYH0009')
   and to_char(b.name) in (select name from (SELECT ID,name FROM (zjtx.FINE_DEPARTMENT@BILINK)
START WITH ID 
IN 
(
select id
from (zjtx.fine_department@BILINK)
where id in 
(
select departmentid from (zjtx.fine_dep_role@BILINK)
where id in 
( 
select roleid from (zjtx.fine_user_role_middle@BILINK)
where userid in 
(
select id from (zjtx.fine_user@BILINK)
where userName='${fine_username}' 
)
)
)
)
CONNECT BY PARENTID = PRIOR ID
) 
where name not like '%供应链%')
) a
order by decode(a.仓库,'广州配送中心',1,'深圳配送中心',2,'茂名配送中心',3,'汕头配送中心',4,'深圳分屯库',5,'广州分屯库',6,'东莞分屯库',7,'佛山分屯库',8,'中山分屯库',9,'惠州分屯库',10,'江门分屯库',11,'汕头分屯库',12,'珠海分屯库',13,'湛江分屯库',14,'茂名分屯库',15,'揭阳分屯库',16,'肇庆分屯库',17,'清远分屯库',18,'梅州分屯库',19,'潮州分屯库',20,'韶关分屯库',21,'河源分屯库',22,'汕尾分屯库',23,'阳江分屯库',24,'云浮分屯库',25),
 decode(a.接收子库,'MSS在库物资',1,'供应商代管库',2,'施工单位代管库',3,'县区分公司代管库',4,'工余料-堪用料',5,'工余料-废料',6,'废旧物资',7,'MSS在途物资',8,'其他',9)

