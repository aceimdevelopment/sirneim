# encoding: utf-8

class CalEstudianteSeccionController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_administrador
	
	def buscar_estudiante
		@cal_semestre_actual_id = CalParametroGeneral.cal_semestre_actual_id
		
		if params[:id]
			@inscripciones = CalEstudianteSeccion.where(cal_estudiante_ci: params[:id], cal_semestre_id: @cal_semestre_actual_id)
			if @inscripciones.count > 2
				flash[:info] = "El estudiante ya posee más de 2 asignaturas inscritas en el periodo actual. Por favor haga clic <a href='/sirneim/cal_principal_admin/detalle_usuario?ci=#{@inscripciones.first.cal_estudiante_ci}' class='btn btn-primary btn-small'>aquí</a> para mayor información y realizar ajustes sobre las asignaturas" 
			end
		end
		@titulo = "Inscripción para el período #{@cal_semestre_actual_id} - Paso 1 - Buscar Estudiante"
		@estudiantes = CalEstudiante.all.sort_by{|e| e.cal_usuario.apellidos}
	end

	def seleccionar

		@cal_semestre_actual_id = CalParametroGeneral.cal_semestre_actual_id
		@inscripciones = CalEstudianteSeccion.where(cal_estudiante_ci: params[:id], cal_semestre_id: @cal_semestre_actual_id)
		@estudiante = CalEstudiante.where(cal_usuario_ci: params[:id]).limit(0).first 
		@titulo = "Inscripción para el período #{@cal_semestre_actual_id} - Paso 2 - Seleccionar Secciones"
		if @inscripciones.count > 2
			flash[:info] = "El estudiante ya posee más de 2 asignaturas inscritas en el periodo actual. Por favor haga clic <a href='/sirneim/cal_principal_admin/detalle_usuario?ci=#{params[:id].first.to_i}' class='btn btn-primary btn-small'>aquí</a> para para mayor información y realizar ajustes sobre las asignaturas" 
			redirect_to action: 'buscar_estudiante', id: params[:id]
		else		
			@departamentos = CalDepartamento.all
			@secciones_disponibles = CalSeccion.del_periodo_actual
		end
	end

	def inscribir
		@cal_semestre_actual_id = CalParametroGeneral.cal_semestre_actual_id
		secciones = params[:secciones]
		total_secciones = secciones.count
		guardadas = 0
		ci = params[:ci]
		begin
			secciones.each_pair do |mat_id, sec_num|
				es_se = CalEstudianteSeccion.new
				es_se.numero = sec_num
				es_se.cal_materia_id = mat_id
				es_se.cal_semestre_id = @cal_semestre_actual_id
				es_se.cal_estudiante_ci = ci
				es_se.cal_tipo_estado_inscripcion_id = 'INS'


				if es_se.save
					guardadas += 1
				else
					flash[:error] = "#{es_se.errors.full_messages.join' | '}"
				end
				flash[:info] = "Para mayor información vaya al detalle del estudiante haciendo clic <a href='/sirneim/cal_principal_admin/detalle_usuario?ci=#{ci.to_i}' class='btn btn-primary btn-small'>aquí</a> "
			end 
		rescue Exception => e
			flash[:error] = "Error Excepcional: #{e}"
		end
		flash[:success] = "Estudiante inscrito en #{guardadas} seccion(es) de #{total_secciones}"
		redirect_to action: :resumen, id: ci, flash: flash
	end

	def resumen
		ci = params[:id]
		@cal_semestre_actual_id = CalParametroGeneral.cal_semestre_actual_id
		@estudiante = CalEstudiante.where(cal_usuario_ci: ci).limit(0).first
		@secciones = @estudiante.cal_secciones.del_periodo_actual
		@titulo = "Inscripción para el período #{@cal_semestre_actual_id} - Paso 3 - Resultados y Resumen: #{@estudiante.cal_usuario.descripcion}"

	end

	def nuevo
		@accion = params[:accion]
		@controlador = params[:controlador]
		@secciones = CalSeccion.all
		@estudiante = CalEstudiante.find(params[:ci])
	end

	def crear
		ci = params[:ci]
		numero, cal_materia_id, cal_semestre_id = params[:cal_seccion][:id].split(",")
		if CalEstudianteSeccion.where(:cal_estudiante_ci => ci, :numero => numero, :cal_materia_id => cal_materia_id, :cal_semestre_id => cal_semestre_id).limit(1).first
			flash[:error] = "El Estudiante ya esta inscrito en esa sección"
		else
			if CalEstudianteSeccion.create(:cal_estudiante_ci => ci, :numero => numero, :cal_materia_id => cal_materia_id, :cal_semestre_id => cal_semestre_id, :cal_tipo_estado_inscripcion_id => 'INS', :cal_tipo_estado_calificacion_id => 'SC')
				flash[:success] = "Estudiante inscrito satisfactoriamente"
			else
				flash[:error] = "No se pudo incorporar al estudiante en la seccion correspondiente, intentelo de nuevo"
			end
		end
		# redirect_to :controller => params[:controlador], :action => params[:accion], :ci => ci, flash: flash[:success]

		redirect_to({ :controller => params[:controlador], :action => params[:accion], :ci => ci}, flash: flash) and return
	end

	def eliminar
		# ci = params[:ci]
		# numero, cal_materia_id, cal_semestre_id = params[:cal_seccion_id].split(",")		
		id = params[:id]
		ci = id[0]
		if es = CalEstudianteSeccion.find(id)
			if es.destroy
				flash[:success] = "El estudiante fue eliminado de la sección correctamente, ci:#{ci}"
			else
				flash[:error] = "El estudiante no pudo ser eliminado"
			end				
		else
			flash[:error] = "El estudiante no fue encontrado en la sección especificada"
		end
		redirect_to({:controller => params[:controlador], :action => params[:accion], :ci => ci}, flash: flash) and return
		# redirect_to :controller => params[:controlador], :action => params[:accion], :ci => ci
	end

	def set_retirar
		valor = 
		id = params[:id]
		if es = CalEstudianteSeccion.find(id)
			es.cal_tipo_estado_inscripcion_id = params[:valor]
			if es.save
				flash[:success] = "El cambio el valor de retiro de #{es.cal_estudiante.cal_usuario.nickname} de la sección #{es.cal_seccion.descripcion} se realizó correctamente"
			else
				flash[:error] = "No se pudo cambiar el valor de retiro, intentelo de nuevo: #{es.errors.full_messages.join' | '}"
			end				
		else
			flash[:error] = "El estudiante no fue encontrado en la sección especificada"
		end
		redirect_to :back

	end
end