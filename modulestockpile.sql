select * from view_st_module_stockpile t where 1=1
      ${if(len(storagename)=0,"","and t.storagename like'%"+storagename+"%'")}
   ${if(len(materielcode)=0,"","and t.materielcode like'%"+materielcode+"%'")}
   ${if(len(materielname)=0,"","and t.materielname like'%"+materielname+"%'")}
   ${if(len(spec)=0,"","and p.spec like'%"+spec+"%'")}

select t.id,t.qty,t.watt,t.materiel_code as share_code from st_module_stock t where t.qty!=0 and t.id ='${A4}'

