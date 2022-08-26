select distinct b.BRAND_NAME as BRAND_NAME from (
select BRAND_NAME from FILL_USER_BRAND  a,FR_T_USER  b
where a.USER_ID=to_char(b.id) 
${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )  a,VBI_BRAND  b
where a.BRAND_NAME=b.BRAND_NAME 

select a.large_cate_code,
       a.large_cate_name,
       a.REGULAR_CODE,
       a.REGULAR_NAME,
       a.small_cate_code,
       a.small_cate_name,
       a.BRAND_NAME,
       a.MANAGE_REGION_NAME,
       a.SUB_COMPANY_NAME,
       a.ORG_DOMAIN_NAME,
       a.ORG_CODE,
       a.small_cate_code || a.ORG_CODE AS PK,
       a.ORG_NAME,
       --b.REAL_AMOUNT,
       NVL(b.REAL_AMOUNT,0) AS REAL_AMOUNT,
       b.ORGI_AMOUNT,
       e.TRANS_QTY,
       e.TRANS_AMOUNT,
       b.REAL_PRICE,
       b.REAL_QTY,
       b.SHOP_REAL_AMOUNT,
       c.STOCK_QTY,
       c.STOCK_AMOUNT,
       c.STOCK_PRICE,
    decode(b.ORGI_AMOUNT,0,'',   c.STOCK_AMOUNT / b.ORGI_AMOUNT) CYCLE,
       d.REAL_QTY ON_QTY,
       d.VALID_AMOUNT,
       f.REAL_QTY LAST_WEEK_REAL_QTY,
       f.REAL_AMOUNT LAST_WEEK_REAL_AMOUNT,
       g.REAL_QTY LAST_YEAR_REAL_QTY,
       g.REAL_AMOUNT LAST_YEAR_REAL_AMOUNT
  from (select c.large_cate_code,
               c.large_cate_name,
               c.REGULAR_CODE,
               c.REGULAR_NAME,
               a.small_cate_code,
               c.small_cate_name,
               b.BRAND_NAME,
               b.MANAGE_REGION_NAME,
               b.SUB_COMPANY_NAME,
               b.ORG_DOMAIN_NAME,
               b.ORG_CODE,
               b.ORG_NAME
          from FACT_SALE_SMALL_WEEK a,
               DIM_SHOP b,
               FACT_S_SALE_SHOP_WEEK e,
               DIM_ITEM c,
               (select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and a.POST in (select POST FROM FILL_POST)
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.DOMAIN
                   and a.POST in ('督导')
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.AD
                   and a.POST in ('城市经理')) f
         where a.WEEK_ALL = '${WEEK_ALL}'
           and e.WEEK_ALL = a.WEEK_ALL
           AND (a.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
           AND (e.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR e.CURRENCY IS NULL", "") })
        
         ${if(len(SMALL_CATE_CODE) = 0,
                    "",
                    " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
         ${if(len(LARGE_CATE_CODE) = 0,
                    "",
                    " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
         ${if(len(BRAND_NAME) = 0,
                    "",
                    " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
         ${if(len(SUB_COMPANY_NAME) = 0,
                    "",
                    " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
         ${if(len(ATTRI_MANAGE_REGION) = 0,
                    "",
                    " AND b.ATTRI_MANAGE_REGION in('" + ATTRI_MANAGE_REGION + "')") }
         ${if(len(ORG_CODE) = 0,
                    "",
                    " AND b.ORG_CODE in('" + ORG_CODE + "')")
         }
           and a.SMALL_CATE_CODE = c.SMALL_CATE_CODE
           and a.ORG_CODE = b.ORG_CODE
           and a.ORG_CODE = e.ORG_CODE
           and a.ORG_CODE = f.ORG_CODE
        union
        select c.large_cate_code,
               c.large_cate_name,
               c.REGULAR_CODE,
               c.REGULAR_NAME,
               a.small_cate_code,
               c.small_cate_name,
               b.BRAND_NAME,
               b.MANAGE_REGION_NAME,
               b.SUB_COMPANY_NAME,
               b.ORG_DOMAIN_NAME,
               b.ORG_CODE,
               b.ORG_NAME
          from FACT_SALE_SMALL_WEEK a,
               DIM_SHOP b,
               FACT_S_SALE_SHOP_WEEK e,
               DIM_ITEM c,
               (select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and a.POST in (select POST FROM FILL_POST)
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.DOMAIN
                   and a.POST in ('督导')
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.AD
                   and a.POST in ('城市经理')) f
         where a.WEEK_ALL = '${WEEK_ALL}' - 52
           and e.WEEK_ALL = a.WEEK_ALL
           AND (a.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
           AND (e.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR e.CURRENCY IS NULL", "") })
        
         ${if(len(SMALL_CATE_CODE) = 0,
                    "",
                    " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
         ${if(len(LARGE_CATE_CODE) = 0,
                    "",
                    " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
         ${if(len(BRAND_NAME) = 0,
                    "",
                    " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
         ${if(len(SUB_COMPANY_NAME) = 0,
                    "",
                    " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
         ${if(len(ATTRI_MANAGE_REGION) = 0,
                    "",
                    " AND b.ATTRI_MANAGE_REGION in('" + ATTRI_MANAGE_REGION + "')") }
         ${if(len(ORG_CODE) = 0,
                    "",
                    " AND b.ORG_CODE in('" + ORG_CODE + "')")
         }
           and a.SMALL_CATE_CODE = c.SMALL_CATE_CODE
           and a.ORG_CODE = b.ORG_CODE
           and a.ORG_CODE = e.ORG_CODE
           and a.ORG_CODE = f.ORG_CODE
        union
        select c.large_cate_code,
               c.large_cate_name,
               c.REGULAR_CODE,
               c.REGULAR_NAME,
               a.small_cate_code,
               c.small_cate_name,
               b.BRAND_NAME,
               b.MANAGE_REGION_NAME,
               b.SUB_COMPANY_NAME,
               b.ORG_DOMAIN_NAME,
               b.ORG_CODE,
               b.ORG_NAME
          from FACT_SALE_SMALL_WEEK a,
               DIM_SHOP b,
               FACT_S_SALE_SHOP_WEEK e,
               DIM_ITEM c,
               (select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and a.POST in (select POST FROM FILL_POST)
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.DOMAIN
                   and a.POST in ('督导')
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.AD
                   and a.POST in ('城市经理')) f
         where a.WEEK_ALL = '${WEEK_ALL}'
           and e.WEEK_ALL = a.WEEK_ALL - 1
           AND (a.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
           AND (e.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR e.CURRENCY IS NULL", "") })
        
         ${if(len(SMALL_CATE_CODE) = 0,
                    "",
                    " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
         ${if(len(LARGE_CATE_CODE) = 0,
                    "",
                    " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
         ${if(len(BRAND_NAME) = 0,
                    "",
                    " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
         ${if(len(SUB_COMPANY_NAME) = 0,
                    "",
                    " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
         ${if(len(ATTRI_MANAGE_REGION) = 0,
                    "",
                    " AND b.ATTRI_MANAGE_REGION in('" + ATTRI_MANAGE_REGION + "')") }
         ${if(len(ORG_CODE) = 0,
                    "",
                    " AND b.ORG_CODE in('" + ORG_CODE + "')")
         }
           and a.SMALL_CATE_CODE = c.SMALL_CATE_CODE
           and a.ORG_CODE = b.ORG_CODE
           and a.ORG_CODE = e.ORG_CODE
           and a.ORG_CODE = f.ORG_CODE
        union
        select c.large_cate_code,
               c.large_cate_name,
               c.REGULAR_CODE,
               c.REGULAR_NAME,
               a.small_cate_code,
               c.small_cate_name,
               b.BRAND_NAME,
               b.MANAGE_REGION_NAME,
               b.SUB_COMPANY_NAME,
               b.ORG_DOMAIN_NAME,
               b.ORG_CODE,
               b.ORG_NAME
        
          from FACT_STOCK_SMALL a,
               DIM_SHOP b,
               DIM_ITEM c,
               (select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and a.POST in (select POST FROM FILL_POST)
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.DOMAIN
                   and a.POST in ('督导')
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.AD
                   and a.POST in ('城市经理')) f
        
         where a.CREATE_DATE =
               to_date('2010-12-26', 'yyyy-mm-dd') +'${WEEK_ALL}' * 7
           and a.ORG_CODE = b.ORG_CODE
           and a.ORG_CODE = f.ORG_CODE
           AND (a.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
           and a.SMALL_CATE_CODE = c.small_cate_code
         ${if(len(SMALL_CATE_CODE) = 0,
                    "",
                    " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
         ${if(len(LARGE_CATE_CODE) = 0,
                    "",
                    " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
         ${if(len(BRAND_NAME) = 0,
                    "",
                    " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
         ${if(len(SUB_COMPANY_NAME) = 0,
                    "",
                    " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
         ${if(len(ATTRI_MANAGE_REGION) = 0,
                    "",
                    " AND b.ATTRI_MANAGE_REGION in('" + ATTRI_MANAGE_REGION + "')") }
         ${if(len(ORG_CODE) = 0,
                    "",
                    " AND b.ORG_CODE in('" + ORG_CODE + "')") }
        union
        select c.large_cate_code,
               c.large_cate_name,
               c.REGULAR_CODE,
               c.REGULAR_NAME,
               c.small_cate_code,
               c.small_cate_name,
               b.BRAND_NAME,
               b.MANAGE_REGION_NAME,
               b.SUB_COMPANY_NAME,
               b.ORG_DOMAIN_NAME,
               b.ORG_CODE,
               b.ORG_NAME
          from FACT_ON_PASSAGE_ITEM a,
               DIM_SHOP b,
               DIM_ITEM_INFO_ALL c,
               (select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and a.POST in (select POST FROM FILL_POST)
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.DOMAIN
                   and a.POST in ('督导')
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.AD
                   and a.POST in ('城市经理')) f
        
         where a.CREATE_DATE = to_char(to_date('2010-12-26', 'yyyy-mm-dd') + '${WEEK_ALL}' * 7, 'yyyy-mm-dd')
           AND (a.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
           AND (c.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR c.CURRENCY IS NULL", "") })
           and a.ITEM_ID = c.ITEM_ID
           and a.ORG_CODE = b.ORG_CODE
           and a.ORG_CODE = f.ORG_CODE
         ${if(len(SMALL_CATE_CODE) = 0,
                    "",
                    " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
         ${if(len(LARGE_CATE_CODE) = 0,
                    "",
                    " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
         ${if(len(BRAND_NAME) = 0,
                    "",
                    " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
         ${if(len(SUB_COMPANY_NAME) = 0,
                    "",
                    " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
         ${if(len(ATTRI_MANAGE_REGION) = 0,
                    "",
                    " AND b.ATTRI_MANAGE_REGION in('" + ATTRI_MANAGE_REGION + "')") }
         ${if(len(ORG_CODE) = 0,
                    "",
                    " AND b.ORG_CODE in('" + ORG_CODE + "')") }
        union
        select c.large_cate_code,
               c.large_cate_name,
               c.REGULAR_CODE,
               c.REGULAR_NAME,
               c.small_cate_code,
               c.small_cate_name,
               b.BRAND_NAME,
               b.MANAGE_REGION_NAME,
               b.SUB_COMPANY_NAME,
               b.ORG_DOMAIN_NAME,
               b.ORG_CODE,
               b.ORG_NAME
          from FACT_ON_SMALL_WEEK a,
               DIM_SHOP b,
               DIM_ITEM c,
               (select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and a.POST in (select POST FROM FILL_POST)
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.DOMAIN
                   and a.POST in ('督导')
                union
                select distinct c.ORG_CODE
                  from FILL_USER_POST   a,
                       FR_T_USER b,
                       DIM_S_SHOP       c
                 where TO_CHAR(B.ID) = a.USER_ID
                   and b.username = '${fr_username}'
                   and TO_CHAR(B.ID) = c.AD
                   and a.POST in ('城市经理')) f
        
         where a.WEEK_ALL = '${WEEK_ALL}'
           and a.ORG_CODE = b.ORG_CODE
           and a.ORG_CODE = f.ORG_CODE
           and a.SMALL_CATE_CODE = c.small_cate_code
           AND (a.CURRENCY = '${currency}'
                ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
         ${if(len(SMALL_CATE_CODE) = 0,
                    "",
                    " AND a.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
         ${if(len(LARGE_CATE_CODE) = 0,
                    "",
                    " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
         ${if(len(BRAND_NAME) = 0,
                    "",
                    " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
         ${if(len(SUB_COMPANY_NAME) = 0,
                    "",
                    " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
         ${if(len(ATTRI_MANAGE_REGION) = 0,
                    "",
                    " AND b.ATTRI_MANAGE_REGION in('" + ATTRI_MANAGE_REGION + "')") }
         ${if(len(ORG_CODE) = 0,
                    "",
                    " AND b.ORG_CODE in('" + ORG_CODE + "')") }) a
  left join (select c.large_cate_code,
                    c.large_cate_name,
                    c.REGULAR_CODE,
                    c.REGULAR_NAME,
                    a.small_cate_code,
                    c.small_cate_name,
                    b.BRAND_NAME,
                    b.MANAGE_REGION_NAME,
                    b.SUB_COMPANY_NAME,
                    b.ORG_DOMAIN_NAME,
                    b.ORG_CODE,
                    b.ORG_NAME,
                    a.REAL_AMOUNT,
                    a.ORGI_AMOUNT,
                    a.TRANS_AMOUNT,
           decode(a.REAL_QTY,0,'',         (a.REAL_AMOUNT / a.REAL_QTY) )REAL_PRICE,
                    a.REAL_QTY,
                    e.REAL_AMOUNT SHOP_REAL_AMOUNT
               from FACT_SALE_SMALL_WEEK  a,
                    DIM_SHOP              b,
                    FACT_S_SALE_SHOP_WEEK e,
                    DIM_ITEM              c
             
              where a.WEEK_ALL = '${WEEK_ALL}'
                and e.WEEK_ALL = a.WEEK_ALL
                AND (a.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
                AND (e.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR e.CURRENCY IS NULL", "") })
              ${if(len(SMALL_CATE_CODE) = 0,
                         "",
                         " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
              ${if(len(LARGE_CATE_CODE) = 0,
                         "",
                         " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
              ${if(len(BRAND_NAME) = 0,
                         "",
                         " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
              ${if(len(SUB_COMPANY_NAME) = 0,
                         "",
                         " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
              ${if(len(ATTRI_MANAGE_REGION) = 0,
                         "",
                         " AND b.ATTRI_MANAGE_REGION in('" +
                          ATTRI_MANAGE_REGION + "')") }
              ${if(len(ORG_CODE) = 0,
                         "",
                         " AND b.ORG_CODE in('" + ORG_CODE + "')")
              }
                and a.SMALL_CATE_CODE = c.SMALL_CATE_CODE
                and a.ORG_CODE = b.ORG_CODE
                and a.ORG_CODE = e.ORG_CODE) b
    on a.SMALL_CATE_CODE = b.SMALL_CATE_CODE
   and a.ORG_CODE = b.ORG_CODE
  left join (select a.ORG_CODE,
                    a.SMALL_CATE_CODE,
                    a.STOCK_QTY,
                    a.STOCK_AMOUNT,
                decode(a.STOCK_QTY,0,'',    a.STOCK_AMOUNT / a.STOCK_QTY) STOCK_PRICE
               from FACT_STOCK_SMALL a, DIM_SHOP b, DIM_ITEM c
             
              where a.CREATE_DATE =
                    to_date('2010-12-26', 'yyyy-mm-dd') + '${WEEK_ALL}' * 7
                and a.ORG_CODE = b.ORG_CODE
                AND (a.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
                and a.SMALL_CATE_CODE = c.small_cate_code
              ${if(len(SMALL_CATE_CODE) = 0,
                         "",
                         " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
              ${if(len(LARGE_CATE_CODE) = 0,
                         "",
                         " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
              ${if(len(BRAND_NAME) = 0,
                         "",
                         " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
              ${if(len(SUB_COMPANY_NAME) = 0,
                         "",
                         " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
              ${if(len(ATTRI_MANAGE_REGION) = 0,
                         "",
                         " AND b.ATTRI_MANAGE_REGION in('" +
                          ATTRI_MANAGE_REGION + "')") }
              ${if(len(ORG_CODE) = 0,
                         "",
                         " AND b.ORG_CODE in('" + ORG_CODE + "')") }) c
    on a.SMALL_CATE_CODE = c.SMALL_CATE_CODE
   and a.ORG_CODE = c.ORG_CODE
  left join (select c.small_cate_code,
                    a.ORG_CODE,
                    sum(REAL_QTY) REAL_QTY,
                    sum(VALID_AMOUNT) VALID_AMOUNT
               from FACT_ON_PASSAGE_ITEM a,
                    DIM_SHOP             b,
                    DIM_ITEM_INFO_ALL    c
             
              where a.CREATE_DATE = to_char(to_date('2010-12-26', 'yyyy-mm-dd') + '${WEEK_ALL}' * 7, 'yyyy-mm-dd')
                AND (a.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
                AND (c.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR c.CURRENCY IS NULL", "") })
                and a.ITEM_ID = c.ITEM_ID
                and a.ORG_CODE = b.ORG_CODE
              ${if(len(SMALL_CATE_CODE) = 0,
                         "",
                         " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
              ${if(len(LARGE_CATE_CODE) = 0,
                         "",
                         " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
              ${if(len(BRAND_NAME) = 0,
                         "",
                         " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
              ${if(len(SUB_COMPANY_NAME) = 0,
                         "",
                         " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
              ${if(len(ATTRI_MANAGE_REGION) = 0,
                         "",
                         " AND b.ATTRI_MANAGE_REGION in('" +
                          ATTRI_MANAGE_REGION + "')") }
              ${if(len(ORG_CODE) = 0,
                         "",
                         " AND b.ORG_CODE in('" + ORG_CODE + "')")} 
              group by c.small_cate_code, a.ORG_CODE
             
             ) d
    on a.SMALL_CATE_CODE = d.SMALL_CATE_CODE
   and a.ORG_CODE = d.ORG_CODE
  left join (select a.small_cate_code,
                    a.small_cate_name,
                    b.ORG_CODE,
                    a.REAL_QTY        TRANS_QTY,
                    a.REAL_AMOUNT     TRANS_AMOUNT
               from FACT_ON_SMALL_WEEK a, DIM_SHOP b, DIM_ITEM c
             
              where a.WEEK_ALL = '${WEEK_ALL}'
                and a.ORG_CODE = b.ORG_CODE
                and a.small_cate_code = c.small_cate_code
                AND (a.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
              ${if(len(SMALL_CATE_CODE) = 0,
                         "",
                         " AND a.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
              ${if(len(LARGE_CATE_CODE) = 0,
                         "",
                         " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
              ${if(len(BRAND_NAME) = 0,
                         "",
                         " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
              ${if(len(SUB_COMPANY_NAME) = 0,
                         "",
                         " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
              ${if(len(ATTRI_MANAGE_REGION) = 0,
                         "",
                         " AND b.ATTRI_MANAGE_REGION in('" +
                          ATTRI_MANAGE_REGION + "')") }
              ${if(len(ORG_CODE) = 0,
                         "",
                         " AND b.ORG_CODE in('" + ORG_CODE + "')") }) e
    on a.SMALL_CATE_CODE = e.SMALL_CATE_CODE
   and a.ORG_CODE = e.ORG_CODE
  left join (select c.large_cate_code,
                    c.large_cate_name,
                    c.REGULAR_CODE,
                    c.REGULAR_NAME,
                    a.small_cate_code,
                    c.small_cate_name,
                    b.BRAND_NAME,
                    b.MANAGE_REGION_NAME,
                    b.SUB_COMPANY_NAME,
                    b.ORG_DOMAIN_NAME,
                    b.ORG_CODE,
                    b.ORG_NAME,
                    a.REAL_AMOUNT,
                    a.ORGI_AMOUNT,
                    a.TRANS_AMOUNT,
             decode(a.REAL_QTY,0,'',       (a.REAL_AMOUNT / a.REAL_QTY)) REAL_PRICE,
                    a.REAL_QTY,
                    e.REAL_AMOUNT SHOP_REAL_AMOUNT
               from FACT_SALE_SMALL_WEEK  a,
                    DIM_SHOP              b,
                    FACT_S_SALE_SHOP_WEEK e,
                    DIM_ITEM              c
              where a.WEEK_ALL = '${WEEK_ALL}' - 1
                and e.WEEK_ALL = a.WEEK_ALL
                AND (a.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
                AND (e.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR e.CURRENCY IS NULL", "") })
              ${if(len(SMALL_CATE_CODE) = 0,
                         "",
                         " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
              ${if(len(LARGE_CATE_CODE) = 0,
                         "",
                         " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
              ${if(len(BRAND_NAME) = 0,
                         "",
                         " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
              ${if(len(SUB_COMPANY_NAME) = 0,
                         "",
                         " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
              ${if(len(ATTRI_MANAGE_REGION) = 0,
                         "",
                         " AND b.ATTRI_MANAGE_REGION in('" +
                          ATTRI_MANAGE_REGION + "')") }
              ${if(len(ORG_CODE) = 0,
                         "",
                         " AND b.ORG_CODE in('" + ORG_CODE + "')")
              }
                and a.SMALL_CATE_CODE = c.SMALL_CATE_CODE
                and a.ORG_CODE = b.ORG_CODE
                and a.ORG_CODE = e.ORG_CODE) f
    on a.SMALL_CATE_CODE = f.SMALL_CATE_CODE
   and a.ORG_CODE = f.ORG_CODE
  left join (select c.large_cate_code,
                    c.large_cate_name,
                    c.REGULAR_CODE,
                    c.REGULAR_NAME,
                    a.small_cate_code,
                    c.small_cate_name,
                    b.BRAND_NAME,
                    b.MANAGE_REGION_NAME,
                    b.SUB_COMPANY_NAME,
                    b.ORG_DOMAIN_NAME,
                    b.ORG_CODE,
                    b.ORG_NAME,
                    a.REAL_AMOUNT,
                    a.ORGI_AMOUNT,
                    a.TRANS_AMOUNT,
        decode(a.REAL_QTY,0,'',            (a.REAL_AMOUNT / a.REAL_QTY)) REAL_PRICE,
                    a.REAL_QTY,
                    e.REAL_AMOUNT SHOP_REAL_AMOUNT
               from FACT_SALE_SMALL_WEEK  a,
                    DIM_SHOP              b,
                    FACT_S_SALE_SHOP_WEEK e,
                    DIM_ITEM              c
             
              where a.WEEK_ALL =
                    (select LAST_WEEK_ALL
                       from DIM_DAY_START_END
                      where WEEK_ALL = '${WEEK_ALL}')
                and e.WEEK_ALL = a.WEEK_ALL
                AND (a.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR a.CURRENCY IS NULL", "") })
                AND (e.CURRENCY = '${currency}'
                     ${IF(currency = '人民币', "OR e.CURRENCY IS NULL", "") })
              ${if(len(SMALL_CATE_CODE) = 0,
                         "",
                         " AND c.SMALL_CATE_CODE in('" + SMALL_CATE_CODE + "')") }
              ${if(len(LARGE_CATE_CODE) = 0,
                         "",
                         " AND c.LARGE_CATE_CODE in ('" + LARGE_CATE_CODE + "')") }
              ${if(len(BRAND_NAME) = 0,
                         "",
                         " AND b.BRAND_NAME ='" + BRAND_NAME + "'") }
              ${if(len(SUB_COMPANY_NAME) = 0,
                         "",
                         " AND b.SUB_COMPANY_NAME ='" + SUB_COMPANY_NAME + "'") }
              ${if(len(ATTRI_MANAGE_REGION) = 0,
                         "",
                         " AND b.ATTRI_MANAGE_REGION in('" +
                          ATTRI_MANAGE_REGION + "')") }
              ${if(len(ORG_CODE) = 0,
                         "",
                         " AND b.ORG_CODE in('" + ORG_CODE + "')")
              }
                and a.SMALL_CATE_CODE = c.SMALL_CATE_CODE
                and a.ORG_CODE = b.ORG_CODE
                and a.ORG_CODE = e.ORG_CODE) g
    on a.SMALL_CATE_CODE = g.SMALL_CATE_CODE
   and a.ORG_CODE = g.ORG_CODE
 order by a.SMALL_CATE_CODE, NVL(b.REAL_AMOUNT,0) desc

select DISTINCT SUB_COMPANY_NAME from DIM_S_SHOP 
WHERE 1=1
${if(len(BRAND_NAME)==0,""," AND BRAND_NAME ='"+BRAND_NAME+"'")}
and SUB_COMPANY_NAME in (select SUB_COMPANY_NAME from FILL_USER_BRAND  a,FR_T_USER     b
where a.USER_ID=to_char(b.id) and b.username='${fr_username}')

select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST   a,
 FR_T_USER   b,DIM_S_SHOP   c
where b.ID=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST   a,
 FR_T_USER   b,DIM_S_SHOP   c
where b.ID=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
and b.ID=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')union 
select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST   a,
 FR_T_USER   b,DIM_S_SHOP   c
where b.ID=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
and b.ID=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')




select * from (
select distinct 
         c.large_cate_code,
         c.large_cate_code||c.large_cate_name   large_cate_name 
      from 
        FILL_USER_POST   a,
         FR_T_USER   b,
        DIM_ITEM   c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST not in('买手','买手助理','大买手','商品AD')
      union 
      select distinct 
         d.large_cate_code,
         d.large_cate_code||d.large_cate_name   large_cate_name  
      from 
        FILL_USER_POST   a,
         FR_T_USER   b,
        DIM_SMALL_BUYER   c,
        DIM_ITEM   d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST in('买手','买手助理')
      and c.STAFF_POSITION in ('买手','大买手')
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
  
      union 
      select distinct 
        d.large_cate_code,
         d.large_cate_code||d.large_cate_name   large_cate_name 
      from 
        FILL_USER_POST   a,
         FR_T_USER   b,
        DIM_SMALL_BUYER   c,
        DIM_ITEM   d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST ='商品AD'
      and c.STAFF_POSITION ='商品AD'
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
)   a where large_cate_code in 
(
select distinct 
  large_cate_code
from 
DIM_ITEM_INFO_ALL 
where BRAND_NAME='${BRAND_NAME}'
)
order by large_cate_code

-- 大类维度



select distinct 
        c.small_cate_code,
        concat(c.small_cate_code,c.small_cate_name)   small_cate_name 
      from 
        FILL_USER_POST   a,
         FR_T_USER   b,
        DIM_ITEM   c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST not in('买手','买手助理','大买手','商品AD')
      ${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
      union 
      select distinct 
        c.small_cate_code,
        concat(c.small_cate_code,c.small_cate_name)   small_cate_name  
      from 
        FILL_USER_POST   a,
         FR_T_USER   b,
        DIM_SMALL_BUYER   c,
        DIM_ITEM   d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST in('买手','买手助理')
      and c.STAFF_POSITION in ('买手','大买手')
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
      ${if(len(LARGE_CATE_CODE)=0,""," AND d.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
      union 
      select distinct 
        c.small_cate_code,
        concat(c.small_cate_code,c.small_cate_name)   small_cate_name 
      from 
        FILL_USER_POST   a,
         FR_T_USER   b,
        DIM_SMALL_BUYER   c,
        DIM_ITEM   d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST ='商品AD'
      and c.STAFF_POSITION ='商品AD'
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
      ${if(len(LARGE_CATE_CODE)=0,""," AND d.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}


-- 小类维度

select sum(STOCK_QTY) as STOCK_QTY ,sum(STOCK_AMOUNT) as STOCK_AMOUNT ,b.LARGE_CATE_CODE
from FACT_STOCK_GENERAL  a,DIM_ITEM_INFO_ALL  b

 where a.CREATE_DATE=to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7
 and a.ITEM_ID=b.ITEM_ID
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
 AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
 ${if(len(LARGE_CATE_CODE)=0,""," AND b.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
 group by b.LARGE_CATE_CODE

select small_cate_code,sum(STOCK_QTY) as STOCK_QTY ,sum(STOCK_AMOUNT) as STOCK_AMOUNT
from 	FACT_STOCK_GENERAL  a,DIM_ITEM_INFO_ALL  b

 where a.CREATE_DATE=to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7
 and a.ITEM_ID=b.ITEM_ID
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
 ${if(len(LARGE_CATE_CODE)=0,""," AND b.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
  ${if(len(SMALL_CATE_CODE)=0,""," AND b.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")}
 group by small_cate_code

select a.small_cate_code,a.ORG_CODE,a.SKU from FACT_S_SALE_SMALL_SKU_WEEK  a,DIM_SHOP  b,DIM_ITEM  c

 where a.WEEK_ALL='${WEEK_ALL}' and a.small_cate_code=c.small_cate_code and a.ORG_CODE=b.ORG_CODE
-- AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")} --and a.org_code='${org_code}'
${if(len(ORG_CODE)=0,""," AND a.ORG_CODE ='"+ORG_CODE+"'")}

select a.small_cate_code,a.ORG_CODE,a.SKU from FACT_S_STOCK_SMALL_SKU  a,DIM_SHOP  b,DIM_ITEM  c

 where a.CREATE_DATE=to_char(to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7,'yyyy-mm-dd hh24:mi:ss')
 and a.small_cate_code=c.small_cate_code and a.ORG_CODE=b.ORG_CODE
-- AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")} --AND a.ORG_CODE='${ORG_CODE}'
${if(len(ORG_CODE)=0,""," AND a.ORG_CODE ='"+ORG_CODE+"'")}

select c.small_cate_code,count(1) as shop_num
 from FACT_SALE_SMALL_WEEK as a,DIM_SHOP as b,
DIM_ITEM as c

 where a.WEEK_ALL='${WEEK_ALL}'
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.SMALL_CATE_CODE=c.SMALL_CATE_CODE and a.ORG_CODE=b.ORG_CODE group by a.SMALL_CATE_CODE

select c.small_cate_code,count(1) as shop_num
 from FACT_SALE_SMALL_WEEK as a,DIM_SHOP as b,
DIM_ITEM as c

 where a.WEEK_ALL='${WEEK_ALL}'-1
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.SMALL_CATE_CODE=c.SMALL_CATE_CODE and a.ORG_CODE=b.ORG_CODE group by a.SMALL_CATE_CODE

select c.small_cate_code,count(1) as shop_num
 from FACT_SALE_SMALL_WEEK as a,DIM_SHOP as b,
DIM_ITEM as c

 where a.WEEK_ALL=(select LAST_WEEK_ALL from DIM_DAY_START_END where WEEK_ALL='${WEEK_ALL}')
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.SMALL_CATE_CODE=c.SMALL_CATE_CODE and a.ORG_CODE=b.ORG_CODE group by a.SMALL_CATE_CODE

select a.ORG_CODE,a.SALE_DAYS from DIM_SHOP_DAYS_WEEK  a,DIM_SHOP  b
where a.ORG_CODE=b.ORG_CODE and a.WEEK_ALL='${WEEK_ALL}'-1
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select c.large_cate_code,c.large_cate_name,c.REGULAR_CODE,c.REGULAR_NAME,a.small_cate_code,c.small_cate_name,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME,a.REAL_AMOUNT,a.ORGI_AMOUNT,a.TRANS_AMOUNT,
(a.REAL_AMOUNT/a.REAL_QTY) as REAL_PRICE,a.REAL_QTY,e.REAL_AMOUNT as SHOP_REAL_AMOUNT
 from FACT_SALE_SMALL_WEEK as a,DIM_SHOP as b,FACT_S_SALE_SHOP_WEEK as e,
DIM_ITEM as c

 where a.WEEK_ALL='${WEEK_ALL}'-1  and 
 e.WEEK_ALL=a.WEEK_ALL
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.SMALL_CATE_CODE=c.SMALL_CATE_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE

select a.ORG_CODE,a.SALE_DAYS from DIM_SHOP_SALE_DAYS  a,DIM_SHOP  b
where a.ORG_CODE=b.ORG_CODE and a.CREATE_MONTH=to_char(to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7,'yyyy-mm')
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select c.large_cate_code,c.large_cate_name,c.REGULAR_CODE,c.REGULAR_NAME,a.small_cate_code,c.small_cate_name,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME,a.REAL_AMOUNT,a.ORGI_AMOUNT,a.TRANS_AMOUNT,
(a.REAL_AMOUNT/a.REAL_QTY) as REAL_PRICE,a.REAL_QTY,e.REAL_AMOUNT as SHOP_REAL_AMOUNT
 from FACT_SALE_SMALL_WEEK as a,DIM_SHOP as b,FACT_S_SALE_SHOP_WEEK as e,
DIM_ITEM as c

 where a.WEEK_ALL=(select LAST_WEEK_ALL from DIM_DAY_START_END where WEEK_ALL='${WEEK_ALL}')  and 
 e.WEEK_ALL=a.WEEK_ALL
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.SMALL_CATE_CODE=c.SMALL_CATE_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE

select a.ORG_CODE,a.SALE_DAYS from DIM_SHOP_DAYS_WEEK  a,DIM_SHOP  b
where a.ORG_CODE=b.ORG_CODE and a.WEEK_ALL='${WEEK_ALL}'
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.org_code='${org_code}'

select c.large_cate_code,c.large_cate_name,c.REGULAR_CODE,c.REGULAR_NAME,c.small_cate_code,c.small_cate_name,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME
 from FACT_ON_SMALL_WEEK as a,DIM_SHOP as b,DIM_ITEM as c

 where a.WEEK_ALL='${WEEK_ALL}'
 and a.ORG_CODE=b.ORG_CODE
 and a.SMALL_CATE_CODE=c.small_cate_code
${if(len(SMALL_CATE_CODE)=0,""," AND a.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

SELECT WEEK_ALL,MIN(DAY_ID) AS DAY_ID
FROM DIM_DAY
group by WEEK_ALL 
order by WEEK_ALL

select  min(DAY_ID) AS DAY_ID from DIM_DAY where WEEK_ALL=(
select WEEK_ALL from DIM_DAY where DAY_SHORT_DESC =trunc(sysdate)-7)

select a.small_cate_code,a.ORG_CODE,a.SKU from FACT_S_SALE_80_SMALL_SKU  a,DIM_SHOP  b,DIM_ITEM  c

 where a.WEEK_ALL='${WEEK_ALL}' and a.small_cate_code=c.small_cate_code and a.ORG_CODE=b.ORG_CODE

${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")} --and a.org_code='${org_code}'
${if(len(ORG_CODE)=0,""," AND a.ORG_CODE ='"+ORG_CODE+"'")}

select a.small_cate_code,a.small_cate_name,b.ORG_CODE,a.REAL_QTY as TRANS_QTY,a.REAL_AMOUNT as TRANS_AMOUNT
 from FACT_ON_SMALL_WEEK as a,DIM_SHOP as b,DIM_ITEM as c

 where a.WEEK_ALL='${WEEK_ALL}'
 and a.ORG_CODE=b.ORG_CODE
and a.small_cate_code=c.small_cate_code
${if(len(SMALL_CATE_CODE)=0,""," AND a.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select c.large_cate_code,c.large_cate_name,c.REGULAR_CODE,c.REGULAR_NAME,a.small_cate_code,c.small_cate_name,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME,a.REAL_AMOUNT,a.ORGI_AMOUNT,a.TRANS_AMOUNT,
DECODE(a.REAL_QTY,0,'',(a.REAL_AMOUNT / a.REAL_QTY) )  as REAL_PRICE,a.REAL_QTY,e.REAL_AMOUNT as SHOP_REAL_AMOUNT
 from FACT_SALE_SMALL_MONTH  a,DIM_SHOP  b,FACT_S_SALE_SHOP_MONTH  e,
DIM_ITEM  c

 where a.CREATE_MONTH=to_char((to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7),'yyyy-mm')  
 and e.CREATE_MONTH=a.CREATE_MONTH
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.SMALL_CATE_CODE=c.SMALL_CATE_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE

select c.large_cate_code,c.large_cate_name,c.REGULAR_CODE,c.REGULAR_NAME,a.small_cate_code,c.small_cate_name,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME,a.REAL_AMOUNT,a.ORGI_AMOUNT,a.TRANS_AMOUNT,
decode(a.REAL_QTY,0,'',(a.REAL_AMOUNT/a.REAL_QTY)) as REAL_PRICE,a.REAL_QTY,e.REAL_AMOUNT as SHOP_REAL_AMOUNT
 from FACT_SALE_SMALL_MONTH  a,DIM_SHOP  b,FACT_S_SALE_SHOP_MONTH  e,
DIM_ITEM  c

 where a.CREATE_MONTH=to_char(  add_months((to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7),-12)     ,'yyyy-mm')
 and  e.CREATE_MONTH=a.CREATE_MONTH
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(SMALL_CATE_CODE)=0,""," AND c.SMALL_CATE_CODE in('"+SMALL_CATE_CODE+"')")} 
${if(len(LARGE_CATE_CODE)=0,""," AND c.LARGE_CATE_CODE in ('"+LARGE_CATE_CODE+"')")}
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.SMALL_CATE_CODE=c.SMALL_CATE_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE

SELECT B.realname as AD,ORG_CODE FROM DIM_S_SHOP  A,FR_T_USER   B
WHERE 1=1
${if(len(BRAND_NAME)=0,""," AND BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and A.AD=B.id and a.org_code='${org_code}'

select id,username||realname as name from FR_T_USER 

select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
${IF(LEN(ATTRI_MANAGE_REGION)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
${IF(LEN(ATTRI_MANAGE_REGION)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
and b.ID=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union  
select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
${IF(LEN(ATTRI_MANAGE_REGION)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
and b.ID=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')


select * from VBI_CURRENCY

