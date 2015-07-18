class CalEstudianteSeccion < ActiveRecord::Base

	set_primary_keys :cal_estudiante_ci, :cal_numero, :cal_materia_id, :cal_semestre_id

	attr_accessible :cal_estudiante_ci, :cal_numero, :cal_materia_id, :cal_semestre_id, 
	:calificacion_primera, :calificacion_segunda, :calificacion_tercera, :calificacion_final, 
	:cal_tipo_estado_caliticacion_id, :cal_tipo_estado_inscripcion_id

	belongs_to :cal_seccion,
    	:foreign_key => [:cal_numero, :cal_materia_id, :cal_semestre_id]

	belongs_to :cal_estudiante,
    	:primary_key => :cal_usuario_ci,
    	:foreign_key => :cal_estudiante_ci

	belongs_to :cal_tipo_estado_caliticacion
	belongs_to :cal_tipo_estado_inscripcion

end