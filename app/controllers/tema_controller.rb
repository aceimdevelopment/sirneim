class TemaController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def nuevo
		@tema = Tema.new
		modulo_numero, diplomado_id = params[:id].split ","
		@tema.diplomado_id = diplomado_id
		@tema.modulo_numero = modulo_numero
		@titulo = "Registro de Nuevo Tema"
	end

	def crear
  		@tema = Tema.new(params[:tema])
	    if @tema.save
	    	flash[:success] = "Tema Agregado Satisfactoriamente"
	    	redirect_to :controller => "diplomado", :action => "vista", :id => "#{@tema.diplomado.id}"
	    else
	    	render :action => "nuevo"
	  	end
	end

	def editar
		1/0
	end
end
