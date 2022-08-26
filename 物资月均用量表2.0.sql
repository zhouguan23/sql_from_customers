select distinct 地市 from 
(select 
       case when b.name like '%直属%' then '直属单位'
            when b.name like '%配送中心%' then substr(b.name,3,4) 
            else substr(b.name,1,2) end as 地市,
       a.WAREHOUSECENTERID,
       b.name as 接单机构
  from lrp_quant a
  left join LRP_WarehouseCenter b
    on a.WAREHOUSECENTERID = b.oid
 where a.OwnerId = '113003031')
 order by 
decode(地市,'配送中心',1,'深圳',2,'广州',3,'东莞',4,'佛山',5,'中山',6,'惠州',7,'江门',8,'汕头',9,'珠海',10,'湛江',11,'茂名',12,'揭阳',13,'肇庆',14,'清远',15,'梅州',16,'潮州',17,'韶关',18,'河源',19,'汕尾',20,'阳江',21,'云浮',22,'直属单位',23)

