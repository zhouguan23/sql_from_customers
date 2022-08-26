select DISTINCT A.GOODS_CODE,B.GOODS_NAME,A.GOODS_CODE||'|'||B.GOODS_NAME GOODS_NAME1 from DIM_DTP_PRE a
,DIM_GOODS B

where  A.GOODS_CODE=B.GOODS_CODE
and 
1=1
${if(len(GOODS_CODE)==0,"", " and GOODS_CODE in ('" + GOODS_CODE + "')")}

ORDER BY 1

select a.*,b.GOODS_NAME,b.SPECIFICATION,b.MANUFACTURER,b.PRODUCT_PLACE,b.approval_num from DIM_DTP_pre a left join dim_disable_code c
on a.goods_code=c.disable_code ,DIM_GOODS b
where a.GOODS_CODE=b.GOODS_CODE
and 
1=1
${if(len(GOODS_CODE)==0,"", " and a.GOODS_CODE in ('" + GOODS_CODE + "')")}
and 1=1 
${if(len(status)=0,"","and case
         when c.goods_code is null then
          '废止'
         when c.goods_code <> c.disable_code then
          '禁用'
         WHEN c.goods_code = c.disable_code AND c.disable_code LIKE '6%' THEN
          '临购码'
         else
          '正常'
       end in ('"+status+"')")}
order by 1

select distinct GOODS_CODE,goods_code||'|'||goods_name from DIM_GOODS
where goods_code<>'0'
order by 1 

