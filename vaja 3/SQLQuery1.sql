--convert(nvarchar(25), datum)
--cast(datum as nvarcahr(25))

select isnull(Color, 'ni barve') from SalesLT.Product
select nullif(Color, 'Black') from SalesLT.Product
--zadnji stolpec bo barve, èe je != null, sincer bo veliko èe != null, sincer bo 48
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

--1. Poišèi vse stranke iz tabele Customers
select * from SalesLT.Customer
--2. Izdelaj seznam strank, ki vsebuje ime kontakta, naziv, ime, srednje ime (èe ga kontakt ima),
--priimek in dodatek (èe ga kontakt ima) za vse stranke.
select isnull(Title+' ', '') + FirstName +' '+ isnull(MiddleName + ' ', '') + LastName + isnull(' '+Suffix, '') as FullCustomerName from SalesLT.Customer
--3. Iz tabele Customers izdelaj seznam, ki vsebuje:
--a. Prodajalca (SalesPerson)
--b. Stolpec z imenom »ImeStranke«, ki vsebuje priimek in naziv kontakta (na primer Mr Smith)
--c. Telefonsko številko stranke
select SalesPerson, isnull(Title, '') + LastName as ImeStranke, Phone from SalesLT.Customer
--4. Izpiši seznam vseh strank v obliki <Customer ID> : <Company Name> na primer 78: Preferred Bikes.
select convert(varchar(10), CustomerID) + ' : ' + CompanyName from SalesLT.Customer
--5. Iz tabele SalesOrderHeader (vsebuje podatke o naroèilih) izpiši podatke
select * from SalesLT.SalesOrderHeader
--a. Številka naroèila v obliki <Order Number> (<Revision>) –na primer SO71774 (2).
select SalesOrderNumber + ' (' + convert(varchar(10), RevisionNumber) + ')' as StevilkaNarocila from SalesLT.SalesOrderHeader
--b. Datum naroèila spremenjen v ANSI standarden format (yyy.mm.dd – na primer 2015.01.31)
select CONVERT(varchar, s.OrderDate, 102) as Datum from SalesLT.SalesOrderHeader s
--Nekateri podatki v bazi manjkajo ali pa so vrnjeni kot NULL. Tvoja naloga je ustrezno obravnavati te podatke.
--6. Ponovno je treba izpisati vse podatke o kontaktih, èe kontakt nima srednjega imena v obliki
--<first name> <last name>, èe ga pa ima <first name> <middle name> <last name> (na primer
--Keith Harris, Jane M. Gates)
select c.FirstName + ISNULL(' '+ c.MiddleName + ' ', ' ') + c.LastName from SalesLT.Customer c
--7. Stranka nam je posredovala e-mail nalov, telefon ali oboje. Èe je dostopen e-mail, ga
--uporabimo za primarni kontakt, sicer uporabimo telefonsko številko. Napiši poizvedbo, ki
--vrne CustomerID in stolpec »PrimarniKontakt«, ki vsebuje e-mail ali telefonsko številko. (v
--podatkovni bazi imajo vsi podatki e-mail. Èe hoèeš preveriti ali poizvedba deluje pravilno
--najprej izvedi stavek
select CustomerID, isnull(c.EmailAddress, c.Phone) as PrimarniKontakt from SalesLT.Customer c
--8. Izdelaj poizvedbo, ki vraèa seznam naroèil (order ID), njihove datume in stolpec
--»StatusDobave«, ki vsebuje besedo »Dobavljeno« za vsa naroèila, ki imajo znan datum
--dobave in »Èaka« za vsa naroèila brez datuma dobave. V bazi imajo vsa naroèila datum
--dobave. Èe želiš preveriti, ali poizvedba deluje pravilno, predhodno izvedi stavek
select s.SalesOrderID, s.OrderDate,
case 
	when s.ShipDate is null then 'èaka' --ne vem kdu se je sponu da ne bo delalu is null èe prej napisme value katerega gledam --za se jokat
	else 'Dostavljeno'
	end as StatusDobave
from SalesLT.SalesOrderHeader s