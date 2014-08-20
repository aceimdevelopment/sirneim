class Reportes

  def self.to_utf16(valor)
    ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    ic_ignore.iconv(valor)
  end

  def self.hola_mundo
    pdf = PDF::Writer.new
    pdf.text to_utf16 "ðåßáåáßäåéëþþüúíœïgßðf© Hólá Mundo"
    return pdf
  end

  def self.planilla_inscripcion(inscripcion=nil)
    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape, 
    t = Time.now
    planilla_inscripcion_pagina(inscripcion,pdf)
        pdf.text to_utf16("----- COPIA DEL PARTICIPANTE -----"), :font_size => 9, :justification => :center
        pdf.text to_utf16("#{t.strftime('%d/%m/%Y %I:%M%p')} - Página: 1 de 2"), :font_size => 6, :justification => :right
        
    pdf.new_page
    pdf.y = 756
    planilla_inscripcion_pagina(inscripcion,pdf)
        pdf.text to_utf16("----- COPIA ADMINISTRACIÓN -----"), :font_size => 9, :justification => :center
        pdf.text to_utf16("#{t.strftime('%d/%m/%Y %I:%M%p')} - Página: 2 de 2"), :font_size => 6, :justification => :right
   
    return pdf
  end

  def self.planilla_inscripcion_pagina(inscripcion,pdf)
    title_font_size = 12
    subtitle_font_size = 11
    paraph_font_size = 8
    table_font_size = 10
    # pdf.add_image_from_file 'app/assets/images/encabezado_diplomados.jpg', 55, 720, 450,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710+10, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 45, 710, 50,nil
    # #pdf.add_image_from_file Rutinas.crear_codigo_barra(historial_academico.usuario_ci), 450-10, 500+35, nil, 120
    # pdf.add_text 480-10,500+35,to_utf16("---- #{usuario.ci} ----"),11
    
    # #texto del encabezado
    # pdf.add_text 100,745,to_utf16("Universidad Central de Venezuela"),11
    # pdf.add_text 100,735,to_utf16("Facultad de Humanidades y Educación"),11
    # pdf.add_text 100,725,to_utf16("Escuela de Idiomas Modernos"),11
    # pdf.add_text 100,715,to_utf16("Diplomado en enseñanza de español como 2/L"),11   

    #titulo    
    pdf.text "\n\n\n\n", :font_size => 7
    pdf.text to_utf16("<b>Planilla de Inscripción</b>\n"), :font_size => title_font_size, :justification => :center
    #pdf.text to_utf16("Periodo #{historial_academico.periodo_id}"), :justification => :center

    # ------- DATOS DE LA INSCRIPCION -------
		pdf.text "\n", :font_size => 8
		pdf.text to_utf16("<b>Datos de la Inscripción:</b>"), :font_size => subtitle_font_size
    pdf.text "\n", :font_size => 6   
    tabla = PDF::SimpleTable.new 
    tabla.font_size = table_font_size
    # tabla.show_lines    = :all
    tabla.show_headings = false 
    tabla.shade_rows = :none
    tabla.column_order = ["nombre", "valor"]

    tabla.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 100
      col.justification = :right
    }
    tabla.columns["valor"] = PDF::SimpleTable::Column.new("valor") { |col|
      col.width = 420
      col.justification = :left
    }
    datos = []
    usuario = inscripcion.estudiante.usuario
    diplomado_cohorte = inscripcion.diplomado_cohorte

    datos << { "nombre" => to_utf16("<b>Participante:</b>"), "valor" => to_utf16("<b>Nombres: </b>#{usuario.nombres}  |  <b>Apellidos:</b> #{usuario.apellidos}\n<b>CI:</b> #{usuario.ci}  |  <b>Cel:</b>#{usuario.telefono_movil}  |  <b>mail:</b>#{usuario.correo}") }
    datos << { "nombre" => to_utf16("<b>Horario:</b>"), "valor" => to_utf16("#{diplomado_cohorte.diplomado.horario}") }
    datos << { "nombre" => to_utf16("<b>Aula:</b>"), "valor" => to_utf16("Aula 230 del 2do. piso de Trasbordo, Av. Minerva.") }
    datos << { "nombre" => to_utf16("<b>Grupo:</b>"), "valor" => to_utf16("Grupo #{inscripcion.grupo} - #{diplomado_cohorte.cohorte.nombre}") }
    tabla.data.replace datos
    tabla.render_on(pdf)
    

    # -------- TABLA CUENTA -------
    pdf.text "\n", :font_size => 8
		pdf.text to_utf16("<b>Datos de Pago:</b>"), :font_size => subtitle_font_size
    pdf.text "\n", :font_size => 6
    tabla = PDF::SimpleTable.new 
    tabla.font_size = table_font_size
    # tabla.show_lines    = :all
    tabla.show_headings = false 
    tabla.shade_rows = :none
    tabla.column_order = ["nombre", "valor"]

    tabla.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|
      col.width = 100
      col.justification = :right
    }
    tabla.columns["valor"] = PDF::SimpleTable::Column.new("valor") { |col|
      col.width = 420
      col.justification = :left
    }
    datos = []
    
    datos << { "nombre" => to_utf16("<b>Banco:</b>"), "valor" => to_utf16("#{diplomado_cohorte.cuenta_bancaria_banco}") }
    datos << { "nombre" => to_utf16("<b>Nro. de Cuenta:</b>"), "valor" => to_utf16("Cuenta #{diplomado_cohorte.cuenta_bancaria_tipo} Nro. #{diplomado_cohorte.cuenta_bancaria_numero}") }
    datos << { "nombre" => to_utf16("<b>A nombre de:</b>"), "valor" => to_utf16("#{diplomado_cohorte.cuenta_bancaria_cliente}") }
    datos << { "nombre" => to_utf16("<b>Forma de pago:</b>"), "valor" => to_utf16("#{inscripcion.tipo_forma_pago.descripcion}") }
    if usuario.inscripcion.tipo_forma_pago_id == TipoFormaPago::UNICO
      datos << { "nombre" => to_utf16("<b>Pago:</b>"), "valor" => to_utf16("#{diplomado_cohorte.inversion} BsF. (Al momento de la inscripción)") }
      datos << { "nombre" => to_utf16("<b>Nro. de depósito:</b>"), "valor" => to_utf16("_____________________________") }

    elsif usuario.inscripcion.tipo_forma_pago_id == TipoFormaPago::MITAD  
      datos << { "nombre" => to_utf16("<b>Pago 1:</b>"), "valor" => to_utf16("#{(diplomado_cohorte.inversion/2)} BsF. (Al momento de la inscripción)") }
      datos << { "nombre" => to_utf16("<b>Nro de depósito:</b>"), "valor" => to_utf16("_____________________________") }
    end
    tabla.data.replace datos  
    tabla.render_on(pdf)
    pdf.text "\n", :font_size => paraph_font_size
    
    # ---- NORMAS -----
		pdf.text to_utf16("LEA CUIDADOSAMENTE LA SIGUIENTE INFORMACIÓN:"), :font_size => paraph_font_size
    pdf.text to_utf16("<b>Reglamento que rige los cursos de Diplomados dictados bajo responsabilidad de la Universidad Central de Venezuela.</b>"), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<b>Resolución N° 014006 del Núcleo de Vicerrectores Académicos sesión realizada el 21 y 22 de septiembre de 2006).</b>"), :font_size => paraph_font_size, :justification => :full
    pdf.text "\n", :font_size => paraph_font_size
    pdf.text to_utf16("Artículo 1.- Los cursos denominados Diplomados forman parte de los programas de educación continua y permanente enmarcados en la política de extensión de la UCV para la difusión y aplicación del conocimiento. Son de carácter divulgativo y práctico por lo que no son susceptibles a reconocimiento de créditos académicos ni de equivalencias en los programas de estudios de pre ni de postgrados."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("Articulo 2.- Son cursos abiertos y dinámicos, no requieren necesariamente que el participante posea grado académico y podrán cursarlo aquellos egresados de  educación superior que requieran ampliar o mejorar los oficios o competencias ligados a su práctica profesional."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("El Diplomado en enseñanza de español como segunda lengua (2L) ofrece las herramientas para la enseñanza del español a hablantes de otras lenguas y está dirigido a los profesionales que ejercen la docencia o que aspiran a ejercerla."), :font_size => paraph_font_size, :justification => :full
	pdf.text "\n", :font_size => paraph_font_size
    pdf.text to_utf16("<C:bullet/>El Diplomado en enseñanza de español como segunda lengua tendrá una duración de 130 horas académicas presenciales."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>La asistencia a clases es obligatoria. El profesor de cada curso tomará la asistencia al inicio de la clase. El participante que llegue con retardo se le tomará la asistencia a partir del momento de su llegada. Todos los participantes deberán firmar la hoja de asistencia en cada clase. Cualquier olvido será de su entera responsabilidad. Ningún participante puede firmar por otro."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>Para aprobar el Diplomado debe cumplir con el 75% de la asistencia; se reprueba con el 25% de inasistencias (32,5 horas)."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>Se considerará aplazado el curso con el 50% de inasistencias (8 horas)."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>El horario de clases será los sábados, de 9:00 a 12:30 para los cursos de 4 horas académicas, y de 8:30 am a 12:30 pm para los cursos de 5 horas sabatinas. En los casos en que sea necesario, el profesor podrá extender el horario de la clase, de previo acuerdo con los participantes."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>Para obtener el certificado del Diplomado al finalizar el período académico, el participante deberá aprobar la totalidad de los cursos del programa. Los certificados emitidos por la Facultad de Humanidades y Educación de la UCV, sólo dan constancia de que el participante culminó satisfactoriamente con el programa académico."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>Las evaluaciones serán informadas por el profesor al inicio de cada curso, y los participantes tienen la obligación de presentarlas en la fecha fijada por el profesor. Si el participante no puede presentar en la fecha acordada deberá comunicarlo al profesor y presentarlo en la semana posterior a la culminación del curso."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>Queda establecido que sobre la escala de 20 puntos la nota mínima aprobatoria es de 15 puntos."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>La Escuela de Idiomas Modernos se reserva el derecho de postergar  el inicio de clases o anular el Diplomado si el número de inscritos no llega al mínimo establecido (20). En dicho caso se reintegrará el monto de la matrícula, previa presentación de la copia del depósito al personal de administración."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>Se establece como sede la Escuela de Idiomas Modernos de la UCV en la Ciudad Universitaria, Los Chaguaramos, Caracas. Los cursos se impartirán en el edificio de Trasbordo, segundo piso, sede de la Escuela de Idiomas Modernos. El aula se indicará en fecha próxima al inicio de las clases."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>Los programas y el material didáctico de cada curso se entregarán digitalizados en un CD al inicio del primer día de clases;  cuando sea necesario y el profesor lo considere pertinente, se suministrará el material a través de la red,  y dicha acción será informada a los participantes."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>En caso de suspensión de actividades por motivos ajenos a nuestra voluntad se recuperarán las clases con reprogramación del cronograma de actividades, previo aviso a los participantes y en común acuerdo con los profesores."), :font_size => paraph_font_size, :justification => :full
    pdf.text to_utf16("<C:bullet/>Queda establecido que el monto de la inversión por el Diplomado debe ser cancelado en su totalidad antes del inicio de clases. En aquellos casos en que el participante decida suspender el Diplomado no se devolverá dinero, una vez iniciado el periodo de clases. El pago de la matrícula no es garantía de aprobación del Diplomado. Para cualquier información o consulta diríjase al correo: diplomado.ele.eim.ucv@gmail.com."), :font_size => paraph_font_size, :justification => :full

    # -- FIRMAS -----

    pdf.text "\n\n", :font_size => 7
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
    datos << { "nombre" => to_utf16("Firma Participante"), "valor" => to_utf16("Firma Autorizada y Sello") }
    tabla.data.replace datos  
    tabla.render_on(pdf)
 		pdf.text "\n", :font_size => 7
  end


end