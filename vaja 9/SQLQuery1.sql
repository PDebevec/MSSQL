CREATE TABLE dbo.MyEmployees
(
EmployeeID smallint NOT NULL,
FirstName nvarchar(30) NOT NULL,
LastName nvarchar(40) NOT NULL,
Title nvarchar(50) NOT NULL,
DeptID smallint NOT NULL,
ManagerID int NULL,
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)
);
-- Napolni tabelo z vrednostmi.
INSERT INTO dbo.MyEmployees VALUES
(1, N'Ken', N'S?nchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);

--vstavljenje
insert into dbo.MyEmployees
values (2345, 'Janez', 'Novak', 'Gospod', 1,1)

insert into dbo.MyEmployees (EmployeeID, FirstName, LastName, Title, DeptID)
values (2346, 'Marija', 'Novak', 'Gospa', 1)

select * from dbo.MyEmployees

--poseben vrednosti izpeljani atributi --compute, default, rowversion
create table T1
( st1 as 'izra?unani stolpec' + st2,
 st2 varchar(30) default ('Moj stolpec'),
 st3 rowversion,
 st4 varchar(40) null
)

select * from dbo.T1
insert into dbo.T1 (st4) values ('Eksplicitna vresnost')
insert into dbo.T1 (st2, st4) values ('neki je narobe', 'waw')
insert into T1 default values

create table T2
(id int identity,
 ime nvarchar(50),
 priimek nvarchar(50) unique
)

select * from T2
insert into T2 values ('Peter', 'Debevec')
set identity_insert T2 on --prvi pogoj za vsatvljanje identitete
insert into T2 (id, ime, priimek) --obvezno na?teti vse atribute
values (2, 'Peter', 'Debevec')
set identity_insert T2 off
insert into T2 values ('Ime', '?limak')

create table T3
(id int identity,
st2 uniqueidentifier
)

insert into T3 values (newid()) --druga?e se ne da unest
select * from T3

--VAJE 91
--ustvarite tabelo z va?im priimkom v PB
CREATE TABLE Priimek
(st1 AS 'Computed column ' + st2,
 st2 varchar(30)
 DEFAULT ('my column default'),
 st4 varchar(40) NULL,
 st5 nchar(5) unique,
 st6 timestamp
);
--1. vstavite vse privzete vrednosti, samo za st5 dajte vrednost 'AAAAA'
insert into Priimek (st5) values ('AAAAAA')
--2. kaj je narobe s stavkom, popravite vse tri napake napaki
insert into Priimek(st2,st4,st5) values ('a','b','c')
select * from Priimek
--izbir?ite tabelo in naredite novo
drop table Priimek;
CREATE TABLE Priimek
(st1 int IDENTITY,
 st2 VARCHAR(30),
 st3 uniqueidentifier
);
--3. vstavite 1,'Barbara' in vrednost, ki jo lahko priredite unique identifierju
insert into Priimek values ('Debevec', NEWID())
--4.presko?ite sedaj zaporedno ?tevilko 2 in dodajte zapis z zaporedno ?tevilko 5
set identity_insert Priimek on
insert into Priimek (st1, st2, st3)
values (5, 'Debevec', NEWID())

select * from Priimek

