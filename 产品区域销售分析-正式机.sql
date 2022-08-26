select
row_number()over() as rowid,
c.*
from
(select
a.*,
b.last_sale_num,
b.last_pick_num,
b.last_price,
b.last_price_per,
a.sale_num-b.last_sale_num AS sale_rise_num,
a.pick_num-b.last_pick_num as pick_rise_num,
a.price_per-b.last_price_per as price_rise_num_per,
if(b.last_sale_num=0,null,(a.sale_num-b.last_sale_num)/b.last_sale_num) as sale_rate,
if(b.last_pick_num=0,null,(a.pick_num-b.last_pick_num)/b.last_pick_num) as pick_rate,
if(b.last_price_per=0,null,(a.price_per-b.last_price_per)/b.last_price_per) as price_rate_per
from
(--今年提货量、零售量
select
${if(find('basic_code,basic_name',显示列)!=0,'basic_code,basic_name,','')}
${if(find('sale_organization',显示列)!=0,'sale_organization,','')}
${if(find('region',显示列)!=0,'region,','')}
${if(find('sale_province',显示列)!=0,'sale_province,','')}
${if(find('first_main_province',显示列)!=0,'first_main_province,','')}
${if(find('city_level',显示列)!=0,'city_level,','')}
${if(find('first_main_city',显示列)!=0,'first_main_city,','')}
${if(find('dealer_type',显示列)!=0,'dealer_type,','')}
${if(find('forbid_type',显示列)!=0,'forbid_type,','')}
${if(find('new_standard_status',显示列)!=0,'new_standard_status,','')}
${if(find('dealer_code,first_main_name',显示列)!=0,'dealer_code,first_main_name,','')}
${if(find('origin_dealer_code,origin_dealer_name',显示列)!=0,'origin_dealer_code,origin_dealer_name,','')}
${if(find('big_type',显示列)!=0,'big_type,','')}
${if(find('statute',显示列)!=0,'statute,','')}
${if(find('serial',显示列)!=0,'serial,','')}
${if(find('car_level',显示列)!=0,'car_level,','')}
${if(find('car_type',显示列)!=0,'car_type,','')}
${if(find('ycc_code,ycc_name',显示列)!=0,'ycc_code,ycc_name,','')}
${if(find('ecc_code,ecc_name',显示列)!=0,'ecc_code,ecc_name,','')}
${if(find('product_code,product_name',显示列)!=0,'product_code,product_name,','')}
${if(find('color',显示列)!=0,'color,','')}
sum(sale_num) as sale_num,
if(sum(sale_num)=0,null,sum(sale_price)/sum(sale_num)) as price_per,
sum(sale_price) as price,
sum(pick_num) as pick_num--,
--sum(have_pick_sale) as have_pick_sale,
--sum(none_pick_sale) as none_pick_sale,
--sum(pick_dealer_sale_num) as pick_dealer_sale_num
from 
hive.dm.dm_sale_area_prod_analysis
where 1=1
${if(len(起)=0,"","and m_date >='"+起+"'")}
${if(len(止)=0,"","and m_date <='"+止+"'")}
${if(len(基地)=0,"","and basic_code in ('"+基地+"')")}
${if(len(销售渠道)=0,"","and sale_organization in ('"+销售渠道+"')")}
${if(len(大区)=0,"","and region in ('"+大区+"')")}
${if(len(省区)=0,"","and sale_province in ('"+省区+"')")}
${if(len(省份)=0,"","and first_main_province in ('"+省份+"')")}
${if(len(城市等级)=0,"","and city_level in ('"+城市等级+"')")}
${if(len(城市)=0,"","and first_main_city in ('"+城市+"')")}
${if(len(经销商类型)=0,"","and dealer_type in ('"+经销商类型+"')")}
${if(len(禁摩)=0,"","and forbid_type in ('"+禁摩+"')")}
${if(len(新国标状态)=0,"","and new_standard_status in ('"+新国标状态+"')")}
${if(len(主账号编码)=0,"","and dealer_code in ('"+主账号编码+"')")}
${if(len(经销商编码)=0,"","and origin_dealer_code in ('"+经销商编码+"')")}
${if(len(品类)=0,"","and big_type in ('"+品类+"')")}
${if(len(法规)=0,"","and statute in ('"+法规+"')")}
${if(len(系列)=0,"","and serial in ('"+系列+"')")}
${if(len(等级)=0,"","and car_level in ('"+等级+"')")}
${if(len(机种)=0,"","and car_type in ('"+机种+"')")}
${if(len(车型)=0,"","and ycc_code in ('"+车型+"')")}
${if(len(配置)=0,"","and ecc_code in ('"+配置+"')")}
${if(len(颜色)=0,"","and color in ('"+颜色+"')")}
------权限
--查鸿翔权限为车型是G5 32192,E2 32234,M6 30022,E3 32181,T6 32211,V7 12213,U3 12298,E6 30026 30050,T9 30032
${if(fine_username = '20030880',"and ycc_code in ('32192','32234','30022','32181','32211','12213','12298','30026','30050','30032')","")}
--沈瑜权限为华南七省（广东，广西，福建，湖南，海南，云南，贵州）
${if(fine_username = 'G14045013',"and first_main_province in ('广东','广西','福建','湖南','海南','云南','贵州')","")}
--电商 经销商类型权限为电商客户和零售客户
${if(GETUSERDEPARTMENTS() = '2201',"and dealer_type in ('电商客户','零售客户')","")}
--周铭 戴淑芬 董振杰 陆晓霞 郭园园 薛润润 刘凤丽 沈瑜 李璐 仝高峰权限不可以查看1021基地 ${if(find(fine_username,"12032003,18062025,16122027,12032007,12040091,12030148,10010003,14045013,15052004,12020425")=0,"","and basic_code in ('"+基地+"')")}
-- 渠道专员权限
-- 华晓娜
${if(fine_username='15032070',"and sale_province = ('苏南')","")}
-- 宋雨泽
${if(fine_username='20030951',"and sale_province = ('苏中北')","")}
-- 刘杰
${if(fine_username='20050611',"and sale_province = ('山东')","")}
-- 孙芸洁
${if(fine_username='20071113',"and sale_province in ('上海','浙江')","")}
-- 韦子途
${if(fine_username='20050256',"and sale_province = ('广西')","")}
-- 周玥
${if(fine_username='20080465',"and sale_province in ('福建','海南','湖南')","")}
-- 陈星宏
${if(fine_username='20040296',"and sale_province in ('京津','广东')","")}
-- 郭艳春
${if(fine_username='16092023',"and sale_province = ('河南')","")}
-- 杨云锐
${if(fine_username='20060089',"and sale_province = ('河北')","")}
-- 孙毛彩
${if(fine_username='19030097',"and sale_province = ('安徽')","")}
-- 邓秋
${if(fine_username='12053008',"and sale_province in ('江西','云南','贵州')","")}
-- 曹少英
${if(fine_username='19110328',"and sale_province in ('湖北','山西','陕西')","")}
-- 陈慧芳
${if(fine_username='19100055',"and sale_province in ('川东','川西','成都','重庆')","")}
-- 浦悦琳
${if(fine_username='20060316',"and sale_province in ('东三省','甘宁蒙中西','青新藏河西')","")}
-- 张健鑫
${if(fine_username='20070106',"and basic_code = '1021'","")}
-- 程龙燕
${if(fine_username = '15072071',"and ecc_code in ('30053008','30072007','30026025','30053008','30022034')","")}
-- 李治国
${if(fine_username = '15092011',"and big_type in ('豪华','其它')","")}
${if(len(显示列)=0,"","GROUP BY "+显示列+"")}
)a
left join
(--去年提货量、零售量
select
${if(find('basic_code,basic_name',显示列)!=0,'basic_code,basic_name,','')}
${if(find('sale_organization',显示列)!=0,'sale_organization,','')}
${if(find('region',显示列)!=0,'region,','')}
${if(find('sale_province',显示列)!=0,'sale_province,','')}
${if(find('first_main_province',显示列)!=0,'first_main_province,','')}
${if(find('city_level',显示列)!=0,'city_level,','')}
${if(find('first_main_city',显示列)!=0,'first_main_city,','')}
${if(find('dealer_type',显示列)!=0,'dealer_type,','')}
${if(find('forbid_type',显示列)!=0,'forbid_type,','')}
${if(find('new_standard_status',显示列)!=0,'new_standard_status,','')}
${if(find('dealer_code,first_main_name',显示列)!=0,'dealer_code,first_main_name,','')}
${if(find('origin_dealer_code,origin_dealer_name',显示列)!=0,'origin_dealer_code,origin_dealer_name,','')}
${if(find('big_type',显示列)!=0,'big_type,','')}
${if(find('statute',显示列)!=0,'statute,','')}
${if(find('serial',显示列)!=0,'serial,','')}
${if(find('car_level',显示列)!=0,'car_level,','')}
${if(find('car_type',显示列)!=0,'car_type,','')}
${if(find('ycc_code,ycc_name',显示列)!=0,'ycc_code,ycc_name,','')}
${if(find('ecc_code,ecc_name',显示列)!=0,'ecc_code,ecc_name,','')}
${if(find('product_code,product_name',显示列)!=0,'product_code,product_name,','')}
${if(find('color',显示列)!=0,'color,','')}
sum(sale_num) as last_sale_num,
sum(pick_num) as last_pick_num,
if(sum(sale_num)=0,null,sum(sale_price)/sum(sale_num)) as last_price_per,
sum(sale_price) as last_price
from 
hive.dm.dm_sale_area_prod_analysis
where 1=1
${if(len(起)=0,"","and cast((date(m_date) + interval '1' year) as varchar) >='"+起+"'")}
${if(len(止)=0,"","and cast((date(m_date) + interval '1' year) as varchar) <='"+止+"'")}
${if(len(基地)=0,"","and basic_code in ('"+基地+"')")}
${if(len(销售渠道)=0,"","and sale_organization in ('"+销售渠道+"')")}
${if(len(大区)=0,"","and region in ('"+大区+"')")}
${if(len(省区)=0,"","and sale_province in ('"+省区+"')")}
${if(len(省份)=0,"","and first_main_province in ('"+省份+"')")}
${if(len(城市等级)=0,"","and city_level in ('"+城市等级+"')")}
${if(len(城市)=0,"","and first_main_city in ('"+城市+"')")}
${if(len(经销商类型)=0,"","and dealer_type in ('"+经销商类型+"')")}
${if(len(禁摩)=0,"","and forbid_type in ('"+禁摩+"')")}
${if(len(新国标状态)=0,"","and new_standard_status in ('"+新国标状态+"')")}
${if(len(主账号编码)=0,"","and dealer_code in ('"+主账号编码+"')")}
${if(len(经销商编码)=0,"","and origin_dealer_code in ('"+经销商编码+"')")}
${if(len(品类)=0,"","and big_type in ('"+品类+"')")}
${if(len(法规)=0,"","and statute in ('"+法规+"')")}
${if(len(系列)=0,"","and serial in ('"+系列+"')")}
${if(len(等级)=0,"","and car_level in ('"+等级+"')")}
${if(len(机种)=0,"","and car_type in ('"+机种+"')")}
${if(len(车型)=0,"","and ycc_code in ('"+车型+"')")}
${if(len(配置)=0,"","and ecc_code in ('"+配置+"')")}
${if(len(颜色)=0,"","and color in ('"+颜色+"')")}
------权限
--查鸿翔权限为车型是G5 32192,E2 32234,M6 30022,E3 32181,T6 32211,V7 12213,U3 12298,E6 30026 30050,T9 30032
${if(fine_username = '20030880',"and ycc_code in ('32192','32234','30022','32181','32211','12213','12298','30026','30050','30032')","")}
--沈瑜权限为华南七省（广东，广西，福建，湖南，海南，云南，贵州）
${if(fine_username = 'G14045013',"and first_main_province in ('广东','广西','福建','湖南','海南','云南','贵州')","")}
--电商 经销商类型权限为电商客户和零售客户
${if(GETUSERDEPARTMENTS() = '2201',"and dealer_type in ('电商客户','零售客户')","")}
--周铭 戴淑芬 董振杰 陆晓霞 郭园园 薛润润 刘凤丽 沈瑜 李璐 仝高峰权限不可以查看1021基地 ${if(find(fine_username,"12032003,18062025,16122027,12032007,12040091,12030148,10010003,14045013,15052004,12020425")=0,"","and basic_code in ('"+基地+"')")}
-- 渠道专员权限
-- 华晓娜
${if(fine_username='15032070',"and sale_province = ('苏南')","")}
-- 宋雨泽
${if(fine_username='20030951',"and sale_province = ('苏中北')","")}
-- 刘杰
${if(fine_username='20050611',"and sale_province = ('山东')","")}
-- 孙芸洁
${if(fine_username='20071113',"and sale_province in ('上海','浙江')","")}
-- 韦子途
${if(fine_username='20050256',"and sale_province = ('广西')","")}
-- 周玥
${if(fine_username='20080465',"and sale_province in ('福建','海南','湖南')","")}
-- 陈星宏
${if(fine_username='20040296',"and sale_province in ('京津','广东')","")}
-- 郭艳春
${if(fine_username='16092023',"and sale_province = ('河南')","")}
-- 杨云锐
${if(fine_username='20060089',"and sale_province = ('河北')","")}
-- 孙毛彩
${if(fine_username='19030097',"and sale_province = ('安徽')","")}
-- 邓秋
${if(fine_username='12053008',"and sale_province in ('江西','云南','贵州')","")}
-- 曹少英
${if(fine_username='19110328',"and sale_province in ('湖北','山西','陕西')","")}
-- 陈慧芳
${if(fine_username='19100055',"and sale_province in ('川东','川西','成都','重庆')","")}
-- 浦悦琳
${if(fine_username='20060316',"and sale_province in ('东三省','甘宁蒙中西','青新藏河西')","")}
-- 张健鑫
${if(fine_username='20070106',"and basic_code = '1021'","")}
-- 程龙燕
${if(fine_username = '15072071',"and ecc_code in ('30053008','30072007','30026025','30053008','30022034')","")}
-- 李治国
${if(fine_username = '15092011',"and big_type in ('豪华','其它')","")}
${if(len(显示列)=0,"","GROUP BY "+显示列+"")}
)b
on 1=1
${if(find('basic_code,basic_name',显示列)!=0,'and a.basic_code=b.basic_code','')}
${if(find('sale_organization',显示列)!=0,'and a.sale_organization=b.sale_organization','')}
${if(find('region',显示列)!=0,'and a.region=b.region','')}
${if(find('sale_province',显示列)!=0,'and a.sale_province=b.sale_province','')}
${if(find('first_main_province',显示列)!=0,'and a.first_main_province=b.first_main_province','')}
${if(find('city_level',显示列)!=0,'and a.city_level=b.city_level','')}
${if(find('first_main_city',显示列)!=0,'and a.first_main_city=b.first_main_city','')}
${if(find('dealer_type',显示列)!=0,'and a.dealer_type=b.dealer_type','')}
${if(find('forbid_type',显示列)!=0,'and a.forbid_type=b.forbid_type','')}
${if(find('new_standard_status',显示列)!=0,'and a.new_standard_status=b.new_standard_status','')}
${if(find('dealer_code,first_main_name',显示列)!=0,'and a.dealer_code=b.dealer_code','')}
${if(find('origin_dealer_code,origin_dealer_name',显示列)!=0,'and a.origin_dealer_code=b.origin_dealer_code','')}
${if(find('big_type',显示列)!=0,'and a.big_type=b.big_type','')}
${if(find('statute',显示列)!=0,'and a.statute=b.statute','')}
${if(find('serial',显示列)!=0,'and a.serial=b.serial','')}
${if(find('car_level',显示列)!=0,'and a.car_level=b.car_level','')}
${if(find('car_type',显示列)!=0,'and a.car_type=b.car_type','')}
${if(find('ycc_code,ycc_name',显示列)!=0,'and a.ycc_code=b.ycc_code','')}
${if(find('ecc_code,ecc_name',显示列)!=0,'and a.ecc_code=b.ecc_code','')}
${if(find('product_code,product_name',显示列)!=0,'and a.product_code=b.product_code','')}
${if(find('color',显示列)!=0,'and a.color=b.color','')}
)c
where 1=1
--增长率范围筛选
${if(isnull(提货范围起),"","and c.pick_rate >= "+提货范围起/100)}
${if(isnull(提货范围止),"","and c.pick_rate <= "+提货范围止/100)}
${if(isnull(零售范围起),"","and c.sale_rate >= "+零售范围起/100)}
${if(isnull(零售范围止),"","and c.sale_rate <= "+零售范围止/100)}

select
distinct region
from hive.dict_basic_topic_area_choose
order by 1

select
distinct sale_province
from hive.dm.dm_sale_area_prod_analysis
where 1=1 
${if(len(大区)=0,"","and region in ('"+大区+"')")}
${if(len(经销商类型)=0,"","and dealer_type in ('"+经销商类型+"')")}
-- 渠道专员权限
-- 华晓娜
${if(fine_username='15032070',"and sale_province = ('苏南')","")}
-- 宋雨泽
${if(fine_username='20030951',"and sale_province = ('苏中北')","")}
-- 刘杰
${if(fine_username='20050611',"and sale_province = ('山东')","")}
-- 孙芸洁
${if(fine_username='20071113',"and sale_province in ('上海','浙江')","")}
-- 韦子途
${if(fine_username='20050256',"and sale_province = ('广西')","")}
-- 周玥
${if(fine_username='20080465',"and sale_province in ('福建','海南','湖南')","")}
-- 陈星宏
${if(fine_username='20040296',"and sale_province in ('京津','广东')","")}
-- 郭艳春
${if(fine_username='16092023',"and sale_province = ('河南')","")}
-- 杨云锐
${if(fine_username='20060089',"and sale_province = ('河北')","")}
-- 孙毛彩
${if(fine_username='19030097',"and sale_province = ('安徽')","")}
-- 邓秋
${if(fine_username='12053008',"and sale_province in ('江西','云南','贵州')","")}
-- 曹少英
${if(fine_username='19110328',"and sale_province in ('湖北','山西','陕西')","")}
-- 陈慧芳
${if(fine_username='19100055',"and sale_province in ('川东','川西','成都','重庆')","")}
-- 浦悦琳
${if(fine_username='20060316',"and sale_province in ('东三省','甘宁蒙中西','青新藏河西')","")}
-- 张健鑫
--${if(fine_username='20070106',"and basic_code = '1021'","")}
order by 1

select
distinct province as province
from
hive.dict_basic_topic_area_choose
where 1=1 
${if(len(大区)=0,"","and region in ('"+大区+"')")}
${if(len(省区)=0,"","and sale_province in ('"+省区+"')")}
-- G14045013沈瑜权限为华南七省（广东，广西，福建，湖南，海南，云南，贵州）
${if(fine_username='G14045013',"and province in ('广东','广西','福建','湖南','海南','云南','贵州')","")}
-- 渠道专员权限
-- 华晓娜
${if(fine_username='15032070',"and sale_province = ('苏南')","")}
-- 宋雨泽
${if(fine_username='20030951',"and sale_province = ('苏中北')","")}
-- 刘杰
${if(fine_username='20050611',"and sale_province = ('山东')","")}
-- 孙芸洁
${if(fine_username='20071113',"and sale_province in ('上海','浙江')","")}
-- 韦子途
${if(fine_username='20050256',"and sale_province = ('广西')","")}
-- 周玥
${if(fine_username='20080465',"and sale_province in ('福建','海南','湖南')","")}
-- 陈星宏
${if(fine_username='20040296',"and sale_province in ('京津','广东')","")}
-- 郭艳春
${if(fine_username='16092023',"and sale_province = ('河南')","")}
-- 杨云锐
${if(fine_username='20060089',"and sale_province = ('河北')","")}
-- 孙毛彩
${if(fine_username='19030097',"and sale_province = ('安徽')","")}
-- 邓秋
${if(fine_username='12053008',"and sale_province in ('江西','云南','贵州')","")}
-- 曹少英
${if(fine_username='19110328',"and sale_province in ('湖北','山西','陕西')","")}
-- 陈慧芳
${if(fine_username='19100055',"and sale_province in ('川东','川西','成都','重庆')","")}
-- 浦悦琳
${if(fine_username='20060316',"and sale_province in ('东三省','甘宁蒙中西','青新藏河西')","")}
-- 张健鑫
--${if(fine_username='20070106',"and basic_code = '1021'","")}
order by 1


select
distinct city
from 
hive.dict_basic_topic_area_choose
where 1=1
${if(len(大区)=0,"","and region in ('"+大区+"')")}
${if(len(省区)=0,"","and sale_province in ('"+省区+"')")}
${if(len(省份)=0,"","and province in ('"+省份+"')")}
${if(len(城市等级)=0,"","and city_level in ('"+城市等级+"')")}
-- G14045013沈瑜权限为华南七省（广东，广西，福建，湖南，海南，云南，贵州）
${if(fine_username='G14045013',"and province in ('广东','广西','福建','湖南','海南','云南','贵州')","")}
-- 渠道专员权限
-- 华晓娜
${if(fine_username='15032070',"and sale_province = ('苏南')","")}
-- 宋雨泽
${if(fine_username='20030951',"and sale_province = ('苏中北')","")}
-- 刘杰
${if(fine_username='20050611',"and sale_province = ('山东')","")}
-- 孙芸洁
${if(fine_username='20071113',"and sale_province in ('上海','浙江')","")}
-- 韦子途
${if(fine_username='20050256',"and sale_province = ('广西')","")}
-- 周玥
${if(fine_username='20080465',"and sale_province in ('福建','海南','湖南')","")}
-- 陈星宏
${if(fine_username='20040296',"and sale_province in ('京津','广东')","")}
-- 郭艳春
${if(fine_username='16092023',"and sale_province = ('河南')","")}
-- 杨云锐
${if(fine_username='20060089',"and sale_province = ('河北')","")}
-- 孙毛彩
${if(fine_username='19030097',"and sale_province = ('安徽')","")}
-- 邓秋
${if(fine_username='12053008',"and sale_province in ('江西','云南','贵州')","")}
-- 曹少英
${if(fine_username='19110328',"and sale_province in ('湖北','山西','陕西')","")}
-- 陈慧芳
${if(fine_username='19100055',"and sale_province in ('川东','川西','成都','重庆')","")}
-- 浦悦琳
${if(fine_username='20060316',"and sale_province in ('东三省','甘宁蒙中西','青新藏河西')","")}
-- 张健鑫
--${if(fine_username='20070106',"and basic_code = '1021'","")}

select
distinct dealer_code,
concat(dealer_code," | ",dealer_name) as dealer_name
from 
hive.dict_basic_topic_area_choose
where 1=1
${if(len(大区)=0,"","and region in ('"+大区+"')")}
${if(len(省区)=0,"","and sale_province in ('"+省区+"')")}
${if(len(省份)=0,"","and province in ('"+省份+"')")}
${if(len(城市等级)=0,"","and city_level in ('"+城市等级+"')")}
${if(len(城市)=0,"","and city in ('"+城市+"')")}
${if(len(经销商类型)=0,"","and dealer_type in ('"+经销商类型+"')")}
${if(len(禁摩)=0,"","and forbid_type in ('"+禁摩+"')")}
${if(len(新国标状态)=0,"","and new_standard_status in ('"+新国标状态+"')")}
-- G14045013沈瑜权限为华南七省（广东，广西，福建，湖南，海南，云南，贵州）
${if(fine_username='G14045013',"and province in ('广东','广西','福建','湖南','海南','云南','贵州')","")}
-- 渠道专员权限
-- 华晓娜
${if(fine_username='15032070',"and sale_province = ('苏南')","")}
-- 宋雨泽
${if(fine_username='20030951',"and sale_province = ('苏中北')","")}
-- 刘杰
${if(fine_username='20050611',"and sale_province = ('山东')","")}
-- 孙芸洁
${if(fine_username='20071113',"and sale_province in ('上海','浙江')","")}
-- 韦子途
${if(fine_username='20050256',"and sale_province = ('广西')","")}
-- 周玥
${if(fine_username='20080465',"and sale_province in ('福建','海南','湖南')","")}
-- 陈星宏
${if(fine_username='20040296',"and sale_province in ('京津','广东')","")}
-- 郭艳春
${if(fine_username='16092023',"and sale_province = ('河南')","")}
-- 杨云锐
${if(fine_username='20060089',"and sale_province = ('河北')","")}
-- 孙毛彩
${if(fine_username='19030097',"and sale_province = ('安徽')","")}
-- 邓秋
${if(fine_username='12053008',"and sale_province in ('江西','云南','贵州')","")}
-- 曹少英
${if(fine_username='19110328',"and sale_province in ('湖北','山西','陕西')","")}
-- 陈慧芳
${if(fine_username='19100055',"and sale_province in ('川东','川西','成都','重庆')","")}
-- 浦悦琳
${if(fine_username='20060316',"and sale_province in ('东三省','甘宁蒙中西','青新藏河西')","")}
-- 张健鑫
--${if(fine_username='20070106',"and basic_code = '1021'","")}
order by 1

select
distinct statute
from 
hive.dict_basic_topic_prod_choose
where 1=1 
${if(isnull(基地),"","and plant_code in ('"+基地+"')")}
-- 查鸿翔权限为车型是G5 32192,E2 32234,M6 30022,E3 32181,T6 32211,V7 12213,U3 12298
${if(fine_username = '20030880',"and ycc_code in ('32192','32234','30022','32181','32211','12213','12298')","")}
-- 李治国
${if(fine_username = '15092011',"and type in ('豪华','其它')","")}
order by 1 desc

select
distinct serial
from 
hive.dict_basic_topic_prod_choose
where 1=1
${if(isnull(基地),"","and plant_code in ('"+基地+"')")}
${if(len(法规)=0,"","and statute in ('"+法规+"')")}
${if(len(品类)=0,"","and type in ('"+品类+"')")}
-- 查鸿翔权限为车型是G5 32192,E2 32234,M6 30022,E3 32181,T6 32211,V7 12213,U3 12298
${if(fine_username = '20030880',"and ycc_code in ('32192','32234','30022','32181','32211','12213','12298')","")}
-- 李治国
${if(fine_username = '15092011',"and type in ('豪华','其它')","")}
order by 1 desc

select
distinct car_type
from 
hive.dict_basic_topic_prod_choose
where 1=1
${if(isnull(基地),"","and plant_code in ('"+基地+"')")}
${if(len(法规)=0,"","and statute in ('"+法规+"')")}
${if(len(品类)=0,"","and type in ('"+品类+"')")}
${if(len(系列)=0,"","and serial in ('"+系列+"')")}
${if(len(等级)=0,"","and level in ('"+等级+"')")}
-- 查鸿翔权限为车型是G5 32192,E2 32234,M6 30022,E3 32181,T6 32211,V7 12213,U3 12298
${if(fine_username = '20030880',"and ycc_code in ('32192','32234','30022','32181','32211','12213','12298')","")}
-- 李治国
${if(fine_username = '15092011',"and type in ('豪华','其它')","")}
order by 1 desc

select
distinct ycc_code,
concat(ycc_code," | ",ycc_name) as ycc_name
from 
hive.dict_basic_topic_prod_choose
where 1=1 
${if(isnull(基地),"","and plant_code in ('"+基地+"')")}
${if(len(法规)=0,"","and statute in ('"+法规+"')")}
${if(len(品类)=0,"","and type in ('"+品类+"')")}
${if(len(系列)=0,"","and serial in ('"+系列+"')")}
${if(len(等级)=0,"","and level in ('"+等级+"')")}
${if(len(机种)=0,"","and car_type in ('"+机种+"')")}
-- 查鸿翔权限为车型是G5 32192,E2 32234,M6 30022,E3 32181,T6 32211,V7 12213,U3 12298,E6 30026 30050,T9 30032
${if(fine_username = '20030880',"and ycc_code in ('32192','32234','30022','32181','32211','12213','12298','30026','30050','30032')","")}
-- 程龙燕
${if(fine_username = '15072071',"and category_code in ('30053008','30072007','30026025','30053008','30022034')","")}
order by 1

select
distinct category_code,
concat(category_code," | ",category_name) as category_name
from 
hive.dict_basic_topic_prod_choose
where 1=1 
${if(isnull(基地),"","and plant_code in ('"+基地+"')")}
${if(len(法规)=0,"","and statute in ('"+法规+"')")}
${if(len(品类)=0,"","and type in ('"+品类+"')")}
${if(len(系列)=0,"","and serial in ('"+系列+"')")}
${if(len(等级)=0,"","and level in ('"+等级+"')")}
${if(len(机种)=0,"","and car_type in ('"+机种+"')")}
${if(len(车型)=0,"","and ycc_code in ('"+车型+"')")}
-- 查鸿翔权限为车型是G5 32192,E2 32234,M6 30022,E3 32181,T6 32211,V7 12213,U3 12298
${if(fine_username = '20030880',"and ycc_code in ('32192','32234','30022','32181','32211','12213','12298')","")}
-- 程龙燕
${if(fine_username = '15072071',"and category_code in ('30053008','30072007','30026025','30053008','30022034')","")}
-- 李治国
${if(fine_username = '15092011',"and type in ('豪华','其它')","")}
order by 1

select
distinct color
from 
hive.dict_basic_topic_prod_choose
where 1=1 
${if(isnull(基地),"","and plant_code in ('"+基地+"')")}
${if(len(品类)=0,"","and type in ('"+品类+"')")}
${if(len(法规)=0,"","and statute in ('"+法规+"')")}
${if(len(系列)=0,"","and serial in ('"+系列+"')")}
${if(len(等级)=0,"","and level in ('"+等级+"')")}
${if(len(机种)=0,"","and car_type in ('"+机种+"')")}
${if(len(车型)=0,"","and ycc_code in ('"+车型+"')")}
${if(len(配置)=0,"","and category_code in ('"+配置+"')")}
-- 查鸿翔权限为车型是G5 32192,E2 32234,M6 30022,E3 32181,T6 32211,V7 12213,U3 12298
${if(fine_username = '20030880',"and ycc_code in ('32192','32234','30022','32181','32211','12213','12298')","")}
-- 李治国
${if(fine_username = '15092011',"and type in ('豪华','其它')","")}
order by 1

select
max(etl_date) as etl_date
from
hive.dm_all_table_etl_date
where name = 'dm_sale_area_prod_analysis'

select
name
from
(select
'提货量' as name
union all
select
'零售量' as name
union all
select
case position('客单价可见' in '${fine_role}')
when 0 then null 
else '客单价' end as name
union all
select
'同比' as name)a
where name is not null

SELECT werks,concat(werks,' | ',sname) as name FROM `dict_werks`
where iswerks = 1
-- 周铭 戴淑芬 董振杰 陆晓霞 郭园园 薛润润 刘凤丽 沈瑜 李璐 仝高峰权限不可以查看1021基地 ${if(find(fine_username,"12032003,18062025,16122027,12032007,12040091,12030148,10010003,14045013,15052004,12020425")=0,"","and werks <> '1021'")}

SELECT werks,concat(werks,' | ',sname) as name FROM `dict_werks`
where isvkorg = 1

select
* 
from external.dict_dealer_type
where name <> '零售客户'
-- 2201电商公司仅可见电商客户和零售客户
${if(GETUSERDEPARTMENTS()='2201',"and name = '电商客户'","")}

select
distinct type
from 
hive.dict_basic_topic_prod_choose
where 1=1
-- 李治国
${if(fine_username = '15092011',"and type in ('豪华','其它')","")}

select
distinct origin_dealer_code,
concat(origin_dealer_code," | ",origin_dealer_name) as origin_dealer_name
from 
hive.dict_basic_topic_area_choose
where 1=1
${if(len(大区)=0,"","and region in ('"+大区+"')")}
${if(len(省区)=0,"","and sale_province in ('"+省区+"')")}
${if(len(省份)=0,"","and province in ('"+省份+"')")}
${if(len(城市等级)=0,"","and city_level in ('"+城市等级+"')")}
${if(len(城市)=0,"","and city in ('"+城市+"')")}
${if(len(经销商类型)=0,"","and dealer_type in ('"+经销商类型+"')")}
${if(len(禁摩)=0,"","and forbid_type in ('"+禁摩+"')")}
${if(len(新国标状态)=0,"","and new_standard_status in ('"+新国标状态+"')")}
${if(len(主账号编码)=0,"","and dealer_code in ('"+主账号编码+"')")}
-- G14045013沈瑜权限为华南七省（广东，广西，福建，湖南，海南，云南，贵州）
${if(fine_username='G14045013',"and province in ('广东','广西','福建','湖南','海南','云南','贵州')","")}
-- 渠道专员权限
-- 华晓娜
${if(fine_username='15032070',"and sale_province = ('苏南')","")}
-- 宋雨泽
${if(fine_username='20030951',"and sale_province = ('苏中北')","")}
-- 刘杰
${if(fine_username='20050611',"and sale_province = ('山东')","")}
-- 孙芸洁
${if(fine_username='20071113',"and sale_province in ('上海','浙江')","")}
-- 韦子途
${if(fine_username='20050256',"and sale_province = ('广西')","")}
-- 周玥
${if(fine_username='20080465',"and sale_province in ('福建','海南','湖南')","")}
-- 陈星宏
${if(fine_username='20040296',"and sale_province in ('京津','广东')","")}
-- 郭艳春
${if(fine_username='16092023',"and sale_province = ('河南')","")}
-- 杨云锐
${if(fine_username='20060089',"and sale_province = ('河北')","")}
-- 孙毛彩
${if(fine_username='19030097',"and sale_province = ('安徽')","")}
-- 邓秋
${if(fine_username='12053008',"and sale_province in ('江西','云南','贵州')","")}
-- 曹少英
${if(fine_username='19110328',"and sale_province in ('湖北','山西','陕西')","")}
-- 陈慧芳
${if(fine_username='19100055',"and sale_province in ('川东','川西','成都','重庆')","")}
-- 浦悦琳
${if(fine_username='20060316',"and sale_province in ('东三省','甘宁蒙中西','青新藏河西')","")}
-- 张健鑫
--${if(fine_username='20070106',"and basic_code = '1021'","")}
order by 1

