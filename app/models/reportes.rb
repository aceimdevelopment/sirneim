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


  def self.planilla_inscripcion_pagina(usuario,pdf)
    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 465, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710+10, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 45, 710, 50,nil
    #pdf.add_image_from_file Rutinas.crear_codigo_barra(historial_academico.usuario_ci), 450-10, 500+35, nil, 120
    pdf.add_text 480-10,500+35,to_utf16("---- #{usuario.ci} ----"),11
    
    #texto del encabezado
    pdf.add_text 100,745,to_utf16("Universidad Central de Venezuela"),11
    pdf.add_text 100,735,to_utf16("Facultad de Humanidades y Educación"),11
    pdf.add_text 100,725,to_utf16("Escuela de Idiomas Modernos"),11
    pdf.add_text 100,715,to_utf16("Diplomado en enseñanza de español como 2/L"),11 
    

    #titulo    
    pdf.text "\n\n\n\n\n"
    pdf.text to_utf16("Planilla de Inscripción\n"), :font_size => 14, :justification => :center
    #pdf.text to_utf16("Periodo #{historial_academico.periodo_id}"), :justification => :center

    # ------- DATOS DE LA PREINSCRIPCIO -------
		pdf.text "\n", :font_size => 10
		pdf.text to_utf16("<b>Datos de la Inscripción:</b>"), :font_size => 12
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
    
    datos << { "nombre" => to_utf16("<b>Estudiante:</b>"), "valor" => to_utf16("#{usuario.descripcion}\n#{usuario.datos_contacto}") }
    datos << { "nombre" => to_utf16("<b>Horario:</b>"), "valor" => to_utf16("Sábado 9:00 a 12:30 pm (4 horas académicas semanales)") }
    datos << { "nombre" => to_utf16("<b>Aula:</b>"), "valor" => to_utf16("Aula 230 del 2do. piso de Trasbordo, Av. Minerva.") }
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
    datos << { "nombre" => to_utf16("<b>Nro. de Cuenta:</b>"), "valor" => to_utf16("Cuenta Corriente Nro. 0102-0491-7100-0938-5674") }
    datos << { "nombre" => to_utf16("<b>A nombre de:</b>"), "valor" => to_utf16("Ingresos propios de la Universidad Central de Venezuela") }
    datos << { "nombre" => to_utf16("<b>Forma de pago:</b>"), "valor" => to_utf16("usuario.inscripcion.tipo_forma_pago.descripcion") }
    if usuario.inscripcion.tipo_forma_pago_id == TipoFormaPago::UNICO
      datos << { "nombre" => to_utf16("<b>Pago:</b>"), "valor" => to_utf16("6.000 BsF. (Al momento de la inscripción)") }
      datos << { "nombre" => to_utf16(" "), "valor" => to_utf16(" ") }
      datos << { "nombre" => to_utf16("<b>Nro de depósito:</b>"), "valor" => to_utf16("_____________________________") }

    else
      datos << { "nombre" => to_utf16("<b>Pago 1:</b>"), "valor" => to_utf16("3.000 BsF. (Al momento de la inscripción)") }
      datos << { "nombre" => to_utf16("<b>Pago 2:</b>"), "valor" => to_utf16("1.500 BsF. (30 de Octubre de 2012)") }
      datos << { "nombre" => to_utf16("<b>Pago 3:</b>"), "valor" => to_utf16("1.500 BsF. (1 de Diciembre de 2012)") }
      datos << { "nombre" => to_utf16(" "), "valor" => to_utf16(" ") }
      datos << { "nombre" => to_utf16("<b>Nro de depósito (Pago 1):</b>"), "valor" => to_utf16("_____________________________") }

    end
    tabla.data.replace datos  
    tabla.render_on(pdf)
    pdf.text "\n", :font_size => 10
    
    # ---- NORMAS -----
		pdf.text to_utf16("<b>IMPORTANTE</b>"), :font_size => 12
		pdf.text "\n", :font_size => 10
    pdf.text to_utf16("<C:bullet/>La Escuela de Idiomas Modernos se reserva el derecho de postergar el inicio de clases o anular el Diplomado si el número de inscritos no llega al mínimo establecido de 25 participantes, en cuyo caso se reintegrará el monto de la matrícula."), :font_size => 11, :justification => :full
		pdf.text to_utf16("<C:bullet/>La asistencia a clases es obligatoria. Sólo se permite 1 inasistencia por módulo."), :font_size => 11, :justification => :full
    pdf.text to_utf16("<C:bullet/>Únicamente DEPOSITOS en EFECTIVO (NO CHEQUES)."), :font_size => 11, :justification => :full
    pdf.text to_utf16("<C:bullet/>El voucher asociado al primer pago junto a la planilla deben ser entregados del lunes 17 al jueves 20 de sepetiembre de 2012 en extensión de (FUNDEIM) a partir de las 3pm."), :font_size => 11, :justification => :full

    # -- FIRMAS -----
		pdf.text "\n", :font_size => 8
		pdf.text "\n", :font_size => 8
		pdf.text "\n", :font_size => 8
		pdf.text "\n", :font_size => 8
    pdf.text "\n", :font_size => 8
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

  def self.planilla_inscripcion(usuario=nil)
    pdf = PDF::Writer.new(:paper => "letter")  #:orientation => :landscape, 
    t = Time.now

    planilla_inscripcion_pagina(usuario,pdf)
		pdf.text to_utf16("----- COPIA DEL ESTUDIANTE -----"), :font_size => 12, :justification => :center
		pdf.text "\n", :font_size => 8
		pdf.text to_utf16("#{t.strftime('%d/%m/%Y %I:%M%p')} - Página: 1 de 2"), :font_size => 10, :justification => :right
		
    pdf.new_page
    pdf.y = 756
    planilla_inscripcion_pagina(usuario,pdf)
		pdf.text to_utf16("----- COPIA ADMINISTRACIÓN -----"), :font_size => 12, :justification => :center
		pdf.text "\n", :font_size => 8
		pdf.text to_utf16("#{t.strftime('%d/%m/%Y %I:%M%p')} - Página: 2 de 2"), :font_size => 10, :justification => :right
   
    return pdf
  end
end