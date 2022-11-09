--1. Iz tabele Address izberi vsa mesta in province, odstrani duplikate. (atributi City, Province)
select distinct a.City, a.StateProvince from SalesLT.Address a
--2. Iz tabele Product izberi 10% najtežjih produktov (izpiši atribut Name, teža je v atributu Weight)
select top 10 percent Weight, Name from SalesLT.Product order by Weight desc
--3. Iz tabele Product izberi najtežjih 100 produktov, izpusti prvih 10 najtežjih.
select Name, Weight from SalesLT.Product order by Weight desc offset 10 rows fetch next 100 rows only
--4. Poišèi ime, barvo in velikost produkta, kjer ima model produkta ID 1. (atributi Name, Color, Size in ProductModelID)
select Name, Color, Size from SalesLT.Product p where p.ProductModelID = 1
--5. Poišèi številko produkta in ime vseh izdelkov, ki imajo barvo 'black', 'red' ali 'white' in velikost 'S' ali 'M'. (Izpiši ProductNumber, primerjaj Color in Size)
select ProductNumber, Color, Size from SalesLT.Product where Color in ('Black', 'Red', 'white') and Size in ('S', 'M')
--6. Poišèi številko produktov, ime in ceno produktov, katerih številka se zaène na BK-. (atributi ProductNumber, Name, ListPrice, primerjaj ProductNumer)
select p.ProductNumber, Name, p.ListPrice from SalesLT.Product p where ProductNumber like 'BK-%'
--7. Spremeni prejšnjo poizvedbo tako, da boš iskal produkte, ki se zaènejo na 'BK-' sledi
--katerikoli znak razen R in se konèajo na »–dve števki«. (atributi ProductNumber,
--Name, ListPrice, primerjaj ProductNumer, primer: BK-F1234J-11)
select p.ProductNumber, Name, p.ListPrice from SalesLT.Product p where ProductNumber like 'BK-[^R]%-[0-9][0-9]'

--inner join
--ANSI 92
--select from -> join -> where -> group by -> having ...
-- 1. FROM
-- 2. WHERE
-- 3. GROUP BY
-- 4. HAVING
-- 5. SELECT
-- 6. ORDER BY
select p.Name as Ime, c.Name as Katerorija from SalesLT.Product p
join SalesLT.ProductCategory c on c.ProductCategoryID = p.ProductCategoryID

--ANSI 89
select p.Name Ime, c.Name as Kategorija from SalesLT.Product p, SalesLT.ProductCategory c
where c.ProductCategoryID = p.ProductCategoryID

--levi zunanji stiki (lefto [outer] join)
--ime strank + njihova naroèil, vse stranke tudi brez narobil
select c.FirstName, c.LastName, h.SalesOrderNumber from SalesLT.Customer c
left join SalesLT.SalesOrderHeader h on c.CustomerID = h.CustomerID

--izpiši vsa naroèila katera nimajo stranke
select c.FirstName, c.LastName, h.SalesOrderNumber from SalesLT.Customer c
right join SalesLT.SalesOrderHeader h on c.CustomerID = h.CustomerID
--join sam ne bo zdruzil podatke kateri so null tako da je treba probat se left ali right join
--left je za null values v levi tabeli
--right je za null values v desni tabeli

--imena strank, številke naroèil pri tem vse stranke tudi tiste brez naroèil in vsa naroèila tudi brez strank
select c.FirstName, c.LastName, h.SalesOrderNumber from SalesLT.Customer c
full join SalesLT.SalesOrderHeader h on c.CustomerID = h.CustomerID

--cross join (ne rabi on)(ne tega uporablat)
select c.FirstName, c.LastName, h.SalesOrderNumber from SalesLT.Customer c
cross join SalesLT.SalesOrderHeader h
