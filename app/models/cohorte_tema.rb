class CohorteTema < ActiveRecord::Base
	set_primary_keys :cohorte_id, :tema_numero, :modulo_numero, :diplomado_id, :grupo

	belongs_to :tema,
	:class_name => 'Tema',
    :foreign_key => ['tema_numero','modulo_numero', 'diplomado_id']

	belongs_to :docente,
	:class_name => 'Docente',
    :foreign_key => ['docente_ci']

	belongs_to :cohorte

	has_many :historiales,
	:foreign_key => ['numero','modulo_numero','diplomado_id']
  	accepts_nested_attributes_for :historiales 	

  	def diplomado
  		Diplomado.find diplomado_id
  	end
end
