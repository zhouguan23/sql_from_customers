select a.deptid,a.deptno,a.deptname,a.shortname,a.articlasscode,a.five_code,
       a.articode,a.stat_code,a.artiabbr,a.artiname,a.artispec,a.artiunit,
       a.manufactory,a.zs,a.storagename,a.provname,oriprovname,a.stkcellno,
       a.stkcelltypename,a.impdate,a.retailprice,d.catagory as articlassname,
       a.taxprice,a.untaxprice,a.costamt,a.batchcode,a.procdate,a.validdate,
       (select c.empname from sys_planer_duty b,org_employee c
         where a.artiid = b.com_goods_id and b.ou_id = 170000
           and b.emp_party_id = c.empid) as planer,
       a.stklocid,a.stkqty,a.tolqty,a.stkstatus
  from store_inv_v a,com_goods_catagory d
 where a.parent_catagory_id = d.com_goods_catagory_id
 ${if(len(ll_iszero)==0,""," and a.stkqty > 0")}
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_ou)==0,""," and a.ou_id = "+ ll_ou)}
 ${if(len(ll_parentorg)==0,""," and a.parentorgid = "+ ll_parentorg)}
 ${if(len(ll_areaid)==0,""," and a.areaid = "+ ll_areaid)}
 ${if(len(ll_storetype)==0,""," and a.store_type = '"+ ll_storetype +"'")}
 ${if(len(ll_storageid)==0,""," and a.storageid = "+ ll_storageid)}
 ${if(len(ll_articode)==0,""," and a.articode = '"+ ll_articode +"'")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}
 ${if(len(ll_artiname)==0,""," and (instr(a.artiabbr,'"+ ll_artiname +"') > 0 or instr(a.artiname,'"+ ll_artiname +"') > 0)")}
 ${if(len(ll_artispell)==0,""," and a.artispell like upper('"+ ll_artispell +"%')")}
 ${if(len(ll_manufactory)==0,""," and a.modelcode like '"+ ll_manufactory +"%'")}
 ${IF(LEN(ls_BATCHCODE)==0,""," and a.BATCHCODE = '"+ ls_BATCHCODE +"'")}
 ${if(len(ll_validdate)==0,""," and a.validdate < to_date('"+ ll_validdate +"','yyyy-mm-dd')+1")}
 ${if(len(ll_stkcellid)==0,"","and a.stkcellid in ("+ll_stkcellid+")")}
 ${if(len(ll_STKCELLTYPEID)==0,"","and a.STKCELLTYPEID in("+ll_STKCELLTYPEID+")")}
 ${if(len(ll_provid)==0,"","and a.provid ="+ll_provid)}
 ${if(len(ll_oriprovid)==0,"","and a.oriprovid ="+ll_oriprovid)}
 ${if(len(ls_uncarticlasscode)==0,""," and exists(select 1 from tbc_uncarticlassrela_view uv where a.artiid = uv.artiid and uv.uncarticlasscode = '"+ ls_uncarticlasscode +"')")}
 ${if(len(ll_zs)==0,""," and instr(a.zs,'"+ ll_zs +"') > 0")}
 ${if(len(ll_planer)==0,""," and exists(select 1 from sys_planer_duty b,org_employee c
              where a.artiid = b.com_goods_id and b.ou_id = 170000
                and b.emp_party_id = c.empid
                and instr(c.empname,'"+ ll_planer +"') > 0)")}
 ${if(len(ll_retailprice)==0,""," and a.retailprice >="+ ll_retailprice)}
 ${if(len(ll_retailprice)==0,""," and a.retailprice < trunc("+ ll_retailprice +",1)+0.1")}
 order by a.areaid,a.deptid,d.catagory_no,a.articode,a.validdate,a.batchcode,a.storageid,a.stkcellno

select a.stkcelltypeid,a.stkcelltypename
  from tbd_stkcelltype a
 where a.stkcelltypeid > 0
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from tbd_stkcell b,com_retail_store st1 where a.stkcelltypeid = b.stkcelltypeid and b.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}

	select stkcellid,stkcellno from     tbd_stkcell  where 1=1
	${if(len(ll_deptid)==0,"","and deptid in ("+ll_deptid+")")}
	${if(len(ll_STKCELLTYPEID)==0,"","and STKCELLTYPEID in("+ll_STKCELLTYPEID+")")}
	${if(len(ll_storageid)==0,"","and storageid in ("+ll_storageid+")")}

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
 ${if(len(ll_ou)==0,""," and b.ouid = "+ ll_ou)}
 ${if(len(ll_parentorg)==0,""," and b.parentorgid = "+ ll_parentorg)}
 ${if(len(ll_areaid)==0,""," and b.areaid = "+ ll_areaid)}
 ${if(len(ll_deptid)==0,""," and b.deptid = "+ll_deptid)}
 order by b.areaid,b.deptno,a.storageid

select distinct  provid,provname from        tbl_provinfo

select distinct a.modelcode,a.manufactory
  from store_inv_v a
 where a.artiid > 0
 ${if(len(ll_iszero)==0,""," and a.stkqty > 0")}
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_articode)==0,""," and a.articode like '"+ ll_articode +"%'")}
 ${if(len(ll_artiname)==0,""," and (instr(a.artiabbr,'"+ ll_artiname +"') > 0 or instr(a.artiname,'"+ ll_artiname +"') > 0)")}

select a.deptid,a.deptname
  from tbl_dept a
 where a.deptid = a.ou_Id 
   and a.deptid<>190000
   and exists(select 1 from com_store_v b where a.deptid = b.ouid)

select distinct a.parentorgid,a.parentorgname
  from com_store_v a
 ${if(len(ll_orgid)==0,"",
" where (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
  ${if(len(ll_ou)==0,"","and a.ouid ="+ ll_ou)}
  order by a.parentorgid

select com_retail_area_id as areaid,retail_area_name as areaname
  from com_retail_area
 order by area_opcode

