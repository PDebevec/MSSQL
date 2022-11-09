--pogledi view DDL
create view Produkti as
select * from SalesLT.Product
go --go se uporablja ce ksna stvar gori krka ksno stvar doli
--drugace je za splitat kodo

--deklaracija spemenljick
declare @mojštevec int
declare @piimek nvarchar(30), @ime nvarchar(30), @podroèje nvarchar(2)
set @mojštevec = 1

declare @cime nvarchar(50)
set @cime = N'Amy'
select LastName, FirstName from SalesLT.Customer where FirstName = @cime

--tabela kot spemenljivka
declare @varprodukti as table
(productid int, imeprodukta varchar(50))

insert into @varprodukti
select ProductID, Name from SalesLT.Product

select * from @varprodukti

--zaèasna tablea s #
create table #tempp
(produktid int, imepordukta varchar(50))
insert into #tempp
select ProductID, Name from SalesLT.Product
select * from #tempp

--zaèasna globalna tabela s ##
create table ##tempp1
(produktid int, imepordukta varchar(50))
insert into ##tempp1
select ProductID, Name from SalesLT.Product
select * from ##tempp1

--izpeljana tabela
--izpiši število aktivnih strank zbrano po letih
select count(CustomerID), YEAR(OrderDate) as leto from SalesLT.SalesOrderHeader
group by YEAR(OrderDate) --ne dela prou s samo OrderDate
--year vrne sam letnico

select leto, COUNT(stranka) from 
(select YEAR(OrderDate) as leto, CustomerID as stranka from SalesLT.SalesOrderHeader) as Poletih
group by leto

--druga opcija
select leto, COUNT(stranka) from 
(select YEAR(OrderDate), CustomerID from SalesLT.SalesOrderHeader) as Poletih (leto, stranka)
group by leto;

--cte common table expression
--uporabna samo za en sql stavek (veè ne dela)
with ctepoletih (leto, stranka)
as (select YEAR(OrderDate), CustomerID from SalesLT.SalesOrderHeader)
select leto, COUNT(stranka) from ctepoletih group by leto
