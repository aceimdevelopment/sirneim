class CalCalificarController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_admin_profe


	def seleccionar_seccion
		@profesor = CalProfesor.find (session[:cal_profesor].cal_usuario_ci)
		@titulo = "Secciones disponibles"
		@periodo_actual = CalParametroGeneral.cal_semestre_actual
		@cal_secciones = @profesor.cal_secciones.where(:cal_semestre_id => @periodo_actual.id)
		@cal_secciones_secundarias = @profesor.cal_secciones_secundarias.where(:cal_semestre_id => @periodo_actual.id)
	end

	def ver_seccion
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

	def calificar

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

		if session[:cal_administrador]
			redirect_to :controller => 'cal_principal_admin'
		else
			redirect_to :action => "ver_seccion", :id => @cal_estudiante_seccion.cal_seccion.id
		end
	end

	def descargar_notas
		id = params[:id]
		cal_seccion = CalSeccion.find(id)
		pdf = DocumentosPDF.cal_notas cal_seccion
		unless send_data pdf.render,:filename => "notas_#{cal_seccion.cal_materia_id}_#{cal_seccion.numero}.pdf",:type => "application/pdf", :disposition => "attachment"
	    	flash[:mensaje] = "en estos momentos no se pueden descargar las notas, intentelo luego."
	    end
		# redirect_to :action => 'index'      
	end


	def importar_secciones
		data = File.readlines("AlemIV.rtf") #read file into array
		data.map! {|line| line.gsub(/world/, "ruby")} #invoke on each line gsub
		File.open("test2.txt", "a") {|f| f.puts "Nueva Linea: #{data}"} #output data to other file
	end




end