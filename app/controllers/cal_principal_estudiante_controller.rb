class CalPrincipalEstudianteController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_estudiante

	def index
		@estudiante = session[:cal_usuario].cal_estudiante

		@secciones = CalEstudianteSeccion.where(:cal_estudiante_ci => @estudiante.cal_usuario_ci)
	end

end
