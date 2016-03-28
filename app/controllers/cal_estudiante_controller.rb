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

	def nuevo
		@cal_usuario = CalUsuario.new

		@cal_departamentos = CalDepartamento.all
	end

	def crear
		@cal_usuario = CalUsuario.new(params[:cal_usuario])
		@cal_usuario.contrasena = @cal_usuario.ci 
		@cal_departamentos = CalDepartamento.all
		if @cal_usuario.save
			params[:cal_estudiante][:cal_usuario_ci] = @cal_usuario.ci
			@cal_estudiante = CalEstudiante.new(params[:cal_estudiante])
			if @cal_estudiante.save
				flash[:success] = "Estudiante Registrado satisfactoriamente"
				redirect_to :controller => 'cal_principal_admin', :action => 'usuarios'
			else
				flash[:danger] = "No se pudo registrar el estudiante, revisa lo siguiente: #{@cal_profesor.errors.message.join(' ')}"
				render :action => 'nuevo'
			end
		else
			flash[:danger] = "No se pudo registrar el usuario, revisa lo siguiente: #{@cal_usuario.errors.message.join(' ')}"
			render :action => 'nuevo'
		end	
	end

end