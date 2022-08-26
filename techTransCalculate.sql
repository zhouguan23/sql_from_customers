SELECT *
  FROM FN_AM_TECH_TRANS_CALCULATE_DTL T
 WHERE T.MAIN_ID = '${mainId}'
   and t.sequence in
       (select to_number(column_value)
          from (table(split((select (case
                                     when count(1) > 0 then                          '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24'
                                     else
                                      '18,23,24'
                                   end) is_belong
                              from sa_oporgproperty t
                             where t.property_definition_id =
                                   (select a.id
                                      from sa_oporgpropertydefinition a
                                     where a.name = 'deptAdminKind')
                               and t.org_id = '${deptId}'
                               and t.property_value = '4')))))

