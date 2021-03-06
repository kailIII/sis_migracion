CREATE OR REPLACE FUNCTION migra.f__on_trig_tts_finalidad_tfinalidad (
  v_operacion varchar,
  p_id_finalidad integer,
  p_color varchar,
  p_estado varchar,
  p_estado_reg varchar,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nombre_finalidad varchar,
  p_usuario_ai varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  October 27, 2014, 5:03 pm
						Autor: autogenerado (GONZALO JOSE SARMIENTO SEJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            TES.tfinalidad (
						id_finalidad,
						color,
						estado,
						estado_reg,
						fecha_mod,
						fecha_reg,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						nombre_finalidad,
						usuario_ai)
				VALUES (
						p_id_finalidad,
						p_color,
						p_estado,
						p_estado_reg,
						p_fecha_mod,
						p_fecha_reg,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nombre_finalidad,
						p_usuario_ai);

                               
                                ELSEIF  v_operacion = 'UPDATE' THEN
                                       
                                       IF  not EXISTS(select 1 
                                           from TES.tfinalidad
 
                                           						 WHERE id_finalidad=p_id_finalidad) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  TES.tfinalidad  
						                SET						 color=p_color
						 ,estado=p_estado
						 ,estado_reg=p_estado_reg
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nombre_finalidad=p_nombre_finalidad
						 ,usuario_ai=p_usuario_ai
						 WHERE id_finalidad=p_id_finalidad;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from TES.tfinalidad
						 WHERE id_finalidad=p_id_finalidad) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              TES.tfinalidad
 
						              						 WHERE id_finalidad=p_id_finalidad;

						       
						       END IF;  
						  
						 return 'true';
						
						-- statements;
						--EXCEPTION
						--WHEN exception_name THEN
						--  statements;
						END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;