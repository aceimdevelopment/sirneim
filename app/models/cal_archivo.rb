# encoding: utf-8
class CalArchivo
	def self.to_utf16(valor)
		ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
		ic_ignore.iconv(valor)
	end

	def self.registro_estudiantil_x_plan # periodo_id # Falta pasar el periodo_id

		# require 'spreadsheet'

		# @book = Spreadsheet::Workbook.new
		# @sheet = @book.create_worksheet :name => "registro_estudiantil_x_plan"

		# @sheet.row(0).concat %w{CEDULA ASIGNATURA DENOMINACION CREDITO NOTA_FINAL NOTA_DEFI TIPO_EXAM PER_LECTI ANO_LECTI SECCION PLAN1}

		# # Plan.all.each do |plan|
		# plan = Plan.first
		# plan.estudiantes.each do |es|
		# 	es.cal_estudiantes_secciones.del_semestre_actual.each do |h| # puede cambiar por el periodo_id
		# 		est = h.cal_estudiante
		# 		sec = h.cal_seccion
		# 		nota_def = h.pi? : 'PI' : h.colocar_nota
		# 		nota_final = h.calificacion_final and h.calificacion_final.to_i < 9 ? 'AP' : h.colocar_nota

		# 		@sheet.row(i+1).concat  [est.cal_usuario_ci, sec.cal_materia.id_upsi, sec.cal_materia.descripcion, sec.creditos, nota_final, nota_def, sec.r_or_f?, 0, sec.cal_semestre.anno, sec.id, plan.id]

		# 	end
		# end

		file_name = "reporte_#{tipo}.xls"
		# return file_name if @book.write file_name

		
		
	end


	def self.hacer_acta_excel(seccion_id)
		require 'spreadsheet'

		@seccion = CalSeccion.find seccion_id
		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "Reporte #{seccion_id}"

		@sheet.column(0).width = 12
		# @sheet.column(1).width = 40
		@sheet.column(2).width = 40
		# @sheet.column(3).width = 15

		data = ['Facultad', 'HUMANIDADES Y EDUCACIÓN']
		@sheet.row(0).concat data
		data = ['Escuela', 'IDIOMAS MODERNOS']
		@sheet.row(1).concat data
		data = ['Plan']
		@sheet.row(2).concat data
		data = ['Materia', @seccion.cal_materia.descripcion]
		@sheet.row(3).concat data
		data = ['Código', @seccion.cal_materia.id_upsi]
		@sheet.row(4).concat data
		data = ['Créditos', @seccion.cal_materia.creditos]
		@sheet.row(5).concat data
		data = ['Sección', @seccion.numero]
		@sheet.row(6).concat data
		data = ['Profesor', "#{@seccion.cal_profesor.cal_usuario.nombre_completo if @seccion.cal_profesor}"]
		@sheet.row(7).concat data
		@sheet.row(8).concat ['CI. Profesor', @seccion.cal_profesor_ci]
		@sheet.row(9).concat ['Semestre', '0']
		@sheet.row(10).concat ['Año', @seccion.cal_semestre.anno]

		data = ['No.', 'Cédula I', 'Nombres y Apellidos', 'Nota_Final', 'Nota_Def', 'Tipo_Ex.']
		@sheet.row(13).concat data

		@seccion.cal_estudiantes_secciones.each_with_index do |es,i|
			e = es.cal_estudiante
			@sheet.row(i+14).concat [i+1, e.cal_usuario_ci, e.cal_usuario.apellido_nombre, es.tipo_calificacion, es.colocar_nota, @seccion.tipo_convocatoria]
		end

		file_name = "reporte_#{@seccion.id}.xls"
		return file_name if @book.write file_name
	end

	def self.hacer_kardex(id)
		# Variable Locales
		estudiante = CalEstudiante.find id
		periodos = CalSemestre.order("id ASC").all
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
		pdf.add_text_wrap 50,645,510,to_utf16("<b>Historia Académica</b>"), 12,:center

		#titulo
		pdf.add_text 50,625,to_utf16("<b>Cédula:</b> #{estudiante.cal_usuario_ci}"),9
		pdf.add_text 50,610,to_utf16("<b>Plan:</b> #{estudiante.ultimo_plan}"),9
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


				tabla.columns["codigo"] = PDF::SimpleTable::Column.new("codigo") { |col|
					col.heading = to_utf16("<b>Código</b>")
					col.heading.justification = :center
					col.justification = :center
				}
				tabla.columns["asignatura"] = PDF::SimpleTable::Column.new("asignatura") { |col|
					col.width = 250
					col.heading = "<b>Nombre Asignatura</b>"
					col.heading.justification = :left
					col.justification = :left
				}
				tabla.columns["convocatoria"] = PDF::SimpleTable::Column.new("convocatoria") { |col|
					col.width = 35
					col.heading = "<b>Conv</b>"
					col.heading.justification = :center
					col.justification = :center
				}
				tabla.columns["creditos"] = PDF::SimpleTable::Column.new("creditos") { |col|
					col.width = 25
					col.heading = "<b>UC</b>"
					col.heading.justification = :center
					col.justification = :center
				}				
				tabla.columns["final"] = PDF::SimpleTable::Column.new("final") { |col|
					col.width = 60
					col.heading = to_utf16("<b>Cal. Num</b>")
					col.heading.justification = :center
					col.justification = :center
				}
				tabla.columns["final_alfa"] = PDF::SimpleTable::Column.new("final_alfa") { |col|
					col.width = 60
					col.heading = to_utf16("<b>Cal. Alf</b>")
					col.heading.justification = :center
					col.justification = :center
				}
				tabla.columns["seccion"] = PDF::SimpleTable::Column.new("seccion") { |col|
					col.heading = to_utf16("<b>Sección</b>")
					col.heading.justification = :center
					col.justification = :center
				}
				data = []
				tabla.column_order = ["codigo", "asignatura", "convocatoria", "creditos", "final", "final_alfa", "seccion"]

				secciones_periodo.each do |h|
					aux = h.cal_seccion.cal_materia.descripcion
					nota_final = h.calificacion_final.nil? ?  '--' : h.calificacion_final
					data << {"codigo" => "#{h.cal_seccion.cal_materia.id_upsi}",
						"asignatura" => to_utf16(h.descripcion),
						"convocatoria" => to_utf16("#{h.cal_seccion.tipo_convocatoria}"),
						"creditos" => to_utf16("#{h.cal_seccion.cal_materia.creditos}"),
						"final" => to_utf16("#{nota_final}"),
						"final_alfa" => to_utf16("#{h.tipo_calificacion}"),
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


	def self.hacer_acta(seccion_id)
		por_pagina = 35
		pdf = PDF::Writer.new
		seccion = CalSeccion.find seccion_id
		estudiantes_seccion = seccion.cal_estudiantes_secciones.sort_by{|h| h.cal_estudiante.cal_usuario.apellidos}
		pdf.start_page_numbering(400, 665, 9, nil, to_utf16("PÁGINA: <b><PAGENUM>/<TOTALPAGENUM></b>"), 1)
		(estudiantes_seccion.each_slice por_pagina).to_a.each_with_index do |ests_sec, j| 
			pdf.start_new_page true if j > 0
			pagina_acta_examen_pdf pdf, ests_sec, j*por_pagina
		end

		return pdf

	end


	private 

	def self.pagina_acta_examen_pdf pdf, estudiantes_seccion, j

		seccion = estudiantes_seccion.first.cal_seccion

		encabezado_acta_pdf pdf, seccion, j

		pdf.text "\n"

		tabla = PDF::SimpleTable.new
		encabezado_tabla_pdf tabla


		data = []

		estudiantes_seccion.each_with_index do |es,i|
			e = es.cal_estudiante
			# plan += e.planes.collect{|c| c.id}.join(" | ") if e.planes
			plan = "#{e.ultimo_plan}"
			data << {"n" => j+i+1,
				"ci" => to_utf16(e.cal_usuario_ci),
				"nom" => to_utf16(e.cal_usuario.apellido_nombre),
				"cod" => to_utf16(plan),
				"cal_des" => to_utf16(es.tipo_calificacion),
				"cal_num" => to_utf16("#{es.colocar_nota}"),
				"cal_letras" => to_utf16("#{es.calificacion_en_letras}")
		 	}

		end

		if data.count > 0
			tabla.data.replace data
			tabla.render_on(pdf)
		end

		pie_acta_pdf pdf, seccion

	end

	def self.encabezado_tabla_pdf tabla
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
		
	end

	def self.encabezado_acta_pdf pdf, seccion, j

		pdf.margins_cm(1.8)

		# Logos
		pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 730, 40,nil

		#texto del encabezado
		pdf.add_text_wrap 50,710,510,to_utf16("UNIVERSIDAD CENTRAL DE VENEZUELA"), 12,:center
		pdf.add_text_wrap 50,695,510,to_utf16("PLANILLA DE EXÁMENES"), 12,:center
		pdf.add_text_wrap 50,680,510,to_utf16("TIPO DE EXAMEN: FINAL ANUAL (SEPTIEMBRE)"), 12,:center

		#titulo

		pdf.add_text 50,665,to_utf16("FECHA DE LA EMISIÓN: <b>#{Time.now.strftime('%d/%m/%Y %I:%M %p')}</b>"),9
		pdf.add_text 50,650,to_utf16("EJERCICIO: <b>#{seccion.ejercicio}</b>"),9
		pdf.add_text 50,635,to_utf16("FACULTAD: <b>HUMANIDADES Y EDUCACIÓN</b>"),9
		pdf.add_text 50,620,to_utf16("ESCUELA: <b>IDIOMAS</b>"),9

		pdf.add_text 400,650,to_utf16("ACTA N°: <b>#{seccion.acta_no.upcase}</b>"),9
		pdf.add_text 400,635,to_utf16("PERIODO ACADÉMICO: <b>#{seccion.cal_semestre.anno}</b>"),9
		pdf.add_text 400,620,to_utf16("TIPO CONVOCATORIA: <b>#{seccion.tipo_convocatoria}</b>"),9

		pdf.text "\n"*11
		pdf.text "\n"*3 if j > 0

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
			"duracion" => "0"
	 	}

		tabla.data.replace data
		tabla.render_on(pdf)

	end

	def self.pie_acta_pdf pdf, seccion

		pdf.add_text 150,90,"<b>JURADO EXAMINADOR</b>",9
		pdf.add_text 50,75,"APELLIDOS Y NOMBRES",9
		pdf.add_text 300,75,"FIRMAS",9
		pdf.add_text 250,60,"___________________________",9
		pdf.add_text 250,45,"___________________________",9
		pdf.add_text 250,30,"___________________________",9
		pdf.add_text 50,60,to_utf16("#{seccion.cal_profesor.cal_usuario.apellido_nombre.upcase if seccion.cal_profesor }"),9
		pdf.add_text 50,45,"_______________________________",9
		pdf.add_text 50,30,"_______________________________",9

		pdf.add_text 470,90, to_utf16("<b>SECRETARÍA</b>"),9
		pdf.add_text 410,60,"NOMBRE: _______________________",9
		pdf.add_text 410,45,"FIRMA:     _______________________",9
		pdf.add_text 410,30,"FECHA:    _______________________",9

	end
end