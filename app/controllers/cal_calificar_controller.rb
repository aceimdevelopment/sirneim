class CalCalificarController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_profesor

	def seleccionar_seccion
		@profesor = CalProfesor.find (session[:cal_profesor].cal_usuario_ci)
		@titulo = "Secciones disponibles para Caficicar"
	end

	def ver_seccion
		id = params[:id]
		@cal_seccion = CalSeccion.where(:numero => id[0], :cal_materia_id => id[1], :cal_semestre_id => id[2]).first
		@estudiantes_secciones = @cal_seccion.cal_estudiantes_secciones.sort_by{|es| es.cal_estudiante.cal_usuario.nombres}
		@titulo = "Sección: #{@cal_seccion.descripcion}"
		if @cal_seccion.cal_materia.cal_categoria_id.eql? 'IB'
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
			if valores[:calificacion_final].to_f > 10
				cal_tipo_estado_caliticacion_id = 'AP'
			else 
				cal_tipo_estado_caliticacion_id = 'RE'
			end

			unless @cal_estudiante_seccion.update_attributes(valores, :cal_tipo_estado_caliticacion_id => cal_tipo_estado_caliticacion_id)
				flash[:danger] = "No se pudo guardar la calificación."
				break
			end

		end

		@cal_seccion.calificada = true
		calificada = @cal_seccion.save

		flash[:success] = "nota guardada satisfactoriamente." if calificada


			# c1 = valores[:calificacion_primera].to_f
			# c2 = valores[:calificacion_segunda].to_f
			# c3 = valores[:calificacion_tercera].to_f

			# if @cal_estudiante_seccion.cal_seccion.cal_materia.cal_categoria_id.eql? 'IB'
			# 	p1 = 25 
			# 	p2 = 35
			# 	p3 = 40
			# else
			# 	p1 = p2 =30
			# 	p3 = 40
			# end

			# @cal_estudiante_seccion.calificacion_primera = c1
			# @cal_estudiante_seccion.calificacion_segunda = c2
			# @cal_estudiante_seccion.calificacion_tercera = c3

			# c1 = c1*p1/100
			# c2 = c2*p2/100
			# c3 = c3*p3/100

			# @cal_estudiante_seccion.calificacion_final = c1+c2+c3

			# if @cal_estudiante_seccion.save
			# 	flash[:success] = "nota guardada satisfactoriamente."
			# else
			# 	flash[:danger] = "No se pudo guardar la calificación."
			# end

		redirect_to :action => "ver_seccion", :id => @cal_estudiante_seccion.cal_seccion.id

	end

	def importar_secciones
		data = File.readlines("AlemIV.rtf") #read file into array
		data.map! {|line| line.gsub(/world/, "ruby")} #invoke on each line gsub
		File.open("test2.txt", "a") {|f| f.puts "Nueva Linea: #{data}"} #output data to other file
	end


end