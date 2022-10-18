--5. Napi�ite poizvedbo, ki vrne seznam imen podjetji in njihovo mesto v rangu, �e jih rangirate
--glede na najvi�jo vrednost atributa TotalDue iz tabele SalesOrderHeader.
select c.FirstName, rank() over (order by TotalDue) as TotalDue from SalesLT.SalesOrderHeader h join SalesLT.Customer c on h.CustomerID = c.CustomerID
--6. Napi�ite poizvedbo, ki izpi�e imena produktov in skupno vsoto izra�unano kot vsoto atributa
--LineTotal iz SalesOrderDetail tabele. Rezultat naj bo urejen po padajo�i vrednosti skupne vsote.
select p.Name, SUM(d.LineTotal) from SalesLT.SalesOrderDetail d join SalesLT.Product p on p.ProductID = d.ProductID group by p.Name
--7. Spremenite prej�njo poizvedbo tako, da vklju�uje samo tiste produkte, ki imajo atribut
--ListPrice ve� kot 1000$.
select p.Name, SUM(d.LineTotal) as sumLineTotal from SalesLT.SalesOrderDetail d join SalesLT.Product p on p.ProductID = d.ProductID
where p.ListPrice > 1000
group by p.Name
--8. Spremenite prej�njo poizvedbo, da bo vsebovala samo skupine, ki imajo skupno vrednost
--prodaje ve�jo kot 20.000$.
select p.Name, SUM(d.LineTotal) from SalesLT.SalesOrderDetail d join SalesLT.Product p on p.ProductID = d.ProductID
group by p.Name having SUM(d.LineTotal) > 20000

--Podpoizvedbe
--iz soh izpi�i id naro�ila, datum naro�ila in najvi�ja cena na tem naro�ilu
select h.SalesOrderID, h.OrderDate, max(d.UnitPrice) as maxPrice
from SalesLT.SalesOrderHeader h join SalesLT.SalesOrderDetail d on h.SalesOrderID = d.SalesOrderID
group by h.SalesOrderID, h.OrderDate
--isto s podpoizvedbo
select h.SalesOrderID, h.OrderDate,
(select max(UnitPrice) from SalesLT.SalesOrderDetail d where d.SalesOrderID = d.SalesOrderID) as maxPrice
from SalesLT.SalesOrderHeader h

--poi��i vasa imena artiklov, ki imaoj isto listprice kot "touring tire tube"
select ListPrice from SalesLT.Product where name = 'Touring Tire Tube'

select name from SalesLT.Product
where ListPrice = (select ListPrice from SalesLT.Product where name = 'Touring Tire Tube')
--isto z join
select p.ListPrice from SalesLT.Product p join SalesLT.Product pr on p.ListPrice = pr.ListPrice where pr.Name = 'Touring Tire Tube'

--operator in, not in, any, all, exsists

