select a.WarehouseCenterId,
       b.name as 仓库,
       a.OwnerId,
       g.MaterialId,
       f.code as 物料编码,
       f.name as 物料名称,
       p.code as 甲方项目编码,
       p.name as 甲方项目名称,
       p.ProjectManager as 项目负责人
  from LRP_WMTx_H a
  left join LRP_WarehouseCenter b
    on a.WarehouseCenterId = b.oid
  left join LRP_Owner c
    on a.OwnerId = c.oid
  left join LRP_WMTx_L g
    on a.oid = g.soid
  left join LRP_Material f
    on g.MaterialId = f.oid
  left join LRP_PartyAProject p
    on g.SrcDictUserDef4 = p.oid
 where a.OwnerId = '113003031' and TXTYPECODE=201
 and 
to_char(b.name) in (select name from (SELECT ID,name FROM    (zjtx.FINE_DEPARTMENT@BILINK)
START WITH ID 
IN 
(
select id
from (zjtx.fine_department@BILINK)
where id in 
(
select departmentid from  (zjtx.fine_dep_role@BILINK)
where id in 
( 
select roleid from (zjtx.fine_user_role_middle@BILINK)
where userid in 
(
select id from   (zjtx.fine_user@BILINK)
where userName='${fine_username}' 
)
)
)
)

CONNECT BY PARENTID = PRIOR ID

) 
where   name not like '%供应链%')
order by decode(仓库,'广州配送中心夏茅仓库',1,'广州配送中心花东仓库',2,'广州配送中心江村仓库',3,'广州分屯库夏茅仓库',4,'广州分屯库沙河仓库',5,'广州分屯库江村仓库',6,'广州分屯库钟落潭仓库',7,'广州分屯库竹山仓库',8,'广州分屯库花东仓库',9,'深圳配送中心1号仓库（东莞）',10,'深圳配送中心2号仓库（惠州）',11,'深圳配送中心3号仓库（河源）',12,'深圳配送中心4号仓库（龙华）',13,'深圳分屯库仓库（龙华）',14,'深圳分屯库同乐仓库',15,'深圳分屯库仓库71区仓库',16,'深圳分屯库田寮仓库',17,'深圳分屯库老太坑仓库',18,'茂名配送中心金山仓库',19,'汕头配送中心仓库',20,'东莞分屯库目标局仓库',21,'东莞分屯库下桥仓库',22,'佛山分屯库城西仓库',23,'佛山分屯库红岗仓库',24,'佛山分屯库南庄仓库',25,'中山分屯库港口仓库',26,'惠州分屯库小金口仓库',27,'江门分屯库礼乐仓库',28,'汕头分屯库汕头仓库',29,'汕头分屯库泰山仓库',30,'珠海分屯库南屏仓库',31,'湛江分屯库麻章仓库',32,'茂名分屯库金山仓库',33,'揭阳分屯库揭阳仓库',34,'揭阳分屯库榕东仓库',35,'肇庆分屯库马安仓库',36,'清远分屯库南丫塘仓库',37,'梅州分屯库梅州仓库',38,'潮州分屯库潮州仓库',39,'潮州分屯库浮洋仓库',40,'韶关分屯库南郊仓库',41,'河源分屯库河源仓库',42,'汕尾分屯库汕尾仓库',43,'阳江分屯库阳江仓库',44,'云浮分屯库牧羊仓库',45,'广东电信综合线路维护库（直属）',46)

