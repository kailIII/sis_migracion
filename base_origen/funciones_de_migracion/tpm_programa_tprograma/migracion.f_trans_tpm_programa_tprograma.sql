﻿CREATE OR REPLACE FUNCTION migracion.f_trans_tpm_programa_tprograma (
  v_operacion varchar,
  p_codigo_programa varchar,
  p_id_programa integer,
  p_id_usuario integer,
  p_descripcion_programa text,
  p_fecha_registro date,
  p_fecha_ultima_modificacion date,
  p_hora_registro time,
  p_hora_ultima_modificacion time,
  p_id_programa_actif integer,
  p_nombre_programa varchar
)
RETURNS varchar [] AS
$body$
DECLARE
			 
			g_registros record;
			v_consulta varchar;
			v_res_cone  varchar;
			v_cadena_cnx varchar;
			v_cadena_con varchar;
			resp boolean;
			v_resp varchar;
			v_respuesta varchar[];
			
			g_registros_resp record;
			v_codigo_programa varchar;
			v_id_programa int4;
			v_descripcion_programa text;
			v_estado_reg varchar;
			v_fecha_mod timestamp;
			v_fecha_reg timestamp;
			v_id_programa_actif int4;
			v_id_usuario_mod int4;
			v_id_usuario_reg int4;
			v_nombre_programa varchar;
BEGIN
			
			
			          --funcion para obtener cadena de conexion
			          v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
			          
			          
			           ---------------------------------------
			           --previamente se tranforman los datos  (descomentar)
			           ---------------------------------------

			v_codigo_programa=convert(p_codigo_programa::varchar, 'LATIN1', 'UTF8');
			v_id_programa=p_id_programa::int4;
			v_descripcion_programa=convert(p_descripcion_programa::text, 'LATIN1', 'UTF8');
			v_estado_reg='activo'::varchar;
			v_fecha_mod=p_fecha_ultima_modificacion::timestamp;
			v_fecha_reg=p_fecha_registro::timestamp;
			v_id_programa_actif=p_id_programa_actif::int4;
			v_id_usuario_mod=NULL::int4;
            IF(p_id_usuario IS NULL)THEN 			
                v_id_usuario_reg=1::int4;
            ELSE 
                v_id_usuario_reg=p_id_usuario::int4;
            END IF;
			v_nombre_programa=convert(p_nombre_programa::varchar, 'LATIN1', 'UTF8');
 
			    --cadena para la llamada a la funcion de insercion en la base de datos destino
			      
			        
			          v_consulta = 'select migra.f__on_trig_tpm_programa_tprograma (
			               '''||v_operacion::varchar||''','||COALESCE(''''||v_codigo_programa::varchar||'''','NULL')||','||COALESCE(v_id_programa::varchar,'NULL')||','||COALESCE(''''||v_descripcion_programa::varchar||'''','NULL')||','||COALESCE(''''||v_estado_reg::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_mod::varchar||'''','NULL')||','||COALESCE(''''||v_fecha_reg::varchar||'''','NULL')||','||COALESCE(v_id_programa_actif::varchar,'NULL')||','||COALESCE(v_id_usuario_mod::varchar,'NULL')||','||COALESCE(v_id_usuario_reg::varchar,'NULL')||','||COALESCE(''''||v_nombre_programa::varchar||'''','NULL')||')';
			          --probar la conexion con dblink
			          
					   --probar la conexion con dblink
			          v_resp =  (SELECT dblink_connect(v_cadena_cnx));
			            
			             IF(v_resp!='OK') THEN
			            
			             	--modificar bandera de fallo  
			                 raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
			                 
			             ELSE
					  
			         
			               PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
			                v_res_cone=(select dblink_disconnect());
			             END IF;
			            
			            v_respuesta[1]='TRUE';
                       
			           RETURN v_respuesta;
			EXCEPTION
			   WHEN others THEN
			     v_respuesta[1]='FALSE';
                 v_respuesta[2]=SQLERRM;
                 v_respuesta[3]=SQLSTATE;
                 v_respuesta[4]=v_consulta;
                 
    
                 
                 RETURN v_respuesta;
			
			END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;