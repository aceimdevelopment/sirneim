# encoding: utf-8

class CalProfesorController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_administrador

	def nuevo
		# @cal_profesor = CalProfesor.new
	end

	def crear
		if @cal_usuario = CalUsuario.where(:ci => params[:cal_usuario][:ci]).limit(1).first
			@cal_usuario.attributes = params[:cal_usuario]
		else
			@cal_usuario = CalUsuario.new(params[:cal_usuario])
		end
		@cal_usuario.contrasena = @cal_usuario.ci

		if @cal_usuario.save
			params[:cal_profesor][:cal_usuario_ci] = @cal_usuario.ci

			if @cal_profesor = CalProfesor.where(:cal_usuario_ci => params[:cal_profesor][:cal_usuario_ci]).limit(1).first
				flash[:success] = "El profesor ya estaba registrado. Se actualizaron sus datos. La contraseña fue reseteada."
			else
				@cal_profesor = CalProfesor.new(params[:cal_profesor])
				flash[:success] = "Profesor registrado satisfactoriamente"
			end

			if @cal_profesor.save
				redirect_to :controller => 'cal_principal_admin', :action => 'usuarios'
			else
				flash[:alert] = "No se pudo registrar el profesor, revisa lo siguiente: #{@cal_profesor.errors.message.join(' ')}"
				render :action => 'nuevo'
			end
		else
			flash[:alert] = "No se pudo registrar el usuario, revisa lo siguiente: #{@cal_usuario.errors.message.join(' ')}"
			render :action => 'nuevo'
		end						

	end
end
