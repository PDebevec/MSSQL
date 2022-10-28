use AdventureWorksLT2012
declare @r money
select @r = max(TotalDue) from SalesLT.SalesOrderHeader
print @r
--go

declare @b nvarchar(20)
set @b = 'Red'
if @b is null
begin
	select * from SalesLT.Product
end
else
begin
	select * from SalesLT.Product where Color = @b
end
--go

--sharnejvanje v procedure
use AdventureWorks2019
go
create procedure M1
as select * from [HumanResources].[Shift]
exec M1

--s parametri
go
create procedure M2
@p nvarchar(50) = 'Night'
as
select * from HumanResources.Shift
where Name = @p
exec M2 'Day'

--s dvemi parametri
go
create procedure M3
@p varchar(50), @s time
as
select * from HumanResources.Shift
where Name=@p and StartTime > @s
exec M3 @p = 'Day', @s = '06:00:00.00000'

--faking return
go
create procedure M4
@v nvarchar(50) output
as
set @v = (select top 1 name from HumanResources.Shift)
declare @o nvarchar(50)
exec M4 @o output
print @o

exec uspGetEmployeeManagers @businessentityid=275

go
use AdventureWorksLT2012
INSERT INTO salesLt.SalesOrderDetail
(SalesOrderID,OrderQty,ProductID,UnitPrice,UnitPriceDiscount)
VALUES (100000,1,680,1431.50,0.00)UPDATE SalesLT.Product
SET DiscontinuedDate=GETDATE()
where ProductID=0
if @@ROWCOUNT = 0
	throw 50001,'Noben zapis ni bil posodobljen',0

declare @popust int = 0
begin try
	update SalesLT.Product
	set ListPrice = ListPrice/@popust
end try
begin catch
--tle je bovezno ; throw ne mara (kurba)
	print error_line();
	print error_number();
	print error_message();
	throw 50001,'Pri�lo je do napake',0
end catch

--vaja
use AdventureWorksLT2012
--1. Napi�i skripto, ki bo vstavljala zapise v tabelo SalesLT.SalesOrderHeader. Uporabnik bo vnesel
--datum naro�ila, datum dobave (DueDate) in �tevilko stranke (CustomerID). SalesOrderID naj
--se generira iz SalesLT.SalesOrderNumber in se shrani kot spremenljivka. Koda, ki to naredi
go
declare
@datumnaro�ila date = getdate(),
@datumdobave date = getdate(),
@�tevilkastranke int = 256,
@OrderID int
SET @OrderID = NEXT VALUE FOR SalesLT.SalesOrderNumber
set identity_insert SalesLT.SalesOrderHeader on


--Nato naj skripta vstavi zapis v tabelo, z uporabo teh vrednosti. Metoda dostave (ShipMethod)
--naj bo kar v stavku nastavljena na �CARGO TRANSPORT 5�. Ostale vrednosti naj bodo NULL. Po
--vstavljanju naj skripta izpi�e SalesOrderID s pomo�jo ukaza PRINT. Testirajte kodo na primeruinsert into SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, SalesOrderID, ShipMethod)
values (@datumnaro�ila, @datumdobave, @�tevilkastranke, @OrderID, 'CARGO TRANSPORT 5')

print @orderid

go
--2. Napi�ite skripto, ki bo dodajala zapise v SalesOrderDetail tabelo. Uporabnik bo vnesel Id
--naro�ila (SalesOrderID), ID produkta (ProductID), koli�ino (Quantity) in ceno za enoto
--(UnitPrice). Skripta naj najprej preveri ali obstaja ta specifi�en ID v glavah naro�il. �e obstaja,
--naj naro�ilo vstavi v tabelo podrobnosti, kjer naj bodo vrednosti NULL za nedolo�ene
--vrednosti stolpcev. �e ID ne obstaja v glavi naro�il, naj izpi�e �Naro�ilo ne obstaja�.
--Uporabite lahko EXSITS. Testirajte kodo na primeru 
select d.ProductID, d.SalesOrderID, d.OrderQty, d.UnitPrice from SalesLT.SalesOrderDetail d where d.UnitPrice = 420.69
go
declare
@naro�iloid int = 22, --71797
@produktid int = 717,
@koli�ina smallint = 7,
@cena money = 420.69

if exists (select d.SalesOrderID from SalesLT.SalesOrderHeader d where d.SalesOrderID = @naro�iloid)
begin
	insert into SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
	values (@naro�iloid, @produktid, @koli�ina, @cena)
end
else
begin
	print 'naro�ilo ne obstaja'
end
go
--3. Pri Adventure Works so ugotovili, da je povpre�na cena kolesa na trgu $2000 in da je najvi�ja
--cena, ki jo je stranka �e pripravljena pla�ati za kolo $5000. Napisati mora� skripto, ki
--postopoma ve�a prodajno ceno koles po 10%, dokler ne bo povpre�na cena kolesa vsaj enaka
--povpre�ni ceni na trgu ali dokler ne postane najdra�je kolo dra�je kot sprejemljiv maksimum
--cene. Napi�i zanko:
--a. Izvaja naj se samo, �e je povpre�na cena v star�evski kategoriji 'Bikes' ni�ja kot $2000.
--Vse kategorije produkt v star�evski kategoriji 'Bikes' lahko dobi� v pogledu
--SalesLT.vGetAllCategories
--b. Posodobi vse produkte v tej kategoriji, tako da jim zvi�a� ceno za 10%
--c. Preveri novo povpre�no ceno in najvi�jo ceno v tej kategoriji
--d. �e je nov maksimum ve�ji od $5000 kon�aj z izvajanjem, sicer ponovi

--mende je treba uporabt procedure namesto funkcij
go --funkcija za povprecno ceno
create function f_avgcena(@pcID int) --tablea
returns money
begin
declare @avg money = (
	select AVG(ListPrice) from SalesLT.Product
	where ProductCategoryID  = @pcID
	)
return @avg
end
go

go --funkcija za maksimalno ceno
create function f_maxcena(@pcID int)
returns money
begin
declare @max money = (
	select MAX(ListPrice) from SalesLT.Product
	where ProductCategoryID  = @pcID
	)
return @max
end
go

declare
@avgcena money,
@maxcena money,
--tle more bit tablea
@pcID int = (select * from SalesLT.vGetAllCategories where ParentProductCategoryName = 'Bikes')

set @avgcena = dbo.f_avgcena(@pcID)
set @maxcena = dbo.f_maxcena(@pcID)

while @avgcena <= 2000 or @maxcena <= 50000
begin
	update SalesLT.Product set ListPrice = ListPrice * 1.1 where ProductCategoryID  = @pcID
	set @avgcena = dbo.f_avgcena(@pcID)
	set @maxcena = dbo.f_maxcena(@pcID)
end
go