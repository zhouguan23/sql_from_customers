 select a.NodeCode,a.nodename,a.BuildDate,isnull(b.ChargeMoney,0)ChargeMoney,isnull(b.BackMoney,0)BackMone,isnull(b. PostingMoney,0)PostingMoney,isnull( b. Charges,0)Charges,isnull(b. Remark,'')Remark from 
    (select a.NodeCode,a.nodename,b.BuildDate from 
 TB部门信息表 a
,
(select convert(varchar(10),dateadd(dd,number,convert(varchar(8),DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01') ,112)),112)BuildDate
from master..spt_values 
where type='p' and number <= datediff(dd,DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01')  ,DATEADD(DD,-DAY(DATEADD(M,1,'${qsrq}'+'01')),DATEADD(M,1,'${jsrq}'+'01'))  )
)b

where a.OpenDate<=convert(varchar(8),getdate() ,112) and a.State!='-1' and a.NodeCode not in (6666,7777,8888,3001,5001,6688,6601,6602,9999)
and  1=1 ${if(len(bm) == 0,   "","and Nodecode in ('" + replace(bm,",","','")+"')") }
)a
 left join 
TB提货卡销售台账 b on  a.NodeCode =b.NodeCode and a.BuildDate=b.ACCdate

order by 1,3


select * from 
TB提货卡销售台账
where accdate=convert(varchar(8),DATEADD(dd,-1,DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01')) ,112) and  1=1 ${if(len(bm) == 0,   "","and Nodecode in ('" + replace(bm,",","','")+"')") }

select * from 
TB资金盘点表
where 1=1 ${if(len(bm) == 0,   "","and Nodecode in ('" + replace(bm,",","','")+"')") }
and YM between '${qsrq}' and '${jsrq}'


    select
        a.NodeCode, a.nodename, A.YM,isnull(B.ERPMoney, 0)ERPMoney,isnull(B.commerce,0)commerce ,
        isnull(B.meituanMoney,        0)meituanMoney,        isnull(B.JDMoney,        0)JDMoney,        isnull(B.Community,        0)Community,        isnull(B.ActivityMoney,        0)ActivityMoney,
        isnull(B.ShoppingMoney,        0)ShoppingMoney,        isnull(B.systemMoney,        0)systemMoney,        isnull(B.systemShoppingMoney,        0)systemShoppingMoney,
        isnull(B.systemmeituanmoney,        0)systemmeituanmoney,        isnull(B.cash,        0)cash,        isnull(B.GroupMoney,        0)GroupMoney,        isnull(B.BHERPMoney,        0)BHERPMoney,        isnull(B.Depositmoney,
        0)Depositmoney ,b.Remark
    from
        (select
            a.NodeCode,
            a.nodename,
            b.YM 
        from
            TB部门信息表 a ,
            (select
                convert(varchar(10),
                dateadd(dd,
                number,
                convert(varchar(8),
                DATEADD(DD,
                -DAY('${qsrq}'+'01')+1,
                '${qsrq}'+'01') ,
                112)),
                112)ym 
            from
                master..spt_values  
            where
                type='p' 
                and number <= datediff(dd,DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01')  ,DATEADD(DD,-DAY(DATEADD(M,1,'${qsrq}'+'01')),DATEADD(M,1,'${jsrq}'+'01'))  ) )b  
        where
            a.OpenDate<=convert(varchar(8),getdate() ,112) 
            and a.State!='-1' 
            and a.NodeCode not in (6666,7777,8888,3001,5001,6688,6601,6602,9999) 
            and  1=1 ${if(len(bm) == 0,   "","and Nodecode in ('" + replace(bm,",","','")+"')") } )a  
        left join
            TB营业款存行台账 b 
                on  a.NodeCode =b.NodeCode 
                and a.ym=b.ym  
        order by
            1,
            3



select NodeCode,YM,abstract,isnull(income,0)income,isnull(deposit,0)deposit,isnull(charges,0)charges,remark from 
TB其它收入台账
where 1=1 ${if(len(bm) == 0,   "","and Nodecode in ('" + replace(bm,",","','")+"')") }
and LEFT(ym,6) between '${qsrq}' and '${jsrq}'

select a.NodeCode, A.YM,b.Merchantnumber,b.LHaccount ,isnull(b.SystemMoney,0)SystemMoney ,isnull(b.BHSystemMoney,0)BHSystemMoney,isnull(b.commission,0)commission
  from (select a.NodeCode,b.YM from
    TB部门信息表 a ,
    (select   convert(varchar(10),
      dateadd(dd,
      number,
      convert(varchar(8),
      DATEADD(DD,
      -DAY('${qsrq}'+'01')+1,
      '${qsrq}'+'01') ,
      112)),
      112)YM 
    from
      master..spt_values  
    where
      type='p' 
      and number <= datediff(dd,DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01')  ,DATEADD(DD,-DAY(DATEADD(M,1,'${qsrq}'+'01')),DATEADD(M,1,'${jsrq}'+'01'))  ) )b  
    where
    a.OpenDate<=convert(varchar(8),getdate() ,112) 
    and a.State!='-1' 
    and a.NodeCode not in (6666,7777,8888,3001,5001,6688,6601,6602,9999) 
    and  1=1 ${if(len(bm) == 0, "","and Nodecode in ('" + replace(bm,",","','")+"')") } )a  
    left join
    TBPOS票刷卡手续费 b 
      on  a.NodeCode =b.NodeCode 
      and a.YM=b.YM  
    order by    1,3

 select a.NodeCode,a.YM,b.CompanyName,b.HomeAddress,b.Linkman,b.LinkTel,b.Paymenttime,isnull(b.bookcredit,0)bookcredit,isnull(b.retrievemoney,0)retrievemoney,isnull(b.terminalmoney,0)terminalmoney from 
    (select a.NodeCode,b.YM from 
 TB部门信息表 a
,
(select convert(varchar(10),dateadd(dd,number,convert(varchar(8),DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01') ,112)),112)YM
from master..spt_values 
where type='p' and number <= datediff(dd,DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01')  ,DATEADD(DD,-DAY(DATEADD(M,1,'${qsrq}'+'01')),DATEADD(M,1,'${jsrq}'+'01'))  )
)b

where a.OpenDate<=convert(varchar(8),getdate() ,112) and a.State!='-1' and a.NodeCode not in (6666,7777,8888,3001,5001,6688,6601,6602,9999)
and  1=1 ${if(len(bm) == 0,   "","and Nodecode in ('" + replace(bm,",","','")+"')") }
)a
 left join 
TB赊销台帐表 b on  a.NodeCode =b.NodeCode and a.YM=b.YM

order by 1,3

select * from 
TB赊销台帐表
where YM=convert(varchar(8),DATEADD(dd,-1,DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01')) ,112) and  1=1 ${if(len(bm) == 0,   "","and Nodecode in ('" + replace(bm,",","','")+"')") }




 select a.NodeCode,a.YM,b.CompanyName,b.HomeAddress,b.Linkman,b.LinkTel,b.Paymenttime,isnull(b.bookcredit,0)bookcredit,isnull(b.retrievemoney,0)retrievemoney,isnull(b.terminalmoney,0)terminalmoney from 
    (select a.NodeCode,b.YM from 
 TB部门信息表 a
,
(select convert(varchar(10),dateadd(dd,number,convert(varchar(8),DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01') ,112)),112)YM
from master..spt_values 
where type='p' and number <= datediff(dd,DATEADD(DD,-DAY('${qsrq}'+'01')+1,'${qsrq}'+'01')  ,DATEADD(DD,-DAY(DATEADD(M,1,'${qsrq}'+'01')),DATEADD(M,1,'${jsrq}'+'01'))  )
)b

where a.OpenDate<=convert(varchar(8),getdate() ,112) and a.State!='-1' and a.NodeCode not in (6666,7777,8888,3001,5001,6688,6601,6602,9999)
and  1=1 ${if(len(bm) == 0,   "","and Nodecode in ('" + replace(bm,",","','")+"')") }
)a
 left join 
TB赊销台帐明细表 b on  a.NodeCode =b.NodeCode and a.YM=b.YM

order by 1,3

