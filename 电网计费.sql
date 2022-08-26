select regexp_substr(function1(MILEAGE), '[^,]A+', 1, 1) as MILEAGE1,
       regexp_substr(function1(MILEAGE), '[^,]A+', 1, 2) as MILEAGE2,
       regexp_substr(function1(MILEAGE), '[^,]A+', 1, 3) as MILEAGE3,
       regexp_substr(function1(MILEAGE), '[^,]A+', 1, 4) as MILEAGE4,
       regexp_substr(function1(MILEAGE), '[^,]A+', 1, 5) as MILEAGE5,
       No,
       case
         when MILEAGE <= 50 then
          b.univalence9
         else
          univalence4
       end as price1,
       b.univalence5,
       b.univalence6,
       b.univalence7,
       b.univalence8,
       a.billid,
       a.INSTITUTION1,
       a.CARRIERS,
       a.orderdate,
       c.CL_MONEY_AMOUNT,
       a.fahuodian,
       d.name,
       a.GOODSAMOUNT,
       a.VEHICLENUMBER,
       a.DRIVER,
       a.MILEAGE,
       a.VEHICLESNUM,
       a.DISTRIBUTIONTYPE,
       a.remark,
       e.name as name1,
       a.IMPORTNUMBER,
       f.CLEARANCEPOINT,
       f.MATERIALNAME,
       f.MONAD,
       f.MAGNITUDE,
       a.IMPORTNUMBER
  from SCM_transportationexpenseHead a
  left join SCM_Mobileprice4 b
    on a.SERVERTYPE = b.Vantype
   and a.DISTRIBUTIONTYPE = b.Distributiontype
  left join BL_CHARGE_LINE c
    on c.CL_BILLID = a.billid
  left join CP_TruckType d
    on a.SERVERTYPE = d.id
  left join CP_OWNER e
    on a.carriers = e.id
  left  join   SCM_transportationexpense4 f 
    on a.billid=f.billid
 where MILEAGE > 0
   and a.status = 20
   and items = 245818866


