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
		cohorte = Cohorte.new
		cohorte.id = params[:cohorte][:id]
		cohorte.nombre = params[:cohorte][:nombre]

	    if cohorte.save
	      redirect_to :action => "index"
	    else
	      redirect_to :action => "nuevo", :mensaje => "Error encontrado: #{cohorte.errors.full_messages.join(" , ")}"
	  	end	  	
	end

	private
	def find_model
		@model = Cohorte.find(params[:id]) if params[:id]
	end
end