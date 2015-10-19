class CalDescargarController < ApplicationController
	before_filter :cal_filtro_logueado

	def horario

		@estudiante = CalEstudiante.where(:cal_usuario_ci => session[:cal_usuario].ci).limit(1).first
		@periodo_anterior = CalParametroGeneral.cal_semestre_anterior

		@secciones_aux = @estudiante.cal_secciones.where(:cal_semestre_id => @periodo_anterior.id)

		idiomas = "#{@estudiante.idioma1_id}-#{@estudiante.idioma2_id}-"

		@cal_estudiantes_secciones = @estudiante.cal_estudiantes_secciones 

		reprobadas = 0
		@cal_estudiantes_secciones.each do |est_sec|
			
			if est_sec.calificacion_final < 10
				reparacion = @cal_estudiantes_secciones.where(:cal_materia_id => est_sec.cal_materia_id, :cal_numero => 'R').first
				if reparacion
					reprobadas +=1 if reparacion.calificacion_final < 10
				else
					reprobadas +=1
				end
			end
		end

		@annos = []
		@secciones_aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).group("cal_materia.anno").each{|x| @annos << x.anno if x.anno > 0}

		@annos << @annos.last+1 if (reprobadas < 2 and @annos.max<5)

		@archivos = []

		@annos.each{|ano| @archivos << idiomas+ano.to_s}
		
		if @archivos.include? params[:id]
			archivo = params[:id]

			idioma1,idioma2,anno = (params[:id].split"-")

			if idioma2.eql? 'ING' or idioma2.eql? 'FRA'

				archivo = idioma2+"-"+idioma1+"-"+anno
			end

			send_file "#{Rails.root}/attachments/horarios/#{anno}/#{archivo}.pdf", :type => "application/pdf", :x_sendfile => true, :disposition => "attachment"
		else
    		flash[:error] = "Disculpe Ud. no cuenta con los privilegios para acceder al archivo solicitado"				
			redirect_to :controller => 'cal_principal_estudiante'
		end
	end

end