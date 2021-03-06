﻿CREATE OR REPLACE FUNCTION migracion.f_tri_tpm_programa_proyecto_actividad_tprograma_proyecto_acttiv (
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
		   
			 v_consulta =  'SELECT migracion.f_trans_tpm_programa_proyecto_actividad_tprograma_proyecto_acttividad (
                  '''||TG_OP::varchar||''','||COALESCE(NEW.id_prog_proy_acti::varchar,'NULL')||','||COALESCE(NEW.id_actividad::varchar,'NULL')||','||COALESCE(NEW.id_programa::varchar,'NULL')||','||COALESCE(NEW.id_proyecto::varchar,'NULL')||','||COALESCE(NEW.id_usuario::varchar,'NULL')||','||COALESCE(''''||NEW.ep_actif::varchar||'''','NULL')||','||COALESCE(''''||NEW.fecha_reg::varchar||'''','NULL')||') as res';				  
		  ELSE 
		      v_consulta =  ' SELECT migracion.f_trans_tpm_programa_proyecto_actividad_tprograma_proyecto_acttividad (
		              '''||TG_OP::varchar||''','||OLD.id_prog_proy_acti||',NULL,NULL,NULL,NULL,NULL,NULL) as res';
		       
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