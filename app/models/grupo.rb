class Grupo < ActiveRecord::Base

# OJO: PARA INSERTAR GRUPOS
# INSERT INTO `grupo` (`id`, `nombre`) VALUES ('A', NULL)
# INSERT INTO `grupo` (`id`, `nombre`) VALUES ('B', NULL)
  has_many :inscripciones
  accepts_nested_attributes_for :inscripciones

  has_many :cohortes_temas
  accepts_nested_attributes_for :cohortes_temas

  validates :id, :presence => true, :uniqueness => true, :length => {:maximum => 1}
  # has_many :preinscripcion
  # accepts_nested_attributes_for :preinscripcion

end