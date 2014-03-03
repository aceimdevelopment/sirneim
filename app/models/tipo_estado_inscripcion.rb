class TipoEstadoInscripcion < ActiveRecord::Base
  has_many :inscripcion
  accepts_nested_attributes_for :inscripcion
end
