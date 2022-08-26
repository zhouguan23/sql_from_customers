select distinct create_month from fact_sale_index 

select t.*,
           sum(no_tax_amount) over(partition by area_code order by sale_date) total_amount
      from (select decode(area_code,'11','10','22','20',area_code) area_code,
                   substr(sale_date,6,2) sale_date,
                   sum(no_tax_amount) no_tax_amount
              from DM_PURCHASE_GROUP_BY_AREA
            
             where substr(sale_date,1,4) ='${year}'
               and gather in
                   ('集采高毛', '集采贴牌', '集采品牌高毛', '集采专销')
                   and related_party_trnsaction<>'是'
             group by decode(area_code,'11','10','22','20',area_code),substr(sale_date,6,2)) t
     order by 1, 2

select t.*,
           sum(no_tax_amount) over(partition by area_code order by sale_date) total_amount
      from (select decode(area_code,'11','10','22','20',area_code) area_code,
                   substr(sale_date,6,2) sale_date,
                   sum(no_tax_amount) no_tax_amount
              from DM_PURCHASE_GROUP_BY_AREA
            
             where substr(sale_date,1,4) ='${year}'-1
               and gather in
                   ('集采高毛', '集采贴牌', '集采品牌高毛', '集采专销')
                   and related_party_trnsaction<>'是'
             group by decode(area_code,'11','10','22','20',area_code),substr(sale_date,6,2)) t
     order by 1, 2

select distinct b.union_area_name,a.area_code,jcgm from fact_sale_index a
left join dim_region b
on a.area_code=b.area_code
where create_month='${year}'
and  1=1
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
and 1=1
${if(len(union_area)=0,""," and b.union_area_name in ('"+union_area+"')")} 

select a.area_code,b.area_name,b.union_area_name from fact_sale_index a
left join dim_region b
on a.area_code=b.area_code
where create_month='${year}'
and jcgm is not null 
and 1=1
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
and 1=1
${if(len(union_area)=0,""," and union_area_name in ('"+union_area+"')")} 

select decode(area_code,'11','10','22','20',area_code) area_code,
                   substr(sale_date,6,2) sale_date,
                   sum(no_tax_amount) no_tax_amount
              from DM_PURCHASE_GROUP_BY_AREA
            
             where substr(sale_date,1,4) ='${year}'
               --and gather in
              --     ('集采高毛', '集采贴牌', '集采品牌高毛', '集采专销')
                   and related_party_trnsaction<>'是'
             group by decode(area_code,'11','10','22','20',area_code),substr(sale_date,6,2)

select decode(area_code,'11','10','22','20',area_code) area_code,
                   substr(sale_date,6,2) sale_date,
                   sum(no_tax_amount) no_tax_amount
              from DM_PURCHASE_GROUP_BY_AREA
            
             where substr(sale_date,1,4) ='${year}'-1
               --and gather in
              --     ('集采高毛', '集采贴牌', '集采品牌高毛', '集采专销')
                   and related_party_trnsaction<>'是'
             group by decode(area_code,'11','10','22','20',area_code) ,substr(sale_date,6,2)
             order by 1,2

select decode(area_code,'11','10','22','20',area_code) area_code,
                   sum(no_tax_amount) no_tax_amount
              from DM_PURCHASE_GROUP_BY_AREA
            
             where substr(sale_date,1,4) ='${year}'
               and gather in
                   ('集采高毛', '集采贴牌', '集采品牌高毛', '集采专销')
                   and related_party_trnsaction<>'是'
             group by decode(area_code,'11','10','22','20',area_code) 

select decode(area_code,'11','10','22','20',area_code) area_code,
                   sum(no_tax_amount) no_tax_amount
              from DM_PURCHASE_GROUP_BY_AREA
            
             where substr(sale_date,1,4) ='${year}'-1
               and gather in
                   ('集采高毛', '集采贴牌', '集采品牌高毛', '集采专销')
                   and related_party_trnsaction<>'是'
             group by decode(area_code,'11','10','22','20',area_code) 

