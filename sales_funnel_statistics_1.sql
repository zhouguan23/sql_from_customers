SELECT * FROM hr_salesman
where sales_parent is not null and sales_parent <> ''

SELECT count(com_id) quantity
FROM cust_company
where com_verified = 'valid' and com_verifier != 'bbs'
and com_status <> '无效' and year(com_recdate) = '${year}'

SELECT count(com_id) quantity
FROM cust_company
where com_verified = 'valid' and com_status = '跟进' and year(com_recdate) = '${year}'

SELECT count(com_id) quantity
FROM cust_company
where com_verified = 'valid' and com_status = '跟进'
and com_key = '是' and year(com_recdate) = '${year}'

SELECT count(opp_id) quantity
FROM cust_company,sale_opportunity
where com_verified = 'valid' and opp_verified = 'valid' and year(opp_recdate) = '${year}'
and com_id = opp_company
and opp_status not like '%签约' and opp_status not like '%失败'

SELECT count(com_id) quantity
FROM cust_company
where com_verified = 'valid' and com_status = '合作'
and year(com_recdate) = '${year}'

SELECT count(com_id) quantity
FROM cust_company
where com_verified = 'valid' and com_status = '合作'
and com_type = '软件公司' and year(com_recdate) = '${year}'

/*yuwh.20170213根据CRM-716添加该数据集*/
select count(com_id) AS quantity from cust_company 
where com_verified='valid'
and com_status='尚未联络'
and com_recdate<date_add(curdate(),interval -7 day)     /*7天之前创建的客户*/
and com_recdate>='2008-01-01'
and year(com_recdate) = '${year}'

/*yuwh.20170213根据CRM-716添加该数据集*/
SELECT count(com_id) quantity
FROM cust_company
where com_verified = 'valid'
and com_status = '尚未联络' 
and year(com_recdate) = '${year}'
and com_recdate>='2008-01-01'

