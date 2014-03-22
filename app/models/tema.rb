class Tema < ActiveRecord::Base
	set_primary_keys :numero, :modulo_numero, :diplomado_id	
	
	belongs_to :modulo,
	:class_name => 'Modulo',
    :foreign_key => ['modulo_numero', 'diplomado_id']

	has_many :cohortes_temas,
	:foreign_key => ['numero', 'modulo_numero','diplomado_id']
  	accepts_nested_attributes_for :cohortes_temas

  	def descripcion_completa
  		aux = "#{numero}.- "
  		aux += descripcion if descripcion
      return aux
  	end

  	def diplomado
  		modulo.diplomado
  	end
end
