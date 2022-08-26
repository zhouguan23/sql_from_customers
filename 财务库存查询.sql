SELECT 
         Tbb_Article_Information.ArtiCode,   
         Tbb_Article_Information.ArtiName,   
         Tbb_Article_Information.ArtiSpec,  
         Tbb_Article_Information.ArtiUnit,       
         sum(d.artiqty) as StkQty,
         tbd_stkloc.stkqty  当前库存,
      round(to_date('${ldt_date}','yyyy-mm-dd')-tbd_stkloc.impdate+1,0) 在库天数,
         null batchcode,
         Tbb_Article_Information.ArtiId,
         Tbb_Article_Information.Manufactory,
         Tbb_Article_Information.BulkSalePrice,
  sum(d.CostAmt) as CostAmt,
  deptname, 
 tbd_stkloc. stklocid,
 tbd_stkloc.impdate,
  tbd_stkloc.retailprice,
  VALIDDATE Chgvalidday,
  tbb_article_dl.stat_name,
  party_opcode,
  party_name
  FROM Tbb_Article_Information,
       tbb_article_dl,
       tbl_dept,
       tbd_stkstorage,
       tbd_stkloc,
       v_com_goods_batch,
   (SELECT artiid,sum(artiqty)artiqty,suM(costamt)costamt,deptid,stklocid FROM TBD_STKCHG 
WHERE nextdate<to_date('${ldt_date}','yyyy-mm-dd')+1
group by artiid,deptid,stklocid
having sum(costamt)<>0) d
 where Tbb_Article_Information.ArtiId = d.ArtiId
  and  Tbb_Article_Information.artiid=tbb_article_dl.artiid
  and  tbl_dept.deptid=tbd_stkstorage.deptid
  and tbd_stkstorage.storageid = tbd_stkloc.storageid
 and  Tbb_Article_Information.ArtiId = tbd_stkloc.ArtiId
 and  d.stklocid=tbd_stkloc.stklocid
 and  Tbb_Article_Information.ArtiId = d.ArtiId
 and tbd_stkloc.com_goods_batch_id  = v_com_goods_batch.COM_GOODS_BATCH_ID (+)
 ${if(len(ll_COMPANYID)==0,"","and COMPANYID  in ("+ll_COMPANYID+")")}
${if(len(ll_deptid)==0,"","and tbl_dept.deptid in ("+ll_deptid+")")}
group by Tbb_Article_Information.ArtiCode,   
         Tbb_Article_Information.ArtiName,   
         Tbb_Article_Information.ArtiSpec,  
         Tbb_Article_Information.ArtiUnit, 
         Tbb_Article_Information.ArtiId,
         Tbb_Article_Information.Manufactory,
         Tbb_Article_Information.BulkSalePrice,      
  VALIDDATE,
  stat_name,
  tbd_stkloc.stklocid,
  tbd_stkloc.stkqty,
  tbd_stkloc.impdate,
   tbd_stkloc.retailprice,
   deptname,
  party_opcode,
  party_name
order by Tbb_Article_Information.ArtiCode

 SELECT 
         Tbb_Article.ArtiCode,   
         Tbb_Article.ArtiName,   
         Tbb_Article.ArtiSpec,  
         Tbb_Article.ArtiUnit,
         Tbb_Article.Validity,
         sum(d.StkQty) as StkQty,
         d.untaxprice as untaxprice,
         d.batchcode,
         Tbb_Article.ArtiId,
         Tbb_Article.Manufactory,
         Tbb_Article.BulkSalePrice,
  Tbb_Article.RetailPrice,
  sum(d.CostAmt) as CostAmt,
  Tbb_Article.ITaxRate,
  Tbb_Article.STaxRate
          FROM  
         Tbb_Article,
   (
        select a.ArtiId,a.StkQty,a.CostAmt,a.batchcode,a.untaxprice from Tbd_StkLoc a
        where a.DeptId=${ll_deptid}
     union all
           select c.ArtiId,-c.ArtiQty, -c.CostAmt,'',0 from Tbd_StkChg c
          where c.DeptId=${ll_deptid}
          and c.ChgDate >to_date('${ldt_date}','YYYY-MM-DD')+1
     union all
          select a.ArtiId,-a.ArtiQty,-a.CostAmt,'',0
          from Tbd_Distribute a
          where a.BussStatus>=10
          and a.OutDate < to_date('${ldt_date}','yyyy-mm-dd')+1
          and a.OutDate>=to_date('2012-09-30','yyyy-mm-dd')
          union all
          select a.ArtiId,-a.ArtiQty,-a.CostAmt,'',0
          from Tbd_Distribute a
          where a.BussStatus>=10
          and a.TranStatus>0
          and a.OutDate<to_date('2012-09-30','yyyy-mm-dd')
       union all
          select a.ArtiId,a.ArtiQty,a.CostAmt,'',0
          from Tbd_Distribute a,Tbf_Bulkinvoice d1
          where a.InvId = d1.InvId
          and d1.BussStatus =4
          and a.BussStatus>=10
          and d1.CompDate < to_date('${ldt_date}','yyyy-mm-dd')+1
  ) d
 where Tbb_Article.ArtiId = d.ArtiId
group by Tbb_Article.ArtiCode,   
         Tbb_Article.ArtiName,   
         Tbb_Article.ArtiSpec,  
         Tbb_Article.ArtiUnit, 
         Tbb_Article.ArtiId,
         Tbb_Article.Manufactory,
         Tbb_Article.BulkSalePrice,
         d.batchcode,
         Tbb_Article.Validity,
  Tbb_Article.RetailPrice,
  Tbb_Article.ITaxRate,
  d.untaxprice,
  Tbb_Article.STaxRate
having sum(d.StkQty)<>0
order by Tbb_Article.ArtiCode

select deptid,deptname from      tbl_dept where  (deptid<>ou_Id or deptid=120000 )
and tbl_dept.DEPTTYPEID=60 and deptname not like '%仓库%'
${if(len(ll_COMPANYID)==0,"","and COMPANYID  in ("+ll_COMPANYID+")")}

select a.com_party_id,a.party_name
  from com_party a,tbl_dept b
 where a.com_party_id = b.COMPANYID

