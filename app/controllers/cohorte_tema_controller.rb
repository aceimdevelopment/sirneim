class CohorteTemaController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def index
		@cohortes_temas = CohorteTema.all
	end

	def nuevo
		@diplomados_cohorte = DiplomadoCohorte.where("cohorte_id = ?", ParametroGeneral.cohorte_actual) 
	end
end
