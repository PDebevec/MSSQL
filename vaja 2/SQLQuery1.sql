--izpis id in al1 v naslov
select CAST(AddressID as varchar(5)) + ':' + AddressLine1 as naslov from SalesLT.Address
--ms sql pretvorba
select CONVERT(varchar(5), AddressID) + ':' + AddressLine1 as naslov from SalesLT.Address

--spremeni datum v niz
select Name, CONVERT(nvarchar(30), [SellStartDate]) as zaèetek,
convert(nvarchar(30), [SellEndDate], 126) as ISOformat
from SalesLT.Product
--uporaba isnull (l, r) vrne r ?e je l null druga?e vrne l
select Name, ISNULL(convert(varchar(30), SellEndDate), 'v prodaji') as datum
from SalesLT.Product