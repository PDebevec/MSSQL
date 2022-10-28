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
	throw 50001,'Prišlo je do napake',0
end catch

--vaja
use AdventureWorksLT2012
--1. Napiši skripto, ki bo vstavljala zapise v tabelo SalesLT.SalesOrderHeader. Uporabnik bo vnesel
--datum naroèila, datum dobave (DueDate) in številko stranke (CustomerID). SalesOrderID naj
--se generira iz SalesLT.SalesOrderNumber in se shrani kot spremenljivka. Koda, ki to naredi
go
declare
@datumnaroèila date = getdate(),
@datumdobave date = getdate(),
@številkastranke int = 256,
@OrderID int
SET @OrderID = NEXT VALUE FOR SalesLT.SalesOrderNumber
set identity_insert SalesLT.SalesOrderHeader on


--Nato naj skripta vstavi zapis v tabelo, z uporabo teh vrednosti. Metoda dostave (ShipMethod)
--naj bo kar v stavku nastavljena na ‘CARGO TRANSPORT 5’. Ostale vrednosti naj bodo NULL. Po
--vstavljanju naj skripta izpiše SalesOrderID s pomoèjo ukaza PRINT. Testirajte kodo na primeruinsert into SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, SalesOrderID, ShipMethod)
values (@datumnaroèila, @datumdobave, @številkastranke, @OrderID, 'CARGO TRANSPORT 5')

print @orderid

go
--2. Napišite skripto, ki bo dodajala zapise v SalesOrderDetail tabelo. Uporabnik bo vnesel Id
--naroèila (SalesOrderID), ID produkta (ProductID), kolièino (Quantity) in ceno za enoto
--(UnitPrice). Skripta naj najprej preveri ali obstaja ta specifièen ID v glavah naroèil. Èe obstaja,
--naj naroèilo vstavi v tabelo podrobnosti, kjer naj bodo vrednosti NULL za nedoloèene
--vrednosti stolpcev. Èe ID ne obstaja v glavi naroèil, naj izpiše »Naroèilo ne obstaja«.
--Uporabite lahko EXSITS. Testirajte kodo na primeru 
select d.ProductID, d.SalesOrderID, d.OrderQty, d.UnitPrice from SalesLT.SalesOrderDetail d where d.UnitPrice = 420.69
go
declare
@naroèiloid int = 22, --71797
@produktid int = 717,
@kolièina smallint = 7,
@cena money = 420.69

if exists (select d.SalesOrderID from SalesLT.SalesOrderHeader d where d.SalesOrderID = @naroèiloid)
begin
	insert into SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
	values (@naroèiloid, @produktid, @kolièina, @cena)
end
else
begin
	print 'naroèilo ne obstaja'
end
go
--3. Pri Adventure Works so ugotovili, da je povpreèna cena kolesa na trgu $2000 in da je najvišja
--cena, ki jo je stranka še pripravljena plaèati za kolo $5000. Napisati moraš skripto, ki
--postopoma veèa prodajno ceno koles po 10%, dokler ne bo povpreèna cena kolesa vsaj enaka
--povpreèni ceni na trgu ali dokler ne postane najdražje kolo dražje kot sprejemljiv maksimum
--cene. Napiši zanko:
--a. Izvaja naj se samo, èe je povpreèna cena v starševski kategoriji 'Bikes' nižja kot $2000.
--Vse kategorije produkt v starševski kategoriji 'Bikes' lahko dobiš v pogledu
--SalesLT.vGetAllCategories
--b. Posodobi vse produkte v tej kategoriji, tako da jim zvišaš ceno za 10%
--c. Preveri novo povpreèno ceno in najvišjo ceno v tej kategoriji
--d. Èe je nov maksimum veèji od $5000 konèaj z izvajanjem, sicer ponovi

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