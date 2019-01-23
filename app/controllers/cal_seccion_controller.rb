# encoding: utf-8

class CalSeccionController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_administrador

	def cambiar_capacidad

	    @seccion = CalSeccion.find params[:id].split
	    @seccion.capacidad = params[:capacidad]
	    @seccion.save
		redirect_to :back
	end

	def clonar_secciones_anteriores
		@periodo_actual = session[:cal_parametros][:semestre_actual]
		@periodo_anterior = session[:cal_parametros][:semestre_anterior]

		@secciones = CalSeccion.where(:cal_semestre_id => @periodo_anterior)

		total_clonadas = 0
		errores = 0
		@secciones.each do |seccion|
			nueva = CalSeccion.new
			nueva.numero = seccion.numero
			nueva.cal_semestre_id = @periodo_actual
			nueva.cal_materia_id = seccion.cal_materia_id
			nueva.cal_profesor_ci = seccion.cal_profesor_ci
			nueva.calificada = false
			begin
				if nueva.save 
					total_clonadas += 1
				else
					errores += 1
				end
			rescue
				flash[:error] = "Error durante Clonación. Es posible que la clonación ya se haya realizado para el actual período."
			end
		end

		flash[:success] = "Se Clonaron un total de #{total_clonadas} secciones. Hubo #{errores}" if total_clonadas > 0
		redirect_to :back

	end

	def eliminar_todas_secciones_actual

		@periodo_actual = session[:cal_parametros][:semestre_actual]
		@secciones = CalSeccion.where(:cal_semestre_id => @periodo_actual.id)

		total_eliminadas = 0
		errores = 0
		@secciones.each do |seccion|
			seccion.cal_estudiantes_secciones.each{|sec_est| sec_est.delete}
			if seccion.delete
				total_eliminadas += 1
			else
				errores += 1
			end
		end

		flash[:info] = "Se eliminaron un total de #{total_eliminadas} secciones. Hubo #{errores} error(es)"
		redirect_to :back

	end


	def eliminar
		"R,ALEMI,2015-02A"

		@cal_seccion = CalSeccion.find params[:id]

		cal_estudiantes_secciones = 
		@cal_seccion.cal_estudiantes_secciones.each{|es| es.delete}
		@cal_seccion.cal_secciones_profesores_secundarios.each{|profe| profe.delete}
		if @cal_seccion.delete
			flash[:info] = "Se eliminó la sección de manera correcta"
		end
		redirect_to :back
	end

	def seleccionar_profesor_secundario
		@cal_profesores = CalProfesor.all.sort_by{|profe| profe.cal_usuario.apellidos}
		@titulo = "Cambio de profesor de sección"
		@cal_seccion = CalSeccion.find(params[:id])		
	end

	def agregar_profesor_secundario
		# numero, cal_materia_id, cal_semestre_id = params[:id].split(" ")
		# params[:numero => numero]

		@cal_seccion = CalSeccion.find params[:id].split(" ")

		unless @cal_seccion.nil?
			if @cal_seccion.cal_secciones_profesores_secundarios.create(:cal_profesor_ci => params[:cal_profesor_ci])
				flash[:success] = "Profesor Secundario agregado a la Asignatura: #{@cal_seccion.descripcion}"
			else
				flash[:error] = "No se pudo agregar la Asignatura"
				render :action => 'seleccionar_profesor_secundario'
			end

		else
			flash[:error] = "Sección no encontrada"
			render :action => 'seleccionar_profesor_secundario'
		end

		redirect_to :controller => "cal_principal_admin"

	end

	def desasignar_profesor_secundario
		numero, cal_materia_id, cal_semestre_id = params[:id].split(",")
		cal_profesor_ci = params[:cal_profesor_ci]

		@cal_seccion_profesor_secundario = CalSeccionProfesorSecundario.find([numero,cal_materia_id,cal_semestre_id,cal_profesor_ci])

		unless @cal_seccion_profesor_secundario.nil?
			flash[:info] =  @cal_seccion_profesor_secundario.delete ? "Profesor Desasignado satisfactoriamente." : "No se pudo desasignar al profesor"
		else
			flash[:error] = "Profesor No Encontrado, por favor revisar su solicitud."
		end

		redirect_to :controller => "cal_principal_admin"
	end
end
