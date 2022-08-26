select wx_prod.F_GETISGPO(tbd_distribute.distdcid,
                          TBB_ARTICLE.ARTIID,
                          tbd_distribute.DEPTID) ISGPO,
       tbd_distribute.reqshtno,
       y.party_name as deptname,
       y.party_opcode as DeptNo,
       tbd_distribute.client_address as DeptAddr,
       tbb_article.artiid,
       tbb_article.articode,
       Tbb_Article.ArtiName,
       Tbb_Article.ArtiSpec,
       Tbb_Article.manufactory,
       tbb_articleadd.authorize,
       Tbb_Article.ArtiUnit,
       Tbb_Article.ArtiBrand,
       tbd_distribute.batchcode,
       -tbd_distribute.artiqty,
       tbd_distribute.taxsaleprice,
       -sum(tbd_distribute.taxamt + tbd_distribute.saleamt) taxsaleamt,
       -sum(tbd_distribute.taxamt) taxamt,
       -sum(tbd_distribute.saleamt) saleamt,
       trim(tbb_articleadd.condition) as condition,
       tbd_distribute.retailprice,
       tbd_distribute.procdate,
       tbd_distribute.validdate,
       tbd_distribute.stklocid,
       (select distinct max(Tbc_UncArtiClass.UncArtiClassName)
          from Tbc_UncArtiClassRela, Tbc_UncArtiClass
         where Tbb_Article.ArtiId = Tbc_UncArtiClassRela.ArtiId
           and Tbc_UncArtiClass.UncArtiClassCode =
               Tbc_UncArtiClassRela.UncArtiClassCode
           and Tbc_UncArtiClassRela.UncArtiClassCode like '31%') as yptype,
       tbl_employee.empname,
       (select count(distinct artiid)
          from tbd_distribute a
         where a.reqshtno = tbd_distribute.reqshtno
           and BussStatus >= 10) pzs,
       (select count(artiid)
          from tbd_distribute a
         where a.reqshtno = tbd_distribute.reqshtno
           and BussStatus >= 10) danshu,
       tbd_distribute.staxrate,
       -sum(tbd_distribute.bulksaleprice * tbd_distribute.artiqty *
            (1 + tbd_distribute.staxrate * 0.01)) taxbulksaleamt,
       -sum(round(tbd_distribute.retailprice * tbd_distribute.artiqty, 2)) retailamt,
       t.goods_code_yb,
       trunc(tbd_distribute.outdate) as outdate,
       case
         when ii.opcode in ('03', '04', '05') then
          i.product_location
         else
          ''
       end as product_location,
       case
         when ii.opcode in ('01', '02') then
          i.sale_holder
         else
          ''
       end as sale_holder,
       ii.opcode,
       nvl(i.ordinary_orspecial, '') as ordinary_orspecial,
       nvl((select count(*)
             from wx_prod.com_goods_storagemode r
            where i.com_goods_storagemode_id = r.com_goods_storagemode_id
              and r.order_split_req = 1),
           0) as is_cold,
       tbd_distribute.memo,
       tbd_distribute.depttypeid
  from (select wx_prod.F_GET_LE_BY_OWNER(a.inv_owner) leid,
               wx_prod.f_Get_Lename_By_Owner(a.inv_owner) lename,
               a.com_client_id as deptid, --客户ID
               c.ssc_order_lines_lots_id as distid, --流水号
               c.com_goods_batch_id as stklocid, --批次ID
               a.inv_owner as distdcid, --库存拥有者
               0 as stkcellid, --货位
               a.order_no as reqshtno, --销售单号
               c.vender_id as provid,
               d.com_goods_id as artiid,
               ba.tax_price taxprice, --含税成本价
               ba.tax_free_price untaxprice, --无税成本价
               d.wholesale_price as taxbulksaleprice, --含税批发价
               d.retail_price as retailprice, --零售价
               round(d.TAX_RATE, 2) * 100 as staxrate,
               -c.qty as artiqty,
               -c.qty as valuqty,
               c.lot_tax_free_price as saleprice, -- 无税销售价
               c.lot_tax_price as taxsaleprice, -- 含税销售价
               -c.lot_tax_free_amount as saleamt, --无税销售金额
               - (c.lot_tax_amount - c.lot_tax_free_amount) as taxamt, --税额
               -ssc_cost_book_lines.loan_amount as costamt, --无税成本金额
               c.prod_date as procdate,
               c.lot_no as batchcode,
               c.expire_date as validdate,
               a.inv_user as buydeptid,
               c.creation_date as shiftdate,
               c.creation_date as outdate,
               case
                 when c.qty < 0 then
                  50
                 else
                  40
               end as busseventid,
               10 as bussstatus,
               (select t3.ssc_sale_invoice_id
                  from wx_prod.ssc_sale_invoice_detail t3
                 where t3.ssc_order_lines_lots_id = c.ssc_order_lines_lots_id
                   and invoice_op_flag != 'CANCEL') as invid,
               (select t3.ssc_sale_invoice_lines_id
                  from wx_prod.ssc_sale_invoice_detail t3
                 where t3.ssc_order_lines_lots_id = c.ssc_order_lines_lots_id
                   and invoice_op_flag != 'CANCEL') as ssc_sale_invoice_lines_id,
               a.created_by as outid,
               case
                 when d.tax_rate = 0 then
                  0
                 else
                  round(d.wholesale_price / (1 + d.tax_rate), 2)
               end as bulksaleprice,
               a.address as client_address,
               com_party.party_opcode,
               com_party.party_name,
               ba.com_goods_batch_id,
               a.memo,
               nvl((select t.depttypeid from wx_prod.Tbl_Dept t where t.deptid = a.com_client_id),0) as depttypeid
          from wx_prod.ssc_order a
         inner join wx_prod.com_party
            on a.com_client_id = com_party.com_party_id
         inner join wx_prod.ssc_order_lines b
            on a.ssc_order_id = b.ssc_order_id
         inner join wx_prod.ssc_order_lines_lots c
            on a.ssc_order_id = c.ssc_order_id
           and b.ssc_order_lines_id = c.ssc_order_lines_id
          left join wx_prod.ssc_cost_book_lines
            on ssc_cost_book_lines.source_detail_id = c.ssc_order_lines_id
           and ssc_cost_book_lines.com_goods_batch_id = c.com_goods_batch_id
           and ssc_cost_book_lines.source_type in ('SALE_NORMAL')
         inner join wx_prod.com_goods_batch ba
            on ba.com_goods_batch_id = c.com_goods_batch_id
           and ba.com_goods_id = c.com_goods_id
         inner join wx_prod.com_goods d
            on b.com_goods_id = d.com_goods_id
         where a.order_lg_flag = 'CHECKED'
         ${if(len(pickingId) == 0,""," and exists(select 1 from wx_prod.ssc_picking_lines pl " + 
               " where pl.source_dtl_id=c.ssc_order_lines_id " + 
               " and pl.com_lot_id = c.com_lot_id " +
               " and pl.com_goods_batch_id=c.com_goods_batch_id " +
               " and pl.ssc_picking_id in(" + pickingId + "))"
         ) }
        ) tbd_distribute,
       wx_prod.com_party y,
       Tbb_Article,
       tbl_employee,
       tbb_articleadd,
       wx_prod.com_goods_yb t,
       wx_prod.com_goods i,
       (select tt1.com_goods_id, min(left(tt2.opcode, 2)) as opcode
          from wx_prod.com_goods tt1, wx_prod.com_goods_catagory tt2
         where tt1.goods_catagory_id = tt2.com_goods_catagory_id
         group by tt1.com_goods_id) ii
 where tbd_distribute.deptid = y.com_party_id
   and tbd_distribute.artiid = Tbb_Article.Artiid
   and tbd_distribute.artiid = tbb_articleadd.artiid
   and tbd_distribute.outid = tbl_employee.empid(+)
   and tbd_distribute.artiid = t.com_goods_id(+)
   and tbd_distribute.artiid = i.com_goods_id(+)
   and tbd_distribute.artiid = ii.com_goods_id(+)
   and Tbd_Distribute.BussStatus >= 10
   and tbd_distribute.artiqty <> 0
 group by tbd_distribute.distdcid,
          tbd_distribute.reqshtno,
          y.party_name,
          y.party_opcode,
          tbd_distribute.client_address,
          tbb_article.artiid,
          tbb_article.articode,
          Tbb_Article.ArtiName,
          Tbb_Article.ArtiSpec,
          Tbb_Article.ArtiUnit,
          Tbb_Article.ArtiBrand,
          Tbb_Article.manufactory,
          tbb_articleadd.authorize,
          tbd_distribute.batchcode,
          tbd_distribute.artiqty,
          tbd_distribute.taxsaleprice,
          tbd_distribute.retailprice,
          tbd_distribute.procdate,
          tbd_distribute.validdate,
          tbl_employee.empname,
          tbd_distribute.staxrate,
          tbd_distribute.bulksaleprice,
          tbd_distribute.staxrate,
          tbd_distribute.retailprice,
          tbb_articleadd.condition,
          tbd_distribute.stklocid,
          tbd_distribute.artiqty,
          tbd_distribute.DEPTID,
          t.goods_code_yb,
          trunc(tbd_distribute.outdate),
          case
            when ii.opcode in ('03', '04', '05') then
             i.product_location
            else
             ''
          end,
          case
            when ii.opcode in ('01', '02') then
             i.sale_holder
            else
             ''
          end,
          ii.opcode,
          nvl(i.ordinary_orspecial, ''),
          i.com_goods_storagemode_id,
          tbd_distribute.memo,
          tbd_distribute.depttypeid,
          tbd_distribute.distid
 order by 2, 1, 7


select party_name from wx_prod.com_party where com_party_id = ${web_distdcid}

