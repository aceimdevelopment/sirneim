# encoding: utf-8

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
			@cal_departamento_id = 'EG' if @admin.cal_usuario_ci.eql? "8965636"
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
		cal_semestre_actual_id = session[:cal_parametros][:semestre_actual]
		@estudiante = CalEstudiante.where(:cal_usuario_ci => params[:ci]).limit(1).first
		# @secciones_estudiantes = CalEstudianteSeccion.where(:cal_estudiante_ci => @estudiante.cal_usuario_ci)		




		@periodos = CalSemestre.order("id DESC").all

		@secciones = CalEstudianteSeccion.where(:cal_estudiante_ci => @estudiante.cal_usuario_ci).order("cal_materia_id ASC, cal_numero DESC")



		# @secciones = CalSeccion.where(:cal_periodo_id => cal_semestre_actual_id)
		@idiomas1 = CalDepartamento.all.delete_if{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
		@idiomas2 = CalDepartamento.all.delete_if{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }

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


	def reader_pdf
		require 'rubygems'
		require 'pdf-reader'
		require 'open-uri'
		require 'pdf/reader/html'
		cal_semestre_actual_id = session[:cal_parametros][:semestre_actual]
		# @reader = PDF::Reader.new('/home/daniel/Descargas/CTT I Alem.pdf')
		# @reader = PDF::Reader.new('/home/daniel/Descargas/Alem I(1).pdf')

		data = params[:archivo][:datafile].tempfile

		@reader = PDF::Reader.new(data)
		# @reader = PDF::Reader.new('/home/daniel/Descargas/Alem IV.pdf')

		@estudiantes_encontrados = []
		@estudiantes_no_encontrados = []		
		@cedulas_no_encontradas = []
		@secciones = []

 		@reader.pages.each_with_index do |pagina,i|
			if i > 0 # descarto la primera pagina
				# busco la asignatura y seccion
				asignatura = 0
				@nombre_asignatura = ""
				@codigo_asignatura = ""
				@numero_seccion = ""
				estudiantes = false
				caso1 = false
				@numeros_cedulas = []

				pagina.to_s.each_line do |linea|
					if @codigo_asignatura or @nombre_asignatura.blank? or @numero_seccion.blank?

						if asignatura.eql? 2
							@codigo_asignatura = linea.strip
							asignatura =0
						end

						if asignatura.eql? 1
							@nombre_asignatura = linea.strip
							asignatura +=1
						end

						asignatura +=1 if linea.include? "INSCRITOS POR ASIGNATURAS"
						@numero_seccion = (linea.split" ")[1] if (linea.include? "SECCION") or (linea.include? "SECCIÓN")
					end

					if estudiantes
						encontrado = false
						tokens = linea.split(" ")
						tokens.each do |token|

							if token.to_i > 900000
								caso1 = true

								aux_est = CalEstudiante.where(:cal_usuario_ci => token.to_i).limit(1)
								
								if aux_est.count > 0
									@numeros_cedulas << token.to_i
									encontrado = true
								else
									@estudiantes_no_encontrados << "otro"+linea 
									@cedulas_no_encontradas << token.to_i
								end								 
								
							# else
							# 	@estudiantes_no_encontrados << linea #aux_cedula+" "+token.to_i if not encontrado and not aux_cedula.nil?
							end

						end

						if (not caso1) and !tokens.nil? and (tokens.count > 0)
							nombrecedula = tokens.last
							cedula = ""
							nombre = ""
							inter = false
							nombrecedula.each_char do |ca| 
								if ca.to_i > 0 or inter
									cedula += ca.to_s
									inter = true
								else
									nombre += ca.to_s
								end
							end

							if cedula.to_i > 900000
								aux_est = CalEstudiante.where(:cal_usuario_ci => cedula.to_i).limit(1)

								if aux_est.count > 0
									@numeros_cedulas << cedula.to_i
									encontrado = true
								else
									@estudiantes_no_encontrados << "(#{cedula}) "+linea.delete(cedula)
									@cedulas_no_encontradas << cedula.to_i
								end
								caso1 = false

							end

						end

					end
					estudiantes = true if linea.include? "Periodo Academico"

					# @estudiantes_encontrados = CalEstudiante.where(:cal_usuario_ci => @numeros_cedulas) 

				end # pagina.each_line

				@secciones << @numero_seccion

				@cal_materia = CalMateria.where(:id_upsi => @codigo_asignatura).limit(1).first

				@numeros_cedulas.each do |cedula|
					aux = CalEstudiante.where(:cal_usuario_ci => cedula).limit(1)
					if aux.count > 0
						@cal_estudiante_seccion = CalEstudianteSeccion.new
						@cal_estudiante_seccion.cal_estudiante_ci = cedula
						@cal_estudiante_seccion.cal_materia_id = @cal_materia.id if @cal_materia 
						@cal_estudiante_seccion.cal_semestre_id = cal_semestre_actual_id
						@cal_estudiante_seccion.cal_numero = @numero_seccion
						@estudiantes_encontrados << @cal_estudiante_seccion
					else
						@cedulas_no_encontradas << cedula
					end
				end



			end # if pagina > 1

		end # @reader.pages.each

	end # fin reader_pdf

	def importar_secciones_paso2
		@estudiantes_seccion = params[:estudiantes_seccion]
		errores = correctos = 0

		@estudiantes_seccion.each do |es|
			ci,numero,materia,semestre = es.split(" ")
			estudiante_seccion = CalEstudianteSeccion.new

			estudiante_seccion.cal_estudiante_ci = ci
			estudiante_seccion.cal_materia_id = materia
			estudiante_seccion.cal_semestre_id = semestre
			estudiante_seccion.cal_numero = numero
			estudiante_seccion.cal_tipo_estado_calificacion_id = 'SC'
			estudiante_seccion.cal_tipo_estado_inscripcion_id = 'INS'

			if	estudiante_seccion.save
				correctos += 1
			else
				errores += 1
			end
		end

		flash[:info] = "Se incorporaron correctamente #{correctos} estudiantes. / "

		flash[:info] += "Se registraron #{errores} errores al intentar guardar."

		redirect_to :action => "importar_secciones_paso1"		
	end

	def importar_secciones_paso1
		
	end

	def subir_archivo
	# DataFile.save_file(params[:archivo])

	archivo = params[:archivo]

	file_name = archivo['datafile'].original_filename  if  (archivo['datafile'] !='')    

	file = archivo['datafile'].read

	root = "#{Rails.root}/attachments/importados/"

	File.open(root + file_name, "wb")  do |f|  
		flash[:info] += "El Archivo ha sido guardado con éxito." if f.write(file)
	end

	redirect_to :action => "reader_pdf"


	end

end # fin cacasee
