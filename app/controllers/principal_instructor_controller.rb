class PrincipalInstructorController < ApplicationController

  def index
  end
  
  def ver_secciones
    @titulo_pagina = "Selecionar Curso"
    @secciones = Seccion.where(:instructor_ci => session[:usuario].ci,
                               :esta_abierta => true,
                               :periodo_id => session[:parametros][:periodo_actual]).uniq.sort_by{|x| Seccion.idioma(x.idioma_id)}
    if @secciones.size == 0
      flash[:mensaje] = "Actualmente no existe ninguna sección"
    end
  end  

  def mostrar_estudiantes
    session[:periodo_id] = params[:p]
    session[:idioma_id] = params[:i]
    session[:tipo_categoria_id] = params[:tc]
    session[:tipo_nivel_id] = params[:tn]
    session[:seccion_numero] = params[:sn]
    @historiales, @usuarios = historiales_usuarios
    historial = @historiales.first
    @titulo_pagina = "Listado de estudiantes"
    @curso = "#{Seccion.idioma(historial.idioma_id)}"
    @horario = Seccion.horario(session)
    @seccion = session[:seccion_numero]
    @nivel = historial.tipo_nivel.descripcion
    @aula = historial.seccion.aula_corta
    if @historiales.size == 0
      flash[:mensaje] = "Actualmente no existe ningún estudiante en esta sección"
    end
  end
  

  def generar_pdf
    @historiales,@usuarios = historiales_usuarios
    historial = @historiales.first
    info_bitacora("Usuario #{session[:usuario].nombre_completo} generó  listado de los alumnos en formato pdf del curso #{Seccion.idioma(historial.idioma_id)}, horario #{Seccion.horario(session)}, seccion #{session[:seccion_numero]},periodo #{session[:parametros][:periodo_calificacion]}")
    pdf = DocumentosPDF.listado(@historiales,session)
    send_data pdf.render,:filename => "listado.pdf",
                         :type => "application/pdf", :disposition => "attachment"
  end

end
