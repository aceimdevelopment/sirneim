class CalDescargarController < ApplicationController
	before_filter :cal_filtro_logueado

	def horario

		@estudiante = CalEstudiante.where(:cal_usuario_ci => session[:cal_usuario].ci).limit(1).first
		@periodo_anterior = CalParametroGeneral.cal_semestre_anterior

		@secciones_aux = @estudiante.cal_secciones.where(:cal_semestre_id => @periodo_anterior.id)

		@cal_estudiantes_secciones = @estudiante.cal_estudiantes_secciones 

		@archivos = @estudiante.archivos_disponibles_para_descarga 
		
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