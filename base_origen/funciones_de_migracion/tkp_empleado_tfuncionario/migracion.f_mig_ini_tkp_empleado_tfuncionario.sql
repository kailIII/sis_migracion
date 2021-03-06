﻿CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tkp_empleado_tfuncionario (
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tfuncionario'',''ORGA'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT 
						codigo_empleado,
						id_empleado,
						id_auxiliar,
						id_cuenta,
						id_depto,
						id_escala_salarial,
						id_lugar_trabajo,
						id_persona,
						id_usuario_reg,
						antiguedad_ant,
						apodo,
						compensa,
						estado_reg,
						fecha_ingreso,
						fecha_reg,
						id_empleado_actif,
						marca,
						nivel_academico
FROM 
						          KARD.tkp_empleado) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tkp_empleado_tfuncionario(
						            'INSERT',g_registros.codigo_empleado
					,g_registros.id_empleado
					,g_registros.id_auxiliar
					,g_registros.id_cuenta
					,g_registros.id_depto
					,g_registros.id_escala_salarial
					,g_registros.id_lugar_trabajo
					,g_registros.id_persona
					,g_registros.id_usuario_reg
					,g_registros.antiguedad_ant
					,g_registros.apodo
					,g_registros.compensa
					,g_registros.estado_reg
					,g_registros.fecha_ingreso
					,g_registros.fecha_reg
					,g_registros.id_empleado_actif
					,g_registros.marca
					,g_registros.nivel_academico
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tfuncionario'',''ORGA'',''insertar'')';                   
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