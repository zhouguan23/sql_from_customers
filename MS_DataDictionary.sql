select * from 
(
SELECT
     表名       = D.name,
     表说明     = isnull(CONVERT(VARCHAR(1000),F.value),''),
     字段序号   = A.colorder,
     字段名     = A.name,
     字段说明   = isnull(CONVERT(VARCHAR(1000),G.[value]A),''),
     --标识       = Case When COLUMNPROPERTY( A.id,A.name,'IsIdentity')=1 Then '√'Else '' End,
     类型       = B.name,
     占用字节数 = A.Length,
     长度       = COLUMNPROPERTY(A.id,A.name,'PRECISION'),
     小数位数   = isnull(COLUMNPROPERTY(A.id,A.name,'Scale'),0),
     主键       = Case When exists(SELECT 1 FROM sys.sysobjects Where xtype='PK' and parent_obj=A.id and name in (
                    SELECT name FROM sys.sysindexes WHERE indid in( SELECT indid FROM sys.sysindexkeys WHERE id = A.id AND colid=A.colid))) then '√' else '' end,
     允许空     = Case When A.isnullable=1 Then '√'Else '' End,
     默认值     = isnull(E.Text,'')
 FROM
     sys.syscolumns A
 Left Join
     sys.systypes B
 On
     A.xusertype=B.xusertype
 Inner Join
     sys.sysobjects D
 On
     A.id=D.id  and D.xtype='U' and  D.name<>'dtproperties'
 Left Join
     sys.syscomments E
 on
     A.cdefault=E.id
 Left Join
     sys.extended_properties  G
 on
     A.id=G.major_id and A.colid=G.minor_id
 Left Join
     sys.extended_properties F
 On
     D.id=F.major_id and F.minor_id=0
     --where d.name='MonPer_Recruitment_Plan'    --如果只查询指定表,加上此条件
     ) aaa
 where 1=1 
 ${if(len(BName)=0,""," and 表名 in ('"+BName+"')")}
 ${if(len(ZName)=0,""," and 字段名 in ('"+ZName+"')")}
 ${if(len(BRemarks)=0,""," and 表说明 like '%"+BRemarks+"%'")}
 ${if(len(ZRemarks)=0,""," and 字段说明 like '%"+ZRemarks+"%'")}
 order by 表名,字段序号
 

SELECT
     distinct 
     表名       = D.name,
     表说明     = isnull(CONVERT(VARCHAR(1000),F.value),'(空)'),
     显示       = D.name+'--'+isnull(CONVERT(VARCHAR(1000),F.value),'(空)')
 FROM
     sys.syscolumns A
 Left Join
     sys.systypes B
 On
     A.xusertype=B.xusertype
 Inner Join
     sys.sysobjects D
 On
     A.id=D.id  and D.xtype='U' and  D.name<>'dtproperties'
 Left Join
     sys.syscomments E
 on
     A.cdefault=E.id
 Left Join
     sys.extended_properties  G
 on
     A.id=G.major_id and A.colid=G.minor_id
 Left Join
     sys.extended_properties F
 On
     D.id=F.major_id and F.minor_id=0
ORDER BY D.name

SELECT
     字段名     = A.name,
     字段说明   = isnull(CONVERT(VARCHAR(1000),G.[value]A),'(空)'),
     显示       = A.name+'--'+isnull(CONVERT(VARCHAR(1000),G.[value]A),'(空)')
 FROM
     sys.syscolumns A
 Left Join
     sys.systypes B
 On
     A.xusertype=B.xusertype
 Inner Join
     sys.sysobjects D
 On
     A.id=D.id  and D.xtype='U' and  D.name<>'dtproperties'
 Left Join
     sys.syscomments E
 on
     A.cdefault=E.id
 Left Join
     sys.extended_properties  G
 on
     A.id=G.major_id and A.colid=G.minor_id
 Left Join
     sys.extended_properties F
 On
     D.id=F.major_id and F.minor_id=0
  
where 1=1 
   ${if(len(BName)=0,""," and D.name in ('"+BName+"')")}
ORDER BY D.name,A.colorder

