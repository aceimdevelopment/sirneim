class Grupo < ActiveRecord::Base

  has_many :inscripcion
  accepts_nested_attributes_for :inscripcion

  has_many :preinscripcion
  accepts_nested_attributes_for :preinscripcion

end