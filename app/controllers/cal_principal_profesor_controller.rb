# encoding: utf-8

class CalPrincipalProfesorController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_profesor

	def index
		@titulo = "Principal - Profesores"	
	end

end
