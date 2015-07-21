class CalTipoEstadoCalificacion < ActiveRecord::Base
	attr_accessible :id, :descripcion	
	has_many :cal_estudiante_seccion,
	:foreign_key => ['tipo_estado_calificacion_id']
	accepts_nested_attributes_for :cal_estudiante_seccion

end