use AdventureWorksLT2019;

--1. Vstavi v tabelo SalesLT.Product produkt
--Ko je produkt ustvarjen, preveri kakšna je identiteta zadnjega vstavljenega produkta.
--Pomagaj si s SELECT SCOPE_IDENTITY();
insert into SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
values ('LED lights', 'LT-L123', 2.56, 12.99, 37, GETDATE())
select SCOPE_IDENTITY() from SalesLT.Product

--2. Vstavi v SalesLT.ProductCategory kategorijo z lastnostjo ParentProductCategoryID = 4 z
--imenom (Name) 'Bells and Horns'. Kljuè v tabeli je identiteta. Nato vstavi v tabelo produktov
--(SalesLT.Product) še spodnje produkte.
select * from SalesLT.ProductCategory where ParentProductCategoryID = 4
insert into SalesLT.ProductCategory (ParentProductCategoryID, Name)
values (4, 'Bells and horns')
select * from SalesLT.Product
insert into SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
values ('Bicycle Bell', 'BB-RING', 2.47, 4.99, 46, GETDATE()),
('Bicycle Horn', 'BB-PARP', 1.29, 3.75, 46, GETDATE())

--Novo identiteto, ki si jo ustvaril v tabeli SalesLT.ProductCategory lahko vstaviš v tabelo
--SalesLT.Product s pomoèjo IDENT_CURRENT('ime tabele'). Preveri ali so produkti pravilno
--vstavljeni tako, da zapišeš ustrezen SELECT stavek.
select IDENT_CURRENT('salesLT.ProductCategory') from SalesLT.Product
select * from SalesLT.Product where ProductCategoryID = 46

--3. Zvišaj ceno (ListPrice) vsem produktom iz SalesLT.Product v kategoriji »Bells and Horns« za 10%.
update SalesLT.Product set ListPrice = ListPrice*1.1
where ProductCategoryID = (
	select c.ProductCategoryID from SalesLT.ProductCategory c where Name like 'Bells and horns'
)

--4. Nastavi DiscountinueDate za vse produkte iz tabele SalesLT.Product v kategoriji luèi (ID
--kategorije je 37) na današnji datum, razen za luè, ki si jo dodal v toèki ena.
update SalesLT.Product set DiscontinuedDate = GETDATE() where ProductCategoryID = 37 and ProductNumber != 'LT-123'

--5. Izbriši produkte iz tabele SalesLT.Product v kategoriji »Bells and Horns«, nato pa izbriši tudi
--kategorijo »Bells and Horns« v tabeli SalesLT.ProductCategory
delete from SalesLT.ProductCategory where Name like 'Bells and horns'
delete from SalesLT.Product where ProductCategoryID = (
	select c.ProductCategoryID from SalesLT.ProductCategory c where Name like 'Bells and horns'
)

use AdventureWorksLT2012

--go izolira sql stavke 
go
declare
@barva nvarchar(25) = 'Black',
@velikost nvarchar(5) = 'L'
--go bi tukaj razdelil gori doli
select * from SalesLT.Product
where Color = @barva and Size = @velikost
go

--printanje vrednosti s set
go
declare
@barva nvarchar(25)
set @barva = 'Red'
print @barva
-- primerjanje vrednosti v poizvedbi
declare
@rez money
select @rez = MAX(totaldue) from SalesLT.SalesOrderHeader
print @rez
go

--vejitve if
go
declare
@barva nvarchar(25)
set @barva = 'Red'
if @barva is null
begin
	select * from SalesLT.Product
end
else
begin
 select * from SalesLT.Product where Color = @barva	
end
go
--print @@rowcount

--zanka while
go
declare
@cID int = 1,
@name nvarchar(25)
while @cID<=5
begin
	select @name=LastName from SalesLT.Customer
	where CustomerID = @cID
	print @name
	set @cID+=1
end
print @@rowcount
go
