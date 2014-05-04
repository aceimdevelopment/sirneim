class Diplomado < ActiveRecord::Base
  attr_accessible :id, :modalidad, :horario, :descripcion, :duracion, :destinatario, :objetivo
  # set_primary_keys :id

  # has_many :inscripcion
  # accepts_nested_attributes_for :inscripcion

  # validates :brand_id, :uniqueness => {:scope => [:name, :identifer]}

  validates :id, :presence => true, :uniqueness => true, :length => {:maximum => 15}
  validates :objetivo, :presence => true, :uniqueness => true
  validates :destinatario, :presence => true, :uniqueness => true
  validates :modalidad, :presence => true, :uniqueness => true
  validates :duracion, :presence => true, :uniqueness => true
  validates :horario, :presence => true, :uniqueness => true


  has_many :diplomado_cohorte
  accepts_nested_attributes_for :diplomado_cohorte

  has_many :modulos
  accepts_nested_attributes_for :modulos  

  def descripcion_completa
    aux = "#{id}"
    aux += " - #{descripcion}" unless descripcion.blank?
    return aux
  end

end