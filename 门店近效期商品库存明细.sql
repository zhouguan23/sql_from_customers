select b.party_name as parentorg,a.areaname,a.deptno,a.deptname,a.shortname,
       a.articode,a.artiabbr,a.artiname,a.artispec,a.artiunit,a.manufactory,
       a.storagename,a.stkareaname,a.provname,oriprovname,a.retailprice,
       sum(a.retailprice*a.stkqty) as retailamt,sum(a.costamt) as costamt,
       sum(a.costamt*(1+a.itaxrate)) as taxcostamt,
       sum(a.tolqty) as tolqty,sum(a.stkqty) as stkqty,
       a.batchcode,a.procdate,a.validdate,
       case when a.validdate-trunc(sysdate) < 0 then '已过期'
         else case when a.validdate-trunc(sysdate) <= 90 then '3个月内'
         else case when a.validdate-trunc(sysdate) <= 180 then '6个月内'
         else case when a.validdate-trunc(sysdate) <= 270 then '9个月内'
         else case when a.validdate-trunc(sysdate) <= 365 then '1年内'
         else '1年以上' end end end end end as validrange,
       round((select sum(sdtl.artiqty)
                from tbv_transaction sdoc,tbv_trandetail sdtl
               where sdoc.tranid = sdtl.tranid
                 and sdoc.deptid = a.deptid
                 and sdtl.artiid = a.artiid
                 and sdtl.batchcode = a.batchcode
                 and sdoc.trandate >= add_months(trunc(sysdate),-3)
                 and sdoc.trandate <= trunc(sysdate))/3,
              length(a.sell_coefficient)-1) as avgsaleqty,
       (select d.empname from sys_planer_duty c,org_employee d
         where a.artiid = c.com_goods_id and c.ou_id = 170000
           and c.emp_party_id = d.empid) as planer
  from store_inv_v a,com_party b
 where a.parentorgid = b.com_party_id
   and a.stkqty > 0
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_ou)==0,""," and a.ou_id = "+ ll_ou)}
 ${if(len(ll_parentorg)==0,""," and a.parentorgid = "+ ll_parentorg)}
 ${if(len(ll_areaid)==0,""," and a.areaid = "+ ll_areaid)}
 ${if(len(ll_deptid)==0,""," and a.deptid in ("+ ll_deptid +")")}
 ${if(len(ll_storetype)==0,""," and a.store_type = '"+ ll_storetype +"'")}
 ${if(len(ll_storageid)==0,""," and a.storageid = "+ ll_storageid)}
 ${if(len(ll_stkarea)==0,""," and a.stkareaid = "+ ll_stkarea)}
 ${if(len(ll_articode)==0,""," and a.articode like '"+ ll_articode +"%'")}
 ${if(len(ll_artiname)==0,""," and (instr(a.artiabbr,'"+ ll_artiname +"') > 0 or instr(a.artiname,'"+ ll_artiname +"') > 0)")}
  ${if(len(ll_manufactory)==0,""," and a.modelcode like '"+ ll_manufactory +"%'")}
 ${IF(LEN(ls_BATCHCODE)==0,""," and a.BATCHCODE like '"+ ls_BATCHCODE +"%'")}
 ${if(len(ll_validdate)==0,""," and a.validdate < to_date('"+ ll_validdate +"','yyyy-mm-dd')+1")}
 ${if(ll_validrange==0," and a.validdate-trunc(sysdate) < 0","")}
 ${if(ll_validrange>0," and a.validdate-trunc(sysdate) >= 0","")}
 ${if(ll_validrange==1," and a.validdate-trunc(sysdate) <= 90","")}
 ${if(ll_validrange==2," and a.validdate-trunc(sysdate) <= 180","")}
 ${if(ll_validrange==3," and a.validdate-trunc(sysdate) <= 270","")}
 ${if(ll_validrange==4," and a.validdate-trunc(sysdate) <= 365","")}
 ${if(ll_validrange==5," and a.validdate-trunc(sysdate) > 365","")}
 ${if(len(ll_provid)==0,"","and a.provid ="+ll_provid)}
 ${if(len(ll_oriprovid)==0,"","and a.oriprovid in ("+ll_oriprovid+")")}
 ${if(len(ll_outoriprov)==0,""," and a.oriprovid not in ("+ll_outoriprov+")")}
 ${if(len(ls_uncarticlasscode)==0,""," and exists(select 1 from tbc_uncarticlassrela_view uv where a.artiid = uv.artiid and uv.uncarticlasscode = '"+ ls_uncarticlasscode +"')")}
 ${if(len(ll_retailprice)==0,""," and a.retailprice >="+ ll_retailprice)}
 ${if(len(ll_retailprice)==0,""," and a.retailprice < trunc("+ ll_retailprice +",1)+0.1")}
 group by b.party_name,a.areaname,a.deptid,a.deptno,a.deptname,a.shortname,
          a.artiid,a.articode,a.artiabbr,a.artiname,a.artispec,a.artiunit,
          a.manufactory,a.storagename,a.stkareaname,a.provname,oriprovname,
          a.sell_coefficient,a.retailprice,a.batchcode,a.procdate,a.validdate
 order by a.areaname,a.deptno,a.articode,a.validdate,a.batchcode,a.storagename

select b.uncarticlasscode, b.uncarticlasscode ||'-'|| b.uncarticlassname as uncarticlassname
  from com_store_v a,sys_uncarticlass b
 where instr(nvl(b.private_org,'GLOBAL'),case b.is_private when 'OU' then to_char(a.ouid) when 'GLOBAL' then 'GLOBAL' else 'NULL' end) > 0
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}

select a.storageid,b.shortname ||' '|| a.storagename as storagename
  from tbd_stkstorage a,com_store_v b
 where a.deptid = b.deptid 
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where b.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_areaid)==0,""," and b.areaid = "+ ll_areaid)}
 ${if(len(ll_deptid)==0,""," and b.deptid = "+ll_deptid)}
 order by b.areaid,b.deptid,a.storageid

select a.com_party_id as provid,
       a.party_opcode || '-' || a.party_name as provname
  from com_party a,com_vender b
 where a.com_party_id = b.com_party_id
 order by a.party_opcode

select distinct a.modelcode,a.manufactory
  from store_inv_v a
 where a.artiid > 0
 ${if(len(ll_iszero)==0,""," and a.stkqty > 0")}
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_articode)==0,""," and a.articode like '"+ ll_articode +"%'")}
 ${if(len(ll_artiname)==0,""," and (instr(a.artiabbr,'"+ ll_artiname +"') > 0 or instr(a.artiname,'"+ ll_artiname +"') > 0)")}

select a.com_party_id as ouid,a.party_name as ouname
  from com_party a
 where exists(select 1 from com_store_v b where a.com_party_id = b.ouid)
 order by a.com_party_id

select distinct a.parentorgid,a.parentorgname
  from com_store_v a
 ${if(len(ll_orgid)==0,"",
" where (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
  ${if(len(ll_ou)==0,"","and a.ouid ="+ ll_ou)}
  order by a.parentorgid

select distinct a.areaid,a.areaname
  from com_store_v a
 ${if(len(ll_orgid)==0,"",
" where (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
  ${if(len(ll_ou)==0,"","and a.ouid ="+ ll_ou)}
  order by a.areaid

select c.stkareaid,b.shortname ||' '|| c.stkareaname as areaname
  from tbd_stkstorage a,com_store_v b,tbd_stkarea c
 where a.deptid = b.deptid
   and a.storageid = c.storageid
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where b.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_areaid)==0,""," and b.areaid = "+ ll_areaid)}
 ${if(len(ll_deptid)==0,""," and b.deptid in ("+ll_deptid +")")}
 order by b.areaid,b.deptid,c.storageid,c.stkareaid

