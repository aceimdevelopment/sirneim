#creada por db2models
class TipoFormaPago < ActiveRecord::Base
	UNICO="UNICO"
	MITAD="MITAD"
	EXO="EXO"
  has_many :inscripcion
  accepts_nested_attributes_for :inscripcion

  has_many :preinscripcion
  accepts_nested_attributes_for :preinscripcion

end
