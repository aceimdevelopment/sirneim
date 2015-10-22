class CalDescargarController < ApplicationController
	before_filter :cal_filtro_logueado



  def descargas

    ids = params[:id]
    alertas = Alerta.where(:id => ids.split(","))
    file_name = Pdf.descargar_alertas_excel(alertas)
    send_file file_name, :type => "application/vnd.ms-excel", :filename => "reporte_alertas.xls", :stream => false

    File.delete(file_name)
  end



	def listados
		tipo = params[:tipo]
		ids = params[:id]
		usuarios = CalUsuario.where(:ci => ids.split(","))
		usuarios.each { |us| puts us.descripcion }
		file_name = CalArchivo.listado_excel(tipo,usuarios) 
		send_file file_name, :type => "application/vnd.ms-excel", :filename => "reporte_#{tipo}.xls", :stream => false
		File.delete(file_name)
	end


	def horario

		@estudiante = CalEstudiante.where(:cal_usuario_ci => session[:cal_usuario].ci).limit(1).first

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