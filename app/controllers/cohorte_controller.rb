class CohorteController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador


	def index
		@cohortes = Cohorte.all
		@titulo = "Listado de Cohorte"
	end

	def nuevo
		@cohorte = Cohorte.new 
		@titulo = "Nueva Cohorte"
	end

	def crear
		# cohorte = Cohorte.new(params[:cohorte])
		@cohorte = Cohorte.find_or_create_by_id(params[:cohorte][:id])
		# @cohorte.id = params[:cohorte][:id]
		@cohorte.nombre = params[:cohorte][:nombre]

    if @cohorte.save
    	if session[:wizard]
    		session[:cohorte] = @cohorte
    		redirect_to :controller => 'asistente_diplomado', :action => 'paso2'
    	else
      	redirect_to :action => 'index'
      end
    else
      render :action => 'nuevo'
  	end	  	
	end

	def editar
		1/0
	end

	def actualizar
		1/0
	end

	private
	def find_model
		@model = Cohorte.find(params[:id]) if params[:id]
	end
end