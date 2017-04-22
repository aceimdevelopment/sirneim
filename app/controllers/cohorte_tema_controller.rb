# encoding: utf-8

class CohorteTemaController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def crear_wizard
		@diplomados_cohorte = DiplomadoCohorte.find(params[:id])
		# for i => 0, @diplomados_cohorte.grupos
	end

	def index
		@cohortes_temas = CohorteTema.all
	end

	def nuevo
		@cohorte_tema = CohorteTema.new
		diplomado_id, cohorte_id = params[:id].split ","

		if @diplomado_cohorte = DiplomadoCohorte.where(:diplomado_id => diplomado_id, :cohorte_id => cohorte_id).limit(1).first

			@cohortes_temas = CohorteTema.where(:diplomado_id => diplomado_id, :cohorte_id => cohorte_id)
			@cohorte_tema.diplomado_id = diplomado_id
			@cohorte_tema.cohorte_id = cohorte_id
			@titulo = "Asignación de fechas y docentes a cada tema"
			@grupos = @diplomado_cohorte.grupos
		else
			flash[:alert] = "No se ha encontrado el diplomado en esta cohorte, por favor registrelo antes"
			redirect_to :back
		end
		# @diplomados_cohorte = DiplomadoCohorte.where("cohorte_id = ?", ParametroGeneral.cohorte_actual) 
	end

	def asignar
		
		@cohorte_tema = CohorteTema.new (params[:cohorte_tema])

		@cohorte_tema.docente_ci = nil if params[:cohorte_tema][:docente_ci].eql? ""
		if @cohorte_tema.save
			flash[:success] = "Asiganción correcta"
			if session[:wizard]
				redirect_to "/asistente_diplomado/paso5/#{@cohorte_tema.diplomado_id},#{@cohorte_tema.cohorte_id}"
			else	
				redirect_to :action => "nuevo", :id => "#{@cohorte_tema.diplomado_id},#{@cohorte_tema.cohorte_id}"
			end
		else
			render :action => "nuevo"
		end
	end

	def actualizar
		
		cohorte_tema = params[:cohorte_tema]
		@cohorte_tema = CohorteTema.where(:diplomado_id => cohorte_tema[:diplomado_id], :cohorte_id => cohorte_tema[:cohorte_id], :tema_numero => cohorte_tema[:tema_numero], :modulo_numero => cohorte_tema[:modulo_numero], :grupo => cohorte_tema[:grupo]).first

		if @cohorte_tema.update_attributes(cohorte_tema)
			flash[:success] = "Asignación actualizada"
			redirect_to :back
			# if session[:wizard]
			# 	redirect_to "/asistente_diplomado/paso3/#{@cohorte_tema.diplomado_id},#{@cohorte_tema.cohorte_id}"
			# else	
			# 	redirect_to :action => "nuevo", :id => "#{@cohorte_tema.diplomado_id},#{@cohorte_tema.cohorte_id}"
			# end
			# redirect_to "nuevo/#{@cohorte_tema.diplomado_id},#{@cohorte_tema.cohorte_id}##{cohorte_tema[:modulo_numero]}"
		else
			render :action => "nuevo"
		end

	end
end
