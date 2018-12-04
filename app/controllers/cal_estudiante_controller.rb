# encoding: utf-8

class CalEstudianteController < ApplicationController
	before_filter :cal_filtro_logueado

	def confirmar
		id = params[:id].split
	    @est_sec_per = CalEstudianteSeccion.find id 
	    @est_sec_per.confirmar_inscripcion = params[:confirmar]
	    @est_sec_per.save

	    redirect_to :back

		
	end


	# def actualizar_plan
	# 	@cal_estudiante = CalEstudiante.find params[:ci]

	# 	@cal_estudiante.plan = params[:plan]
	
	# 	if @cal_estudiante.save
	# 		flash[:success] = "¡Plan actualizado!"
	# 	else
	# 		flash[:error] = "El plan no pudo ser actualizado. Por favor inténtelo de nuevo: #{@cal_estudiante.errors.full_messages.join' | '}"
	# 	end

	# 	redirect_to "/sirneim/cal_principal_admin/detalle_usuario?ci=#{@cal_estudiante.cal_usuario_ci}"

	# end

	def actualizar_idiomas
		@estudiante = CalEstudiante.find params[:ci]

		if @estudiante.combinaciones.count > 0
			flash[:error] = "Usted ya posee una combinación de idiomas. Para cambiarla por favor diríjase al personal administrativo."
		else
			combinacion = @estudiante.combinaciones.new
			combinacion.idioma_id1 = params[:cal_estudiante][:idioma_id1]
			combinacion.idioma_id2 = params[:cal_estudiante][:idioma_id2]
			combinacion.desde_cal_semestre_id = CalParametroGeneral.cal_semestre_actual_id

			if combinacion.save
				flash[:success] = "Datos guardados satisfactoriamente"
			else
				flash[:error] = "No se pudo guardar los datos: #{combinacion.errors.full_messages.join' | '}"
			end

		end
		redirect_to :back, flash: flash
	end

	def nuevo
		@cal_usuario = CalUsuario.new
		@cal_departamentos = CalDepartamento.all.delete_if{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
	end

	def crear
		@cal_usuario = CalUsuario.new(params[:cal_usuario])
		@cal_usuario.contrasena = @cal_usuario.ci 
		@cal_departamentos = CalDepartamento.all.delete_if{|i| i.id.eql? 'EG' or i.id.eql? 'TRA'; }
		begin		
			if @cal_usuario.save
				@cal_estudiante = CalEstudiante.new
				@cal_estudiante.cal_usuario_ci = @cal_usuario.ci
				if @cal_estudiante.save
					flash[:success] = "Estudiante Registrado satisfactoriamente. "
					@combinaciones = @cal_estudiante.combinaciones.new
					@combinaciones.idioma_id1 = params[:combinacion][:idioma_id1]
					@combinaciones.idioma_id2 = params[:combinacion][:idioma_id2]
					@combinaciones.desde_cal_semestre_id = CalParametroGeneral.cal_semestre_actual_id
					if @combinaciones.save
						flash[:success] += "Combinacion de idiomas guardada. "
						es_plan = @cal_estudiante.historiales_planes.new
						es_plan.tipo_plan_id = params[:tipo_plan][:id]
						es_plan.desde_cal_semestre_id = CalParametroGeneral.cal_semestre_actual_id
						if es_plan.save
							flash[:success] += "Plan de Estudio guardado. "
							redirect_to controller: 'cal_principal_admin', action: 'detalle_usuario', ci: @cal_usuario.ci
						else
							flash[:error] = "Error al intentar guardar el plan de estudio."
							render :action => 'nuevo'
						end
					else
						flash[:error] = "Error al intentar guardar el plan de estudio."
						render :action => 'nuevo'
					end
				else
					flash[:error] = "No se pudo registrar el estudiante, revisa lo siguiente: #{@cal_estudiante.errors.message.join(' ')}"
					render :action => 'nuevo'
				end
			else
				flash[:error] = "No se pudo registrar el usuario, revisa lo siguiente: #{@cal_usuario.errors.message.join(' ')}"
				render :action => 'nuevo'
			end	
		rescue Exception => e
			flash[:error] = "Error excepcional: #{e}"
			render :action => 'nuevo'
		end
	end

end