select a.*,case
         when b.goods_code is null then
          '废止'
         when b.goods_code <> b.disable_code then
          '禁用'
         WHEN b.goods_code = b.disable_code AND b.disable_code LIKE '6%' THEN
          '禁用'
         else
          '正常'
       end status,b.goods_code disable_code,case when d.goods_code is not null then '是' else '否' end DTP from DIM_GOODS a
left join DIM_DISABLE_CODE b
on a.goods_code=b.disable_code
left join dim_dtp_pre d
on a.goods_code=d.goods_code
WHERE 1=1
${if(len(GOODS_CODE)=0,"","and a.GOODS_CODE in ('"+GOODS_CODE+"')")}
${if(len(function)=0,"","and function like '%"+function+"%'")}

--${if(len(GOODS_CODE)=0,"",if(GOODS_CODE='必选',"and goods_code is null","and goods_code in('"+GOODS_CODE+"')"))}
${if(len(BIG_CATE)=0,"",if(BIG_CATE='空'," and BIG_CATE is null","and case when BIG_CATE is null then '空' else BIG_CATE end  in ('"+BIG_CATE+"')"))}
${if(len(category)=0,"",if(category='空'," and category is null","and case when category is null then '空' else category end in ('"+category+"')"))}
${if(len(sub_category)=0,"",if(sub_category='空'," and sub_category is null","and case when sub_category is null then '空' else sub_category end   in ('"+sub_category+"')"))}
${if(len(COMPOSITION)=0,"",if(COMPOSITION='空'," and COMPOSITION is null","and case when COMPOSITION is null then '空' else COMPOSITION end in ('"+COMPOSITION+"')"))}
${if(len(SUB_COMPOSITION)=0,"",if(SUB_COMPOSITION='空'," and SUB_COMPOSITION is null","and case when SUB_COMPOSITION is null then '空' else SUB_COMPOSITION end in ('"+SUB_COMPOSITION+"')"))}
${if(len(FINISHING_MANUFACTURER)=0,"",if(FINISHING_MANUFACTURER='空'," and FINISHING_MANUFACTURER is null","and case when FINISHING_MANUFACTURER is null then '空' else FINISHING_MANUFACTURER end in ('"+FINISHING_MANUFACTURER+"')"))}

${if(len(DATE1)=0,"","and LAST_UPDATE_DATETIME >= TO_DATE( '" + DATE1 + "','YYYY-MM-DD')")}
${if(len(DATE1)=0,"","and LAST_UPDATE_DATETIME <= TO_DATE( '" + DATE2 + "','YYYY-MM-DD')")}
and
1=1
${if(len(status)=0,"","and case
         when b.goods_code is null then
          '废止'
         when b.goods_code <> b.disable_code then
          '禁用'
         WHEN b.goods_code = b.disable_code AND b.disable_code LIKE '6%' THEN
          '禁用'
         else
          '正常'
       end in ('"+status+"')")}
order by 1


--select '必选' as GOODS_CODE from dual
--union
SELECT DISTINCT GOODS_CODE,GOODS_NAME,GOODS_CODE||'|'||GOODS_NAME GOODS_NAME1 FROM DIM_GOODS
WHERE 1=1
${if(len(BIG_CATE)=0,"",if(BIG_CATE='空'," and BIG_CATE is null","and BIG_CATE in ('"+BIG_CATE+"')"))}
and
1=1
${if(len(CATEGORY)=0,"","and CATEGORY in ('"+CATEGORY+"')")}
and
1=1
${if(len(SUB_CATEGORY)=0,"","and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(DATE1)=0,"","and LAST_UPDATE_DATETIME >= date'" + DATE1 + "'")}
${if(len(DATE1)=0,"","and LAST_UPDATE_DATETIME <= TO_DATE( '" + DATE2 + "','YYYY-MM-DD')")}


ORDER by GOODS_CODE ASC

SELECT DISTINCT BIG_CATE FROM DIM_GOODS
union 
select '空' from dual

SELECT DISTINCT CATEGORY
FROM DIM_GOODS
WHERE 1=1
${if(len(BIG_CATE)=0, "" ,"and BIG_CATE in ('"+BIG_CATE+"')")}
union 
select '空' from dual

SELECT DISTINCT 
SUB_CATEGORY 
FROM DIM_GOODS
WHERE 1=1
${if(len(BIG_CATE)=0, "" ,"and BIG_CATE in ('"+BIG_CATE+"')")}
AND 
1=1
${if(len(CATEGORY)=0, "" ,"and CATEGORY in ('"+CATEGORY+"')")}
union 
select '空' from dual

SELECT DISTINCT 
COMPOSITION
FROM DIM_GOODS
WHERE 1=1
${if(len(BIG_CATE)=0, "" ,"and BIG_CATE in ('"+BIG_CATE+"')")}
AND 
1=1
${if(len(CATEGORY)=0, "" ,"and CATEGORY in ('"+CATEGORY+"')")}
AND 
1=1
${if(len(SUB_CATEGORY)=0, "" ,"and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
union 
select '空' from dual


SELECT DISTINCT 
SUB_COMPOSITION
FROM DIM_GOODS
WHERE 
1=1
${if(len(COMPOSITION)=0, "" ,"and COMPOSITION in ('"+COMPOSITION+"')")}
AND
 1=1
${if(len(BIG_CATE)=0, "" ,"and BIG_CATE in ('"+BIG_CATE+"')")}
AND 
1=1
${if(len(CATEGORY)=0, "" ,"and CATEGORY in ('"+CATEGORY+"')")}
AND 
1=1
${if(len(SUB_CATEGORY)=0, "" ,"and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
union 
select '空' from dual

SELECT DISTINCT 
FINISHING_MANUFACTURER
FROM 
DIM_GOODS
union 
select '空' from dual

