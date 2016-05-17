# encoding: utf-8

class AsistenciaController < ApplicationController
  
  before_filter :filtro_logueado
  before_filter :filtro_administrador

  def seleccionar_curso
    @titulo_pagina = "Seleccionar curso"
    if session[:instructor]
      @seccion = Seccion.where(:instructor_ci => session[:usuario].ci, 
                             :esta_abierta => true,
                             :periodo_id => session[:parametros][:periodo_actual]).uniq.sort_by{|x| Seccion.idioma(x.idioma_id)}
    elsif session[:administrador]
      @seccion = Seccion.where(:esta_abierta => true,
                               :periodo_id => session[:parametros][:periodo_actual]).uniq.sort_by{|x| Seccion.idioma(x.idioma_id)}
    end
    
    if @seccion.size == 0 
      flash[:mensaje] = "Actualmente no posee nigún curso"
    end
  end

  def buscar_estudiantes
    saltar = true
    if params[:saltar] == nil
      saltar = true
    else
      saltar = false
    end
    if saltar
      session[:periodo_id] = params[:p]
      session[:idioma_id] = params[:i]
      session[:tipo_categoria_id] = params[:tc]
      session[:tipo_nivel_id] = params[:tn]
      session[:seccion_numero] = params[:sn]
    end
    @historiales = HistorialAcademico.where(:periodo_id => session[:periodo_id],
                                              :idioma_id => session[:idioma_id],
                                              :tipo_categoria_id => session[:tipo_categoria_id],
                                              :tipo_estado_inscripcion_id => "INS",
                                              :tipo_nivel_id => session[:tipo_nivel_id],
                                              :seccion_numero => session[:seccion_numero]
                                             )
    @historiales = @historiales.sort_by{|x| x.usuario.nombre_completo}
    historial = @historiales.first
    @titulo_pagina = "Control de asistencia"
    @curso = "#{Seccion.idioma(historial.idioma_id)}"
    @horario = Seccion.horario(session)
    @seccion = session[:seccion_numero]
    @nivel = historial.tipo_nivel.descripcion
    @instructor = historial.seccion.instructor.usuario.nombre_completo
    @justificaciones = TipoJustificacion.all
    #verificando que no tenga todos los dias asistidos
    #if historial.asistencia_completa(session[:periodo_actual])
    #  redirect_to :action => :ver_asistencia
    #  return
    #end
  end

  def guardar_asistencia
    params[:asistencia].each_pair{|clave,valor|
      cedula = clave.split("_")[0]
      clase = clave.split("_")[1]
      asistencia = valor.to_i
      cedula_admin = session[:administrador] ? session[:administrador].usuario_ci : nil
      if (!params["fecha_#{clase}".to_sym] || params["fecha_#{clase}".to_sym] == "") && cedula_admin != "10264009"
        flash[:mensaje] = "Debe indicar la fecha de la clase"
        redirect_to :action => :buscar_estudiantes, :saltar => "s"
        return
      end



      if !((!params["fecha_#{clase}".to_sym] || params["fecha_#{clase}".to_sym] == "") && cedula_admin == "10264009")
        control = AsistenciaEnCurso.where(:historial_academico_usuario_ci => cedula,
                                        :historial_academico_idioma_id => session[:idioma_id],
                                        :historial_academico_tipo_categoria_id => session[:tipo_categoria_id],
                                        :historial_academico_tipo_nivel_id => session[:tipo_nivel_id],
                                        :historial_academico_periodo_id => session[:periodo_id],
                                        :historial_academico_seccion_numero => session[:seccion_numero],
                                        :clase => clase).limit(0).first
        control.asistencia = asistencia
        control.esta_tomada = true
        fecha = params["fecha_#{clase}".to_sym].split("/").join("-")
        control.fecha_asistencia = Date.parse(fecha)
        if params["combo_#{cedula}"]["#{clase}"] 
          control.tipo_justificacion_id = params["combo_#{cedula}"]["#{clase}"]
        end
        control.fecha_hora_registro = Time.now
        control.save
      end
    }
    flash[:mensaje] = "Asistencia almacenada satisfactoriamente"
    redirect_to :action => :buscar_estudiantes, :saltar => "s"
    return
  end


  def asistencia_pdf
    historiales = HistorialAcademico.where(:periodo_id => session[:periodo_id],
                                              :idioma_id => session[:idioma_id],
                                              :tipo_categoria_id => session[:tipo_categoria_id],
                                              :tipo_estado_inscripcion_id => "INS",
                                              :tipo_nivel_id => session[:tipo_nivel_id],
                                              :seccion_numero => session[:seccion_numero]
                                             )
    historiales = historiales.sort_by{|x| x.usuario.nombre_completo}
    historial = historiales.first
    datos ={
      :historiales => historiales,
      :titulo => "Control de asistencia",
      :curso => "#{Seccion.idioma(historial.idioma_id)}",
      :horario => Seccion.horario(session),
      :seccion => session[:seccion_numero],
      :nivel => historial.tipo_nivel.descripcion,
      :periodo => session[:periodo_id]
    }
    pdf = DocumentosPDF.asistencia(datos,historiales)
    send_data pdf.render,:filename => "asistencia_#{historial.tipo_nivel.descripcion}_#{session[:periodo_id]}.pdf",
                         :type => "application/pdf", :disposition => "attachment"

  end

end
