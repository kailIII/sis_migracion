CREATE OR REPLACE FUNCTION migracion.f_mig_ini_taf_clasificacion_tclasificacion (
)
RETURNS boolean AS
$body$
						DECLARE
						 
						g_registros record;
						v_consulta varchar;
						v_res_cone varchar;
						v_cadena_cnx varchar;
						v_resp varchar;
						
						v_cadena_resp varchar[];
						
						BEGIN
						     --funcion para obtener cadena de conexion
							 v_cadena_cnx =  migracion.f_obtener_cadena_con_dblink();
									          
						  
						    --quirta llaves foraneas en el destino
						     v_resp =  (SELECT dblink_connect(v_cadena_cnx));
									            
						     IF(v_resp!='OK') THEN
									            
						        --modificar bandera de fallo  
						         raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
									                 
						     ELSE
                             	
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tclasificacion'',''ALM'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
                               
						        v_res_cone=(select dblink_disconnect());
                                
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						codigo,
						id_clasificacion,
						correlativo_act,
						descripcion,
						estado,
						fecha_mod,
						fecha_reg,
						fk_id_clasificacion,
						flag_depreciacion,
						id,
						id_metodo_depreciacion,
						id_padre,
						id_usuario_mod,
						id_usuario_reg,
						ini_correlativo,
						nivel,
						tipo,
						vida_util
FROM 
						          ACTIF.taf_clasificacion
                                  order by id_clasificacion) LOOP
						        
						        -- inserta en el destino

						            v_cadena_resp = migracion.f_trans_taf_clasificacion_tclasificacion(
						            'INSERT',g_registros.codigo
					,g_registros.id_clasificacion
					,g_registros.correlativo_act
					,g_registros.descripcion
					,g_registros.estado
					,g_registros.fecha_mod
					,g_registros.fecha_reg
					,g_registros.fk_id_clasificacion
					,g_registros.flag_depreciacion
					,g_registros.id
					,g_registros.id_metodo_depreciacion
					,g_registros.id_padre
					,g_registros.id_usuario_mod
					,g_registros.id_usuario_reg
					,g_registros.ini_correlativo
					,g_registros.nivel
					,g_registros.tipo
					,g_registros.vida_util
					);	
                   
					            IF v_cadena_resp[1] = 'FALSE' THEN
					              RAISE NOTICE 'ERROR ->>>  (%),(%) - %   ', v_cadena_resp[3], v_cadena_resp[2], v_cadena_resp[4];
					            END IF; 	
						 END LOOP;
						
						     --reconstruye llaves foraneas
						     v_resp =  (SELECT dblink_connect(v_cadena_cnx));
									            
						     IF(v_resp!='OK') THEN
									            
						        --modificar bandera de fallo  
						         raise exception 'FALLA CONEXION A LA BASE DE DATOS CON DBLINK';
									                 
						     ELSE
                             
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tclasificacion'',''ALM'',''insertar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						RETURN TRUE;
						END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;