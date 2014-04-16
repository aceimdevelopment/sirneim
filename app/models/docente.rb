class Docente < ActiveRecord::Base
	set_primary_keys :usuario_ci
	
	has_many :cohortes_temas
  	accepts_nested_attributes_for :cohortes_temas

	belongs_to :usuario,
	:class_name => 'Usuario',
	:foreign_key => ['usuario_ci']

	def nombre_completo
    	usuario.nombre_completo
    end 
end
