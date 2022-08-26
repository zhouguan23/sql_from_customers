select * from FR_SUPPLY_CHAIN
where to_char("DATE",'yyyy-mm-dd')='${P_DATE}'
${if(len(P_COMPANY) == 0,"","and COMPANY = '" + P_COMPANY + "' ")}
${if(len(P_GOODS) == 0,"","and GOODS = '" + P_GOODS + "' ")}
${if(len(P_SUPPLIER) == 0,"","and SUPPLIER = '" + P_SUPPLIER + "' ")}

select distinct COMPANY from FR_SUPPLY_CHAIN

select distinct GOODS from FR_SUPPLY_CHAIN

select distinct SUPPLIER from FR_SUPPLY_CHAIN

