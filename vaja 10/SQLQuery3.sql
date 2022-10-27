use AdventureWorks2019
--UPDATE
update Person.Address
set ModifiedDate = GETDATE()

select Bonus, CommissionPct, SalesQuota from Sales.SalesPerson
update Sales.SalesPerson
set Bonus = 6000,CommissionPct = 0.1, SalesQuota = null

update Production.Product
set Color = 'Metallic Red' where Color = 'Red' and Name like 'Road-250%'
select Name, Color from Production.Product

select * from Production.BillOfMaterials
where ProductAssemblyID = 800

with Parts (AssemblyID, ComponentID, PerAssembelyQty, EndDate, ComponentLevel)
as (
	select ProductAssemblyID, ComponentID, PerAssemblyQty, EndDate, 0
	from Production.BillOfMaterials
	where ProductAssemblyID = 800 and EndDate is null
	union all
	select m.ProductAssemblyID, m.ComponentID, m.PerAssemblyQty, m.EndDate, p.ComponentLevel+1
	from Production.BillOfMaterials m join Parts p on m.ProductAssemblyID = p.ComponentID
	where m.EndDate is null
)

--to je podobno rekurziji --za vsako kodo gremo dol po hirarhiji

--Unu spodi dela sam ku je tu zakomentirano wtf kr neki
--select * from Parts order by ComponentLevel
update Production.BillOfMaterials set PerAssemblyQty = 2*PerAssemblyQty
where ProductAssemblyID in (select AssemblyID from Parts)

--prištej znesek zadnjega naroèila
select * from Sales.SalesPerson
select * from Sales.SalesOrderHeader

update Sales.SalesPerson set SalesYTD = SalesYTD + (
	select sum(SubTotal) from Sales.SalesOrderHeader h
	where h.OrderDate = (
		select MAX(OrderDate)
		from Sales.SalesOrderHeader oh
		where h.SalesPersonID = oh.SalesPersonID
	) and Sales.SalesPerson.BusinessEntityID = h.SalesPersonID
	group by h.SalesPersonID
)

--delete
delete from Sales.SalesPersonQuotaHistory