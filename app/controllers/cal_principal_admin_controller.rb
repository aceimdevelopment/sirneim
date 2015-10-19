class CalPrincipalAdminController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_administrador

	def nueva_seccion_admin
		@seccion = CalSeccion.new
		@seccion.cal_semestre_id = cal_parametros[:semestre_actual]
		@seccion.cal_materia_id = params[:id]

	end

	def nueva_seccion_admin_guardar
		
		@cal_materia_id = params[:cal_materia][:id]
		@cal_materia = CalMateria.find @cal_materia_id
		@seccion = @cal_materia.cal_secciones.new(params[:cal_seccion])
		if @seccion.save
			flash[:success] = "Seccion agregada con éxito"
		else
			flash[:error] = "No se pudo agregar la nueva sección. Por favor verifique: #{@seccion.errors.full_messages.join(' ')}"
		end
		redirect_to :back, :anchor => 'mat_ALEMI'

	end

	def configuracion_general
		@periodo_actual = CalParametroGeneral.cal_semestre_actual
		@periodo_anterior = CalParametroGeneral.cal_semestre_anterior
		@cal_periodos = CalSemestre.all
	end


	def usuarios
		@estudiantes = CalEstudiante.all.delete_if{|es| es.cal_usuario.nil?}.sort_by{|es| es.cal_usuario.apellido_nombre}
		@profesores = CalProfesor.all.delete_if{|po| po.cal_usuario.nil?}.sort_by{|po| po.cal_usuario.apellido_nombre }
	end

	def index
		cal_semestre_actual_id = session[:cal_parametros][:semestre_actual]
		@cal_semestre_actual = CalSemestre.where(:id => cal_semestre_actual_id).limit(1).first
		@departamentos = CalDepartamento.all
		@cal_usuario = session[:cal_usuario]
		@admin = session[:cal_administrador]

		if @admin and @admin.cal_tipo_admin_id.eql? 3

			@cal_departamento_id = 'ALE' if @admin.cal_usuario_ci.eql? "14755681"
			@cal_departamento_id = 'EG' if @admin.cal_usuario_ci.eql? "3940410"
			@cal_departamento_id = 'FRA' if @admin.cal_usuario_ci.eql? "14141534"
			@cal_departamento_id = 'ING' if @admin.cal_usuario_ci.eql? "12293163"
			@cal_departamento_id = 'ITA' if @admin.cal_usuario_ci.eql? "1045134"
			@cal_departamento_id = 'POR' if @admin.cal_usuario_ci.eql? "10274406"
			@cal_departamento_id = 'TRA' if @admin.cal_usuario_ci.eql? "3673283"

		end
		@departamentos = CalDepartamento.where(:id => @cal_departamento_id)	if @cal_departamento_id
		
	end

	def seleccionar_profesor
		@cal_profesores = CalProfesor.all.sort_by{|profe| profe.cal_usuario.apellidos}
		@titulo = "Cambio de profesor de sección"
		@cal_seccion = CalSeccion.find(params[:id])

	end

	def cambiar_profe_seccion 

		id = params[:id]
		@cal_seccion = CalSeccion.find(id.split(" "))

		@cal_seccion.cal_profesor_ci = params[:cal_profesor_ci]
		if @cal_seccion.save
			flash[:success] = "Cambio realizado con éxito"
		else
			flash[:error] = "no se pudo guardar los cambios"
		end

		redirect_to :action => 'index'

	end

	def nuevo_profesor
		
	end

	def ver_seccion_admin
		id = params[:id]
		@cal_seccion = CalSeccion.find(id)
		@estudiantes_secciones = @cal_seccion.cal_estudiantes_secciones.sort_by{|es| es.cal_estudiante.cal_usuario.apellidos}
		@titulo = "Sección: #{@cal_seccion.descripcion}"
		if @cal_seccion.cal_materia.cal_categoria_id.eql? 'IB' or @cal_seccion.cal_materia.cal_categoria_id.eql? 'LIN' or @cal_seccion.cal_materia.cal_categoria_id.eql? 'LE'
			@p1 = 25 
			@p2 =35
			@p3 = 40
		else
			@p1 = @p2 =30
			@p3 = 40
		end
		
	end


	def calificar_admin

		id = params[:id]

		@cal_seccion = CalSeccion.find(id.split(" "))

		@estudiantes = params[:est]

		@estudiantes.each_pair do |ci,valores|

			@cal_estudiante_seccion = @cal_seccion.cal_estudiantes_secciones.where(:cal_estudiante_ci => ci).limit(1).first
			
			if valores['pi']
				cal_tipo_estado_calificacion_id = 'PI'
			else
				if valores[:calificacion_final].to_f >= 10
					cal_tipo_estado_calificacion_id = 'AP'
				else 
					cal_tipo_estado_calificacion_id = 'RE'
				end
			end
			valores['cal_tipo_estado_calificacion_id'] = cal_tipo_estado_calificacion_id
			unless @cal_estudiante_seccion.update_attributes(valores)
				flash[:danger] = "No se pudo guardar la calificación."
				break
			end

		end
		@cal_seccion.calificada = true
		calificada = @cal_seccion.save

		flash[:success] = "Calificaciones guardada satisfactoriamente." if calificada

		redirect_to :action => "index"

	end

	def detalle_usuario
		@estudiante = CalEstudiante.where(:cal_usuario_ci => params[:ci]).limit(1).first
		@secciones_estudiantes = CalEstudianteSeccion.where(:cal_estudiante_ci => @estudiante.cal_usuario_ci)		

		@secciones = CalSeccion.all


	end

	def resetear_contrasena

		@cal_usuario = CalUsuario.where(:ci =>params[:ci]).limit(1).first
		@cal_usuario.contrasena = @cal_usuario.ci

		if @cal_usuario.save(:validate => false)
			# AdministradorMailer.aviso_general("#{@usuario.correo}","Su Contraseña fue Reseteada II", "su contraseña fue reseteada, ahora es:#{@usuario.contrasena}. Si ud. no solicitó este servicio dirijase a nuestras oficinas a fin de aclarar la situación").deliver
			flash[:success] = "Contraseña reseteada corréctamente"
			redirect_to  :action=>"usuarios"
		else
			flash[:error] = "No se pudo resetear la contraseña#{@cal_usuario.errors.full_messages.join(' ')}"
			redirect_to  :action=>"usuarios"
		end

	end

	def habilitar_calificar
		id = params[:id]
		@cal_seccion = CalSeccion.find(id)

		@cal_seccion.calificada = false

		if @cal_seccion.save
			flash[:success] = "El Profesor #{@cal_seccion.cal_profesor.cal_usuario.nombres} ya puede calificar la seccion: #{@cal_seccion.descripcion} "
		else
			flash[:danger] = "No se pudo actualizar el valor"
		end

		redirect_to :action => 'index'		
	end


end
