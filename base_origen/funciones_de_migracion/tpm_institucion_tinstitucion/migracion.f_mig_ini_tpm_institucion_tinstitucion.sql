CREATE OR REPLACE FUNCTION migracion.f_mig_ini_tpm_institucion_tinstitucion()
						RETURNS boolean AS
						$BODY$


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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tinstitucion'',''PARAM'',''eliminar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						
						   --consulta los registro de la tabla origen
						    FOR g_registros in (
						        SELECT DISTINCT
						inst.id_institucion,
						inst.id_tipo_doc_institucion,
						inst.casilla,
						inst.celular1,
						inst.celular2,
						inst.codigo,
						inst.codigo_banco,
						inst.direccion,
						inst.doc_id,
						inst.email1,
						inst.email2,
						inst.estado_institucion,
						inst.fax,
						inst.fecha_registro,
						inst.fecha_ultima_modificacion,
						inst.hora_registro,
						inst.hora_ultima_modificacion,
						inst.id_persona,
						inst.nombre,
						inst.observaciones,
						inst.pag_web,
						inst.telefono1,
						inst.telefono2,
						case coalesce(cban.id_institucion,0)
                        	when 0 then 'no'::varchar
                            else 'si'::varchar
                        end as es_banco
						FROM 
						PARAM.tpm_institucion inst
						LEFT JOIN tesoro.tts_cuenta_bancaria cban
						ON cban.id_institucion = inst.id_institucion) LOOP
						        
						        -- inserta en el destino
						      
						            v_cadena_resp = migracion.f_trans_tpm_institucion_tinstitucion(
						            'INSERT'
					,g_registros.id_institucion
					,g_registros.id_tipo_doc_institucion
					,g_registros.casilla
					,g_registros.celular1
					,g_registros.celular2
					,g_registros.codigo
					,g_registros.codigo_banco
					,g_registros.direccion
					,g_registros.doc_id
					,g_registros.email1
					,g_registros.email2
					,g_registros.estado_institucion
					,g_registros.fax
					,g_registros.fecha_registro
					,g_registros.fecha_ultima_modificacion
					,g_registros.hora_registro
					,g_registros.hora_ultima_modificacion
					,g_registros.id_persona
					,g_registros.nombre
					,g_registros.observaciones
					,g_registros.pag_web
					,g_registros.telefono1
					,g_registros.telefono2
					,g_registros.es_banco
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
						       v_consulta = 'select pxp.f_add_remove_foraneas(''tinstitucion'',''PARAM'',''insertar'')';                   
						       raise notice '%',v_consulta;
						       PERFORM * FROM dblink(v_consulta,true) AS ( xx varchar);
						        v_res_cone=(select dblink_disconnect());
						     END IF;
						
						RETURN TRUE;
						END;
						$BODY$


						LANGUAGE 'plpgsql'
						VOLATILE
						CALLED ON NULL INPUT
						SECURITY INVOKER;