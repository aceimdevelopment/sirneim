class CalEstudianteController < ApplicationController
	before_filter :cal_filtro_logueado

	def actualizar_idiomas
		
		@estudiante = CalEstudiante.where(:cal_usuario_ci => params[:ci]).limit(1).first

		if @estudiante.update_attributes(params[:cal_estudiante])
			flash[:success] = "Datos guardados satisfactoriamente"
		else
			flash[:error] = "No se pudo guardar los datos: #{@estudiante.errors.full_messages.join' | '}"
		end		
		@return = params[:url] ? params[:url] : 'index'

		if session[:cal_estudiante]
			redirect_to :controller => 'cal_principal_estudiante', :action => 'index'
		elsif session[:cal_administrador]
			redirect_to :controller => 'cal_principal_admin', :action => 'detalle_usuario', :ci => params[:ci]
		else
			redirect_to :action => 'index'			
		end

	end

end