# encoding: utf-8

class CalPrincipalEstudianteController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_estudiante

	def index
		@estudiante = CalEstudiante.where(:cal_usuario_ci => session[:cal_usuario].ci).limit(1).first
		@periodo_actual = CalParametroGeneral.cal_semestre_actual
		@periodo_anterior = CalParametroGeneral.cal_semestre_anterior

		@periodos = CalSemestre.order("id DESC").all
		# @periodos = CalSemestre.where(:id => '2014-02A')
		@secciones = CalEstudianteSeccion.where(:cal_estudiante_ci => @estudiante.cal_usuario_ci).order("cal_materia_id ASC, cal_numero DESC")#.group(:cal_materia_id)

		if @estudiante.combinaciones.count < 1 #idioma1_id.nil? or @estudiante.idioma2_id.nil?		 
			@idiomas = CalDepartamento.all.delete_if{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
			@programaciones = CalDepartamento.all
		else
			@programaciones = CalDepartamento.where(:id => [ "#{@estudiante.idioma1_id}" ,"#{@estudiante.idioma2_id}"]) #,'EG','TRA'

		end
		@total = @secciones.all.count

		#@archivos = @estudiante.archivos_disponibles_para_descarga 

# -------------------------------------------------------------------------------------------------------------------------------------------
# OJO: TEMPORALMENTE ESTOS MENSAJES SERAN OCULTADOS

		# if @estudiante.cal_tipo_estado_inscripcion_id.eql? 'NUEVO'
		# 	flash[:info] = "Como aún no has seleccionado formalmente tu combinación de idiomas, te mostramos todas las combinaciones posibles para que te hagas una idea de como puede ser tu horario. Luego de realizar tu inscripción en la EIM debes indicarnos tu combinación de idiomas para actualizar tu información."
		# elsif @estudiante.cal_tipo_estado_inscripcion_id.eql? 'REINC'
		# 	flash[:info] =  "Como SIRNEIM es una plataforma nueva no tiene tu información previa, por eso te mostramos todos los horarios de tu combinación de idiomas.  Una vez que realices tu inscripción en la EIM y se migre esa información a la plataforma ya podrás ver solo los horarios que te corresponde"
		# end

# -------------------------------------------------------------------------------------------------------------------------------------------


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
