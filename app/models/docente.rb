class Docente < ActiveRecord::Base
	set_primary_keys :usuario_ci
	
	has_many :cohortes_temas
  	accepts_nested_attributes_for :cohortes_temas

end
