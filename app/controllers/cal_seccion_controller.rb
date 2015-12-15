class CalSeccionController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_administrador

	def clonar_secciones_anteriores
		@periodo_actual = CalParametroGeneral.cal_semestre_actual
		@periodo_anterior = CalParametroGeneral.cal_semestre_anterior

		@secciones = CalSeccion.where(:cal_semestre_id => @periodo_anterior.id)

		total_clonadas = 0
		errores = 0
		@secciones.each do |seccion|
			nueva = CalSeccion.new
			nueva.numero = seccion.numero
			nueva.cal_semestre_id = @periodo_actual.id
			nueva.cal_materia_id = seccion.cal_materia_id
			nueva.cal_profesor_ci = seccion.cal_profesor_ci
			nueva.calificada = false
			begin
				if nueva.save 
					total_clonadas += 1
				else
					errores += 1
				end
			rescue
				flash[:error] = "Error durante Clonación. Es posible que la clonación ya se haya realizado para el actual período."
			end
		end

		flash[:success] = "Se Clonaron un total de #{total_clonadas} secciones. Hubo #{errores}" if total_clonadas > 0
		redirect_to :back

	end

	def eliminar_todas_secciones_actual

		@periodo_actual = CalParametroGeneral.cal_semestre_actual

		@secciones = CalSeccion.where(:cal_semestre_id => @periodo_actual.id)

		total_eliminadas = 0
		errores = 0
		@secciones.each do |seccion|
			seccion.cal_estudiantes_secciones.each{|sec_est| sec_est.delete}
			if seccion.delete
				total_eliminadas += 1
			else
				errores += 1
			end
		end

		flash[:info] = "Se Eliminaron un total de #{total_eliminadas} secciones. Hubo #{errores} error(es)"
		redirect_to :back

	end


	def eliminar
		"R,ALEMI,2015-02A"

		@cal_seccion = CalSeccion.find params[:id]

		if @cal_seccion.delete
			flash[:info] = "Se eliminó la sección de manera correcta"
		end
		redirect_to :back
	end
end
