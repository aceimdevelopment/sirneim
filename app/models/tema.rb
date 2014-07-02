class Tema < ActiveRecord::Base
	set_primary_keys :numero, :modulo_numero, :diplomado_id	
	
	belongs_to :modulo,
	:class_name => 'Modulo',
  :foreign_key => ['modulo_numero', 'diplomado_id']

	has_many :cohorte_tema,
	:foreign_key => ['tema_numero', 'modulo_numero','diplomado_id']
  accepts_nested_attributes_for :cohorte_tema

  validates_uniqueness_of :numero, :scope => [:modulo_numero, :diplomado_id], :on => :create
  validates_presence_of :numero

  	def descripcion_completa
  		aux = "#{numero}.- "
  		aux += descripcion if descripcion
      return aux
  	end

  	def diplomado
  		modulo.diplomado
  	end
end
