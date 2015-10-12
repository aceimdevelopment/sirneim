class CalPrincipalEstudianteController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_estudiante

	def index
		@estudiante = session[:cal_usuario].cal_estudiante
		@periodo_actual = CalParametroGeneral.cal_semestre_actual
		@periodos = CalSemestre.all.delete_if{|p| p.id = @periodo_actual.id}
		@secciones = CalEstudianteSeccion.where(:cal_estudiante_ci => @estudiante.cal_usuario_ci).order("cal_materia_id ASC")
	end

end
