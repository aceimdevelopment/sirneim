class AsistenteDiplomadoController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador
	PASOS = 6
	def cargar_cohorte
				
	end

	# Crear o actualizar Cohorte 
	def paso1
		session[:wizard] = true
		
		if @cohorte = (Cohorte.find Date.today.year)
			flash[:info] = "Fueron cargados los datos de la Cohorte del corriente año."
		else
			@cohorte = Cohorte.new
		end
		@titulo = "#{action_name.capitalize}: Registrar o actualizar Cohorte"
		@porcentaje = (1.0/5)*100
		@siguiente = "paso2"
	end

	# Seleccionar Diplomado 
	def paso2
		@diplomados = Diplomado.all

		if (@diplomados.count.eql? 1)
			flash[:success] = "Fue seleccionado el único diplomado disponible: #{@diplomados.first.id}"
			redirect_to :controller => 'asistente_diplomado', :action => "paso3", :id => @diplomados.first.id
		else
			@atras = 'paso1'
			@titulo = "#{action_name.capitalize}: Seleccionar Diplomado"
			@porcentaje = (2.0/PASOS)*100
			@siguiente = 'paso3'
		end
	end

	def paso2_guardar
		redirect_to :controller => 'asistente_diplomado', :action => 'paso3', :id => params[:id]
	end
	
	# editar caracteristicas del diplomado
	def paso3
		@accion = "actualizar"
		@diplomado = Diplomado.find params[:id] 
		@atras = "/aceim_diplomados/asistente_diplomado/paso2"

		@titulo = "#{action_name.capitalize}: Editar caracteristicas del Diplomado"
		@porcentaje = (3.0/PASOS)*100
		@siguiente = "/aceim_diplomados/asistente_diplomado/paso4/#{@diplomado.id}"

	end

	def paso4
		@cohorte = session[:cohorte]
		# @diplomado_cohorte = DiplomadoCohorte.find_or_create_by_diplomado_id_and_cohorte_id(params[:id],@cohorte.id)

		
		@accion = "actualizar"

		unless @diplomado_cohorte = DiplomadoCohorte.where(:diplomado_id => params[:id],:cohorte_id => @cohorte.id).limit(1).first
			@diplomado_cohorte = DiplomadoCohorte.new
			@diplomado_cohorte.cohorte_id = @cohorte.id
			@diplomado_cohorte.diplomado_id = params[:id]
			@accion = "registrar"
		end
		@atras = "/aceim_diplomados/asistente_diplomado/paso3/#{@diplomado_cohorte.diplomado_id}"
		@titulo = "#{action_name.capitalize}: Editar datos del Diplomado en la Cohorte"
		@porcentaje = (4.0/PASOS)*100
		@siguiente = "/aceim_diplomados/asistente_diplomado/paso5/#{@diplomado_cohorte.id.to_s}"
	end

	def paso5

		diplomado_id, cohorte_id = params[:id].split ","

		if @diplomado_cohorte = DiplomadoCohorte.where(:diplomado_id => diplomado_id, :cohorte_id => cohorte_id).limit(1).first
			@cohorte_tema = CohorteTema.new
			@cohortes_temas = CohorteTema.where(:diplomado_id => diplomado_id, :cohorte_id => cohorte_id)
			@cohorte_tema.diplomado_id = diplomado_id
			@cohorte_tema.cohorte_id = cohorte_id
			@titulo = "#{action_name.capitalize}: Asignación de fechas y docentes a cada tema"
			@grupos = @diplomado_cohorte.grupos

			@atras = "/aceim_diplomados/asistente_diplomado/paso4/#{@diplomado_cohorte.diplomado_id}"
			@titulo = "#{action_name.capitalize}: Seleccionar Diplomado"
			@porcentaje = (4.0/PASOS)*100
			@siguiente = "/aceim_diplomados/asistente_diplomado/paso6"

		else
			flash[:alert] = "No se ha encontrado el diplomado en esta cohorte, por favor registrelo antes"
			redirect_to :back
		end

		# @cohorte_tema = CohorteTema.new
		# diplomado_id, cohorte_id = params[:id].split ","
		# @cohortes_temas = CohorteTema.where(:diplomado_id => diplomado_id, :cohorte_id => cohorte_id)
		# @cohorte_tema.diplomado_id = diplomado_id
		# @cohorte_tema.cohorte_id = cohorte_id
		# @titulo = "#{action_name.capitalize}: Asignación de fechas y docentes a cada tema"
		# @grupos = Grupo.all
	end

	def paso_final

		# asignarle cohorte_actual a la cohorte seleccionada en el asistente.
		# abrir la inscripcion.
		session[:wizard] = nil
		session[:cohorte] = nil
		flash[:success] = "Planificación del diplomado completada satisfactoriamente"
		redirect_to :controller => "principal_admin"
		
	end
end