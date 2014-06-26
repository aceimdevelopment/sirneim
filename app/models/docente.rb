class Docente < ActiveRecord::Base
	set_primary_keys :usuario_ci
	
	has_many :cohorte_tema,
	:foreign_key => ['docente_ci']
  	accepts_nested_attributes_for :cohorte_tema

	belongs_to :usuario,
	:class_name => 'Usuario',
	:foreign_key => ['usuario_ci']

	def nombre_completo
    	usuario.nombre_completo
    end 
end
