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

	def editar
		diplomado_id, cohorte_id = params[:id].split ","
		@diplomado_cohorte = DiplomadoCohorte.where(:diplomado_id => diplomado_id, :cohorte_id => cohorte_id).limit(1).first
	end

	def actualizar
		dc = params[:diplomado_cohorte]
		@diplomado_cohorte = DiplomadoCohorte.where(:diplomado_id => dc[:diplomado_id], :cohorte_id => dc[:cohorte_id] ).first

		if @diplomado_cohorte.update_attributes(dc)
			flash[:success] = "Diplomado actualizado"
			redirect_to :action => "index"
		else
			render :action => "nuevo"
		end
	end

	def crear
		# @diplomado_cohorte = DiplomadoCohorte.new(params[:diplomado_cohorte])
		@diplomado_cohorte = DiplomadoCohorte.find_or_create_by_diplomado_id_and_cohorte_id(params[:diplomado_cohorte][:diplomado_id],params[:diplomado_cohorte][:cohorte_id])
		@diplomado_cohorte.attributes = params[:diplomado_cohorte]

		if @diplomado_cohorte.save
			flash[:success] = "Registro Correcto de Diplomado para esta cohorte"

			if session[:wizard]
				# redirect_to "/aceim_diplomados/asistente_diplomado/paso3/#{@cohorte_tema.diplomado_id},#{@cohorte_tema.cohorte_id}"
				redirect_to :controller => 'asistente_diplomado',:action => 'paso3', :id => @diplomado_cohorte.id.to_s
			else
				redirect_to :action => 'index'
			end
		else
			render 'nuevo'
		end
	end
end