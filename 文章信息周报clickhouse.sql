SELECT DISTINCT ifnull(replace(mall,"'",""),'-') mall
FROM
    app.app_youhui_article_week_report a
    where COALESCE(a.pubdate,substring(a.uhomedate,1,10))  between '${begin_date}' and '${end_date}'

select * from (SELECT 
   a.channel,
   a.cha,
   ifnull(a.pubdate,a.uhomedate) pubdate1,
   ifnull(a.pubdatetime,'-') pubtime,
   ifnull(a.bl_add_time,'-') bl_time,
    ifnull(a.close_time,'-') close_time,
    a.mall,
    a.id,
    a.bl_from,
    a.title_prefix,
    a.user_id,
    ifnull(a.user_name,'-') username,
    a.top_category,
    ifnull(a.second_category,'-') level2,
    ifnull(a.third_category,'-') level3,
    ifnull(a.fourth_category,'-') level4,
    a.title,
    ifnull(a.mall_id,'-') mallid,
    ifnull(a.b2c_name,'-') b2c_name,
    a.home,
    ifnull(a.yh_type_name,'-') yh_type,
    ifnull(a.tags,'-') tags,
    a.worthy,
    a.unworthy,
    a.comment_count,
    a.collection_count,
    a.digital_price,
    a.totuser,
    a.totalcoin,
    ifnull(a.fx_editor_id,'-') fx_editorid,
    ifnull(a.fx_editor_name,'-') fx_editorname,
    ifnull(a.jx_editor_id,'-') jx_editorid,
    ifnull(a.jx_editor_name,'-') jx_editorname,
    ifnull(a.shang_times,'0') shangtimes,
    ifnull(a.share,'0') sharetimes,
    a.pc_pv,
    a.pc_uv,
    a.pc_event,
    a.wap_pv,
    a.wap_uv,
    a.wap_event,
    a.app_pv,
    a.app_uv,
    a.app_event,
    a.clean_link,
    a.url,
    sales,
    amounts,
    brand,
   district_zhongwen
 
FROM
    app_youhui_article_week_report.app_youhui_article_week_report a
    where ifnull(a.pubdate,a.uhomedate) between '${begin_date}' and '${end_date}'
    and match(a.mall,'${replace(mall,",","|")}') 
    and match(a.id,'${replace(id,",","|")}') 
    and match(ifnull(a.user_name,'-'),'${replace(username,",","|")}') 
    and match(a.cha,'${replace(channel,",","|")}') 
    and match(a.brand,'${replace(brand,",","|")}') 
    and match(a.title,'${replace(title,",","|")}')
    and match(a.district_zhongwen,'${replace(district,",","|")}')
     and match(a.top_category,'${replace(cate1,",","|")}')
    order by pubdate1,pubtime) x
    where match(x.district_zhongwen,'${replace(district,",","|")}')


select * from (select "国内" as district_zhongwen
union all
select "海淘" as district_zhongwen
union all
select "跨境" as district_zhongwen ) a
where (find_in_set(a.district_zhongwen,'${district}')>0 or ${len(district)=0} )

select '海淘' district_zhongwen

