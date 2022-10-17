--convert(nvarchar(25), datum)
--cast(datum as nvarcahr(25))

select isnull(Color, 'ni barve') from SalesLT.Product
select nullif(Color, 'Black') from SalesLT.Product
--zadnji stolpec bo barve, �e je != null, sincer bo veliko �e != null, sincer bo 48
select name, Color, Size, coalesce(Color, isnull(size, 48)) from SalesLT.Product
select name, Color, Size, coalesce(Color, size, '48') from SalesLT.Product --48 more bit v '' v tem primeru
--poraba case
select name,
case --lahko dodamo Size in ga odstranimo spodi |when 'l' than 'large'
	when Size='L' then 'Large'
	when Size='M' then 'Medium'
	when Size='S' then 'Small'
	else isnull(size, 'n/a')
	end, Size
from SalesLT.Product

--1. Poi��i vse stranke iz tabele Customers
select * from SalesLT.Customer
--2. Izdelaj seznam strank, ki vsebuje ime kontakta, naziv, ime, srednje ime (�e ga kontakt ima),
--priimek in dodatek (�e ga kontakt ima) za vse stranke.
select isnull(Title+' ', '') + FirstName +' '+ isnull(MiddleName + ' ', '') + LastName + isnull(' '+Suffix, '') as FullCustomerName from SalesLT.Customer
--3. Iz tabele Customers izdelaj seznam, ki vsebuje:
--a. Prodajalca (SalesPerson)
--b. Stolpec z imenom �ImeStranke�, ki vsebuje priimek in naziv kontakta (na primer Mr Smith)
--c. Telefonsko �tevilko stranke
select SalesPerson, isnull(Title, '') + LastName as ImeStranke, Phone from SalesLT.Customer
--4. Izpi�i seznam vseh strank v obliki <Customer ID> : <Company Name> na primer 78: Preferred Bikes.
select convert(varchar(10), CustomerID) + ' : ' + CompanyName from SalesLT.Customer
--5. Iz tabele SalesOrderHeader (vsebuje podatke o naro�ilih) izpi�i podatke
select * from SalesLT.SalesOrderHeader
--a. �tevilka naro�ila v obliki <Order Number> (<Revision>) �na primer SO71774 (2).
select SalesOrderNumber + ' (' + convert(varchar(10), RevisionNumber) + ')' as StevilkaNarocila from SalesLT.SalesOrderHeader
--b. Datum naro�ila spremenjen v ANSI standarden format (yyy.mm.dd � na primer 2015.01.31)
select CONVERT(varchar, s.OrderDate, 102) as Datum from SalesLT.SalesOrderHeader s
--Nekateri podatki v bazi manjkajo ali pa so vrnjeni kot NULL. Tvoja naloga je ustrezno obravnavati te podatke.
--6. Ponovno je treba izpisati vse podatke o kontaktih, �e kontakt nima srednjega imena v obliki
--<first name> <last name>, �e ga pa ima <first name> <middle name> <last name> (na primer
--Keith Harris, Jane M. Gates)
select c.FirstName + ISNULL(' '+ c.MiddleName + ' ', ' ') + c.LastName from SalesLT.Customer c
--7. Stranka nam je posredovala e-mail nalov, telefon ali oboje. �e je dostopen e-mail, ga
--uporabimo za primarni kontakt, sicer uporabimo telefonsko �tevilko. Napi�i poizvedbo, ki
--vrne CustomerID in stolpec �PrimarniKontakt�, ki vsebuje e-mail ali telefonsko �tevilko. (v
--podatkovni bazi imajo vsi podatki e-mail. �e ho�e� preveriti ali poizvedba deluje pravilno
--najprej izvedi stavek
select CustomerID, isnull(c.EmailAddress, c.Phone) as PrimarniKontakt from SalesLT.Customer c
--8. Izdelaj poizvedbo, ki vra�a seznam naro�il (order ID), njihove datume in stolpec
--�StatusDobave�, ki vsebuje besedo �Dobavljeno� za vsa naro�ila, ki imajo znan datum
--dobave in ��aka� za vsa naro�ila brez datuma dobave. V bazi imajo vsa naro�ila datum
--dobave. �e �eli� preveriti, ali poizvedba deluje pravilno, predhodno izvedi stavek
select s.SalesOrderID, s.OrderDate,
case 
	when s.ShipDate is null then '�aka' --ne vem kdu se je sponu da ne bo delalu is null �e prej napisme value katerega gledam --za se jokat
	else 'Dostavljeno'
	end as StatusDobave
from SalesLT.SalesOrderHeader s