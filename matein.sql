select t.* from view_st_mate_in_srm t
 where 1=1
   ${if(len(billCode)=0,"","and t.bill_code like'%"+billCode+"%'")}
   ${if(len(starttime)=0,"","and t.fn_date>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and t.fn_date<=to_date('"+endtime+"','yyyy-mm-dd')")}
   ${if(len(organName)=0,"","and t.organ_name like'%"+organName+"%'")}
   ${if(len(venderName)=0,"","and t.vender_name like'%"+venderName+"%'")}
   ${if(len(buyCode)=0,"","and t.procure_order_code like'%"+buyCode+"%'")}
   ${if(len(operation)=0,"","and t.operation_type_name='"+operation+"'")}
   ${if(len(materielcode)=0,"","and t.materiel_code like'%" +materielcode+"%'")}
   ${if(len(materielname)=0,"","and t.materiel_name like'%" +materielname+"%'")}
   ${if(len(spec)=0,"","and t.spec like'%"+spec+"%'")}

select d.es_rcv_line_id,
       decode(d.rcv_trx_type,
              'RETURN_DIRECT',
              -d.trx_quantity,
              d.trx_quantity) trx_quantity,
       d.trx_amount
  from pur_rcv_trx_lines d
 where 1 = 1 and d.es_rcv_line_id = '${id}'
  

