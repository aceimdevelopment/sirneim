class TemaController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def nuevo
		@tema = Tema.new
		modulo_numero, diplomado_id = params[:id].split ","
		@tema.diplomado_id = diplomado_id
		@tema.modulo_numero = modulo_numero
	end

	def crear
  		tema = Tema.new(params[:tema])
	    if tema.save
	      redirect_to :controller => "modulo", :action => "vista", :id => "#{tema.modulo.id}", :mensaje => "Modulo Registrado"
	    else
	      redirect_to :action => "nuevo", :id => tema.id, :mensaje => "Error encontrado: #{tema.errors.full_messages}"
	  	end
	end
end
