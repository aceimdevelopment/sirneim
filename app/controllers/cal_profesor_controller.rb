class CalProfesorController < ApplicationController

	def nuevo
		# @cal_profesor = CalProfesor.new
	end

	def crear

		@cal_usuario = CalUsuario.new(params[:cal_usuario])
		@cal_usuario.contrasena = @cal_usuario.ci 

		if @cal_usuario.save
			params[:cal_profesor][:cal_usuario_ci] = @cal_usuario.ci
			@cal_profesor = CalProfesor.new(params[:cal_profesor])
			if @cal_profesor.save
				flash[:success] = "Profesor Registrado satisfactoriamente"
				redirect_to :controller => 'cal_principal_admin', :action => 'usuarios'
			else
				flash[:danger] = "No se pudo registrar el profesor, revisa lo siguiente: #{@cal_profesor.errors.message.join(' ')}"
				render :action => 'nuevo'
			end
		else
			flash[:danger] = "No se pudo registrar el usuario, revisa lo siguiente: #{@cal_usuario.errors.message.join(' ')}"
			render :action => 'nuevo'
		end	
	end

end
