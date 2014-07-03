class TemaController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def nuevo
		@tema = Tema.new
		modulo_numero, diplomado_id = params[:id].split ","
		@tema.diplomado_id = diplomado_id
		@tema.modulo_numero = modulo_numero
		@titulo = "Registro de Nuevo Tema"
		@accion = 'crear'
	end

	def crear
  		@tema = Tema.new(params[:tema])
	    
	    if @tema.save
	    	flash[:success] = "Tema Agregado Satisfactoriamente" 
			if session[:wizard]
				redirect_to :controller => 'asistente_diplomado', :action => 'paso3', :id => @tema.diplomado_id
			else
				redirect_to :controller => 'principal_admin'
			end
		else
			@titulo = "Registro de Nuevo Tema"
			@accion = 'crear'
			render :action => 'nuevo'
		end
	end

	def editar
		@tema = Tema.new(params[:id])
		@accion = 'actualizar'
	end

	def actualizar
		@tema = Tema.find(params[:id])

		if @tema.update_attributes(params[:tema])
			flash[:success] = "Tema Actualizado Satisfactoriamente" 
			if session[:wizard]
				redirect_to "/aceim_diplomados/asistente_diplomado/paso3/#{@tema.diplomado_id}"
			else
				redirect_to '/aceim_diplomados/principal_admin'
			end
		else
			render :action => 'nuevo'
		end
	end

	def eliminar
		@tema = Tema.find(params[:id])
		@tema.destroy
		info_bitacora "Tema (curso) #{@tema.id} eliminado"
		flash[:alert] = "Curso eliminado"
		respond_to do |format|
			
			format.html { redirect_to :back }
			format.json { head :ok }
		end
	end

end
