select left(convert(int,b.CategoryCode),1)大分类,left(convert(int,b.CategoryCode),2)课分类,sum(zhcsku)综超,sum(bcsku)标超,sum(dsqsku)大社区,SUM(xsqsku)小社区,sum(bldsu)便利店 from 
tbaowkxgoods  a 
left JOIN
[000]A.tbgoods b on a.goodscode=b.goodscode
where deletebz=1 
group by left(convert(int,b.CategoryCode),1),left(convert(int,b.CategoryCode),2)
order by left(convert(int,b.CategoryCode),1),left(convert(int,b.CategoryCode),2)

