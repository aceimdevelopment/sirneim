class CalPrincipalAdminController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_administrador

	def index
		@departamentos = CalDepartamento.all
		@cal_usuario = session[:cal_usuario]
		
	end

end
