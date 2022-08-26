select left(fromDate,4)+'年' 年, 
right(left(fromDate,7),2)+'月' 月,cast(sum(cast(weight as float))/10000 as decimal(18,2)) 总重箱 from u8_salefrom WITH(NOLOCK)
left join u8_customer  on  cCusName = customer 
WHERE    left(cCusCode,2) not in ('10','2000') 
 and customer not like'%ZD%' and datediff(yy,fromDate,getdate())=2
group by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'
order by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'

select left(fromDate,4)+'年' 年, 
right(left(fromDate,7),2)+'月' 月,cast(sum(cast(weight as float))/10000 as decimal(18,2)) 总重箱 from u8_salefrom WITH(NOLOCK)
left join u8_customer  on  cCusName = customer 
WHERE    (left(cCusCode,2)  in ('10') 
 or customer  like'%ZD%') and datediff(yy,fromDate,getdate())=2
group by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'
order by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'

select left(fromDate,4)+'年' 年, 
right(left(fromDate,7),2)+'月' 月,cast(sum(cast(weight as float))/10000 as decimal(18,2)) 总重箱 from u8_salefrom WITH(NOLOCK)
left join u8_customer  on  cCusName = customer 
WHERE    left(cCusCode,2) not in ('10','2000') 
 and customer not like'%ZD%' and datediff(yy,fromDate,getdate())=1
group by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'
order by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'

select left(fromDate,4)+'年' 年, 
right(left(fromDate,7),2)+'月' 月,cast(sum(cast(weight as float))/10000 as decimal(18,2)) 总重箱 from u8_salefrom WITH(NOLOCK)
left join u8_customer  on  cCusName = customer 
WHERE    (left(cCusCode,2)  in ('10') 
 or customer  like'%ZD%') and datediff(yy,fromDate,getdate())=1
group by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'
order by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'

select left(fromDate,4)+'年' 年, 
right(left(fromDate,7),2)+'月' 月,cast(sum(cast(weight as float))/10000 as decimal(18,2)) 总重箱 from u8_salefrom WITH(NOLOCK)
left join u8_customer  on  cCusName = customer 
WHERE    left(cCusCode,2) not in ('10','2000') 
 and customer not like'%ZD%' and datediff(yy,fromDate,getdate())=0
group by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'
order by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'

select left(fromDate,4)+'年' 年, 
right(left(fromDate,7),2)+'月' 月,cast(sum(cast(weight as float))/10000 as decimal(18,2)) 总重箱 from u8_salefrom WITH(NOLOCK)
left join u8_customer  on  cCusName = customer 
WHERE    (left(cCusCode,2)  in ('10') 
 or customer  like'%ZD%') and datediff(yy,fromDate,getdate())=0
group by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'
order by left(fromDate,4)+'年' , right(left(fromDate,7),2)+'月'

