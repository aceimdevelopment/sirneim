class AsistenteDiplomadoController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def cargar_cohorte
				
	end

	def paso1
		session[:wizard] = true
		
		if @cohorte = (Cohorte.find Date.today.year)
			flash[:info] = "Fueron cargados los datos de la Cohorte del corriente año"
		else
			@cohorte = Cohorte.new
		end
		@titulo = "#{action_name.capitalize}: Registrar Nueva Cohorte"
		@porcentaje = 33
		@siguiente = "paso2"
	end

	def paso2
		@cohorte = session[:cohorte]
		@diplomado_cohorte = DiplomadoCohorte.new
		@diplomado_cohorte.cohorte_id = @cohorte.id
		@atras = "paso1"
		@titulo = "#{action_name.capitalize}: Seleccionar Diplomado"
		@porcentaje = 66
		@siguiente = "paso3"
	end

	def paso3
		@atras = "paso2"
		@titulo = "#{action_name.capitalize}: Seleccionar Diplomado"
		@porcentaje = 98
		@siguiente = "Finalizar"
		@cohorte_tema = CohorteTema.new
		diplomado_id, cohorte_id = params[:id].split ","
		@cohortes_temas = CohorteTema.where(:diplomado_id => diplomado_id, :cohorte_id => cohorte_id)
		@cohorte_tema.diplomado_id = diplomado_id
		@cohorte_tema.cohorte_id = cohorte_id
		@titulo = "#{action_name.capitalize}: Asignación de fechas y docentes a cada tema"
		@grupos = Grupo.all
	end

	def paso_final
		session[:wizard] = nil
		session[:cohorte] = nil
		flash[:success] = "Planificación del diplomado completada satisfactoriamente"
		redirect_to :controller => "principal_admin"
		
	end
end