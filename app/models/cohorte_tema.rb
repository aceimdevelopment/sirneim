class CohorteTema < ActiveRecord::Base
	set_primary_keys :cohorte_id, :tema_numero, :modulo_numero, :diplomado_id, :grupo_id

	belongs_to :tema
	belongs_to :cohorte
	belongs_to :grupo
	belongs_to :docente

	has_many :historiales,
	:foreign_key => ['numero','modulo_numero','diplomado_id']
  	accepts_nested_attributes_for :historiales 	
end
