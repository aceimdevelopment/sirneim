class CalSemestre < ActiveRecord::Base

	attr_accessible :id, :fecha_inicio, :fecha_culminacion

	has_many :cal_secciones,
		:class_name => 'CalSeccion'

	accepts_nested_attributes_for :cal_secciones

end
