class DocumentosPDF

  def self.to_utf16(valor)
    ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    ic_ignore.iconv(valor)
  end

  def self.hola_mundo
    pdf = PDF::Writer.new
    pdf.text to_utf16 "ðåßáåáßäåéëþþüúíœïgßðf© Hólá Mundo"
    return pdf
  end

  def self.generar_planilla(cedula)
    usuario = Usuario.find cedula
    datos = DatosEstudiante.where(:estudiante_ci => cedula).first
    pdf = PDF::Writer.new
    pdf.margins_cm(1.8)
    
    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 465, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710+10, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 45, 710, 50,nil
 
    pdf.add_text 100,745,to_utf16("Universidad Central de Venezuela"),11
    pdf.add_text 100,735,to_utf16("Facultad de Humanidades y Educación"),11
    pdf.add_text 100,725,to_utf16("Escuela de Idiomas Modernos"),11
    pdf.add_text 100,715,to_utf16("Diplomados"),11

    pdf.text "\n\n\n\n"
    pdf.text to_utf16("Planilla Preinscripción"), :justification => :center, :font_size => 20

    pdf.text to_utf16("\nDatos personales"), :justification => :left, :font_size => 16
    pdf.text to_utf16("<b>Cédula de identidad: </b> #{usuario.ci}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Nombres: </b> #{usuario.nombres}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Apellidos: </b> #{usuario.apellidos}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Lugar de nacimiento: </b> #{usuario.lugar_nacimiento}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Fecha de nacimiento: </b> #{usuario.fecha_nacimiento.strftime('%d/%m/%Y')}"), :justification => :left, :font_size => 12

    bDate = usuario.fecha_nacimiento
    age = Date.today.year - bDate.year
    if Date.today.month < bDate.month ||
      (Date.today.month == bDate.month && bDate.day >= Date.today.day)
      age = age - 1
    end
    edad = age.to_s
    pdf.text to_utf16("<b>Edad: </b> #{edad} años"), :justification => :left, :font_size => 12

    sexo = (usuario.tipo_sexo_id == "M")? "Masculino" : "Femenino" 
    pdf.text to_utf16("<b>Sexo: </b> #{sexo}"), :justification => :left, :font_size => 12

    pdf.text to_utf16("\nDatos de contacto"), :justification => :left, :font_size => 16
    pdf.text to_utf16("<b>Teléfono habitación: </b> #{usuario.telefono_habitacion}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Teléfono celular: </b> #{usuario.telefono_movil}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Correo electrónico: </b> #{usuario.correo}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Correo electrónico (alternativo): </b> #{usuario.correo_alternativo}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Cuenta twitter: </b> #{usuario.estudiante.cuenta_twitter}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Dirección de domicilio: </b> #{usuario.direccion}"), :justification => :left, :font_size => 12

    pdf.text to_utf16("\nDatos laborales"), :justification => :left, :font_size => 16

    trabaja = (datos.trabaja == 1 ? "Si" : "No")
    pdf.text to_utf16("<b>Trabaja: </b> #{trabaja}"), :justification => :left, :font_size => 12
    if trabaja == "Si"
      pdf.text to_utf16("<b>Ocupación: </b> #{datos.ocupacion}"), :justification => :left, :font_size => 12
      pdf.text to_utf16("<b>Institución: </b> #{datos.institucion}"), :justification => :left, :font_size => 12
      pdf.text to_utf16("<b>Cargo actual: </b> #{datos.cargo_actual}"), :justification => :left, :font_size => 12
      pdf.text to_utf16("<b>Antigüedad: </b> #{datos.antiguedad}"), :justification => :left, :font_size => 12
      pdf.text to_utf16("<b>Dirección de trabajo: </b> #{datos.direccion_de_trabajo}"), :justification => :left, :font_size => 12
    end

    pdf.text to_utf16("\nEstudios realizados"), :justification => :left, :font_size => 16
    pdf.text to_utf16("<b>Título de estudio: </b> #{datos.titulo_estudio}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Institución de estudio: </b> #{datos.institucion_estudio}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Año de graduación: </b> #{datos.ano_graduacion_estudio}"), :justification => :left, :font_size => 12

    pdf.text to_utf16("\nEstudios concluidos"), :justification => :left, :font_size => 16
    pdf.text to_utf16("<b>Título de estudio: </b> #{datos.titulo_estudio_concluido}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Institución de estudio: </b> #{datos.institucion_estudio_concluido}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Año de graduación: </b> #{datos.ano_estudio_concluido}"), :justification => :left, :font_size => 12

    pdf.text to_utf16("\nEstudios en curso"), :justification => :left, :font_size => 16
    pdf.text to_utf16("<b>Título de estudio: </b> #{datos.titulo_estudio_en_curso}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Institución de estudio: </b> #{datos.institucion_estudio_en_curso}"), :justification => :left, :font_size => 12
    fecha_inicio = (datos.fecha_inicio_estudio_en_curso)? datos.fecha_inicio_estudio_en_curso.strftime('%d/%m/%Y') : ""
    pdf.text to_utf16("<b>Fecha de inicio: </b> #{fecha_inicio}"), :justification => :left, :font_size => 12

    pdf.text to_utf16("\nExperiencia en la enseñanza de idiomas"), :justification => :left, :font_size => 16
    experiencia = (datos.tiene_experiencia_ensenanza_idiomas == 1 ? "Si" : "No")
    pdf.text to_utf16("<b>¿Ha tenido experiencia en la enseñanza de idiomas?: </b> #{experiencia}"), :justification => :left, :font_size => 12
    if experiencia == "Si"
      pdf.text to_utf16("<b>Descripción de la experiencia: </b> #{datos.descripcion_experiencia}"), :justification => :left, :font_size => 12
    end
    espanol = (datos.ha_dado_clases_espanol == 1 ? "Si" : "No")
    pdf.text to_utf16("<b>¿Ha dado clases de español?: </b> #{espanol}"), :justification => :left, :font_size => 12
    if espanol == "Si"
      pdf.text to_utf16("<b>¿Dónde?: </b> #{datos.donde_clases_espanol}"), :justification => :left, :font_size => 12
      pdf.text to_utf16("<b>¿Por cuánto tiempo?: </b> #{datos.tiempo_clases_espanol}"), :justification => :left, :font_size => 12
    end

    pdf.text to_utf16("\nIntereses"), :justification => :left, :font_size => 16
    pdf.text to_utf16("<b>¿Por qué le interesa cursar el diplomado?: </b> #{datos.por_que_interesa_diplomado}"), :justification => :left, :font_size => 12
    pdf.text to_utf16("<b>Expectativas sobre el diplomado: </b> #{datos.expectativas_sobre_diplomado}"), :justification => :left, :font_size => 12

    return pdf
  end


  def self.notas(historiales,session)
    usuario = session[:usuario]
    pdf = PDF::Writer.new
    pdf.margins_cm(1.8)
    #color de relleno para el pdf (color de las letras)
#    pdf.fill_color(Color::RGB.new(255,255,255))
    #imagen del encabezado
 #   pdf.add_image_from_file 'app/assets/images/banner.jpg', 50, 685, 510, 60
    
    
    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 465, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710+10, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 45, 710, 50,nil
 
    
    #texto del encabezado
    pdf.add_text 100,745,to_utf16("Universidad Central de Venezuela"),11
    pdf.add_text 100,735,to_utf16("Facultad de Humanidades y Educación"),11
    pdf.add_text 100,725,to_utf16("Escuela de Idiomas Modernos"),11
    pdf.add_text 100,715,to_utf16("Cursos de Extensión EIM-UCV"),11

    #texto del encabezado
#    pdf.add_text 70,722,to_utf16("Universidad Central de Venezuela"),7
#    pdf.add_text 70,714,to_utf16("Facultad de Humanidades y Educación"),7
#    pdf.add_text 70,706,to_utf16("Escuela de Idiomas Modernos"),7
#    pdf.add_text 70,698,to_utf16("Administrador de Cursos de Extensión de Idiomas Modernos"),7

    #titulo
    pdf.fill_color(Color::RGB.new(0,0,0))
    historial = historiales.first
    #periodo_calificacion
    
    pdf.add_text_wrap 50,650,510,to_utf16("#{Seccion.idioma(historial.idioma_id)} (#{Seccion.tipo_categoria(historial.tipo_categoria_id)} - Sección #{historial.seccion_numero})"), 12,:center
    pdf.add_text_wrap 50,635,510,to_utf16(Seccion.horario(session)),10,:center
    pdf.add_text_wrap 50,621,510,to_utf16("Periodo #{ParametroGeneral.periodo_calificacion.id}"),9.5,:center

    #instructor
    pdf.add_text_wrap 50,600,510,to_utf16(usuario.nombre_completo),10
    pdf.add_text_wrap 50,585,505,to_utf16(usuario.ci),10

    pdf.add_text_wrap 50,555,510,to_utf16("<b>Tabla de Calificaciones<b>"),10

    historiales = historiales.sort_by{|h| h.usuario.nombre_completo}
    #  historiales.each { |h|
    #    pdf.text to_utf16 "#{h.usuario.nombre_completo} - #{h.nota_final}"
    #  }
    pdf.text "\n"*18
    tabla = PDF::SimpleTable.new
    tabla.heading_font_size = 8
    tabla.font_size = 8
    tabla.show_lines    = :all
    tabla.line_color = Color::RGB::Gray
    tabla.show_headings = true
    tabla.shade_headings = true
    tabla.shade_heading_color = Color::RGB.new(230,238,238)
    tabla.shade_color = Color::RGB.new(230,238,238)
    tabla.shade_color2 = Color::RGB::White
    tabla.shade_rows = :striped
    tabla.orientation   = :center
    tabla.position      = :center
    if !historiales.first.tiene_notas_adicionales?
      tabla.column_order = ["#", "nombre", "cedula", "nota", "descripcion"]
    else
      tabla.column_order = ["#", "nombre", "cedula", "nota1","nota2","nota3","nota4","nota5", "descripcion"]
    end

    tabla.columns["#"] = PDF::SimpleTable::Column.new("#") { |col|
      col.width = 30
      col.heading = to_utf16("<b>#</b>")
      col.heading.justification = :center
      col.justification = :center
    }
    tabla.columns["cedula"] = PDF::SimpleTable::Column.new("cedula") { |col|
      col.width = 60
      col.heading = to_utf16("<b>Cédula</b>")
      col.heading.justification = :center
      col.justification = :center
    }
    tabla.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      if !historiales.first.tiene_notas_adicionales?
        col.width = 190
      else
        col.width = 140  
      end
      col.heading = "<b>Nombre</b>"
      col.heading.justification = :left
      col.justification = :left
    }
    if !historiales.first.tiene_notas_adicionales?
      tabla.columns["nota"] = PDF::SimpleTable::Column.new("nota") { |col|
        col.width = 80
        col.heading = to_utf16("<b>Nota</b>")
        col.heading.justification = :center
        col.justification = :center
      }
    else
      tabla.columns["nota1"] = PDF::SimpleTable::Column.new("nota1") { |col|
        col.width = 50
        col.heading = to_utf16("<b>Exámen Teórico 1</b>")
        col.heading.justification = :center
        col.justification = :center
      }
      tabla.columns["nota2"] = PDF::SimpleTable::Column.new("nota2") { |col|
        col.width = 50
        col.heading = to_utf16("<b>Exámen Teórico 2</b>")
        col.heading.justification = :center
        col.justification = :center
      }
      tabla.columns["nota3"] = PDF::SimpleTable::Column.new("nota3") { |col|
        col.width = 50
        col.heading = to_utf16("<b>Exámen Oral</b>")
        col.heading.justification = :center
        col.justification = :center
      }
      tabla.columns["nota4"] = PDF::SimpleTable::Column.new("nota4") { |col|
        col.width = 40
        col.heading = to_utf16("<b>Otras</b>")
        col.heading.justification = :center
        col.justification = :center
      }
      tabla.columns["nota5"] = PDF::SimpleTable::Column.new("nota5") { |col|
        col.width = 60
        col.heading = to_utf16("<b>Nota</b>")
        col.heading.justification = :center
        col.justification = :center
      }
    end
    tabla.columns["descripcion"] = PDF::SimpleTable::Column.new("descripcion") { |col|
      if !historiales.first.tiene_notas_adicionales?
        col.width = 100
      else
        col.width = 60
      end
      col.heading = to_utf16("<b>Descripción</b>")
      col.heading.justification = :left
      col.justification = :left
    }

    data = []

    historiales.each_with_index{|h,i|
      if !historiales.first.tiene_notas_adicionales?
        data << {"#" => "#{i+1}",
          "cedula" => to_utf16(h.usuario.ci),
          "nombre" => to_utf16(h.usuario.nombre_completo),
          "nota" => to_utf16(HistorialAcademico.colocar_nota(h.nota_final)),
          "descripcion" => to_utf16(HistorialAcademico::NOTASPALABRAS[h.nota_final + 2])
        }
      else
        nota1 = nil
        nota2 = nil
        nota3 = nil
        nota4 = nil
        if h.nota_en_evaluacion(HistorialAcademico::EXAMENESCRITO1).nota == -1
          nota1 = "PI" 
        else
          nota1 = h.nota_en_evaluacion(HistorialAcademico::EXAMENESCRITO1).nota.to_s
        end
        if h.nota_en_evaluacion(HistorialAcademico::EXAMENESCRITO2).nota == -1
          nota2 = "PI" 
        else
          nota2 = h.nota_en_evaluacion(HistorialAcademico::EXAMENESCRITO2).nota.to_s
        end
        if h.nota_en_evaluacion(HistorialAcademico::EXAMENORAL).nota == -1
          nota3 = "PI" 
        else
          nota3 = h.nota_en_evaluacion(HistorialAcademico::EXAMENORAL).nota.to_s
        end
        if h.nota_en_evaluacion(HistorialAcademico::OTRAS).nota == -1
          nota4 = "PI" 
        else
          nota4 = h.nota_en_evaluacion(HistorialAcademico::OTRAS).nota.to_s
        end
        data << {"#" => "#{i+1}",
          "cedula" => to_utf16(h.usuario.ci),
          "nombre" => to_utf16(h.usuario.nombre_completo),
          "nota1" => to_utf16(nota1),
          "nota2" => to_utf16(nota2),
          "nota3" => to_utf16(nota3),
          "nota4" => to_utf16(nota4),
          "nota5" => to_utf16(HistorialAcademico.colocar_nota(h.nota_final)),
          "descripcion" => to_utf16(HistorialAcademico::NOTASPALABRAS[h.nota_final + 2])
        }
      end
    }
    tabla.data.replace data
    tabla.render_on(pdf)
    pdf.add_text 430,50,to_utf16("#{Time.now.strftime('%d/%m/%Y %I:%M%p')} - Página: 1 de 1")
    return pdf
  end

  def self.planilla_inscripcion_pagina(historial_academico,pdf)
    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 465, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710+10, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 45, 710, 50,nil
    pdf.add_image_from_file Rutinas.crear_codigo_barra(historial_academico.usuario_ci), 450-10, 500+35, nil, 120
    pdf.add_text 480-10,500+35,to_utf16("---- #{historial_academico.usuario_ci} ----"),11
    
    #texto del encabezado
    pdf.add_text 100,745,to_utf16("Universidad Central de Venezuela"),11
    pdf.add_text 100,735,to_utf16("Facultad de Humanidades y Educación"),11
    pdf.add_text 100,725,to_utf16("Escuela de Idiomas Modernos"),11
    pdf.add_text 100,715,to_utf16("Cursos de Extensión EIM-UCV"),11 
    

    #titulo    
    pdf.text "\n\n\n\n\n"
    pdf.text to_utf16("Planilla de Inscripción (Sede Ciudad Universitaria)\n"), :font_size => 14, :justification => :center
    pdf.text to_utf16("Periodo #{historial_academico.periodo_id}"), :justification => :center

    # ------- DATOS DE LA PREINSCRIPCIO -------
    pdf.text "\n", :font_size => 10
    pdf.text to_utf16("<b>Datos de la Preinscripción:</b>"), :font_size => 12
    tabla = PDF::SimpleTable.new 
    tabla.font_size = 12
    tabla.show_lines    = :none
    tabla.show_headings = false 
    tabla.shade_rows = :none
    tabla.column_order = ["nombre", "valor"]

    tabla.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 100
      col.justification = :left
    }
    tabla.columns["valor"] = PDF::SimpleTable::Column.new("valor") { |col|
      col.width = 400
      col.justification = :left
    }
    datos = []
    
    datos << { "nombre" => to_utf16("<b>Estudiante:</b>"), "valor" => to_utf16("#{historial_academico.usuario.descripcion}\n#{historial_academico.usuario.datos_contacto}") }
    datos << { "nombre" => to_utf16("<b>Curso:</b>"), "valor" => to_utf16("#{historial_academico.tipo_curso.descripcion}") }
    datos << { "nombre" => to_utf16("<b>Nivel:</b>"), "valor" => to_utf16("#{historial_academico.tipo_nivel.descripcion}") }
    datos << { "nombre" => to_utf16("<b>Horario:</b>"), "valor" => to_utf16("#{historial_academico.seccion.horario}") }
    datos << { "nombre" => to_utf16("<b>Sección:</b>"), "valor" => to_utf16("#{historial_academico.seccion_numero}") }
    datos << { "nombre" => to_utf16("<b>Aula:</b>"), "valor" => to_utf16("#{historial_academico.seccion.aula}") }
    if historial_academico.tipo_convenio_id != "REG"
      datos << { "nombre" => to_utf16("<b>Convenio:</b>"), "valor" => to_utf16("#{historial_academico.tipo_convenio.descripcion}") }
    end
    tabla.data.replace datos
    tabla.render_on(pdf)
    

    # -------- TABLA CUENTA -------
    pdf.text "\n", :font_size => 10
    pdf.text to_utf16("<b>Datos de Pago:</b>"), :font_size => 12
    pdf.text "\n", :font_size => 8
    tabla = PDF::SimpleTable.new 
    tabla.font_size = 12
    tabla.show_lines    = :none
    tabla.show_headings = false 
    tabla.shade_rows = :none
    tabla.column_order = ["nombre", "valor"]

    tabla.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 110
      col.justification = :left
    }
    tabla.columns["valor"] = PDF::SimpleTable::Column.new("valor") { |col|
      col.width = 400
      col.justification = :left
    }
    datos = []
    
    datos << { "nombre" => to_utf16("<b>Banco:</b>"), "valor" => to_utf16("Banco de Venezuela") }
    datos << { "nombre" => to_utf16("<b>Nro. de Cuenta:</b>"), "valor" => to_utf16("Cuenta Corriente #{historial_academico.cuenta_numero}") }
    datos << { "nombre" => to_utf16("<b>A nombre de:</b>"), "valor" => to_utf16("#{historial_academico.cuenta_nombre}") }
    datos << { "nombre" => to_utf16("<b>Monto:</b>"), "valor" => to_utf16("#{historial_academico.cuenta_monto} BsF.") }
    datos << { "nombre" => to_utf16("<b>Nro Depósito:</b>"), "valor" => to_utf16("______________________________") }
    tabla.data.replace datos  
    tabla.render_on(pdf)
    pdf.text "\n", :font_size => 10
    
    # ---- NORMAS -----
    pdf.text to_utf16("<b>LEA CUIDADOSAMENTE LA SIGUIENTE INFORMACIÓN Y NORMATIVA DEL PROGRAMA</b>"), :font_size => 12
    pdf.text "\n", :font_size => 10
    pdf.text to_utf16("<C:bullet/>La inscripción es válida UNICAMENTE para el período indicado en esta planilla. NO SE CONGELAN CUPOS POR NINGÚN MOTIVO."), :font_size => 11, :justification => :full
    pdf.text to_utf16("<C:bullet/>SOLO SE REINTEGRARÁ EL MONTO DE LA MATRÍCULA EN CASO DE QUE NO SE REUNA EL QUORUM NECESARIO PARA LA APERTURA DEL CURSO."), :font_size => 11, :justification => :full
    pdf.text to_utf16("<C:bullet/>La asistencia a clases es obligatoria: Cursos <b>LUN-MIE</b>: Límite de 3 inasistencias. Cursos <b>MAR-JUE</b>: Límite de 3 inasistencias. Cursos <b>SÁBADOS</b>: Límite de 2 inasistencias."), :font_size => 11, :justification => :full
    pdf.text to_utf16("<C:bullet/>La nota mínima aprobatoria es de 15 puntos. El cupo mínimo es de 15 participantes."), :font_size => 11, :justification => :full
    pdf.text to_utf16("<C:bullet/>NO SE PERMITEN CAMBIOS DE SECCIÓN."), :font_size => 11, :justification => :full
    pdf.text to_utf16("<C:bullet/>El horario, sección y aula se reserva hasta la fecha indicada."), :font_size => 11, :justification => :full
    pdf.text to_utf16("<C:bullet/>Únicamente DEPOSITOS en EFECTIVO (NO CHEQUES)."), :font_size => 11, :justification => :full
    
    # -- FIRMAS -----
    pdf.text "\n", :font_size => 8
    pdf.text "\n", :font_size => 8
    pdf.text "\n", :font_size => 8
    pdf.text "\n", :font_size => 8
    tabla = PDF::SimpleTable.new 
    tabla.font_size = 12 
    tabla.orientation   = :center
    tabla.position      = :center
    tabla.show_lines    = :none
    tabla.show_headings = false 
    tabla.shade_rows = :none
    tabla.column_order = ["nombre", "valor"]

    tabla.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 250
      col.justification = :center
    }
    tabla.columns["valor"] = PDF::SimpleTable::Column.new("valor") { |col|
      col.width = 250
      col.justification = :center
    }
    datos = []
    datos << { "nombre" => to_utf16("<b>__________________________</b>"), "valor" => to_utf16("<b>__________________________</b>") }
    datos << { "nombre" => to_utf16("Firma Estudiante"), "valor" => to_utf16("Firma Autorizada y Sello") }
    tabla.data.replace datos  
    tabla.render_on(pdf)
    pdf.text "\n", :font_size => 8
    pdf.text "\n", :font_size => 8
  end

  def self.planilla_inscripcion(historial_academico=nil)
    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape, 
    t = Time.now

    planilla_inscripcion_pagina(historial_academico,pdf)
    pdf.text to_utf16("----- COPIA DEL ESTUDIANTE -----"), :font_size => 12, :justification => :center
    pdf.text "\n", :font_size => 8
    pdf.text to_utf16("#{t.strftime('%d/%m/%Y %I:%M%p')} - Página: 1 de 2"), :font_size => 10, :justification => :right
    
    pdf.new_page
    pdf.y = 756
    planilla_inscripcion_pagina(historial_academico,pdf)
    pdf.text to_utf16("----- COPIA ADMINISTRACIÓN -----"), :font_size => 12, :justification => :center
    pdf.text "\n", :font_size => 8
    pdf.text to_utf16("#{t.strftime('%d/%m/%Y %I:%M%p')} - Página: 2 de 2"), :font_size => 10, :justification => :right
   
    return pdf
  end
  
  def self.generar_listado_estudiantes(periodo,idioma,nivel,\
  categoria,seccion_numero,guardar=false)

    
    historial = HistorialAcademico.where(:periodo_id=>periodo, :idioma_id=>idioma, :tipo_nivel_id=>nivel, :tipo_categoria_id=>categoria, :seccion_numero=>seccion_numero, :tipo_estado_inscripcion_id=>"INS")
    historial = historial.sort_by{|x| x.usuario.nombre_completo}
    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape, 
    
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss

    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 710, 50,nil
    pdf.line 35,700,575,700
    
    if historial.size > 0
      @seccion = historial.last.seccion
      pdf.text "\n\n\n\n\n"
      pdf.text to_utf16("<b>Período:</b> #{historial.last.periodo_id}"), :justification => :center
      pdf.text to_utf16("<b>Curso:</b> #{Seccion.idioma(@seccion.idioma)} #{Seccion.tipo_categoria(@seccion.tipo_categoria)} #{@seccion.tipo_nivel.descripcion} - #{"%002i"%@seccion.seccion_numero}"), :justification => :center        
      pdf.text to_utf16("<b>Aula:</b> #{@seccion.aula}"), :justification => :center
      pdf.text to_utf16("<b>Horario:</b> #{@seccion.horario}"), :justification => :center
      if @seccion.instructor
        pdf.text to_utf16("<b>Profesor:</b> #{@seccion.instructor.nombre_completo}"), :justification => :center
      else                                                                                                   
        pdf.text to_utf16("<b>Profesor:</b> NO ASIGNADO"), :justification => :center
      end
      pdf.text "\n\n"
      
      pdf.line 35,630,575,630
      
      
      
      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :inner
      tab.show_headings = true
      tab.shade_rows = :none
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 8
      tab.row_gap = 3
      tab.minimum_space = 0
      tab.column_order = ["nro","nombre","cedula", "correo","telefono"]
      tab.columns["nro"] = PDF::SimpleTable::Column.new("nro") { |col|
        col.width = 25
        col.justification = :right
        col.heading = "#"
        col.heading.justification= :center
      }
      tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
        col.width = 180
        col.justification = :left
        col.heading = "NOMBRE COMPLETO"
        col.heading.justification= :center
      }
      tab.columns["cedula"] = PDF::SimpleTable::Column.new("cedula") { |col|
        col.width = 50
        col.justification = :center
        col.heading = to_utf16 "CÉDULA"
        col.heading.justification= :center
      }
      tab.columns["correo"] = PDF::SimpleTable::Column.new("correo") { |col|
        col.width = 180
        col.justification = :left
        col.heading = "CORREO"
        col.heading.justification= :center
      }
      tab.columns["telefono"] = PDF::SimpleTable::Column.new("telefono") { |col|
        col.width = 80
        col.justification = :left
        col.heading = "TELEFONO"
        col.heading.justification= :center
      }

      data = []

      historial.each_with_index{|reg,ind|
        data << {
          "nro" => "#{(ind+1)}",          
          "nombre" => to_utf16(reg.usuario.nombre_completo),
          "cedula" => reg.usuario_ci,
          "correo" => reg.usuario.correo,
          "telefono" => reg.usuario.telefono_movil
        }
      }


      t = Time.new
      pdf.start_page_numbering(250, 15, 7, nil, to_utf16("#{t.day} / #{t.month} / #{t.year}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)

      tab.data.replace data
      
      pdf.line 35,25,575,25
      
      tab.render_on(pdf)

      pdf.save_as "#{historial.last.seccion.id.to_s.gsub(",","_")}.pdf" if guardar
    end
    pdf

  end

  def self.generar_listado_secciones(periodo,guardar=false,filtro=nil,filtro2=nil, filtro3=nil, filtro4 = nil)
    secciones = nil
    secciones = Seccion.where(:periodo_id => periodo)
    if filtro
      idioma_id , tipo_categoria_id = filtro.split ","
      
      secciones = Seccion.where(:periodo_id => periodo, :idioma_id => idioma_id,
        :tipo_categoria_id => tipo_categoria_id)
    end
    if filtro2
      secciones2 = []
      secciones.each{|s|
        aula = s.horario_seccion.first.aula
        secciones2 << s if aula && aula.tipo_ubicacion_id == filtro2
      }                
      secciones = secciones2
    end
    
    if filtro3
      secciones = Seccion.where(:periodo_id=>periodo).delete_if{|s| !s.mach_horario?(filtro3)}
    end          
                                     
    if filtro4
      ids = filtro4.split("_").compact 
      secciones = []
      ids.each{|iden|
        periodo_id, idioma_id, tipo_categoria_id, tipo_nivel_id, seccion_numero = iden.split(",")
        secciones << Seccion.where(
          :periodo_id => periodo_id,
          :idioma_id => idioma_id,
          :tipo_categoria_id => tipo_categoria_id,
          :tipo_nivel_id => tipo_nivel_id,
          :seccion_numero => seccion_numero
        ).limit(1).first
      }
    end
    
    
    secciones = secciones.sort_by{|x| "#{x.tipo_curso.id}-#{'%03i'%x.curso.grado}-#{x.horario}-#{x.seccion_numero}"}
    pdf = PDF::Writer.new(:paper => "letter",:orientation => :landscape)

    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 65, 550, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 665, 550, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 365, 550, 50,nil
    
    pdf.line 55,545,720,545
    
    pdf.text "\n\n\n"
    pdf.text "SECCIONES #{periodo}\n",:justification => :center
    pdf.text "\n\n"
    
    pdf.line 55,515,720,515
    
    tab = PDF::SimpleTable.new
    tab.bold_headings = true
    tab.show_lines    = :all
    tab.show_headings = true
    tab.shade_rows = :none
    tab.orientation   = :center
    tab.heading_font_size = 8
    tab.font_size = 8
    tab.row_gap = 2
    tab.minimum_space = 0

    tab.column_order = ["PRE", "INS","idioma","nivel","seccion","horario","aula","instructor"]
    tab.columns["preinscritos"] = PDF::SimpleTable::Column.new("preinscritos") { |col|
      col.width = 30
      col.justification = :center
      col.heading = to_utf16 "PRE"
      col.heading.justification= :center
    }
    tab.columns["inscritos"] = PDF::SimpleTable::Column.new("inscritos") { |col|
      col.width = 30
      col.justification = :center
      col.heading = "INS"
      col.heading.justification= :center
    }
    tab.columns["idioma"] = PDF::SimpleTable::Column.new("idioma") { |col|
      col.width = 80
      col.justification = :left
      col.heading = "IDIOMA"
      col.heading.justification= :center
    }
    tab.columns["nivel"] = PDF::SimpleTable::Column.new("nivel") { |col|
      col.width = 80
      col.justification = :left
      col.heading = "NIVEL"
      col.heading.justification= :center
    }
    tab.columns["seccion"] = PDF::SimpleTable::Column.new("seccion") { |col|
      col.width = 30
      col.justification = :left
      col.heading = "SEC"
      col.heading.justification= :center
    }
    tab.columns["horario"] = PDF::SimpleTable::Column.new("horario") { |col|
      col.width = 140
      col.justification = :left
      col.heading = "HORARIO"
      col.heading.justification= :center
    }
    tab.columns["aula"] = PDF::SimpleTable::Column.new("aula") { |col|
      col.width = 100
      col.justification = :left
      col.heading = "AULA"
      col.heading.justification= :center
    }
    tab.columns["instructor"] = PDF::SimpleTable::Column.new("instructor") { |col|
      col.width = 140
      col.justification = :left
      col.heading = "INSTRUCTOR"
      col.heading.justification= :center
    }

    if secciones.size > 0
      data = []
      
      tab.column_order = ["preinscritos", "inscritos","idioma","nivel","seccion","horario","aula","instructor"]

      secciones.each{|sec|
        instructor = (sec.instructor) ? to_utf16("#{sec.instructor.descripcion}") : "-- NO ASIGNADO --"
        data << {
          "preinscritos" => to_utf16("#{sec.preinscritos}"),
          "inscritos" => to_utf16("#{sec.inscritos}"),  
          "idioma" => to_utf16("#{sec.idioma.descripcion} (#{sec.tipo_categoria.descripcion})"), 
          "nivel" => to_utf16("#{sec.tipo_nivel.descripcion}"), 
          "seccion" => to_utf16("#{sec.seccion_numero}"), 
          "horario" => to_utf16("#{sec.horario}"), 
          "aula" => to_utf16("#{sec.aula_corta}"),       
          "instructor" => instructor
        }
        
      }
      pdf.start_page_numbering(665, 30, 7, nil, to_utf16("Página: <PAGENUM> de <TOTALPAGENUM>"), 1)
      tab.data.replace data
      tab.render_on(pdf)  
      pdf.text "\n"
      
      
      
      
      pdf.text Time.now.strftime("%d/%m/%Y %I:%M %p"),:justification => :center
            
      
      


      pdf.save_as "secciones.pdf" if guardar
      pdf
    end


  end

  def self.imprimir_secciones
    periodo = ParametroGeneral.periodo_actual
    secciones = Seccion.where(:periodo_id=> periodo)
    
    secciones.each do  |seccion|
       generar_listado_estudiantes(seccion.periodo_id,\
       seccion.idioma_id,seccion.tipo_nivel_id,\
       seccion.tipo_categoria_id,seccion.seccion_numero,true)
    end
  end
 
  def self.generar_constancia_notas(ci,idioma,categoria,guardar=false)

    #historial = HistorialAcademico.all(
    #:conditions => ["usuario_ci = ?",ci])
    historial = HistorialAcademico.where(:usuario_ci=>ci,:idioma_id=>idioma,:tipo_categoria_id=>categoria)
    historial = historial.sort_by{|x| x.curso.grado}

    #pdf.add_image_from_file 'public/images/logo_pi_color1.jpg', 55, 660, 490,nil

    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape, 
    
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss

    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg',45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 280, 710, 50,nil
    pdf.text "\n\n\n\n"
    pdf.margins_mm(30)
    pdf.text "UNIVERSIDAD CENTRAL DE VENEZUELA", :font_size => 6,:justification => :center
    pdf.text to_utf16("FACULTAD DE HUMANIDADES Y EDUCACIÓN"), :font_size => 6,:justification => :center
    pdf.text "ESCUELA DE IDIOMAS MODERNOS", :font_size => 6,:justification => :center
    
    #pdf.image "public/images/Logo FHE-UCV.jpg", :justification => :left, :width => 50
    #pdf.image "public/images/Logo FHE-UCV.jpg", :justification => :center, :width => 50, :pad => 0
    
    pdf.line 35,650,575,700
    
    #pdf.add_image_from_file 'public/images/logoEIM.jpg', 5, 660, 50,nil
    
    if historial.size > 0
      #pdf.select_font "Helvetica"
      pdf.text "\n\n\n\n"
      pdf.text "<b>CONSTANCIA</b>", :font_size => 20,:justification => :center
      pdf.text "\n"
      pdf.text to_utf16("Quien suscribe, Prof. Lucius Daniel, Director de la Escuela de Idiomas Modernos de la Facultad de Humanidades y Educación de la Universidad Central de Venezuela, hace constar por medio de la presente que #{sexo(historial.first.usuario.tipo_sexo_id,"la","el")} ciudadan#{sexo(historial.first.usuario.tipo_sexo_id,"a","o")}:"), :font_size => 11, :justification => :full
      pdf.text "\n"
      pdf.text "<b>#{to_utf16(historial.first.usuario.nombres)} #{to_utf16(historial.first.usuario.apellidos)} (#{to_utf16(historial.first.usuario.ci)})</b>",:justification => :center, :font_size => 12
      
      if historial.size
        
      end
      pdf.text "\n"
      pdf.text to_utf16("aprobó del curso <b>#{historial.first.tipo_curso.descripcion}</b> #{pluralize(historial.count, "el", "los")}  #{pluralize(historial.count, "nivel","niveles")} que se indican a continuación:"), :font_size => 11, :justification => :full
      pdf.text "\n"
            
      #pdf.line 35,630,575,630
      
      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :none
      tab.show_headings = true
      tab.shade_rows = :none
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 10
      tab.row_gap = 1
      tab.minimum_space = 0
      
      tab.column_order = ["nivel","periodo","nota"]
      tab.columns["nivel"] = PDF::SimpleTable::Column.new("nivel") { |col|
        col.width = 160
        col.justification = :center
        col.heading = to_utf16 "Nivel"
        col.heading.justification= :center
      }
      tab.columns["periodo"] = PDF::SimpleTable::Column.new("periodo") { |col|
        col.width = 80
        col.justification = :center
        col.heading = to_utf16("Período")
        col.heading.justification= :center
      }
      tab.columns["nota"] = PDF::SimpleTable::Column.new("nota") { |col|
        col.width = 80
        col.justification = :center
        col.heading = to_utf16("Calificación")
        col.heading.justification= :center
      }

      data = []

      historial.each{|reg|
        if reg.aprobo_curso?
        
        data << {        
          "nivel" => "<b>#{to_utf16(reg.tipo_nivel.descripcion)}</b>",
          "periodo" => "<b>#{reg.periodo_id}</b>",
          "nota" => "<b>#{"%002i"%reg.nota_final}</b>"
        }
        
        end
        
        
      }
      tab.data.replace data
      tab.render_on(pdf)
      
      t = Time.new
      
      pdf.text "\n\n\n\n\n"
      pdf.text to_utf16("Cada nivel tiene una duración de 54 horas académicas (9 semanas aproximadamente). Esta constancia se expide a solicitud del interesad#{sexo(historial.first.usuario.tipo_sexo_id,"a","o")}."), :font_size => 11, :justification => :full
      
      pdf.text to_utf16("En Caracas, a los #{t.day} días del mes de #{mes(t.month)} de #{t.year}"), :font_size => 11, :justification => :full
      
      pdf.text "\n\n\n"
      pdf.image 'app/assets/images/firma_joyce.jpg', :justification => :center, :resize => 0.25
      pdf.text "____________________________" , :justification => :center
      pdf.text "Prof. Lucius Daniel" , :justification => :center
      
      
      pdf.add_text_wrap(160, 38, 300 , "\"CIUDAD UNIVERSITARIA DE CARACAS - PATRIMONIO CULTURAL DE LA HUMANIDAD\"", 6, :center)
      pdf.add_text_wrap(160, 30, 300 , to_utf16("Ciudad Universitaria de de Caracas, Galpón 7, Frente a Farmacia. Telf.: (0212) 6052982"), 6, :center)
      pdf.add_text_wrap(160, 22, 300 , to_utf16("Telefax: (2012) 6052908"), 6, :center)


      pdf.save_as "Constancia - #{historial.usuario.ci} - #{historial.usuario.nombre_completo}.pdf" if guardar
    end
    pdf

  end


  def self.generar_constancia_estudio(ci,idioma,categoria,remitente, periodo,guardar=false)

    #periodo_actual = ParametroGeneral.periodo_actual
    historial = HistorialAcademico.where(:periodo_id=> periodo, :usuario_ci=>ci,:idioma_id=>idioma,:tipo_categoria_id=>categoria).limit(1).first


    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape, 
    
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss

    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg',45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 280, 710, 50,nil
    pdf.text "\n\n\n\n"
    pdf.margins_mm(30)
    pdf.text "UNIVERSIDAD CENTRAL DE VENEZUELA", :font_size => 6,:justification => :center
    pdf.text to_utf16("FACULTAD DE HUMANIDADES Y EDUCACIÓN"), :font_size => 6,:justification => :center
    pdf.text "ESCUELA DE IDIOMAS MODERNOS", :font_size => 6,:justification => :center

    if historial
      pdf.text "\n\n\n"
      pdf.text to_utf16("<b>#{remitente}</b>"), :font_size => 16, :justification => :left
      pdf.text "\n"
      pdf.text to_utf16("\tQuien suscribe, Prof. Lucius Daniel, Director de la Escuela de Idiomas Modernos de la Facultad de Humanidades y Educación de la Universidad Central de Venezuela, hace constar por medio de la presente que #{sexo(historial.usuario.tipo_sexo_id,"la","el")} ciudadan#{sexo(historial.usuario.tipo_sexo_id,"a","o")}:"), :spacing => 1.5, :font_size => 12, :justification => :full
      pdf.text "\n"
      pdf.text "<b>#{to_utf16(historial.usuario.descripcion)}</b>",:spacing => 1.5,:justification => :center
      pdf.text "\n"
    pdf.text to_utf16("\tEstá inscrit#{sexo(historial.usuario.tipo_sexo_id,"a","o")} en el programa de cursos de idiomas coordinado por esta institución. Los datos sobre el curso se indican a continuación:"), :spacing => 1.5, :font_size => 12, :justification => :full
      
      pdf.text "\n\n"
    tabla = PDF::SimpleTable.new
    tabla.heading_font_size = 8
    tabla.font_size = 8
    tabla.show_lines    = :all
    tabla.line_color = Color::RGB::Gray
    tabla.show_headings = true
    tabla.shade_headings = true
    tabla.shade_heading_color = Color::RGB.new(230,238,238)
    tabla.shade_color = Color::RGB.new(230,238,238)
    tabla.shade_color2 = Color::RGB::White
    tabla.shade_rows = :striped
    tabla.orientation   = :center
    tabla.position      = :center
    tabla.column_order = ["Idioma", "Nivel","Categoria", "Horario", "Periodo"]
      
    tabla.columns["Idioma"] = PDF::SimpleTable::Column.new("Idioma") { |col|
      col.width = 70
      col.justification = :center
      col.heading = to_utf16 "<b>Idioma</b>"
      col.heading.justification= :center
    }
    tabla.columns["Nivel"] = PDF::SimpleTable::Column.new("Nivel") { |col|
      col.width = 80
      col.justification = :center
      col.heading = to_utf16("<b>Nivel</b>")
      col.heading.justification= :center
    }
     tabla.columns["Categoria"] = PDF::SimpleTable::Column.new("Categoria") { |col|
      col.width = 70
      col.justification = :center
      col.heading = to_utf16("<b>Categoría</b>")
      col.heading.justification= :center
    }
    tabla.columns["Horario"] = PDF::SimpleTable::Column.new("Horario") { |col|
      col.width = 140
      col.justification = :center
      col.heading = to_utf16("<b>Horario</b>")
      col.heading.justification= :center
    }
    tabla.columns["Periodo"] = PDF::SimpleTable::Column.new("Periodo") { |col|
      col.width = 70
      col.justification = :center
      col.heading = to_utf16("<b>Período</b>")
      col.heading.justification= :center
    }
   
    periodo, ano = periodo.split("-")
    data = []
    data << {        
      "Idioma" => to_utf16("#{historial.tipo_curso.idioma.descripcion}"),
      "Nivel" => to_utf16("#{historial.tipo_nivel.descripcion}"),
      "Categoria" => to_utf16("#{historial.tipo_categoria.descripcion}"),
      "Horario" => to_utf16("#{historial.seccion.horario}"),
      "Periodo" => to_utf16("#{periodo} - #{ano}")
    }
    tabla.data.replace data
    tabla.render_on(pdf)
      
      #pdf.text to_utf16("<b>#{historial.tipo_curso.descripcion}</b>"), :spacing => 1.5, :font_size => 12, :justification => :center
      
      #pdf.text to_utf16("\n\tEn el horario de #{historial.seccion.horario} durante el período #{periodo} del año #{ano}. La nota mínima aprobatoria es #{aprobado(historial.tipo_categoria_id)} puntos."), :spacing => 1.5, :font_size => 12, :justification => :full
      t = Time.new
      pdf.text to_utf16("\n\tEsta constancia se expide en Caracas, a los #{t.day} días del mes de #{mes(t.month)} de #{t.year} con fines laborales únicamente y bajo ningún concepto indica que #{sexo(historial.usuario.tipo_sexo_id,"la","el")} Sr#{sexo(historial.usuario.tipo_sexo_id,"a","")}. #{historial.usuario.nombre_completo} es estudiante regular de la Universidad Central de Venezuela.
      "), :spacing => 1.5, :font_size => 12, :justification => :full
      
      pdf.image 'app/assets/images/firma_joyce.jpg', :justification => :center, :resize => 0.30
      pdf.text "____________________________" , :justification => :center
      pdf.text "Prof. Lucius Daniel" , :justification => :center
      pdf.text "Director" , :justification => :center
      
      pdf.add_text_wrap(160, 38, 300 , "\"CIUDAD UNIVERSITARIA DE CARACAS - PATRIMONIO CULTURAL DE LA HUMANIDAD\"", 6, :center)
      pdf.add_text_wrap(160, 30, 300 , to_utf16("Ciudad Universitaria de de Caracas, Galpón 7, Frente a Farmacia. Telf.: (0212) 6052982"), 6, :center)
      pdf.add_text_wrap(160, 22, 300 , to_utf16("Telefax: (2012) 6052908"), 6, :center)


      pdf.save_as "Constancia - #{historial.usuario.ci} - #{historial.usuario.nombre_completo}.pdf" if guardar
    end
    pdf

  end

  def self.aprobado(categoria)
    if categoria =="NI" || categoria =="TE"
      return "diéz (10)"
    else
      return "quince (15)"
    end
  end
  
  def self.sexo(valor,femenino, masculino)
    if valor
      if valor=="F"
        femenino
      else
        masculino
      end
    else
      "#{masculino}(#{femenino})"
    end
  end

  def self.pluralize(count, singular, plural)
    if count>1 
      plural
    else
      singular
    end
  end
  
  def self.mes(mun)
    return "Enero" if mun == 1
    return "Febrero" if mun == 2
    return "Marzo" if mun == 3
    return "Abril" if mun == 4
    return "Mayo" if mun == 5
    return "Junio" if mun == 6
    return "Julio" if mun == 7
    return "Agosto" if mun == 8
    return "Septiembre" if mun == 9
    return "Octubre" if mun == 10
    return "Noviembre" if mun == 11
    return "Diciembre" if mun == 12
    
  end

  def self.listado(historiales,session)
    usuario = session[:usuario]
    pdf = PDF::Writer.new
    pdf.margins_cm(1.8)
    #color de relleno para el pdf (color de las letras)
#    pdf.fill_color(Color::RGB.new(255,255,255))
    #imagen del encabezado
 #   pdf.add_image_from_file 'app/assets/images/banner.jpg', 50, 685, 510, 60
    
    
    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 465, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710+10, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 45, 710, 50,nil
 
    
    #texto del encabezado
    pdf.add_text 100,745,to_utf16("Universidad Central de Venezuela"),11
    pdf.add_text 100,735,to_utf16("Facultad de Humanidades y Educación"),11
    pdf.add_text 100,725,to_utf16("Escuela de Idiomas Modernos"),11
    pdf.add_text 100,715,to_utf16("Cursos de Extensión EIM-UCV"),11

    #texto del encabezado
#    pdf.add_text 70,722,to_utf16("Universidad Central de Venezuela"),7
#    pdf.add_text 70,714,to_utf16("Facultad de Humanidades y Educación"),7
#    pdf.add_text 70,706,to_utf16("Escuela de Idiomas Modernos"),7
#    pdf.add_text 70,698,to_utf16("Administrador de Cursos de Extensión de Idiomas Modernos"),7

    #titulo
    pdf.fill_color(Color::RGB.new(0,0,0))
    historial = historiales.first
    #periodo_calificacion
    
    pdf.add_text_wrap 50,650,510,to_utf16(
      "#{Seccion.idioma(historial.idioma_id)} (#{Seccion.tipo_categoria(historial.tipo_categoria_id)}) - #{historial.tipo_nivel.descripcion} - Sección #{historial.seccion_numero}"), 12,:center
    pdf.add_text_wrap 50,635,510,to_utf16("#{Seccion.horario(session)} - #{historial.seccion.aula_corta}"),10,:center
    pdf.add_text_wrap 50,621,510,to_utf16("Periodo #{ParametroGeneral.periodo_actual.id}"),9.5,:center

    #instructor
    pdf.add_text_wrap 50,600,510,to_utf16(usuario.nombre_completo),10
    pdf.add_text_wrap 50,585,505,to_utf16(usuario.ci),10

    pdf.add_text_wrap 50,555,510,to_utf16("<b>Listado de alumnos<b>"),10

    historiales = historiales.sort_by{|h| h.usuario.nombre_completo}
    #  historiales.each { |h|
    #    pdf.text to_utf16 "#{h.usuario.nombre_completo} - #{h.nota_final}"
    #  }
    pdf.text "\n"*18
    tabla = PDF::SimpleTable.new
    tabla.heading_font_size = 8
    tabla.font_size = 8
    tabla.show_lines    = :all
    tabla.line_color = Color::RGB::Gray
    tabla.show_headings = true
    tabla.shade_headings = true
    tabla.shade_heading_color = Color::RGB.new(230,238,238)
    tabla.shade_color = Color::RGB.new(230,238,238)
    tabla.shade_color2 = Color::RGB::White
    tabla.shade_rows = :striped
    tabla.orientation   = :center
    tabla.position      = :center
    tabla.column_order = ["#", "nombre", "cedula", "correo"]

    tabla.columns["#"] = PDF::SimpleTable::Column.new("#") { |col|
      col.width = 30
      col.heading = to_utf16("<b>#</b>")
      col.heading.justification = :center
      col.justification = :center
    }
    tabla.columns["cedula"] = PDF::SimpleTable::Column.new("cedula") { |col|
      col.width = 60
      col.heading = to_utf16("<b>Cédula</b>")
      col.heading.justification = :center
      col.justification = :center
    }
    tabla.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 190
      col.heading = "<b>Nombre</b>"
      col.heading.justification = :left
      col.justification = :left
    }
    tabla.columns["correo"] = PDF::SimpleTable::Column.new("correo") { |col|
      col.width = 190
      col.heading = to_utf16("<b>Correo</b>")
      col.heading.justification = :left
      col.justification = :left
    }

    data = []

    historiales.each_with_index{|h,i|
        data << {"#" => "#{i+1}",
          "cedula" => to_utf16(h.usuario.ci),
          "nombre" => to_utf16(h.usuario.nombre_completo),
          "correo" => to_utf16(h.usuario.correo)
        }
    }
    tabla.data.replace data
    tabla.render_on(pdf)
    pdf.add_text 430,50,to_utf16("#{Time.now.strftime('%d/%m/%Y %I:%M%p')} - Página: 1 de 1")
    return pdf
  end


  def self.generar_certificado_curso(ci,idioma,categoria,guardar=false)

    #historial = HistorialAcademico.all(
    #:conditions => ["usuario_ci = ?",ci])

    estudiante_curso = EstudianteCurso.where(:usuario_ci=>ci,:idioma_id=>idioma,:tipo_categoria_id=>categoria).limit(1).first

    #pdf.add_image_from_file 'public/images/logo_pi_color1.jpg', 55, 660, 490,nil

    pdf = PDF::Writer.new(:paper => "letter", :orientation => :landscape)  #:orientation => :landscape, 
    
    #ss = PDF::Writer::StrokeStyle.new(2)
    #ss.cap = :round
    #pdf.stroke_style ss

    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 50, 510, 70, nil  #,45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg',365, 500, 70, nil # 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 670, 510, 70, nil#280, 710, 50,nil
    pdf.text "\n\n\n\n\n\n\n"
    #pdf.margins_mm(10)
    pdf.select_font "Times-Roman"
    pdf.text "UNIVERSIDAD CENTRAL DE VENEZUELA", :font_size => 10,:justification => :center
    pdf.text to_utf16("FACULTAD DE HUMANIDADES Y EDUCACIÓN"), :font_size => 10,:justification => :center
    pdf.text "ESCUELA DE IDIOMAS MODERNOS", :font_size => 10,:justification => :center
    
    #pdf.image "public/images/Logo FHE-UCV.jpg", :justification => :left, :width => 50
    #pdf.image "public/images/Logo FHE-UCV.jpg", :justification => :center, :width => 50, :pad => 0

    
    #pdf.add_image_from_file 'public/images/logoEIM.jpg', 5, 660, 50,nil
      pdf.text "CERTIFICADO", :font_size => 40,:justification => :center
      pdf.select_font "Times-Italic"
      pdf.text to_utf16("que se otorga a"), :justification => :center, :font_size => 22
      pdf.text "\n"
      pdf.select_font "Helvetica-Bold"
      pdf.text "#{to_utf16(estudiante_curso.usuario.nombres)} #{to_utf16(estudiante_curso.usuario.apellidos)}",:justification => :center, :font_size => 30
      pdf.text "\n"
      pdf.select_font "Times-Italic"
      pdf.text to_utf16("por haber aprobado el curso de"), :justification => :center, :font_size => 22
      pdf.select_font "Times-BoldItalic"
      pdf.text to_utf16("#{estudiante_curso.tipo_curso.idioma.descripcion}"), :justification => :center   
      pdf.text to_utf16("COMO LENGUA EXTRANJERA"), :justification => :center
      pdf.select_font "Times-Roman"
      pdf.text to_utf16("#{estudiante_curso.tipo_curso.numero_grados*54} Horas"), :justification => :center
      
      t = Time.new
      pdf.text to_utf16("Caracas, #{t.day} de #{mes(t.month)} de #{t.year}"), :spacing => 1.5, :font_size => 12, :justification => :center
      
      
      pdf.add_text_wrap(40, 110, 200 , "Prof. Lucius Daniel", 10, :center)
      pdf.add_text_wrap(40, 100, 200 , "Director", 10, :center)
      pdf.add_text_wrap(540, 110, 200 , to_utf16("Prof. Carlos A. Saavedra A."), 10, :center)
      pdf.add_text_wrap(540, 100, 200 , to_utf16("Coordinador Académico"), 10, :center)

      pdf.save_as "Certificado - #{estudiante_curso.usuario.ci} - #{estudiante_curso.usuario.nombre_completo}.pdf" if guardar
    pdf

  end

  def self.generar_listado_instructores(guardar=false)
    periodo_actual = ParametroGeneral.periodo_actual
    instructores = Instructor.all.delete_if{|i| i.seccion_periodo.size==0}.sort_by{|x| x.usuario.nombre_completo}
    pdf = PDF::Writer.new(:paper => "letter")
    
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss

    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 710, 50,nil
    pdf.line 35,700,575,700
    if instructores.size > 0
      pdf.text "\n\n\n\n\n"
      pdf.text to_utf16("<b>Instructores Período:</b> #{periodo_actual.id}"), :justification => :center
      pdf.text "\n\n"
      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :inner
      tab.show_headings = true
      tab.shade_rows = :none
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 8
      tab.row_gap = 3
      tab.minimum_space = 0
      tab.column_order = ["nro","nombre","cedula","correo","telefono","domina"]
      tab.columns["nro"] = PDF::SimpleTable::Column.new("nro") { |col|
        col.width = 25
        col.justification = :right
        col.heading = "#"
        col.heading.justification= :center
      }
      tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
        col.width = 140
        col.justification = :left
        col.heading = "NOMBRE COMPLETO"
        col.heading.justification= :center
      }
      tab.columns["cedula"] = PDF::SimpleTable::Column.new("cedula") { |col|
        col.width = 50
        col.justification = :center
        col.heading = to_utf16 "CÉDULA"
        col.heading.justification= :center
      }
      tab.columns["correo"] = PDF::SimpleTable::Column.new("correo") { |col|
        col.width = 140
        col.justification = :left
        col.heading = to_utf16 "CORREO ELECTRÓNICO"
        col.heading.justification= :center
      }
      tab.columns["telefono"] = PDF::SimpleTable::Column.new("telefono") { |col|
        col.width = 80
        col.justification = :left
        col.heading = "TELEFONO"
        col.heading.justification= :center
      }
      
      tab.columns["domina"] = PDF::SimpleTable::Column.new("domina") { |col|
        col.width = 80
        col.justification = :left
        col.heading = "IDIOMA"
        col.heading.justification= :center
      }

      data = []

      instructores.each_with_index{|reg,ind|
        
        data << {
          "nro" => "#{(ind+1)}",          
          "nombre" => to_utf16(reg.usuario.nombre_completo),
          "cedula" => reg.usuario_ci,
          "correo" => reg.usuario.correo,
          "telefono" => reg.usuario.telefono_movil,
          "domina" => to_utf16(reg.domina_descripcion)
        } if reg.usuario_ci!="-----"
      }


      t = Time.new
      pdf.start_page_numbering(250, 15, 7, nil, to_utf16("#{t.day} / #{t.month} / #{t.year}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)

      tab.data.replace data
      tab.render_on(pdf)
      pdf.save_as "instructores_periodo_#{perido_actual.id}.pdf" if guardar
    end
    pdf
  end


  def self.generar_listado_instructores_xls

      periodo_actual = ParametroGeneral.periodo_actual
      instructores = Instructor.all.delete_if{|i| i.seccion_periodo.size==0}.sort_by{|x| x.usuario.nombre_completo}
      open("Instructores_periodo_#{periodo_actual.id}.xls","w") {|f|
        f.puts "No./\t Nombre Completo /\t Cédula \t Correo Electrónico \t Teléfono Movil \t Idioma"
        p "No.\t Nombre Completo \t Cédula \t Correo Electrónico \t Teléfono Movil \t Idioma"
        instructores.each_with_index{|reg,ind|
          f.puts "#{ind+1}\t#{reg.usuario.nombre_completo} \t#{reg.usuario_ci}\t#{reg.usuario.correo}\t#{reg.usuario.telefono_movil}\t#{reg.domina_descripcion}"
        }   
      }

  end


def self.generar_listado_convenios(convenio_id, periodo_id,guardar=false)

    historiales = HistorialAcademico.where(["tipo_convenio_id = ? AND periodo_id = ? AND tipo_estado_inscripcion_id = ? ",convenio_id,periodo_id,"INS"])

    historiales = historiales.sort_by{|x| "#{x.tipo_curso.descripcion} - #{x.tipo_nivel.descripcion} - #{x.usuario.nombre_completo}"}

    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape, 
    
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss

    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 710, 50,nil
    pdf.line 35,700,575,700
    
    if historiales.size > 0
      pdf.text "\n\n\n\n\n"
      pdf.text to_utf16("<b>Período:</b> #{historiales.last.periodo_id}"), :justification => :center  
      pdf.text to_utf16("<b>Convenio:</b> #{historiales.last.tipo_convenio.descripcion_convenio}"), :justification => :center
      pdf.text "\n\n"
      
      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :inner
      tab.show_headings = true
      tab.shade_rows = :none
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 8
      tab.row_gap = 3
      tab.minimum_space = 0
      tab.column_order = ["nombre","cedula", "correo","telefono","idioma","nivel"]
      tab.columns["nivel"] = PDF::SimpleTable::Column.new("nro") { |col|
        col.width = 70
        col.heading = "Nivel"
        col.heading.justification= :center
      }
      tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
        col.width = 150
        col.justification = :left
        col.heading = "NOMBRE COMPLETO"
        col.heading.justification= :center
      }
      tab.columns["cedula"] = PDF::SimpleTable::Column.new("cedula") { |col|
        col.width = 50
        col.justification = :center
        col.heading = to_utf16 "CÉDULA"
        col.heading.justification= :center
      }
      tab.columns["correo"] = PDF::SimpleTable::Column.new("correo") { |col|
        col.width = 140
        col.justification = :left
        col.heading = "CORREO"
        col.heading.justification= :center
      }
      tab.columns["telefono"] = PDF::SimpleTable::Column.new("telefono") { |col|
        col.width = 70
        col.justification = :left
        col.heading = "TELEFONO"
        col.heading.justification= :center
      }
      tab.columns["idioma"] = PDF::SimpleTable::Column.new("idioma") { |col|
        col.width = 80
        col.justification = :left
        col.heading = "IDIOMA"
        col.heading.justification= :center
      }

      data = []

      historiales.each_with_index{|reg,ind|
        data << {       
          "nombre" => to_utf16(reg.usuario.nombre_completo),
          "cedula" => to_utf16(reg.usuario_ci),
          "correo" => to_utf16(reg.usuario.correo),
          "telefono" => to_utf16(reg.usuario.telefono_movil),
          "idioma" => to_utf16(reg.tipo_curso.descripcion),
          "nivel" => to_utf16(reg.tipo_nivel.descripcion)   
        }
      }


      t = Time.new
      pdf.start_page_numbering(250, 15, 7, nil, to_utf16("#{t.day} / #{t.month} / #{t.year}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)

      tab.data.replace data
      
      pdf.line 35,25,575,25
      
      tab.render_on(pdf)

      pdf.save_as "#{historial.last.seccion.id.to_s.gsub(",","_")}.pdf" if guardar
    end
    pdf

  end



def self.generar_listado_congelados(periodo_id,guardar=false)

    historiales = HistorialAcademico.where(["historial_academico.periodo_id = ? AND tipo_estado_inscripcion_id = ?",periodo_id,"CON"])

    historiales = historiales.sort_by{|x| x.usuario.nombre_completo}

    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape, 
    
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss

    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 710, 50,nil
    pdf.line 35,700,575,700
    
    if historiales.size > 0
      pdf.text "\n\n\n\n\n"
      pdf.text to_utf16("<b>Período:</b> #{historiales.last.periodo_id}"), :justification => :center  
      pdf.text to_utf16("<b>Reporte:</b> Alumnos Congelados"), :justification => :center
      pdf.text "\n\n"
           
      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :inner
      tab.show_headings = true
      tab.shade_rows = :none
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 8
      tab.row_gap = 3
      tab.minimum_space = 0
      tab.column_order = ["nro","nombre","cedula", "correo","telefono","idioma","nivel"]
      tab.columns["nro"] = PDF::SimpleTable::Column.new("nro") { |col|
        col.width = 15
        col.justification = :right
        col.heading = "#"
        col.heading.justification= :center
      }
      tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
        col.width = 120
        col.justification = :left
        col.heading = "NOMBRE COMPLETO"
        col.heading.justification= :center
      }
      tab.columns["cedula"] = PDF::SimpleTable::Column.new("cedula") { |col|
        col.width = 50
        col.justification = :center
        col.heading = to_utf16 "CÉDULA"
        col.heading.justification= :center
      }
      tab.columns["correo"] = PDF::SimpleTable::Column.new("correo") { |col|
        col.width = 110
        col.justification = :left
        col.heading = "CORREO"
        col.heading.justification= :center
      }
      tab.columns["telefono"] = PDF::SimpleTable::Column.new("telefono") { |col|
        col.width = 60
        col.justification = :left
        col.heading = "TELEFONO"
        col.heading.justification= :center
      }
      tab.columns["idioma"] = PDF::SimpleTable::Column.new("idioma") { |col|
        col.width = 75
        col.justification = :left
        col.heading = "IDIOMA"
        col.heading.justification= :center
      }

      tab.columns["nivel"] = PDF::SimpleTable::Column.new("nivel") { |col|
        col.width = 85
        col.justification = :left
        col.heading = "NIVEL"
        col.heading.justification= :center
      }


      data = []

      historiales.each_with_index{|reg,ind|
        data << {
          "nro" => "#{(ind+1)}",          
          "nombre" => to_utf16(reg.usuario.nombre_completo),
          "cedula" => reg.usuario_ci,
          "correo" => reg.usuario.correo,
          "telefono" => reg.usuario.telefono_movil,
          "idioma" => reg.tipo_curso.descripcion,
          "nivel" => reg.tipo_nivel.descripcion
        }
      }


      t = Time.new
      pdf.start_page_numbering(250, 15, 7, nil, to_utf16("#{t.day} / #{t.month} / #{t.year}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)

      tab.data.replace data
      
      pdf.line 35,25,575,25
      
      tab.render_on(pdf)

      pdf.save_as "#{historial.last.seccion.id.to_s.gsub(",","_")}.pdf" if guardar
    end
    pdf

  end
  
  
  def self.generar_listado_alumnos_por_edificio_pdf(consulta,titulo)
    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape,   
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss
    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 710, 50,nil
    pdf.text "\n\n\n\n\n"
    pdf.text to_utf16(titulo), :justification => :center, :font_size => 14
    pdf.text "\n\n"
    
    tab = PDF::SimpleTable.new
    tab.bold_headings = true
#    tab.show_lines    = :inner
    tab.show_headings = true
#    tab.shade_rows = :none
    tab.orientation   = :center
    tab.heading_font_size = 8
    tab.font_size = 8
    tab.row_gap = 3
    tab.minimum_space = 0
    tab.column_order = ["nro","nombre","cedula", "aula","idioma","nivel","categoria"]
    tab.columns["nro"] = PDF::SimpleTable::Column.new("nro") { |col|
      col.width = 30
      col.justification = :center
      col.heading = "#"
      col.heading.justification= :center
    }
    tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 120
      col.justification = :left
      col.heading = "NOMBRE COMPLETO"
      col.heading.justification= :center
    }
    tab.columns["cedula"] = PDF::SimpleTable::Column.new("cedula") { |col|
      col.width = 50
      col.justification = :center
      col.heading = to_utf16 "CÉDULA"
      col.heading.justification= :center
    }
    tab.columns["aula"] = PDF::SimpleTable::Column.new("aula") { |col|
      col.width = 110
      col.justification = :left
      col.heading = "AULA"
      col.heading.justification= :center
    }
    tab.columns["idioma"] = PDF::SimpleTable::Column.new("idioma") { |col|
      col.width = 60
      col.justification = :left
      col.heading = "IDIOMA"
      col.heading.justification= :center
    }
    tab.columns["nivel"] = PDF::SimpleTable::Column.new("nivel") { |col|
      col.width = 85
      col.justification = :left
      col.heading = "NIVEL"
      col.heading.justification= :center
    }
    tab.columns["categoria"] = PDF::SimpleTable::Column.new("categoria") { |col|
      col.width = 75
      col.justification = :left
      col.heading = to_utf16 "CATEGORÍA"
      col.heading.justification= :center
    }

    data = []

    consulta.each_with_index{|con,ind|
      data << {
        "nro" => "#{(ind+1)}",          
        "nombre" => to_utf16(con.nombre),
        "cedula" => to_utf16(con.cedula),
        "aula" => to_utf16(con.aula),
        "idioma" => to_utf16(con.idioma),
        "nivel" => to_utf16(con.nivel),
        "categoria" => to_utf16(con.categoria)
      }
    }
    
    tab.data.replace data
    tab.render_on pdf
    pdf
  end

  def self.nomina_instructores(instructores,periodo)
    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape,   
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss
    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 45, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 710, 50,nil
    pdf.text "\n\n\n\n\n"
    pdf.text to_utf16("Nómina de instructores (#{periodo})"), :justification => :center, :font_size => 14
    pdf.text "\n\n"
    
    tab = PDF::SimpleTable.new
    tab.bold_headings = true
#    tab.show_lines    = :inner
    tab.show_headings = true
#    tab.shade_rows = :none
    tab.orientation   = :center
    tab.heading_font_size = 8
    tab.font_size = 8
    tab.row_gap = 3
    tab.minimum_space = 0
    tab.column_order = ["nombre","cantidad_secciones","horarios"]
    tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 120
      col.justification = :left
      col.heading = "Nombre"
      col.heading.justification= :center
    }
    tab.columns["cantidad_secciones"] = PDF::SimpleTable::Column.new("cantidad_secciones") { |col|
      col.width = 90
      col.justification = :center
      col.heading = to_utf16 "Cantidad de secciones"
      col.heading.justification= :center
    }
    tab.columns["horarios"] = PDF::SimpleTable::Column.new("horarios") { |col|
      col.width = 220
      col.justification = :left
      col.heading = "Horarios"
      col.heading.justification= :center
    }
    data = []

    instructores.each{|ins|
      data << {
        "nombre" => "#{to_utf16(ins.usuario.nombre_completo)}",          
        "cantidad_secciones" => to_utf16(ins.secciones_que_dicta(periodo).size.to_s),
        "horarios" => to_utf16(ins.horario_secciones_que_dicta(periodo).join(" // "))
      }
    }
    
    tab.data.replace data
    tab.render_on pdf
    pdf
  end


  def self.asistencia_pdf(datos,historiales)
    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape,   
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss
    #pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 45, 710, 50,nil
    #pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710, 50,nil
    #pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 275, 710, 50,nil
    #pdf.text "\n\n\n\n\n"
    pdf.text to_utf16("ACEIM - BBVA")
    pdf.text to_utf16("Control de Asistencia")
    
    pdf.text to_utf16(""), :justification => :center, :font_size => 14
    pdf.text "\n\n"
    
    tab = PDF::SimpleTable.new
    tab.bold_headings = true
#    tab.show_lines    = :inner
    tab.show_headings = true
#    tab.shade_rows = :none
    tab.orientation   = :center
    tab.heading_font_size = 8
    tab.font_size = 8
    tab.row_gap = 3
    tab.minimum_space = 0
    tab.column_order = ["nombre","cantidad_secciones","horarios"]
    tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 120
      col.justification = :left
      col.heading = "Nombre"
      col.heading.justification= :center
    }
  end

  def self.resumen_asistencia(periodo)
    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape,   
    ss = PDF::Writer::StrokeStyle.new(2)
    ss.cap = :round
    pdf.stroke_style ss

    pdf.add_image_from_file 'app/assets/images/banner_bbva.jpg', 45, 710, 520,nil
    pdf.text "\n\n\n\n\n"
    pdf.text to_utf16("Resumen de Asistencia (#{periodo})"),:justification => :center, :font_size => 16
    pdf.text "\n"


    secciones = Seccion.where(:periodo_id => periodo).sort_by{|sec| sec.curso.grado}
    secciones.each_with_index{|seccion,ind|
      if seccion.tiene_estudiantes?
        tab = PDF::SimpleTable.new
        tab.bold_headings = true
    #    tab.show_lines    = :inner
        tab.show_headings = true
    #    tab.shade_rows = :none
        tab.orientation   = :center
        tab.shade_headings = true
        if ind % 2 == 0
          tab.shade_heading_color = Color::RGB.new(230,195,26)
        else
          tab.shade_heading_color = Color::RGB.new(157,179,211)
        end
        tab.heading_font_size = 8
        tab.font_size = 8
        tab.row_gap = 3
        tab.minimum_space = 0
        tab.column_order = ["vp","nombre","total_clases","total_asistencias","total_inasistencias","nota1","nota2","nota3","nota4","nota5"]

        tab.columns["vp"] = PDF::SimpleTable::Column.new("vp") { |col|
          col.width = 50
          col.justification = :left
          col.heading = "#{seccion.tipo_nivel.descripcion}"
        }
        tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
          col.width = 120
          col.justification = :center
          col.heading = to_utf16 "#{seccion.horario} \n Prof. #{to_utf16(seccion.instructor.usuario.nombre_completo)}"
          col.heading.justification= :center
        }
        tab.columns["total_clases"] = PDF::SimpleTable::Column.new("total_clases") { |col|
          col.width = 50
          col.justification = :center
          col.heading = "Total clases"
          col.heading.justification= :center
        }
        tab.columns["total_asistencias"] = PDF::SimpleTable::Column.new("total_asistencias") { |col|
          col.width = 60
          col.justification = :center
          col.heading = "Total asistencias"
          col.heading.justification= :center
        }
        tab.columns["total_inasistencias"] = PDF::SimpleTable::Column.new("total_inasistencias") { |col|
          col.width = 65
          col.justification = :center
          col.heading = "Total inasistencias"
          col.heading.justification= :center
        }


        tab.columns["nota1"] = PDF::SimpleTable::Column.new("nota1") { |col|
          col.width = 30
          col.justification = :left
          col.heading = "EE1"
        }

        tab.columns["nota2"] = PDF::SimpleTable::Column.new("nota2") { |col|
          col.width = 30
          col.justification = :left
          col.heading = "EE2"
        }

        tab.columns["nota3"] = PDF::SimpleTable::Column.new("nota3") { |col|
          col.width = 30
          col.justification = :left
          col.heading = "EO"
        }

        tab.columns["nota4"] = PDF::SimpleTable::Column.new("nota4") { |col|
          col.width = 30
          col.justification = :left
          col.heading = "OT"
        }

        tab.columns["nota5"] = PDF::SimpleTable::Column.new("nota5") { |col|
          col.width = 50
          col.justification = :left
          col.heading = "Final"
        }


        
        data = []
        asistencias_tomadas = seccion.asistencias_tomadas
        seccion.listado_estudiantes_inscritos.each{|est|
          total_asistencias = est.estudiante.total_asistencias(periodo)
          total_inasistencias = est.estudiante.total_asistencias(periodo,false)
          nota1 = nota2 = nota3 = nota4 = final = "SC"
          historial = est
          if historial.nota_final != -2
            nota1 = historial.nota_en_evaluacion("EXA_ESC_1").nota == -1 ? "PI" : historial.nota_en_evaluacion("EXA_ESC_1").nota
            nota2 = historial.nota_en_evaluacion("EXA_ESC_2").nota == -1 ? "PI" : historial.nota_en_evaluacion("EXA_ESC_2").nota
            nota3 = historial.nota_en_evaluacion("EXA_ORA").nota == -1 ? "PI" : historial.nota_en_evaluacion("EXA_ORA").nota
            nota4 = historial.nota_en_evaluacion("OTRAS").nota == -1 ? "PI" : historial.nota_en_evaluacion("OTRAS").nota
            final = historial.nota_final == -1 ? "PI" : historial.nota_final.to_i
          end
          data << {
            "vp" => est.usuario_ci,          
            "nombre" => to_utf16(est.usuario.nombre_completo),
            "total_clases" => asistencias_tomadas,
            "total_asistencias" => "#{total_asistencias} (#{"%.0f" % ((Float(total_asistencias) / Float(asistencias_tomadas)) * 100)}%)",
            "total_inasistencias" => "#{total_inasistencias} (#{"%.0f" % ((Float(total_inasistencias) / Float(asistencias_tomadas)) * 100)}%)",
            "nota1" => nota1,
            "nota2" => nota2,
            "nota3" => nota3,
            "nota4" => nota4,
            "nota5" => final
          }
        }
        tab.data.replace data
        tab.render_on pdf
      end
      pdf.text "\n\n"
    }
    pdf
  end




end

