class ModuloController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador		

	def nuevo
    	@modulo = Modulo.new
		@modulo.diplomado_id = params[:id]
		@titulo = "Registro de Nuevo Modulo"
	end

	def crear
		@modulo = Modulo.new(params[:modulo])
	    if @modulo.save
	    	flash[:success] = "Módulo Registrado Satisfactoriamente"
	    	redirect_to :controller => "diplomado", :action => "vista", :id => "#{@modulo.diplomado.id}"
	    else
	    	render :action => "nuevo"
	  	end

	end

	def vista
    	numero, diplomado_id = params[:id].split ","
		@modulo = Modulo.where(:numero => numero, :diplomado_id => diplomado_id).first
	end

	def editar
		1/0
	end
end