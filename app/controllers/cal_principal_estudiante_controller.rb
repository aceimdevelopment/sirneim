class CalPrincipalEstudianteController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_estudiante

	def actualizar_idiomas
		@estudiante = CalEstudiante.where(:cal_usuario_ci => session[:cal_usuario].ci).limit(1).first

		if @estudiante.update_attributes(params[:cal_estudiante])
			flash[:success] = "Datos guardados Satisfactoriamente"
		else
			flash[:error] = "No se pudo guardar los datos: #{@estudiante.errors.full_messages.join' | '}"
		end		
		
		redirect_to :action => 'index'	

	end

	def index
		@estudiante = CalEstudiante.where(:cal_usuario_ci => session[:cal_usuario].ci).limit(1).first
		@periodo_actual = CalParametroGeneral.cal_semestre_actual
		@periodo_anterior = CalParametroGeneral.cal_semestre_anterior

		@periodos = CalSemestre.all.delete_if{|p| p.id.eql? @periodo_actual.id}
		@secciones = CalEstudianteSeccion.where(:cal_estudiante_ci => @estudiante.cal_usuario_ci).order("cal_materia_id ASC, cal_numero DESC").group(:cal_materia_id)

		@secciones_aux = @estudiante.cal_secciones.where(:cal_semestre_id => @periodo_anterior.id)

		if @estudiante.idioma1_id.nil? or @estudiante.idioma2_id.nil?		 
			@idiomas1 = CalDepartamento.where('id = ? || id = ?', 'ING', 'FRA').order('id DESC')
			@idiomas2 = CalDepartamento.all.delete_if{|i| i.id.eql? 'ING' or i.id.eql? 'EG' or i.id.eql? 'TRA'; }
		else

			idiomas = "#{@estudiante.idioma1_id}-#{@estudiante.idioma2_id}-"

			@cal_estudiantes_secciones = @estudiante.cal_estudiantes_secciones 

			reprobadas = 0
			@cal_estudiantes_secciones.each do |est_sec|
				
				if est_sec.calificacion_final < 10
					reparacion = @cal_estudiantes_secciones.where(:cal_materia_id => est_sec.cal_materia_id, :cal_numero => 'R').first
					if reparacion
						reprobadas +=1 if reparacion.calificacion_final < 10
					else
						reprobadas +=1
					end
				end
			end			

		@annos = []
		@secciones_aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).group("cal_materia.anno").each{|x| @annos << x.anno if x.anno > 0}

		@annos << @annos.last+1 if (reprobadas < 2 and @annos.max<5)

		@archivos = []

		@annos.each{|ano| @archivos << idiomas+ano.to_s}

		end

		# @total_materias_anno_base = CalMateria.where(:anno => @annos.first).count
		# @annos.shift if (@reprobadas.eql? 0 and @cal_estudiantes_secciones.count.eql? @total_materias_anno_base)


		# @cal_departamentos = []

		# @secciones_aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).group("cal_materia.cal_departamento_id").each{|y| @cal_departamentos << y.cal_departamento_id if (y.cal_departamento_id != 'EG' and y.cal_departamento_id != 'TRA') }

		# @archivos = []


		# if @cal_departamentos.count.eql? 1

		# 	if @cal_departamentos.first.eql? "ING"
		# 		@annos.each{|ano| @archivos << "ING-ALE-"+ano.to_s}
		# 		@annos.each{|ano| @archivos << "ING-FRA-"+ano.to_s}
		# 		@annos.each{|ano| @archivos << "ING-ITA-"+ano.to_s}
		# 		@annos.each{|ano| @archivos << "ING-POR-"+ano.to_s}
		# 	elsif @cal_departamentos.first.eql? "FRA"
		# 		@annos.each{|ano| @archivos << "FRA-ALE-"+ano.to_s}
		# 		@annos.each{|ano| @archivos << "FRA-ITA-"+ano.to_s}
		# 		@annos.each{|ano| @archivos << "FRA-POR-"+ano.to_s}				
		# 	else
		# 		@annos.each{|ano| @archivos << "ING-#{@cal_departamentos.first.to_s}-"+ano.to_s}
		# 		@annos.each{|ano| @archivos << "FRA-#{@cal_departamentos.first.to_s}-"+ano.to_s}
		# 	end
		# end

		# if @cal_departamentos.count.eql? 2
			
		# 	if @cal_departamentos.include? "ING"
		# 		@cal_departamentos.delete "ING"
		# 		@annos.each{|ano| @archivos << "ING-#{@cal_departamentos.first.to_s}-"+ano.to_s}
		# 	elsif @cal_departamentos.include? "FRA"
		# 		@cal_departamentos.delete "FRA"
		# 		@annos.each{|ano| @archivos << "FRA-#{@cal_departamentos.first.to_s}-"+ano.to_s}				
		# 	else
		# 		@annos.each{|ano| @archivos << "ING-#{@cal_departamentos.first.to_s}-"+ano.to_s}
		# 		@annos.each{|ano| @archivos << "FRA-#{@cal_departamentos.first.to_s}-"+ano.to_s}				
		# 	end
		# end



		# @aprobadas = @secciones_aux.where("calificacion_final >= ?", 10).all.count
		# @reprobadas = @secciones_aux.where("calificacion_final < ?", 10).all.count
		@total = @secciones.all.count
	

		# @secciones.each do |seccion|



		# @annos = @secciones.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).group("cal_materia.cal_departamento_id")
		# @departamentos = @secciones.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).group("cal_materia.anno")


		# CalEstudiante.first.cal_secciones.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).group("cal_materia.anno")

		# @materias_periodo_anterior = @secciones.where(:cal_semestre_id => @periodo_anterior.id)
		# aprobadas = 0

		# @materias_periodo_anterior_rep_sup = @materias_periodo_anterior.where
		# @materias_periodo_anterior.each do |materia|
		# 	materia.numero.eql? 'R'
		# 	aprobadas += 1 if materia.nota_final > 10



	end

end
