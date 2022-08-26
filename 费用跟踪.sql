
    select
        CategoryItemCode,
        CategoryCode,
        CategoryName,
        Controllable,
        case 
            when ParentCategoryCode=CategoryItemCode then '' 
            else ParentCategoryCode 
        end ParentCategoryCode,
        CategoryLevel  
    from
        TB费用科目表 
    where
        CategoryLevel>='0' 
        and CategoryItemCode ='0000' 
    order by
        1,
        6,
        5,
        cast(CategoryCode as int)

${if(js == "1","
select case when rank()  over(order by CategoryLevel)=1 then '' else  ParentCategoryCode end  F_ID,CategoryCode ID,CategoryCode, CategoryCode+' '+CategoryName  CategoryName,ParentCategoryCode,CategoryLevel,CategoryLengCode from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryLevel>=0
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)","
DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX)
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL 
select case when rank()  over(order by CategoryLevel)=1 then '''' else  ParentCategoryCode end  F_ID,CategoryCode ID,CategoryCode, CategoryCode+'' ''+CategoryName  CategoryName,ParentCategoryCode,CategoryLevel,CategoryLengCode from 
TB分类对照表 a
where a.CategoryItemCode=''0003''
and  CHARINDEX ('''+CategoryLengCode+''',a.CategoryLengCode)>0
 ' 
 FROM  [HLCWDW]A.[dbo]A.[tbCatToOperator]A a
  left join 
  [HLCWDW]A.[dbo]A.[TB分类对照表]A b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode
  WHERE a.CategoryItemCode='0003' and a.OperatorCode in (select distinct 部门编码 from tb职员用户表 where 职员编码='"+gh+"')


SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL='
select * from 
('+@sql1+')a
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)
'exec(@sql)")}


select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' 


select '${qsrq}'+'00'YM
union all 
SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201'
    AND CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112)>='201906'


select * from 
TB部门费用预算表 a
where  exists(select * from TB分类对照表 z where a.deptcode=z.CategoryCode and  z.CategoryItemCode='0003' and  1=1 ${if(len(bm)==0,"","and z.CategoryLengCode in ('"+replace(bm,",","','")+"')")}  )  and BudgetYM like '${qsrq}%'


    select
        a.ParentCategoryCode F_ID,
        a.CategoryCode ID,
        a.CategoryCode NodeCode,
        a.CategoryName NodeCode,
        a.ParentCategoryCode ParentNodecode,
        a.CategoryLevel NodeLevel ,
        b.*,
        c.YM   
    from
        (select
            ParentCategoryCode F_ID,
            CategoryCode ID,
            CategoryCode,
            CategoryName,
            ParentCategoryCode,
            CategoryLevel 
        from
            TB分类对照表 a 
        where
            a.CategoryItemCode='0003' 
            and  exists(
                select
                    * 
                from
                    TB分类对照表 z 
                where
                    a.CategoryCode=z.CategoryCode 
                    and  z.CategoryItemCode='0003'  
                    and  1=1 ${if(len(bm)==0,"","and z.CategoryLengCode in ('"+replace(bm,",","','")+"')")}    
            ) 
        )a,     (
            select
                a.CategoryItemCode,
				b.Controllable,  
				a.ParentCategoryCode ,
                a.CategoryCode,
                a.CategoryName,   
                a.CategoryLevel       
            from
                TB费用科目表  a 
				left join 
				TB费用科目表 b  on a.CategoryItemCode=b.CategoryItemCode and a.ParentCategoryCode=b.CategoryCode
            where
                a.CategoryLevel='1'          
                and a.CategoryItemCode ='0000' 
        )b,   (
            select
                '${qsrq}'+'00'YM 
            union
            all  SELECT
                CONVERT(varchar(6),
                DATEADD(month,
                number,
                '${qsrq}'+'0101'),
                112) AS YM 
            FROM
                master.dbo.spt_values 
            WHERE
                type = 'p'     
                AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201'     
                AND CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112)>='202001' 
        )c     
    order by
        1,
        2,
        6,
        cast(b.CategoryCode as int),
        13         

select * from 
tb费用调整表 a
where  exists(select * from TB分类对照表 z where a.deptcode=z.CategoryCode and  z.CategoryItemCode='0003' and  1=1 ${if(len(bm)==0,"","and z.CategoryLengCode in ('"+replace(bm,",","','")+"')")}  )  and BudgetYM like '${qsrq}%'

select a.ChargeDeptCode DeptCode,a.CostCoding,rq BuildYM,sum(CEMoneyext)CEMoneye
from
(select distinct a.*,CONVERT(varchar(6),END_TIME_,112) rq from 
TB费用报销单  a
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.[ACT_HI_PROCINST]A b on a.BillNumber=b.BUSINESS_KEY_
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.act_hi_varinst c on c.NAME_='process_state'  
and  b.PROC_INST_ID_=c.PROC_INST_ID_  
where CONVERT(varchar(8),b.END_TIME_,112) like '${qsrq}%' and  exists(select * from TB分类对照表 z where a.ChargeDeptCode=z.CategoryCode and  z.CategoryItemCode='0003' and  1=1 ${if(len(bm)==0,"","and z.CategoryLengCode in ('"+replace(bm,",","','")+"')")}  )  and c.TEXT_ = '6')a
group by ChargeDeptCode,CostCoding,rq



select a.ChargeDeptCode DeptCode,a.CostCoding,CONVERT(varchar(6),GETDATE(),112) BuildYM,sum(CEMoneyext)CEMoneye
from
(select distinct a.* from 
TB费用报销单  a
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.[ACT_HI_PROCINST]A b on a.BillNumber=b.BUSINESS_KEY_
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.act_hi_varinst c on c.NAME_='process_state'  
and  b.PROC_INST_ID_=c.PROC_INST_ID_  
where BuildYM like CONVERT(varchar(4),GETDATE(),112)+'%' and  exists(select * from TB分类对照表 z where a.ChargeDeptCode=z.CategoryCode and  z.CategoryItemCode='0003' and  1=1 ${if(len(bm)==0,"","and z.CategoryLengCode in ('"+replace(bm,",","','")+"')")}  )  and c.TEXT_ in ('0','1','2','3','4','5','8'))a
group by ChargeDeptCode,CostCoding



select a.DeptCode DeptCode,a.CategoryCode CostCoding,rq BuildYM,sum(Salesindex)CEMoneye
from
(select distinct a.*,CONVERT(varchar(6),END_TIME_,112) rq from 
TB部门费用预算增补单  a
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.[ACT_HI_PROCINST]A b on a.BillNumber=b.BUSINESS_KEY_
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.act_hi_varinst c on c.NAME_='process_state'  
and  b.PROC_INST_ID_=c.PROC_INST_ID_  
where CONVERT(varchar(8),b.END_TIME_,112) like '${qsrq}%' and BudgetType='0' and  exists(select * from TB分类对照表 z where a.DeptCode=z.CategoryCode and  z.CategoryItemCode='0003' and  1=1 ${if(len(bm)==0,"","and z.CategoryLengCode in ('"+replace(bm,",","','")+"')")}  )  and c.TEXT_ = '6')a
group by a.DeptCode ,a.CategoryCode,rq

