CREATE OR REPLACE FUNCTION migra.f__on_trig_tkp_empleado_afp_tfuncionario_afp (
  v_operacion varchar,
  p_id_funcionario_afp integer,
  p_id_afp integer,
  p_estado_reg varchar,
  p_fecha_fin date,
  p_fecha_ini date,
  p_fecha_mod timestamp,
  p_fecha_reg timestamp,
  p_id_funcionario integer,
  p_id_usuario_ai integer,
  p_id_usuario_mod integer,
  p_id_usuario_reg integer,
  p_nro_afp varchar,
  p_tipo_jubilado varchar,
  p_usuario_ai varchar
)
RETURNS text AS
$body$
/*
						Function:  Para migracion de la tabla param.tgestion
						Fecha Creacion:  June 17, 2014, 11:46 am
						Autor: autogenerado (JAIME RIVERA ROJAS)
						
						*/
						
						DECLARE
						
						BEGIN
						
						    if(v_operacion = 'INSERT') THEN
						
						          INSERT INTO 
						            PLANI.tfuncionario_afp (
						id_funcionario_afp,
						id_afp,
						estado_reg,
						fecha_fin,
						fecha_ini,
						fecha_mod,
						fecha_reg,
						id_funcionario,
						id_usuario_ai,
						id_usuario_mod,
						id_usuario_reg,
						nro_afp,
						tipo_jubilado,
						usuario_ai)
				VALUES (
						p_id_funcionario_afp,
						p_id_afp,
						'activo',
						p_fecha_fin,
						p_fecha_ini,
						p_fecha_mod,
						p_fecha_reg,
						p_id_funcionario,
						p_id_usuario_ai,
						p_id_usuario_mod,
						p_id_usuario_reg,
						p_nro_afp,
						(case when p_tipo_jubilado is null then 'no' else p_tipo_jubilado end),
						p_usuario_ai);

						       
							    ELSEIF  v_operacion = 'UPDATE' THEN
						               
						               IF  not EXISTS(select 1 
                                           from PLANI.tfuncionario_afp
 
                                           where id_funcionario_afp=p_id_funcionario_afp) THEN
                                       
                                            raise exception 'No existe el registro que  desea modificar';
                                            
                                       END IF;
						               
						               
						               UPDATE 
						                  PLANI.tfuncionario_afp  
						                SET						 id_afp=p_id_afp						 
						 ,fecha_fin=p_fecha_fin
						 ,fecha_ini=p_fecha_ini
						 ,fecha_mod=p_fecha_mod
						 ,fecha_reg=p_fecha_reg
						 ,id_funcionario=p_id_funcionario
						 ,id_usuario_ai=p_id_usuario_ai
						 ,id_usuario_mod=p_id_usuario_mod
						 ,id_usuario_reg=p_id_usuario_reg
						 ,nro_afp=p_nro_afp
						 ,tipo_jubilado=(case when p_tipo_jubilado is null then 'no' else p_tipo_jubilado end)
						 ,usuario_ai=p_usuario_ai
						 WHERE id_funcionario_afp=p_id_funcionario_afp;

						       
						       ELSEIF  v_operacion = 'DELETE' THEN
						       
						         
						         IF  not EXISTS(select 1 
                                           from PLANI.tfuncionario_afp
 
                                           where id_funcionario_afp=p_id_funcionario_afp) THEN
                                       
                                            raise exception 'No existe el registro que  desea eliminar';
                                            
                                END IF;
						         
						         
						         DELETE FROM 
						              PLANI.tfuncionario_afp
 
						              						 WHERE id_funcionario_afp=p_id_funcionario_afp;

						       
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