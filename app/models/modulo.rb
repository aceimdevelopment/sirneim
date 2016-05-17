# encoding: utf-8

class Modulo < ActiveRecord::Base
	set_primary_keys :numero, :diplomado_id

	belongs_to :diplomado
	
	has_many :temas,
	:foreign_key => ['modulo_numero', 'diplomado_id']
  accepts_nested_attributes_for :temas

  validates_uniqueness_of :numero, :scope => [:diplomado_id]
  validates_presence_of :numero

  	def descripcion_completa 
  		aux = "Módulo #{numero}.- "
  		aux += descripcion if descripcion
  	end

  	def descripcion_diplomado
  		aux = diplomado.descripcion_completa if diplomado
  		aux += " #{descripcion_completa}"
  	end
end
