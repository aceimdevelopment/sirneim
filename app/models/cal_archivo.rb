# encoding: utf-8
class CalArchivo
	def self.to_utf16(valor)
		ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
		ic_ignore.iconv(valor)
	end


	def self.hacer_acta(seccion_id)

		seccion = CalSeccion.find seccion_id
		pdf = PDF::Writer.new

		acta_no = "#{seccion.cal_materia.id_upsi}#{seccion.numero}#{seccion.cal_semestre.anno}"
		# Parametros
		pdf.margins_cm(1.8)

		# Logos
		pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 720, 50,nil

		#texto del encabezado
		pdf.add_text_wrap 50,705,510,to_utf16("UNIVERSIDAD CENTRAL DE VENEZUELA"), 12,:center
		pdf.add_text_wrap 50,690,510,to_utf16("PLANILLA DE EXÁMENES"), 12,:center
		pdf.add_text_wrap 50,675,510,to_utf16("TIPO DE EXAMEN: FINAL ANUAL (SEPTIEMBRE)"), 12,:center

		#titulo

		pdf.add_text 50,660,to_utf16("FECHA DE LA EMISIÓN: <b>#{Time.now.strftime('%d/%m/%Y %I:%M %p')}</b>"),9
		pdf.add_text 50,645,to_utf16("EJERCICIO: <b>#{seccion.ejercicio}</b>"),9
		pdf.add_text 50,630,to_utf16("FACULTAD: <b>HUMANIDADES Y EDUCACIÓN</b>"),9
		pdf.add_text 50,615,to_utf16("ESCUELA: <b>IDIOMAS</b>"),9


		pdf.start_page_numbering(400, 660, 9, nil, to_utf16("PÁGINA: <b><PAGENUM>/<TOTALPAGENUM></b>"), 1)
		pdf.add_text 400,645,to_utf16("ACTA N°: <b>#{acta_no.upcase}</b>"),9
		pdf.add_text 400,630,to_utf16("PERIODO ACADÉMICO: <b>#{seccion.cal_semestre.anno}</b>"),9
		pdf.add_text 400,615,to_utf16("TIPO CONVOCATORIA: <b>#{seccion.tipo_convocatoria}</b>"),9

		pdf.text "\n"*12

		tabla = PDF::SimpleTable.new
		tabla.heading_font_size = 9
		tabla.font_size = 9
		tabla.show_lines    = :all
		tabla.show_headings = true
		tabla.orientation   = :center
		tabla.position      = :center

		tabla.column_order = ["asignatura", "codigo", "creditos", "curso", "seccion", "duracion"]

		tabla.columns["asignatura"] = PDF::SimpleTable::Column.new("asignatura") { |col|
			col.heading = to_utf16("<b>ASIGNATURA</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["codigo"] = PDF::SimpleTable::Column.new("codigo") { |col|
			col.heading = "<b>COD. ASIGNATURA</b>"
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["creditos"] = PDF::SimpleTable::Column.new("creditos") { |col|
			col.heading = "<b>UNID/CRED</b>"
			col.heading.justification = :center
			col.justification = :center
		}				
		tabla.columns["curso"] = PDF::SimpleTable::Column.new("curso") { |col|
			col.heading = to_utf16("<b>CURSO</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["seccion"] = PDF::SimpleTable::Column.new("seccion") { |col|
			col.heading = to_utf16("<b>SECCIÓN</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["duracion"] = PDF::SimpleTable::Column.new("duracion") { |col|
			col.heading = to_utf16("<b>DURACIÓN</b>")
			col.heading.justification = :center
			col.justification = :center
		}

		data = []

		data << {"asignatura" => to_utf16("#{seccion.cal_materia.descripcion}"),
			"codigo" => to_utf16("#{seccion.cal_materia.id_upsi}"),
			"creditos" => to_utf16("#{seccion.cal_materia.creditos}"),
			"curso" => 1,
			"seccion" => to_utf16("#{seccion.numero}"),
			"duracion" => "A2"
	 	}

		tabla.data.replace data
		tabla.render_on(pdf)

 		# pdf.line 50,560,570,560
 		# pdf.line 50,559,570,559

		pdf.text "\n"*2

		tabla = PDF::SimpleTable.new
		tabla.heading_font_size = 8
		tabla.font_size = 7
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


		tabla.columns["n"] = PDF::SimpleTable::Column.new("n") { |col|
			col.heading = to_utf16("<b>N°</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["ci"] = PDF::SimpleTable::Column.new("ci") { |col|
			col.width = 60
			col.heading = "<b>CEDULA DE IDENTIDAD</b>"
			col.heading.justification = :center
			col.justification = :left
		}
		tabla.columns["nom"] = PDF::SimpleTable::Column.new("nom") { |col|
			col.heading = "<b>APELLIDOS Y NOMBRES</b>"
			col.heading.justification = :center
			col.justification = :left
		}
		tabla.columns["cod"] = PDF::SimpleTable::Column.new("cod") { |col|
			col.width = 50
			col.heading = "<b>COD PLAN</b>"
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["cal_des"] = PDF::SimpleTable::Column.new("cal_des") { |col|
			col.width = 50
			col.heading = "<b>CALIF. DESCRIP</b>"
			col.heading.justification = :center
			col.justification = :center
		}		
		tabla.columns["cal_num"] = PDF::SimpleTable::Column.new("cal_num") { |col|
			col.width = 50
			col.heading = to_utf16("<b>CALIF. NUMER.</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.columns["cal_letras"] = PDF::SimpleTable::Column.new("cal_letras") { |col|
			col.heading = to_utf16("<b>CALIF. EN LETRAS</b>")
			col.heading.justification = :center
			col.justification = :center
		}
		tabla.column_order = ["n", "ci", "nom", "cod", "cal_des", "cal_num", "cal_letras"]
		data = []

		estudiantes_seccion = seccion.cal_estudiantes_secciones.sort_by{|h| h.cal_estudiante.cal_usuario.apellidos}

		estudiantes_seccion.each_with_index do |es,i|
			e = es.cal_estudiante
			data << {"n" => i+1,
				"ci" => to_utf16(e.cal_usuario_ci),
				"nom" => to_utf16(e.cal_usuario.apellido_nombre),
				"cod" => to_utf16(e.plan),
				"cal_des" => to_utf16(es.tipo_calificacion),
				"cal_num" => to_utf16("#{es.colocar_nota}"),
				"cal_letras" => to_utf16("#{es.calificacion_en_letras}")
		 	}

		end
		if data.count > 0
			tabla.data.replace data
			tabla.render_on(pdf)
		end
		pdf.add_text 150,110,"<b>JURADO EXAMINADOR</b>",9
		pdf.add_text 50,85,"APELLIDOS Y NOMBRES",9
		pdf.add_text 300,85,"FIRMAS",9
		pdf.add_text 50,70,to_utf16("#{seccion.cal_profesor.cal_usuario.apellido_nombre.upcase}"),9

		pdf.add_text 470,110, to_utf16("<b>SECRETARÍA</b>"),9
		pdf.add_text 450,85,"NOMBRE: ________________",9
		pdf.add_text 450,70,"FIRMA:     ________________",9
		pdf.add_text 450,55,"FECHA:    ________________",9

		return pdf
		
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

				tabla.column_order = ["codigo", "asignatura", "creditos", "final", "seccion"]

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
				tabla.columns["creditos"] = PDF::SimpleTable::Column.new("asignatura") { |col|
					col.width = 25
					col.heading = "<b>UC</b>"
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
				tabla.column_order = ["codigo", "asignatura", "creditos", "final", "seccion"]

				secciones_periodo.each do |h|
					aux = h.cal_seccion.cal_materia.descripcion
					nota_final = h.calificacion_final.nil? ?  '--' : h.calificacion_final
					data << {"codigo" => "#{h.cal_seccion.cal_materia.id_upsi}",
						"asignatura" => to_utf16(h.descripcion),
						"creditos" => to_utf16("#{h.cal_seccion.cal_materia.creditos}"),
						"final" => to_utf16("#{nota_final}"),
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

		pdf.text "\n"
		pdf.text "\n"
		pdf.text to_utf16("________________"), font_size: 11, justification: :right
		pdf.text to_utf16("Firma Autorizada"), font_size: 11, justification: :right



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
			estudiantes = seccion.cal_estudiantes_secciones.no_retirados.confirmados.sort_by{|e| e.cal_estudiante.cal_usuario.apellidos}
		else
			estudiantes = seccion.cal_estudiantes_secciones.no_retirados.sort_by{|e| e.cal_estudiante.cal_usuario.apellidos}
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
			@sheet.row(i+3).concat  [usuario.ci, est.nombre_estudiante_con_retiro, usuario.correo_electronico, usuario.telefono_movil]
		end

		file_name = "reporte_seccion.xls"
		return file_name if @book.write file_name
	end


end