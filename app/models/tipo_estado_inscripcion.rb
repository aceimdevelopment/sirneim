class TipoEstadoInscripcion < ActiveRecord::Base
	attr_accessible :id, :nombre

	has_many :inscripcion
	accepts_nested_attributes_for :inscripcion

end
