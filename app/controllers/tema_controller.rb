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
		
  		# tema = Tema.new(params[:tema])
  		tema = Tema.new
  		tema.diplomado_id = params[:tema][:diplomado_id]
  		tema.modulo_numero = params[:tema][:modulo_numero]
  		tema.descripcion = params[:tema][:decripcion]
  		tema.numero = params[:tema][:numero]
	    if tema.save
	      redirect_to :controller => "diplomado", :action => "vista", :id => "#{tema.diplomado.id}", :mensaje => "Tema Registrado"
	    else
	      redirect_to :action => "nuevo", :id => tema.id, :mensaje => "Error encontrado: #{tema.errors.full_messages}"
	  	end
	end
end
