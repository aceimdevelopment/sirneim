# encoding: utf-8

class CalDescargarController < ApplicationController
	before_filter :cal_filtro_logueado

	def reportes
		@cal_semestre_actual_id = session[:cal_parametros][:semestre_actual]
		@cal_semestre_actual = CalSemestre.where(:id => @cal_semestre_actual_id).limit(1).first
		@cal_usuario = session[:cal_usuario]
		@admin = session[:cal_administrador]

		
	end

	def programaciones
		id = params[:id]
		periodo = params[:cal_semestre_id]

		send_file "#{Rails.root}/attachments/programaciones/#{periodo}/PROG_#{id}_#{periodo}.pdf", :type => "application/pdf", :x_sendfile => true, :disposition => "attachment"		
	end


  # def descargas

  #   ids = params[:id]
  #   alertas = Alerta.where(:id => ids.split(","))
  #   file_name = Pdf.descargar_alertas_excel(alertas)
  #   send_file file_name, :type => "application/vnd.ms-excel", :filename => "reporte_alertas.xls", :stream => false

  #   File.delete(file_name)
  # end


  def cita_horaria
		file_name = CalArchivo.cita_horaria params[:id]
		# send_data data, filename: "cita_horaria_#{params[:id]}.xls"
		send_file file_name, :type => "application/vnd.ms-excel", :x_sendfile => true, :stream => false, :filename => "cita_horaria_#{params[:id]}.xls",:disposition => "attachment"
  end

	def listado_estudiantes_x_plan_csv
		periodo_id = session[:cal_parametros][:semestre_actual]
		data = CalArchivo.estudiantes_x_plan_csv params[:id], periodo_id
		send_data data, filename: "estudiantes_x_plan_#{periodo_id}_#{params[:id]}.csv"
	end


	def registro_estudiantil_x_plan
		file_name = CalArchivo.registro_estudiantil_x_plan
		send_file file_name, x_sendfile: true, stream: false, disposition: "attachment"
	end


	def listado_estudiantes_periodo_excel
		file_name = CalArchivo.listado_excel_asignaturas_estudiantes_periodo(params[:id], params[:nuevos])
		send_file file_name, type:"application/vnd.ms-excel", x_sendfile: true, stream: false, disposition: "attachment"
	end

	def listado_seccion
		seccion_id = params[:id]
		file_name = CalArchivo.listado_seccion_excel(seccion_id)
		send_file file_name, :type => "application/vnd.ms-excel", :x_sendfile => true, :stream => false, :filename => "reporte_seccion.xls",:disposition => "attachment"
	end

	def listados
		tipo = params[:tipo]
		ids = params[:id]
		usuarios = CalUsuario.order("apellidos ASC, nombres ASC").where(:ci => ids.split(","))
		# usuarios.each { |us| puts us.descripcion }
		file_name = CalArchivo.listado_excel(tipo,usuarios) 
		# send_file file_name, :type => "application/vnd.ms-excel", :filename => "reporte_#{tipo}.xls", :stream => false
		send_file file_name, :type => "application/vnd.ms-excel", :x_sendfile => true, :stream => false, :filename => "reporte_#{tipo}.xls",:disposition => "attachment"
		# File.delete(file_name)
	end

	def archivo
		tipo = params[:tipo] ? params[:tipo] : "pdf"
		send_file "#{Rails.root}/attachments/#{params[:id]}.#{tipo}", :type => "application/#{tipo}", :x_sendfile => true, :disposition => "attachment"

	end

	def acta_examen
		pdf = CalArchivo.hacer_acta params[:id]
		unless send_data pdf.render,:filename => "acta_#{params[:id].to_s.gsub(",","_")}.pdf",:type => "application/pdf", :disposition => "attachment"
			flash[:mensaje] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
		end
		
	end


	def acta_examen_excel
		excel = CalArchivo.hacer_acta_excel params[:id]
		unless send_file excel, :type => "application/vnd.ms-excel", :x_sendfile => true, :stream => false, :filename => "acta_excel_#{params[:id].to_s.gsub(",","_")}.xls",:disposition => "attachment"
			flash[:mensaje] = "En estos momentos no se pueden descargar el acta, intentelo más tarde."
		end
		
	end

	def kardex
		pdf = CalArchivo.hacer_kardex params[:id]
		unless send_data pdf.render,:filename => "kardex_#{params[:id]}.pdf",:type => "application/pdf", :disposition => "attachment"
	    	flash[:mensaje] = "En estos momentos no se pueden descargar el kardex, intentelo luego."
	    end
		
	end

	def horario

		@estudiante = CalEstudiante.where(:cal_usuario_ci => session[:cal_usuario].ci).limit(1).first

		@archivos = @estudiante.archivos_disponibles_para_descarga 
		
		if @archivos.include? params[:id]
			archivo = params[:id]

			idioma1,idioma2,anno = (params[:id].split"-")

			archivo = idioma2+"-"+idioma1+"-"+anno if (idioma2.eql? 'ING' or (idioma2.eql? 'FRA' and not idioma1.eql? 'ING'))
			archivo = 'ING-FRA-'+anno if (idioma2.eql? 'ING' and idioma1.eql? 'FRA')

			send_file "#{Rails.root}/attachments/horarios/#{anno}/#{archivo}.pdf", :type => "application/pdf", :x_sendfile => true, :disposition => "attachment"
		else
    		flash[:error] = "Disculpe Ud. no cuenta con los privilegios para acceder al archivo solicitado"				
			redirect_to :controller => 'cal_principal_estudiante'
		end
	end

end