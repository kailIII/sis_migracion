CREATE OR REPLACE FUNCTION migracion.f_tri_tts_libro_bancos_tts_libro_bancos (
)
RETURNS trigger AS
$body$
DECLARE
		 
		g_registros record;
		v_consulta varchar;
		v_res_cone  varchar;
		v_cadena_cnx varchar;
		v_cadena_con varchar;
		resp boolean;

		
		BEGIN
		   IF(TG_OP = 'INSERT' or  TG_OP ='UPDATE' ) THEN
		   
			 v_consulta =  'SELECT migracion.f_trans_tts_libro_bancos_tts_libro_bancos (
                  '''||TG_OP::varchar||''','||COALESCE(NEW.id_cuenta_bancaria::varchar,'NULL')||','||COALESCE(NEW.id_libro_bancos::varchar,'NULL')||','||COALESCE(NEW.fk_libro_bancos::varchar,'NULL')||','||COALESCE(NEW.id_cuenta_bancaria::varchar,'NULL')||','||COALESCE(''''||NEW.a_favor::varchar||'''','NULL')||','||COALESCE(''''||NEW.detalle::varchar||'''','NULL')||','||COALESCE(''''||NEW.estado::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||','||COALESCE(NEW.importe_cheque::varchar,'NULL')||','||COALESCE(NEW.importe_deposito::varchar,'NULL')||','||COALESCE(NEW.indice::varchar,'NULL')||','||COALESCE(NEW.nro_cheque::varchar,'NULL')||','||COALESCE(''''||NEW.nro_comprobante::varchar||'''','NULL')||','||COALESCE(''''||NEW.nro_liquidacion::varchar||'''','NULL')||','||COALESCE(''''||NEW.observaciones::varchar||'''','NULL')||','||COALESCE(''''||NEW.origen::varchar||'''','NULL')||','||COALESCE(''''||NEW.tipo::varchar||'''','NULL')||','||COALESCE(''''||NEW.usr_mod::varchar||'''','NULL')||','||COALESCE(''''||NEW.usr_reg::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tts_libro_bancos_tts_libro_bancos (
		              '''||TG_OP::varchar||''',NULL,'||OLD.id_libro_bancos||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
		  END IF;
		   --------------------------------------
		   -- PARA PROBAR SI FUNCIONA LA FUNCION DE TRANFROMACION, HABILITAR EXECUTE
		   ------------------------------------------
		     --EXECUTE (v_consulta);
		   
		   
		    INSERT INTO 
		                      migracion.tmig_migracion
		                    (
		                      verificado,
		                      consulta,
		                      operacion
		                    ) 
		                    VALUES (
		                      'no',
		                       v_consulta,
		                       TG_OP::varchar
		                       
		                    );
		
		  RETURN NULL;
		
		END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;