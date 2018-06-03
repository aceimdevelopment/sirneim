# encoding: utf-8
class CalArchivo

	def self.listado_excel_asignaturas_estudiantes_periodo(cal_semestre_id, nuevos=nil)
		require 'spreadsheet'

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "ReporteEstudiantesPeriodo#{cal_semestre_id}"

		semestre = CalSemestre.find cal_semestre_id

      	if nuevos
      		estudiantes = CalEstudiante.where(cal_tipo_estado_inscripcion_id: 'NUEVO')
      	else
    		estudiantes = semestre.cal_estudiantes_secciones.uniq #CalEstudiante.join(:cal_secciones).where('cal_secciones.cal_semestre_id = ?', @semestre_id)
    	end
		# secciones = e.cal_estudiantes_secciones.del_semestre @semestre_id

		data = 
		@sheet.row(0).concat %w{# CI NOMBRE ASIG1 ASIG2 ASIG3 ASIG4 ASIG5 ASIG6 ASIG7 ASIG8 ASIG9 ASIG10 ASIG11 ASIG12}

		data = []
		estudiantes.each_with_index do |e,i|
			secciones = e.cal_estudiantes_secciones.del_semestre cal_semestre_id
			aux = [i+1, e.cal_usuario_ci, e.cal_usuario.apellido_nombre]

			secciones.each do |seccion|
				aux << "#{seccion.cal_seccion.descripcion} (#{seccion.cal_seccion.cal_materia.id_upsi})"
			end
			aux 
			@sheet.row(i+1).concat  aux
			# aux = { "CI" => usuario.ci, "NOMBRES" => usuario.apellido_nombre, "CORREO" => usuario.correo_electronico, "MOVIL" => usuario.telefono_movil}
		end
		if nuevos
			file_name = "reporte_estudiantes_asignaturas_nuevos.xls"
		else
			file_name = "reporte_estudiantes_asignaturas_periodo_#{cal_semestre_id}.xls"
		end
		return file_name if @book.write file_name
	end


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

		if seccion.cal_semestre_id.eql? '2016-02A'
			estudiantes = seccion.cal_estudiantes_secciones.confirmados.sort_by{|e| e.cal_estudiante.cal_usuario.apellidos}
		else
			estudiantes = seccion.cal_estudiantes_secciones.sort_by{|e| e.cal_estudiante.cal_usuario.apellidos}
		end
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
			usuario = est.cal_estudiante.cal_usuario
			@sheet.row(i+3).concat  [usuario.ci, usuario.apellido_nombre, usuario.correo_electronico, usuario.telefono_movil]
		end

		file_name = "reporte_seccion.xls"
		return file_name if @book.write file_name
	end


end