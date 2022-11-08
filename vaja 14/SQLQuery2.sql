--1. Iz tabele SalesLT.Customer izpi�i vse stranke, ki nimajo e-po�tnega naslova. Izpis naj bo v
--obliki (rezultat ima 124 vrstic).
select c.Title + c.LastName + c.FirstName as Stranka from SalesLT.Customer c where c.EmailAddress is null
--2. Iz tabele SalesLT.Product bi �eleli izpisati imena (Name) produktov, pri katerih se v imenu
--kategorije pojavlja 'Bike' (imamo Mountain Bike, Bike, Bike racks,�.). V rezultatu naj bo ime
--stolpca �Artikli� (re�itev ima 99 vrstic)
select p.Name as Artikli from SalesLT.Product p join SalesLT.ProductCategory c
on p.ProductCategoryID = c.ProductCategoryID
where c.Name like '%Bike%'
--3. Izpi�i imena (Name) in cene (ListPrice) 10% najdra�jih artiklov iz SalesLT.Product (31 vrstic)
select top 10 percent p.Name, p.ListPrice from SalesLT.Product p order by p.ListPrice desc
--4. Izpi�i ime star�evske kategorija (ParentProductCategoryName), ime kategorije
--(ProductCategoryName) in ime (Name) produkta iz tabele SalesLT.Product in iz pogleda
--SalesLT.vGetAllCategories. (re�itev ima 299 vrstic)
select c.ParentProductCategoryName, ProductCategoryName, p.Name
from SalesLT.Product p join SalesLT.vGetAllCategories c
on p.ProductCategoryID = c.ProductCategoryID
--5. V tabeli SalesLT.ProductCategory imamo podatke o kategorijah. Tabela je povezana sama s
--seboj, saj so v njej zapisani podatki o glavnih kategorijah (ParentProductCategoryID) in o
--podkategorijah (ProductCategoryName). Zna�ilno je, da imajo glavne kategorije vrednost
--ParentProductCategoryID enako NULL. Napi�i poizvedbo, ki vra�a ParentProductCategoryID,
--ProductCategoryID in Name iz tabele SalesLT.ProductCategory. Rezultat je oblike (ni v celoti)
select c.ParentProductCategoryID, c.ProductCategoryID, c.Name
from SalesLT.ProductCategory c join SalesLT.ProductCategory cc
on c.ParentProductCategoryID = cc.ProductCategoryID
--6. Izpi�ite imena (Name) in povpre�ne cene (UnitPrice) produkta iz tabele
--SalesLT.SalesOrderDetail, v izpisu naj bo tudi rang artikla od tistega z najvi�jo povpre�no
--ceno, do tistega z najni�jo povpre�no ceno.
select p.Name, avg(d.UnitPrice)
from SalesLT.SalesOrderDetail d join SalesLT.Product p
on d.ProductID = p.ProductID
group by p.name
order by avg(d.UnitPrice) desc
--7. Poi��i seznam strank v obliki Company (Contact Name), skupni prihodki za vsako stranko.
--Uporabi CTE, da poi��e� podatek TotalDue iz tabele SalesLT.SalesOrderHeader in podatke o
--stranki iz SalesLT.Customer, nato pa naredi poizvedbo po novi tabeli, tako da agregira� in
--sumira� podatke.
select * from SalesLT.Customer
go
with cteTabela (companyName, customerName, totalDue)
as (
	select c.CompanyName, (c.Title+' '+c.FirstName+' '+c.LastName+' '+c.Suffix), h.TotalDue
	from SalesLT.Customer c join SalesLT.SalesOrderHeader h
	on c.CustomerID = h.CustomerID
	where c.LastName is not null
)
select * from cteTabela
--8. Izpi�i koliko je produktov v posamezni kategoriji, v okviru kategorije pa �e v star�evski
--kategoriji in vseh artiklov skupaj. ( pomagaj si z nalogo 4., v kategoriji Bikes je tako 97
--artiklov, v Accessories 33,�, vseh skupaj je 299)