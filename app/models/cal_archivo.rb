# encoding: utf-8
class CalArchivo

	def self.listado_excel(tipo,usuarios)
		require 'spreadsheet'

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "Reporte #{tipo}"

		@sheet.column(0).width = 10
		@sheet.column(1).width = 40
		@sheet.column(2).width = 30
		@sheet.column(3).width = 15

		data = %w{CI NOMBRES CORREO MOVIL}
		@sheet.row(0).concat data

		data = []
		usuarios.each_with_index do |usuario,i|
			# aux = { "CI" => usuario.ci, "NOMBRES" => usuario.apellido_nombre, "CORREO" => usuario.correo_electronico, "MOVIL" => usuario.telefono_movil}
			@sheet.row(i+1).concat  [usuario.ci, usuario.apellido_nombre, usuario.correo_electronico, usuario.telefono_movil]
		end

		file_name = "reporte_#{tipo}.xls"
		return file_name if @book.write file_name
	end

	def self.listado_seccion_excel(seccion_id)
		require 'spreadsheet'

		seccion = CalSeccion.find seccion_id

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "Seccion #{seccion.id}"

		estudiantes = seccion.cal_estudiantes.sort_by{|e| e.cal_usuario.apellidos}

		# cal_estudiantes_secciones.sort_by{|h| h.cal_estudiante.cal_usuario.apellidos}

		@sheet.column(0).width = 15 #estudiantes.collect{|e| e.cal_usuario_ci.length if e.cal_usuario_ci}.max+2;
		@sheet.column(1).width = 30	#estudiantes.collect{|e| e.cal_usuario.apellido_nombre.length if e.cal_usuario.apellido_nombre}.max+2;
		@sheet.column(2).width = 30 #estudiantes.collect{|e| e.cal_usuario.correo_electronico.length if e.cal_usuario.correo_electronico}.max+2;
		@sheet.column(3).width = 15

		@sheet.row(0).concat ["Profesor: #{seccion.cal_profesor.cal_usuario.apellido_nombre}"]
		@sheet.row(1).concat ["Sección: #{seccion.descripcion}"]
		@sheet.row(2).concat %w{CI NOMBRES CORREO MOVIL}

		data = []
		estudiantes.each_with_index do |est,i|
			usuario = est.cal_usuario
			@sheet.row(i+3).concat  [usuario.ci, usuario.apellido_nombre, usuario.correo_electronico, usuario.telefono_movil]
		end

		file_name = "reporte_seccion.xls"
		return file_name if @book.write file_name
	end


end