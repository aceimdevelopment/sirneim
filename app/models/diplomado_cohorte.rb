class DiplomadoCohorte < ActiveRecord::Base
	set_primary_keys :diplomado_id, :cohorte_id
	belongs_to :cohorte
	belongs_to :diplomado

	has_many :inscripciones,
		:foreign_key => ['diplomado_id', 'cohorte_id']
		
	accepts_nested_attributes_for :inscripciones

	validates_uniqueness_of :diplomado_id, :scope => [:cohorte_id]

	# scope :actuales, -> {where("cohorte_id IS ?", ParametroGeneral.cohorte_actual)}
	def descripcion
		"#{diplomado.descripcion_completa} #{cohorte.descripcion}"
	end
end
