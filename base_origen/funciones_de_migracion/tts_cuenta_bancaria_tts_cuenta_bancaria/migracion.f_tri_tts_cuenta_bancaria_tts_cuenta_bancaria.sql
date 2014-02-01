
		CREATE OR REPLACE FUNCTION migracion.f_tri_tts_cuenta_bancaria_tts_cuenta_bancaria ()
		RETURNS trigger AS
		$BODY$

DECLARE
		 
		g_registros record;
		v_consulta varchar;
		v_res_cone  varchar;
		v_cadena_cnx varchar;
		v_cadena_con varchar;
		resp boolean;
		
		BEGIN
		   IF(TG_OP = 'INSERT' or  TG_OP ='UPDATE' ) THEN
		   
			 v_consulta =  'SELECT migracion.f_trans_tts_cuenta_bancaria_tts_cuenta_bancaria (
                  '''||TG_OP::varchar||''','||COALESCE(NEW.id_cuenta_bancaria::varchar,'NULL')||','||COALESCE(NEW.id_auxiliar::varchar,'NULL')||','||COALESCE(NEW.id_cuenta::varchar,'NULL')||','||COALESCE(NEW.id_institucion::varchar,'NULL')||','||COALESCE(NEW.id_parametro::varchar,'NULL')||','||COALESCE(NEW.estado_cuenta::varchar,'NULL')||','||COALESCE(NEW.nro_cheque::varchar,'NULL')||','||COALESCE(''''||NEW.nro_cuenta_banco::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tts_cuenta_bancaria_tts_cuenta_bancaria (
		              '''||TG_OP::varchar||''','||OLD.id_cuenta_bancaria||',NULL,NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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
		$BODY$LANGUAGE 'plpgsql'
		VOLATILE
		CALLED ON NULL INPUT
		SECURITY INVOKER;