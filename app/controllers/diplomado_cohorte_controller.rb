class DiplomadoCohorteController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def index
		@diplomados_cohortes = DiplomadoCohorte.where(:cohorte_id => ParametroGeneral.cohorte_actual)
		@titulo = "Listados de Diplomados para esta Cohorte"
	end

	def nuevo
		@titulo = "Diplomados para esta Cohorte"
		@diplomado_cohorte = DiplomadoCohorte.new
		# @diplomados_cohortes = DiplomadoCohorte.where("cohorte_id = ?", ParametroGeneral.cohorte_actual)
		@diplomado_cohorte.cohorte_id = ParametroGeneral.cohorte_actual
	end

	def crear
		diplomados_ids = params[:diplomado_cohorte][:diplomado_id]
		cohorte_id = params[:diplomado_cohorte][:cohorte_id]
		diplomados_ids.each do |diplomado_id|
			@diplomado_cohorte = DiplomadoCohorte.new
			@diplomado_cohorte.cohorte_id = cohorte_id
			@diplomado_cohorte.diplomado_id = diplomado_id
			
			unless @diplomado_cohorte.save
	      		render :action => "nuevo"
	  		end
		end
		flash[:success] = "Registro Correcto de Diplomados para esta cohorte"
		redirect_to :action => "index"

	end
end