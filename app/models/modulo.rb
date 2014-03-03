class Modulo < ActiveRecord::Base
	set_primary_keys :numero, :diplomado_id

	belongs_to :diplomado
	
	has_many :temas,
	:foreign_key => ['numero', 'diplomado_id']
  	accepts_nested_attributes_for :temas

  	validates_uniqueness_of :numero, :scope => [:diplomado_id]

  	def descripcion_completa 
  		aux = "Modulo: #{numero} "
  		aux += descripcion if descripcion
  	end

  	def descripcion_diplomado
  		aux = diplomado.descripcion_completa if diplomado
  		aux += " #{descripcion_completa}"
  	end
end
