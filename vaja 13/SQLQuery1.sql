--tranzaksije
begin try
 begin transaction
	insert into SalesLT.SalesOrderHeader	(DueDate, CustomerID, ShipMethod)
	values									(dateadd(dd, 7, GETDATE()), 1, 'STD DELIVERY')
	declare @id int = scope_identity()
	insert into SalesLT.SalesOrderDetail	(SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	values									(@id, 1, 99999, 1431.50, 0.0)
 commit transaction
end try
begin catch
	print error_message()
	if @@TRANCOUNT>0
		begin
			print xact_state()
			rollback transaction
		end
end catch
go
--avtomacki rollback tranzaksije
set xact_abort on;
begin try
 begin transaction
	insert into SalesLT.SalesOrderHeader	(DueDate, CustomerID, ShipMethod)
	values									(dateadd(dd, 7, GETDATE()), 1, 'STD DELIVERY')
	declare @id int = scope_identity()
	insert into SalesLT.SalesOrderDetail	(SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	values									(@id, 1, 99999, 1431.50, 0.0)
 commit transaction
end try
begin catch
	print error_message()
end catch

--naro�i brez podrobnosti
select h.SalesOrderID, h.DueDate, h.CustomerID, h.ShipMethod
from SalesLT.SalesOrderHeader h left join SalesLT.SalesOrderDetail d --join odstrani vednosti null
on h.SalesOrderID = d.SalesOrderID
where d.SalesOrderDetailID is null

delete from SalesLT.SalesOrderHeader
where SalesOrderID = 71947

--vaja
--1. Denimo, da ima� spodnjo kodo za brisanje zapisov iz naro�il in podrobnosti naro�il.
	--DECLARE @SalesOrderID int = <the_order_ID_to_delete>
	--DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
	--DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
--Koda se vedno izvede, ne glede na to ali naro�ilo z izbrano �tevilko obstaja ali ne. Dodaj kodo, ki bo
--spro�ila napako v primeru, da �tevilka naro�ila ne obstaja in izpisala sporo�ilo, ko se napaka zgodi.
go
DECLARE @SalesOrderID int = 0,
@napaka nvarchar(255)
begin try
	if not exists (select * from SalesLT.SalesOrderHeader where SalesOrderID = @SalesOrderID)
	begin
		set @napaka = 'naro�ilo �t ' + cast(@SalesOrderID as nvarchar) + ' ne obstaja';
		throw 50001, @napaka, 0
	end
	else
	begin
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
	end
end try
begin catch
 print error_message()
end catch
--2. Popravi kodo v prej�nji nalogi tako, da se bosta obe brisanji izvedli kot transakcija. V
--obravnavi napak spremeni kodo tako, da : �e je transakcija na pol izvedena, naj se povrne
--baza v prej�nje stanje in naj ponovno spro�i napako. �e transakcija ni v teku, naj preprosto
--izpi�e napako. Testiraj kodo tako, da da� med oba DELETE stavka en THROW stavek, ki bo
--spro�il izjemo in prekinil transakcijo.
select h.SalesOrderID from SalesLT.SalesOrderHeader h
select d.SalesOrderID from SalesLT.SalesOrderDetail d

go
DECLARE @SalesOrderID int = 71782, --71935
@napaka nvarchar(255)
begin try
	set xact_abort on;
	if not exists (select * from SalesLT.SalesOrderHeader where SalesOrderID = @SalesOrderID)
	begin
		set @napaka = 'naro�ilo �t ' + cast(@SalesOrderID as nvarchar) + ' ne obstaja';
		throw 50001, @napaka, 0
	end
	else
	begin
	begin transaction
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
		throw 50001, 'fiksna napaka', 0
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
	commit transaction
	end
end try
begin catch
	print error_message()
	if @@TRANCOUNT>0
	begin
		print xact_state()
		rollback transaction
	end
end catch
