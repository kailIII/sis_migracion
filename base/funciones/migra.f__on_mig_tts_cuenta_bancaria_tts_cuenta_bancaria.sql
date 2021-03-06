--------------- SQL ---------------

CREATE OR REPLACE FUNCTION migra.f__on_trig_tts_cuenta_bancaria_tts_cuenta_bancaria (
  v_operacion varchar,
  p_id_cuenta_bancaria integer,
  p_estado_cuenta numeric,
  p_id_auxiliar integer,
  p_id_cuenta integer,
  p_id_institucion integer,
  p_id_parametro integer,
  p_nro_cheque integer,
  p_nro_cuenta_banco varchar,
  p_id_gestion integer,
  p_central varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  November 30, 2013, 11:10 am
						Autor: autogenerado (ADMINISTRADOR DEL SISTEMA )
						
						*/
						
DECLARE

	v_id_cuenta_bancaria integer;
    v_id_cuenta_bancaria_pxp integer;
						
BEGIN
						
	if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            MIGRA.tts_cuenta_bancaria (
						id_cuenta_bancaria,
						estado_cuenta,
						id_auxiliar,
						id_cuenta,
						id_institucion,
						id_parametro,
						nro_cheque,
						nro_cuenta_banco,
                        id_gestion,
                        centro)
				VALUES (
						p_id_cuenta_bancaria,
						p_estado_cuenta,
						p_id_auxiliar,
						p_id_cuenta,
						p_id_institucion,
						p_id_parametro,
						p_nro_cheque,
						p_nro_cuenta_banco,
                        p_id_gestion,
                        p_central);

		-------------------------------------------
		--Inserción en table tes.tcuenta_bancaria
        -------------------------------------------
        --Verificación de existencia de la cuenta por nro_cuenta
        select cb.id_cuenta_bancaria
        into v_id_cuenta_bancaria
        from tes.tcuenta_bancaria cb
        where cb.nro_cuenta = p_nro_cuenta_banco;
        
        if v_id_cuenta_bancaria is not null then
        	--Ya existe creada esta cuenta bancaria. Sólo guarda la referencia entre registros
            update migra.tts_cuenta_bancaria set
            id_cuenta_bancaria_pxp = v_id_cuenta_bancaria
            where id_cuenta_bancaria = p_id_cuenta_bancaria;
            
        else
        	--Cuenta bancaria nueva. Se realiza el nuevo registro más la referencia entre registros
            INSERT INTO 
              tes.tcuenta_bancaria
            (
              id_usuario_reg,
              id_usuario_mod,
              fecha_reg,
              fecha_mod,
              estado_reg,
              id_cuenta_bancaria,
              id_institucion,
              nro_cuenta,
              fecha_alta,
              fecha_baja,
              id_moneda,
              centro
            ) 
            VALUES (
              1,
              null,
              now(),
              null,
              'activo',
              p_id_cuenta_bancaria,
              p_id_institucion,
              p_nro_cuenta_banco,
              null,
              null,
              1,
              p_central
            );
            
            update migra.tts_cuenta_bancaria set
            id_cuenta_bancaria_pxp = p_id_cuenta_bancaria
            where id_cuenta_bancaria = p_id_cuenta_bancaria;
            
            --MIGRACION DE SU RELACION CONTABLE
            
            
        end if;
        
                        

						       
	ELSEIF  v_operacion = 'UPDATE' THEN
    
    
     --chequear si ya existe el registro si no sacar un error
      IF  not EXISTS(select 1 
         from  MIGRA.tts_cuenta_bancaria  
         where id_cuenta_bancaria=p_id_cuenta_bancaria) THEN
                                                       
          raise exception 'No existe el registro que desea modificar';
                                                            
       END IF; 
    
    
    
    
						 UPDATE MIGRA.tts_cuenta_bancaria SET						 
						 estado_cuenta=p_estado_cuenta
						 ,id_auxiliar=p_id_auxiliar
						 ,id_cuenta=p_id_cuenta
						 ,id_institucion=p_id_institucion
						 ,id_parametro=p_id_parametro
						 ,nro_cheque=p_nro_cheque
						 ,nro_cuenta_banco=p_nro_cuenta_banco
                         ,centro=p_central
						 WHERE id_cuenta_bancaria=p_id_cuenta_bancaria;
                         
    	--Obtiene el id_cuenta_bancaria_pxp para realizar el update
        select
        cb.id_cuenta_bancaria_pxp
        into v_id_cuenta_bancaria_pxp
        from migra.tts_cuenta_bancaria cb
        where id_cuenta_bancaria=p_id_cuenta_bancaria;
                         
		--Actualiza cuenta bancaria de pxp
        update tes.tcuenta_bancaria set
        id_usuario_mod = 1,
        fecha_mod = now(),
        estado_reg = (case when p_estado_cuenta = 1 then 'activo' else 'inactivo' end),
        id_institucion = p_id_institucion,
        centro=p_central,
        nro_cuenta = p_nro_cuenta_banco --,
      	--  fecha_alta = :fecha_alta,
      	--  fecha_baja = :fecha_baja,
      	--  id_moneda = :id_moneda
      	WHERE id_cuenta_bancaria = v_id_cuenta_bancaria_pxp;                          

						       
	ELSEIF  v_operacion = 'DELETE' THEN
						       
          --chequear si ya existe el registro si no sacar un error
      IF  not EXISTS(select 1 
         from   MIGRA.tts_cuenta_bancaria  
         where id_cuenta_bancaria=p_id_cuenta_bancaria) THEN
                                                       
          raise exception 'No existe el registro que desea modificar';
                                                            
       END IF;
          
          
          --Obtiene el id_cuenta_bancaria_pxp para realizar el delete
        select
        cb.id_cuenta_bancaria_pxp
        into v_id_cuenta_bancaria_pxp
        from migra.tts_cuenta_bancaria cb
        where id_cuenta_bancaria=p_id_cuenta_bancaria;
        
        DELETE FROM 
           MIGRA.tts_cuenta_bancaria
          WHERE id_cuenta_bancaria=p_id_cuenta_bancaria;
        
        delete from tes.tcuenta_bancaria where id_cuenta_bancaria = v_id_cuenta_bancaria_pxp;

						       
	END IF;  
						  
	return 'true';
	
	END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;