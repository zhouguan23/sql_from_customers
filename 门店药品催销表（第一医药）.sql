select b.deptno,b.deptname,b.shortname,b.deptname ||'——药品催销表' as titlename,
       b.artiid,b.articode,b.artiabbr,b.artispec,b.artiunit,b.retailprice,
       b.manufactory,a.batchcode,a.validdate,a.validdate-trunc(sysdate) as vdays,
       sum(a.stkqty) as stkqty,sum(a.taxprice*a.stkqty) as taxcostamt,
       b.product_location,d.stkcellno
 from  tbd_stkloc a,store_goods_v b,tbd_stkstorage c,tbd_stkcell d
 where a.storageid = c.storageid
   and b.deptid = c.deptid
   and a.artiid = b.artiid
   and a.stkcellid = d.stkcellid
   and a.stkqty > 0
   and a.validdate <= trunc(sysdate)+${ll_day}
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where c.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,"","and b.deptid ="+ ll_deptid)}
 ${if(len(ll_storageid)==0,"","and c.storageid ="+ ll_storageid)}
 ${if(len(ll_areaid)==0,"","and d.stkareaid ="+ ll_areaid)}
 ${if(len(ll_catagory)==0,"","and b.parent_catagory_id ="+ ll_catagory)}
 ${if(len(ll_articode)==0,"","and b.articode = '"+ ll_articode +"'")}
 ${if(len(ll_artiname)==0,"","and instr(b.artiabbr,'"+ll_artiname+"') > 0 or 
instr(b.artiname,'"+ll_artiname+"') > 0 ")}
 ${if(len(ll_celltypeid)==0,"","and d.stkcelltypeid in ("+ ll_celltypeid +")")}
 
 ${if(len(ll_kind_id)==0,"","and b.com_goods_manage_kind_id = "+ ll_kind_id)}
   ${if(len(ls_articlasscode)==0,"","and exists(select 1 from com_goods_set_v v where a.artiid = v.artiid and v.UncArtiClassCode = '"+ls_articlasscode+"')")}
 group by b.deptno,b.deptname,b.shortname,b.artiid,b.articode,b.artiabbr,
          b.artispec,b.artiunit,b.retailprice,b.manufactory,
          a.batchcode,a.validdate,product_location,d.stkcellno
 order by a.validdate,b.articode,a.batchcode,d.stkcellno

select storageid,storagename
  from tbd_stkstorage a
  ${if(len(ll_orgid)==0,"",
" where (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}
 order by deptid,storageno

select b.stkareaid,b.stkareaname
  from tbd_stkstorage a,tbd_stkarea b
 where a.storageid = b.storageid
   ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}
 ${if(len(ll_storageid)==0,""," and a.storageid = "+ ll_storageid)}
 order by a.storageno,b.stkareano

select com_goods_catagory_id,catagory
  from com_goods_catagory 
 where is_root_catagory='TRUE'
 order by catagory_no

select a.stkcellid,a.stkcellno,b.stkcelltypeid,b.stkcelltypename
  from tbd_stkcell a,tbd_stkcelltype b
 where a.stkcelltypeid = b.stkcelltypeid
   ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}
 ${if(len(ll_storageid)==0,"","and a.storageid ="+ ll_storageid)}
 ${if(len(ll_areaid)==0,"","and a.stkareaid ="+ ll_areaid)}
 order by a.deptid,a.stkareaid,b.stkcelltypeid,a.stkcellno

select b.uncarticlasscode, b.uncarticlasscode ||'-'|| b.uncarticlassname as uncarticlassname
  from com_store_v a,sys_uncarticlass b
 where instr(nvl(b.private_org,'GLOBAL'),case b.is_private when 'OU' then to_char(a.ouid) when 'GLOBAL' then 'GLOBAL' else 'NULL' end) > 0
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}

