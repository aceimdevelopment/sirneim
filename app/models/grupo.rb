class Grupo < ActiveRecord::Base

  has_many :inscripciones
  accepts_nested_attributes_for :inscripciones

  has_many :cohortes_temas
  accepts_nested_attributes_for :cohortes_temas

  validates :id, :presence => true, :uniqueness => true, :length => {:maximum => 1}
  # has_many :preinscripcion
  # accepts_nested_attributes_for :preinscripcion

end