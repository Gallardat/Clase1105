
--Crear dos tablas la de cuentas con id, saldo, la otra de movimientos con id, tipo de movimiento y monto
--Realizar un pa que: inserte en la tabla de movimientos y actualice el saldo en una transacción

--------------------------------
---PROCEDIMIENTO ALMACENADO-----
--------------------------------
--CREAMOS TABLAS
create table cuentas(id_cuenta serial primary key, saldo numeric);
create table movimientos(id_movimientos serial primary key, tipo_movimiento varchar(20), monto numeric)
--HACEMOS INSERT EN LA CUENTA PARA TRABAJAR CON ELLA
insert into cuentas(saldo)values(5000);
insert into cuentas(saldo)values(4000);
insert into cuentas(saldo)values(0);
SELECT * FROM cuentas;
SELECT * FROM movimientos;


CREATE  OR REPLACE PROCEDURE actualizar_saldo(
	IN tipo_mov varchar,
	IN _monto numeric,
	IN cuenta integer
) 
AS $$ 
BEGIN 
--si el tipo de movimiento es retiro
	IF tipo_mov ='retiro' THEN 
-- verificamos si tiene saldo la cuenta o no. 
			IF(SELECT saldo FROM cuentas WHERE id_cuenta=cuenta)< _monto THEN
				RAISE SQLSTATE '22012';
			END IF;
	-- actualizamos la cuenta restandole
			insert into movimientos(tipo_movimiento,monto) values (tipo_mov,_monto);
		UPDATE cuentas SET saldo = saldo - _monto WHERE id_cuenta=cuenta;
	ELSE
--si el tipo de movimiento es ingreso
		IF tipo_mov='ingreso' THEN 
	-- actualizamos la cuenta sumandole 
			IF _monto <1 THEN
				RAISE SQLSTATE '22013';
			END IF;
				insert into movimientos(tipo_movimiento,monto) values (tipo_mov,_monto);
				UPDATE cuentas SET saldo = saldo + _monto WHERE id_cuenta=cuenta;
		END IF;
	END IF;
	
	EXCEPTION
    WHEN SQLSTATE '22012' THEN
        RAISE NOTICE 'No cuenta con saldo suficiente.';
        rollback;
        commit;
	WHEN SQLSTATE '22013' THEN
        RAISE NOTICE 'Tiene que ingresar mas de 0';
        rollback;
        commit;
END;
$$ LANGUAGE 'plpgsql';

call actualizar_saldo('ingreso',0,1)


-------------------------------
-----TRIGGERS ejercicio 1------
-------------------------------
create table cuentas(id_cuenta serial, 
					 saldo numeric
					CONSTRAINT pk_cuentas PRIMARY KEY (id_cuenta));
create table movimientos(id_movimientos serial,
						 tipo_movimiento varchar(20),
						 monto numeric, 
						 cuenta integer,
						CONSTRAINT pk_movimientos PRIMARY KEY (id_movimientos),
						CONSTRAINT pk_cuenta FOREIGN KEY (cuenta)
						REFERENCES cuentas(id_cuenta))

CREATE OR REPLACE FUNCTION update_cuenta()
returns trigger
as
$$
BEGIN
	IF new.tipo_movimiento ='retiro' THEN 
			IF(SELECT saldo FROM cuentas WHERE id_cuenta=new.cuenta)< new.monto THEN
				RAISE SQLSTATE '22012';
			END IF;
		UPDATE cuentas SET saldo = saldo - new.monto WHERE id_cuenta=new.cuenta;
	ELSIF new.tipo_movimiento='ingreso' THEN 
			IF new.monto <1 THEN
				RAISE SQLSTATE '22013';
			END IF;
		UPDATE cuentas SET saldo = saldo + new.monto WHERE id_cuenta=new.cuenta;
	END IF;
RETURN new;
EXCEPTION
    WHEN SQLSTATE '22012' THEN
        RAISE NOTICE 'No cuenta con saldo suficiente.';
        rollback;
        commit;
	WHEN SQLSTATE '22013' THEN
        RAISE NOTICE 'Tiene que ingresar mas de 0';
        rollback;
        commit;
end;
$$ LANGUAGE 'plpgsql';

CREATE trigger	trigger_update_cuenta
before insert
on movimientos
for each row
execute procedure update_cuenta();

INSERT INTO movimientos (tipo_movimiento,monto,cuenta) VALUES('ingreso',100,3);

SELECT * FROM cuentas;
SELECT * FROM movimientos;	

drop trigger if exists trigger_update_cuenta on movimientos;



-------------------------------
-----TRIGGERS ejercicio 2------
-------------------------------
create table cuentas(id_cuenta serial, 
					 saldo numeric
					CONSTRAINT pk_cuentas PRIMARY KEY (id_cuenta));
create table movimientos(id_movimientos serial,
						 tipo_movimiento varchar(20),
						 monto numeric, 
						 cuenta integer,
						CONSTRAINT pk_movimientos PRIMARY KEY (id_movimientos),
						CONSTRAINT pk_cuenta FOREIGN KEY (cuenta)
						REFERENCES cuentas(id_cuenta))

CREATE OR REPLACE FUNCTION insert_movimiento()
returns trigger
as
$$
BEGIN
if new.saldo > old.saldo THEN
	INSERT INTO movimientos (tipo_movimiento,monto,cuenta) VALUES('ingreso',new.saldo+old.saldo,new.cuenta);
ELSE
	INSERT INTO movimientos (tipo_movimiento,monto,cuenta) VALUES('retiro',new.saldo-old.saldo,100,new.cuenta);
END IF;
RETURN new;
end;
$$ LANGUAGE 'plpgsql';

CREATE trigger	trigger_update_cuenta
after insert
on cuentas
for each row
execute procedure update_cuenta();


UPDATE cuentas SET saldo = saldo - 100 WHERE id_cuenta=1;
UPDATE cuentas SET saldo = saldo + 200 WHERE id_cuenta=2;
--INSERT INTO movimientos (tipo_movimiento,monto,cuenta) VALUES('ingreso',100,3);

SELECT * FROM cuentas;
SELECT * FROM movimientos;	

drop trigger if exists trigger_update_cuenta on movimientos;







	
	