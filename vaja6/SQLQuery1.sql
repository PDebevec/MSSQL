--5. Napišite poizvedbo, ki vrne seznam imen podjetji in njihovo mesto v rangu, èe jih rangirate
--glede na najvišjo vrednost atributa TotalDue iz tabele SalesOrderHeader.
select c.FirstName, rank() over (order by TotalDue) as TotalDue from SalesLT.SalesOrderHeader h join SalesLT.Customer c on h.CustomerID = c.CustomerID
--6. Napišite poizvedbo, ki izpiše imena produktov in skupno vsoto izraèunano kot vsoto atributa
--LineTotal iz SalesOrderDetail tabele. Rezultat naj bo urejen po padajoèi vrednosti skupne vsote.
select p.Name, SUM(d.LineTotal) from SalesLT.SalesOrderDetail d join SalesLT.Product p on p.ProductID = d.ProductID group by p.Name
--7. Spremenite prejšnjo poizvedbo tako, da vkljuèuje samo tiste produkte, ki imajo atribut
--ListPrice veè kot 1000$.
select p.Name, SUM(d.LineTotal) as sumLineTotal from SalesLT.SalesOrderDetail d join SalesLT.Product p on p.ProductID = d.ProductID
where p.ListPrice > 1000
group by p.Name
--8. Spremenite prejšnjo poizvedbo, da bo vsebovala samo skupine, ki imajo skupno vrednost
--prodaje veèjo kot 20.000$.
select p.Name, SUM(d.LineTotal) from SalesLT.SalesOrderDetail d join SalesLT.Product p on p.ProductID = d.ProductID
group by p.Name having SUM(d.LineTotal) > 20000

--Podpoizvedbe
--iz soh izpiši id naroèila, datum naroèila in najvišja cena na tem naroèilu
select h.SalesOrderID, h.OrderDate, max(d.UnitPrice) as maxPrice
from SalesLT.SalesOrderHeader h join SalesLT.SalesOrderDetail d on h.SalesOrderID = d.SalesOrderID
group by h.SalesOrderID, h.OrderDate
--isto s podpoizvedbo
select h.SalesOrderID, h.OrderDate,
(select max(UnitPrice) from SalesLT.SalesOrderDetail d where d.SalesOrderID = d.SalesOrderID) as maxPrice
from SalesLT.SalesOrderHeader h

--poišèi vasa imena artiklov, ki imaoj isto listprice kot "touring tire tube"
select ListPrice from SalesLT.Product where name = 'Touring Tire Tube'

select name from SalesLT.Product
where ListPrice = (select ListPrice from SalesLT.Product where name = 'Touring Tire Tube')
--isto z join
select p.ListPrice from SalesLT.Product p join SalesLT.Product pr on p.ListPrice = pr.ListPrice where pr.Name = 'Touring Tire Tube'

--operator in, not in, any, all, exists
--izpiši vsa imena produktov v kategoriji 'Wheels'
select p.Name from SalesLT.Product p
where p.ProductCategoryID in (select ProductCategoryID from SalesLT.ProductCategory where Name = 'Wheels')
--not in 'Wheels'
select p.Name from SalesLT.Product p
where p.ProductCategoryID not in (select ProductCategoryID from SalesLT.ProductCategory where Name = 'Wheels')

--izeri imena produktov kjer je cena veèja od minimalne cene v kategoriji 14
select Name from SalesLT.Product where ListPrice >= (
select MIN(p.ListPrice) from SalesLT.Product p
where ProductCategoryID = 14)
--any (èe veè podatkov uporabi any za katero koli (podobno or ||))
select Name from SalesLT.Product where ListPrice >= any (
select MIN(p.ListPrice) from SalesLT.Product p
group by p.ProductCategoryID)
--all (morejo bit veèje od vseh (podobno and $$))
select Name from SalesLT.Product where ListPrice >= all (
select MIN(p.ListPrice) from SalesLT.Product p
group by p.ProductCategoryID)
--[not] exists (is used to test for the existence of any record in a subquery)[lih obratono]
--!!null je kurba je treba pazt

--izpiši id naroèila, maximalno ceno na tem naroèilu
select * from SalesLT.SalesOrderHeader
select * from SalesLT.udfMaxUnitPrice(71784)
select h.SalesOrderID, MaxUnitPrice from SalesLT.SalesOrderHeader h cross apply SalesLT.udfMaxUnitPrice(h.SalesOrderID)
--MaxUnitPrice je iz funkcije/tu ne dela z join ali cross join/

--1. Poišèi ID produkta, ime in ceno produkta (list price) za vsak produkt, kje je cena produkta
--veèja od povpreène cene na enoto (unit price) za vse produkte, ki smo jih prodali
select p.ProductID, p.Name, p.ListPrice from SalesLT.Product p
where p.ListPrice >= (select AVG(d.UnitPrice) from SalesLT.SalesOrderDetail d)
--2. Poišèi ID produkta, ime in ceno produkta (list price) za vsak produkt, kjer je cena (list) 100$ ali
--veè in je bil produkt prodan (unit price) za manj kot 100$.
select distinct p.ProductID, Name, p.ListPrice from SalesLT.Product p join SalesLT.SalesOrderDetail d on p.ProductID = d.ProductID
where p.ListPrice >= 100 and d.UnitPrice < 100
--3. Poišèi ID produkta, ime in ceno produkta (list price) in proizvodno ceno (standardcost) za vsak
--produkt skupaj s povpreèno ceno, po kateri je bil produkt prodan.
select p.ProductID, AVG(d.UnitPrice) from SalesLT.Product p
join SalesLT.SalesOrderDetail d on p.ProductID = d.ProductID
group by p.ProductID
--4. Filtriraj prejšnjo poizvedbo, da bo vsebovala samo produkte, kjer je cena proizvodnje (cost
--price) veèja od povpreène prodajne cene.select p.ProductID, AVG(d.UnitPrice), p.ListPrice from SalesLT.Product p
join SalesLT.SalesOrderDetail d on p.ProductID = d.ProductID
where p.StandardCost > AVG(d.UnitPrice)
group by p.ProductID
order by p.StandardCost
--5. Poišèi ID naroèila, ID stranke, Ime in priimek stranke in znesek dolga za vsa naroèila v
--SalesLT.SalesOrderHeader s pomoèjo funkcije dbo.ufnGetCustomerInformation
select h.SalesOrderID, h.CustomerID, i.FirstName from SalesLT.SalesOrderHeader h
cross apply dbo.ufnGetCustomerInformation(h.CustomerID) i
order by h.SalesOrderID
--6. Poišèi ID stranke, Ime in priimek stranke, naslov in mesto iz tabele SalesLT.Address in iz
--tabele SalesLT.CustomerAddress s pomoèjo funkcije dbo.ufnGetCustomerInformation
