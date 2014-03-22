class ModuloController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador		

	def nuevo
    @modulo = Modulo.new
	  @modulo.diplomado_id = params[:id]
	end

	def crear
		modulo = Modulo.new(params[:modulo])
    if modulo.save
    	redirect_to :controller => "diplomado", :action => "vista", :id => "#{tema.diplomado.id}", :mensaje => "Módulo Registrado"	
    else
      redirect_to :action => "nuevo", :id => modulo.diplomado_id, :mensaje => "Error encontrado: #{modulo.errors.full_messages}"
  	end	  	
	end

	def vista
    numero, diplomado_id = params[:id].split ","

		@modulo = Modulo.where(:numero => numero, :diplomado_id => diplomado_id).first
	end

  def editar
    
  end
end