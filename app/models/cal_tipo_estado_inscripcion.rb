class CalTipoEstadoInscripcion < ActiveRecord::Base
	attr_accessible :id, :descripcion

	has_many :cal_estudienate_seccion,
	:foreign_key => ['tipo_estado_inscripcion_id']
	accepts_nested_attributes_for :cal_estudienate_seccion

end