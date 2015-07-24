class CalEstudianteSeccionController < ApplicationController

	def nuevo
		@accion = params[:accion]
		@controlador = params[:controlador]
		@secciones = CalSeccion.all
		@estudiante = CalEstudiante.find(params[:ci])
	end

	def crear
		ci = params[:ci]
		cal_numero, cal_materia_id, cal_semestre_id = params[:cal_seccion][:id].split(",")		
		if CalEstudianteSeccion.where(:cal_estudiante_ci => ci, :cal_numero => cal_numero, :cal_materia_id => cal_materia_id, :cal_semestre_id => cal_semestre_id).limit(1).first
			flash[:error] = "El Estudiante ya esta inscrito en esa sección"
		else
			if CalEstudianteSeccion.create(:cal_estudiante_ci => ci, :cal_numero => cal_numero, :cal_materia_id => cal_materia_id, :cal_semestre_id => cal_semestre_id, :cal_tipo_estado_inscripcion_id => 'INS', :cal_tipo_estado_calificacion_id => 'SC')
				flash[:success] = "Estudiante inscrito satisfactoriamente"
			else
				flash[:error] = "No se pudo incorporar al estudiante en la seccion correspondiente, intentelo de nuevo"
			end
		end
		redirect_to :controller => params[:controlador], :action => params[:accion], :ci => ci
	end

	def eliminar
		# ci = params[:ci]
		# cal_numero, cal_materia_id, cal_semestre_id = params[:cal_seccion_id].split(",")		
		id = params[:id]
		ci = id[0]
		if es = CalEstudianteSeccion.find(id)
			if es.destroy
				flash[:success] = "El estudiante fue retirado de la sección correctamente, ci:#{ci}"
			else
				flash[:error] = "El estudiante no pudo ser eliminado"
			end				
		else
			flash[:error] = "El estudiante no fue encontrado en la sección especificada"
		end
		redirect_to :controller => params[:controlador], :action => params[:accion], :ci => ci
	end

end