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
from Production.BillOfMaterials m join Parts p on m.ProductAssemblyID = p.AssemblyID
where m.EndDate is null
)

select * from Parts order by AssemblyID

