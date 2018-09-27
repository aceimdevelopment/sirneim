# encoding: utf-8

class DocumentosPDF

  def self.to_utf16(valor)
    ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    ic_ignore.iconv(valor)
  end

  def self.cal_notas(seccion)
    pdf = PDF::Writer.new
    pdf.margins_cm(1.8)
    
    
    pdf.add_image_from_file 'app/assets/images/logo_fhe_ucv.jpg', 465, 710, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_eim.jpg', 515, 710+10, 50,nil
    pdf.add_image_from_file 'app/assets/images/logo_ucv.jpg', 45, 710, 50,nil
 
    #texto del encabezado
    pdf.add_text 100,745,to_utf16("Universidad Central de Venezuela"),11
    pdf.add_text 100,735,to_utf16("Facultad de Humanidades y Educación"),11
    pdf.add_text 100,725,to_utf16("Escuela de Idiomas Modernos"),11
    pdf.add_text 100,715,to_utf16("Coordinación Académica"),11

    #titulo    
    pdf.add_text_wrap 50,650,510,to_utf16("Sección: #{seccion.descripcion} / Periodo: #{seccion.cal_semestre_id} / U. Créditos: #{seccion.cal_materia.creditos}"), 12,:center

    #instructor
    pdf.add_text_wrap 50,600,510,to_utf16("Profesor: #{seccion.cal_profesor.cal_usuario.descripcion}"),10
 
    if seccion.cal_semestre_id.eql? '2016-02A'
      estudiantes_seccion = seccion.cal_estudiantes_secciones.confirmados.sort_by{|h| h.cal_estudiante.cal_usuario.apellidos}
    else
      estudiantes_seccion = seccion.cal_estudiantes_secciones.sort_by{|h| h.cal_estudiante.cal_usuario.apellidos}
    end

    if seccion.cal_materia.cal_categoria_id.eql? 'IB' or seccion.cal_materia.cal_categoria_id.eql? 'LIN' or seccion.cal_materia.cal_categoria_id.eql? 'LE'
      p1 = 25 
      p2 =35
      p3 = 40
    else
      p1 = p2 =30
      p3 = 40
    end

    pdf.text "\n"*18
    tabla = PDF::SimpleTable.new
    tabla.heading_font_size = 8
    tabla.font_size = 8
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
    
    tabla.column_order = ["#", "nombre", "cedula", "nota1","nota2","nota3","final", "tipo", "estado"]

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
      col.heading = "<b>Nombre</b>"
      col.heading.justification = :left
      col.justification = :left
    }
      tabla.columns["nota1"] = PDF::SimpleTable::Column.new("nota1") { |col|
        col.width = 32
        col.heading = to_utf16("<b>(#{p1}%)</b>")
        col.heading.justification = :center
        col.justification = :center
      }
      tabla.columns["nota2"] = PDF::SimpleTable::Column.new("nota2") { |col|
        col.width = 32
        col.heading = to_utf16("<b>(#{p2}%)</b>")
        col.heading.justification = :center
        col.justification = :center
      }
      tabla.columns["nota3"] = PDF::SimpleTable::Column.new("nota3") { |col|
        col.width = 32
        col.heading = to_utf16("<b>(#{p3}%)</b>")
        col.heading.justification = :center
        col.justification = :center
      }
      tabla.columns["final"] = PDF::SimpleTable::Column.new("final") { |col|
        col.width = 32
        col.heading = to_utf16("<b>Final</b>")
        col.heading.justification = :center
        col.justification = :center
      }
      tabla.columns["tipo"] = PDF::SimpleTable::Column.new("tipo") { |col|
        col.width = 33
        col.heading = to_utf16("<b>Desc Calif</b>")
        col.heading.justification = :center
        col.justification = :center
      }

      tabla.columns["estado"] = PDF::SimpleTable::Column.new("estado") { |col|
        col.heading = to_utf16("<b>Estado</b>")
        col.heading.justification = :center
        col.justification = :center
      }

    data = []

    estudiantes_seccion.each_with_index do |h,i|
      estado = h.cal_tipo_estado_calificacion.descripcion.to_s
      estado = 'Retirada' if h.retirada?
      data << {"#" => "#{i+1}",
        "cedula" => to_utf16(h.cal_estudiante_ci),
        "nombre" => to_utf16(h.cal_estudiante.cal_usuario.descripcion_apellido),
        "nota1" => to_utf16(h.calificacion_primera.to_s),
        "nota2" => to_utf16(h.calificacion_segunda.to_s),
        "nota3" => to_utf16(h.calificacion_tercera.to_s),
        "final" => to_utf16(h.calificacion_final.to_i.to_s),
        "tipo" => to_utf16(h.tipo_calificacion),
        "estado" => to_utf16(estado),
      }

    end
    tabla.data.replace data
    tabla.render_on(pdf)
    pdf.add_text 430,50,to_utf16("#{Time.now.strftime('%d/%m/%Y %I:%M%p')} - Página: 1 de 1")
    return pdf
  end

end

