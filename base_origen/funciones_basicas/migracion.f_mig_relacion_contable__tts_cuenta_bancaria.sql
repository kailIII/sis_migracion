CREATE OR REPLACE FUNCTION migracion.f_mig_relacion_contable__tts_cuenta_bancaria (
  p_operacion varchar,
  p_id_relacion_contable integer,
  p_id_cuenta_bancaria integer,
  p_id_cuenta integer,
  p_id_auxiliar integer,
  p_id_centro_costo integer,
  p_id_gestion integer,
  p_nro_cuenta_banco varchar,
  p_denominacion varchar,
  p_centro varchar,
  p_id_institucion integer
)
RETURNS integer AS
$body$
/*
Autor: RCM
Fecha: 23/12/2013
Descripción: Función para migrar la cuenta bancaria
*/

DECLARE

	v_respuesta varchar;
	v_id_parametro integer;
    v_id_cuenta_bancaria integer;

BEGIN

	--Obtener parametro de tesoreria
    select id_parametro
    into v_id_parametro
    from tesoro.tts_parametro pa
    where pa.id_gestion = p_id_gestion;
    
    select id_cuenta_bancaria into v_id_cuenta_bancaria
    from tesoro.tts_cuenta_bancaria
    where nro_cuenta_banco = p_nro_cuenta_banco
				and id_parametro = v_id_parametro;

	if p_operacion = 'INSERT' then
		
		--Verifica si ya existe registrado esa cuenta en este parametro
		if exists(select 1 from tesoro.tts_cuenta_bancaria
				where nro_cuenta_banco = p_nro_cuenta_banco
				and id_parametro = v_id_parametro) then

			--Actualiza el registro
			UPDATE tesoro.tts_cuenta_bancaria SET
			id_cuenta = p_id_cuenta,
			id_auxiliar = p_id_auxiliar
			WHERE nro_cuenta_banco = p_nro_cuenta_banco
			and id_parametro = v_id_parametro;
			
		else
        
        	if not exists(select 1 from param.tpm_institucion
            			where id_institucion = p_id_institucion) then
            	raise exception 'Error al migrar cuenta a Endesis, no existe la Institución';
            end if;
		
			--Inserción del registro
	        INSERT INTO tesoro.tts_cuenta_bancaria (
--			  id_cuenta_bancaria,
			  id_institucion,
			  id_cuenta,
			  nro_cuenta_banco,
			  nro_cheque,
			  estado_cuenta,
			  id_auxiliar,
			  id_parametro,
              denominacion,
              central
			) values(
--			  p_id_cuenta_bancaria,
			  p_id_institucion,
			  p_id_cuenta,
			  p_nro_cuenta_banco,
			  0,
			  1,
			  p_id_auxiliar,
			  v_id_parametro,
              p_denominacion,
              p_centro
			) returning id_cuenta_bancaria into v_id_cuenta_bancaria ;
			
		end if;

        --Respuesta
        v_respuesta= 'Migración de parametrización de Cuenta Bancaria de pxp a endesis realizada';
    
    elsif p_operacion = 'UPDATE' then
    	
    	--Actualiza el registro
		update tesoro.tts_cuenta_bancaria set
		id_cuenta = p_id_cuenta,
		id_auxiliar = p_id_auxiliar,
        denominacion = p_denominacion,
        central = p_centro
		WHERE nro_cuenta_banco = p_nro_cuenta_banco
		and id_parametro = v_id_parametro;
        
        --Respuesta
        v_respuesta= 'Modificación de parametrización de Cuenta Bancaria de pxp a endesis realizada';
        
    else
    	--Eliminación: se intenta eliminar la cuenta bancaria cuando se borró la relación contable
    	
    	delete from tesoro.tts_cuenta_bancaria
        where nro_cuenta_banco = p_nro_cuenta_banco
		and id_parametro = v_id_parametro;
        
        --Respuesta
        v_respuesta= 'Eliminación de Cuenta Bancaria realizada';
    
    end if;

	
	return v_id_cuenta_bancaria;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;