CREATE OR REPLACE FUNCTION migra.f__on_trig_tpr_programa_tcp_programa (
						  v_operacion varchar,p_id_cp_programa int4,p_codigo varchar,p_descripcion varchar,p_estado_reg varchar,p_fecha_mod timestamp,p_fecha_reg timestamp,p_id_gestion int4,p_id_usuario_ai int4,p_id_usuario_mod int4,p_id_usuario_reg int4,p_usuario_ai varchar)
						RETURNS text AS
						$BODY$

/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  April 19, 2016, 12:45 pm
						Autor: autogenerado (ENDESIS ROOT SISTEMA)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PRE.tcp_programa (
						id_cp_programa,
						codigo,
						descripcion,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_gestion,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						usuario_ai)
				VALUES (
						p_id_cp_programa,
						p_codigo,
						p_descripcion,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_gestion,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_usuario_ai);

                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from PRE.tcp_programa
 
                                           						 WHERE id_cp_programa=p_id_cp_programa) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  PRE.tcp_programa  
						                SET						 codigo=p_codigo
						 ,descripcion=p_descripcion
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_gestion=p_id_gestion
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,usuario_ai=p_usuario_ai
						 WHERE id_cp_programa=p_id_cp_programa;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from PRE.tcp_programa
						 WHERE id_cp_programa=p_id_cp_programa) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              PRE.tcp_programa
 
						              						 WHERE id_cp_programa=p_id_cp_programa;

						       
						       END IF;  
						  
						 return 'true';
						
						-- statements;
						--EXCEPTION
						--WHEN exception_name THEN
						--  statements;
						END;
						$BODY$


						LANGUAGE 'plpgsql'
						VOLATILE
						CALLED ON NULL INPUT
						SECURITY INVOKER
						COST 100;