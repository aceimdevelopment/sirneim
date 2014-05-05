class CohorteTemaController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def index
		@cohortes_temas = CohorteTema.all
	end

	def nuevo
		@cohorte_tema = CohorteTema.new
		diplomado_id, cohorte_id = params[:id].split ","
		@cohortes_temas = CohorteTema.where(:diplomado_id => diplomado_id, :cohorte_id => cohorte_id)
		@cohorte_tema.diplomado_id = diplomado_id
		@cohorte_tema.cohorte_id = cohorte_id
		@titulo = "Asignación de fechas y docentes a cada tema"
		@grupos = Grupo.all
		# @diplomados_cohorte = DiplomadoCohorte.where("cohorte_id = ?", ParametroGeneral.cohorte_actual) 
	end

	def asignar
		
		@cohorte_tema = CohorteTema.new (params[:cohorte_tema])

		@cohorte_tema.docente_ci = nil if params[:cohorte_tema][:docente_ci].eql? ""
		if @cohorte_tema.save
			flash[:success] = "Asiganción correcta" 
			redirect_to :action => "nuevo", :id => "#{@cohorte_tema.diplomado_id},#{@cohorte_tema.cohorte_id}"
		else
			render :action => "nuevo"
		end
	end

	def actualizar
		
		cohorte_tema = params[:cohorte_tema]
		@cohorte_tema = CohorteTema.where(:diplomado_id => cohorte_tema[:diplomado_id], :cohorte_id => cohorte_tema[:cohorte_id], :tema_numero => cohorte_tema[:tema_numero], :modulo_numero => cohorte_tema[:modulo_numero], :grupo_id => cohorte_tema[:grupo_id]).first

		if @cohorte_tema.update_attributes(cohorte_tema)
			flash[:success] = "Asignación actualizada"
			redirect_to :action => "nuevo"
		else
			render :action => "nuevo"
		end

	end
end
