--filtri spredaj, where in order by
select distinct color from SalesLT.Product
--samo 10 poroductov
select top 10 percent name, ListPrice from SalesLT.Product p order by p.ListPrice desc

--ostranjevanje
select name, ListPrice from SalesLT.Product
order by ListPrice desc
offset 10 rows fetch next 100 rows only

--where
--<,>,<=,>=,<> ali !=, and in or, not = !, like between, in <- dobesedno
--produkti, katerih productnumber se za�ne na FR
select p.ProductNumber from SalesLT.Product p where p.ProductNumber like 'FR%'
--% je za nadaljevanje kar koli, _ nataknko en podatek, [ABC], [A-Z], [0-9], [345] --vzorci (brez -) ali od do (z - umes)
select ProductNumber from SalesLT.Product where ProductNumber like 'FR-_[0-9][0-9]_-[0-9][0-9]'