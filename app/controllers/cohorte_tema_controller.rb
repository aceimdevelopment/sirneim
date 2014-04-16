class CohorteTemaController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def index
		@cohortes_temas = CohorteTema.all
	end

	def nuevo
		@cohorte_tema = CohorteTema.new
		@cohortes_temas = CohorteTema.all
		diplomado_id, cohorte_id = params[:id].split ","
		@cohorte_tema.diplomado_id = diplomado_id
		@cohorte_tema.cohorte_id = cohorte_id
		@titulo = "Asignación de Temas por Cohorte"
		# @diplomados_cohorte = DiplomadoCohorte.where("cohorte_id = ?", ParametroGeneral.cohorte_actual) 
	end
end
