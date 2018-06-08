# encoding: utf-8
class CalArchivo
	def self.to_utf16(valor)
		ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
		ic_ignore.iconv(valor)
	end



	def self.hacer_kardex(id)
		# Variable Locales
		estudiante = CalEstudiante.find id
		periodos = CalSemestre.order("id DESC").all
		secciones = CalEstudianteSeccion.where(:cal_estudiante_ci => estudiante.cal_usuario_ci).order("cal_materia_id ASC, cal_numero DESC")

		pdf = PDF::Writer.new

		# Parametros
		pdf.margins_cm(1.8)

		# Logos
		pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 720, 50,nil

		#texto del encabezado
		pdf.add_text_wrap 50,705,510,to_utf16("UNIVERSIDAD CENTRAL DE VENEZUELA"), 12,:center
		pdf.add_text_wrap 50,690,510,to_utf16("FACULTAD DE HUMANIDADES Y EDUCACIÓN"), 12,:center
		pdf.add_text_wrap 50,675,510,to_utf16("ESCUELA DE IDIOMAS MODERNOS"), 12,:center
		pdf.add_text_wrap 50,660,510,to_utf16("CONTROL DE ESTUDIOS DE PREGRADO"), 12,:center
		pdf.add_text_wrap 50,645,510,to_utf16("<b>Historial Académico</b>"), 12,:center

		#titulo
		pdf.add_text 50,625,to_utf16("<b>Cédula:</b> #{estudiante.cal_usuario_ci}"),9
		pdf.add_text 150,625,to_utf16("<b>Alumno:</b> #{estudiante.cal_usuario.apellido_nombre.upcase}"),9

		pdf.text "\n"*10
		periodos.each do |periodo|
			secciones_periodo = secciones.where(:cal_semestre_id => periodo.id)
			if secciones_periodo.count > 0


				tabla = PDF::SimpleTable.new
				tabla.heading_font_size = 9
				tabla.font_size = 9
				tabla.show_lines    = :all
				tabla.line_color = Color::RGB::Gray
				tabla.show_headings = true
				tabla.shade_headings = true
				tabla.shade_heading_color = Color::RGB.new(238,238,238)
				tabla.shade_color = Color::RGB.new(230,238,238)
				tabla.shade_color2 = Color::RGB::White
				tabla.shade_rows = :striped
				tabla.orientation   = :center
				tabla.position      = :center

				tabla.column_order = ["codigo", "asignatura", "final", "seccion"]

				tabla.columns["codigo"] = PDF::SimpleTable::Column.new("codigo") { |col|
					col.heading = to_utf16("<b>Código</b>")
					col.heading.justification = :center
					col.justification = :center
				}
				tabla.columns["asignatura"] = PDF::SimpleTable::Column.new("asignatura") { |col|
					col.width = 300
					col.heading = "<b>Nombre Asignatura</b>"
					col.heading.justification = :left
					col.justification = :left
				}
				tabla.columns["final"] = PDF::SimpleTable::Column.new("final") { |col|
					col.width = 60
					col.heading = to_utf16("<b>Cal. Num</b>")
					col.heading.justification = :center
					col.justification = :center
				}
				tabla.columns["seccion"] = PDF::SimpleTable::Column.new("seccion") { |col|
					col.heading = to_utf16("<b>Sección</b>")
					col.heading.justification = :center
					col.justification = :center
				}
				data = []
				tabla.column_order = ["codigo", "asignatura", "final", "seccion"]

				secciones_periodo.each do |h|
					aux = h.cal_seccion.cal_materia.descripcion
					data << {"codigo" => "#{h.cal_seccion.cal_materia.id_upsi}",
						"asignatura" => to_utf16(h.descripcion),
						"final" => to_utf16("#{h.calificacion_final}"),
						"seccion" => to_utf16("#{h.cal_seccion.numero}")
				 	}

				end
				pdf.text "\n"*2

				pdf.text to_utf16("<b>Periodo:</b> #{periodo.id}"), font_size: 10
				pdf.text "\n"

				tabla.data.replace data
				tabla.render_on(pdf)

			end
		end
      	t = Time.new

      	pdf.start_page_numbering(250, 15, 7, nil, to_utf16("#{t.day} / #{t.month} / #{t.year}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)
		pdf.text "\n"
		pdf.text to_utf16("<b>NOTA:</b> CUANDO EXISTA DISCREPANCIA ENTRE LOS DATOS CONTENIDOS EN LAS ACTAS DE EXAMENES Y ÉSTE COMPROBANTE, LOS PRIMEROS SE TENDRÁN COMO AUTÉNTICOS PARA CUALQUIER FIN."), font_size: 11
		pdf.text "\n"
		pdf.text to_utf16("* ÉSTE COMPROBANTE ES DE CARACTER INFORMATIVO, NO TIENE VALIDEZ LEGAL *"), font_size: 11, justification: :center


		return pdf

	end





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