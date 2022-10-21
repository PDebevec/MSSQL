--izpis zaposlenih po hirarhiji
with DirectReport(ManagerID, EmployeeID, Title, EmployeeLevel)
as (
select ManagerID, EmployeeID, Title, 0 as EmployeeLevel from dbo.MyEmployees
where ManagerID is null
union all
select e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel+1
from dbo.MyEmployees e join DirectReport d on e.ManagerID = d.EmployeeID
)
select * from DirectReport
--v u�ilnici je bul�e napisano

--
--1. Izdelaj poizvedbo, ki bo vsebovala Id produkta, ime produkta in povzetek produkta (Summary) iz
--SalesLT.Product tabele in SalesLT.vProductModelCatalogDescription pogleda.
select p.ProductID, p.Name, d.Summary from SalesLT.Product p join SalesLT.vProductModelCatalogDescription d on p.ProductModelID = d.ProductModelID
--2. Izdelaj tabelari�no spremenljivko in jo napolni s seznamom razli�nih barv iz tabele SalesLT.Product.
--Nato uporabi spremenljivko kot filter poizvedbe, ki vra�a ID produkta, ime, barvo iz tabele
--SalesLT.Product in samo tiste izdelke, ki imajo barvo v zgoraj definirani za�asni tabeli (rezultat
--vsebuje 245 vrstic)
create table #barve (barve nvarchar(15))
insert into #barve
select distinct p.Color from SalesLT.Product p
where p.Color is not null
select * from #barve
select p.Color from SalesLT.Product p
where p.Color = any (select * from #barve)
drop table #barve
--3. Podatkovna baza AdventureWorksLT vsebuje funkcijo dbo.ufnGetAllCategories, ki vra�a tabelo
--kategorij produktov (na primer 'Road Bikes') in roditeljske kategorije (na primer 'Bikes'). Napi�i
--poizvedbo, ki uporablja to funkcijo in vra�a seznam izdelkov, skupaj s kategorijo in roditeljsko
--kategorijo.
select c.ProductCategoryName, c.ProductCategoryName from dbo.ufnGetAllCategories() c
join SalesLT.ProductCategory p on c.ProductCategoryID = p.ProductCategoryID
--4. Poi��i seznam strank v obliki Company (Contact Name), skupni prihodki za vsako stranko. Uporabi
--izpeljano tabelo, da poi��e� naro�ila, nato pa naredi poizvedbo po izpeljani tabeli, da agregira� in
--sumira� podatke.
select companyContact, SUM(salesAmount) as Revenue from
(select CONCAT(c.CompanyName, c.FirstName + ' ' + c.LastName), h.TotalDue from SalesLT.SalesOrderHeader h
join SalesLT.Customer c on h.CustomerID = c.CustomerID) as CustomerSales(companyContact, salesAmount)
group by companyContact
order by companyContact
--5. Ista naloga kot prej, le da namesto izpeljane tabele uporabi� CTE
with CustomerSales(companyContact, salesAmount)
as (select CONCAT(c.CompanyName, c.FirstName + ' ' + c.LastName), h.TotalDue from SalesLT.SalesOrderHeader h
join SalesLT.Customer c on h.CustomerID = c.CustomerID)
select companyContact, SUM(salesAmount) as Revenue from CustomerSales
group by companyContact
order by companyContact

--na druga�en na�in brez grupiranja
select sum(Sales), Country, Region from sales
group by Country, Region
--drugi na�in
select sum(Sales), Country, Region from sales
group by rollup (Country, Region)
--�e en drugi na�in
select sum(Sales), Country, Region from sales
group by cube(Country, Region)
--another one
select Country, Region, sum(Sales)from sales
group by grouping sets (Country, region, ())

select Country, Region, sum(Sales),
GROUPING_ID(country) as idc, GROUPING_ID(region) as idr
from Sales s group by rollup(s.Country, s.Region)

select IIF(GROUPING_ID(s.Country)=1 and GROUPING_ID(s.Region)=1, 'Vse skupaj',
iif(grouping_id(s.region)=1, 'Skupaj'+s.country, region)) as opis,
sum(sales) from Sales s group by rollup (country, region)

--1. Imamo �e obstoje�e poro�ilo, ki vra�a vsote prodaj po country/region (USA; Zdru�eno
--kraljestvo) in po State/Province (England, California, Colorado,�). Poizvedba je
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY rollup(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;
--Popravi poizvedbo tako, da bo vsebovala �e delne vsote za country/region, poleg teh, ki jih
--imamo za state/province. Primer re�itve:
--sam rollup je treba dodat mende ^^^^^^^^
--2. Spremeni poizvedbo tako, da bo vsebovala nov atribut Level, ki bo opisoval tip delne vsote.
--Primer re�itve:
SELECT a.CountryRegion, a.StateProvince,
iif(GROUPING_ID(a.CountryRegion)=1 and GROUPING_ID(a.StateProvince)=1, 'Total',
iif(grouping_id(a.StateProvince)=0, a.StateProvince+' Subtotal', a.CountryRegion+' Subtotal')) as Level,
SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY rollup(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;
--3. Raz�iri poizvedbo tako, da bo vsebovala tudi mesta.
SELECT a.CountryRegion, a.StateProvince, a.city,
iif(GROUPING_ID(a.CountryRegion)=1 and GROUPING_ID(a.StateProvince)=1 and grouping_id(a.city)=1, 'Total',
iif(grouping_ID(a.city)=0, a.city,
iif(grouping_ID(a.StateProvince)=0, a.StateProvince, a.CountryRegion))+' Subtotal') as Level,
SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY rollup(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;
