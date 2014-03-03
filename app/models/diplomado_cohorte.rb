class DiplomadoCohorte < ActiveRecord::Base
	set_primary_keys :diplomado_id, :cohorte_id
	belongs_to :cohorte
	belongs_to :diplomado
	# scope :actuales, -> {where("cohorte_id IS ?", ParametroGeneral.cohorte_actual)}
	def descripcion
		"#{diplomado.descripcion_completa} #{cohorte.descripcion}"
	end
end
