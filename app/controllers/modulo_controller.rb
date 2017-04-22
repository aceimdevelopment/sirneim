# encoding: utf-8

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
	    	redirect_to session[:wizard] ? "/asistente_diplomado/paso3" : "/diplomado"
	    else
	    	render :action => "nuevo"
	    end
	end

	def vista
    	numero, diplomado_id = params[:id].split ","
		@modulo = Modulo.where(:numero => numero, :diplomado_id => diplomado_id).first
	end

	def editar
		@modulo = Modulo.find params[:id]
	end

	def actualizar
		
	end

	def eliminar
		@modulo = Modulo.find(params[:id])
		@modulo.temas.each do |tema|
			tema.destroy
		end	
		@modulo.destroy
		info_bitacora "Módulo #{@modulo.id} eliminado"
		flash[:alert] = "Modulo con sus cursos, eliminado"
		respond_to do |format|
			format.html { redirect_to :back }
			format.json { head :ok }
		end
  end
end