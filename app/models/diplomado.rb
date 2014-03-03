class Diplomado < ActiveRecord::Base
  # set_primary_keys :id

  # has_many :inscripcion
  # accepts_nested_attributes_for :inscripcion

  # validates :brand_id, :uniqueness => {:scope => [:name, :identifer]}

  validates :id, :presence => true, :uniqueness => true, :length => {:maximum => 15}
  validates :descripcion, :presence => true, :uniqueness => true

  has_many :diplomado_cohorte
  accepts_nested_attributes_for :diplomado_cohorte

  has_many :modulos
  accepts_nested_attributes_for :modulos  

  def descripcion_completa
    "#{id} - #{descripcion}"
  end

end