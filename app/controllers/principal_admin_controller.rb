# encoding: utf-8

class PrincipalAdminController < ApplicationController
  
  before_filter :filtro_logueado
  before_filter :filtro_administrador
  
  def index
    if params[:ci]
      flash[:mensaje] = "Correo enviado satisfactoriamente"
    end
    @titulo_pagina = "Opciones del administrador"
    session[:estudiante_ci] = nil
    session[:especial_usuario] = nil
    session[:especial_estudiante] = nil
    session[:especial_rol] = nil
    session[:especial_tipo_curso] = nil
    
  end
  
  def estado_instructores
    @titulo_pagina = "Estado de los Instructores"
    
    notificados = NotificacionCalificacion.where(:periodo_id => session[:parametros][:periodo_calificacion],
                                                 :correo_enviado => true).collect{|n| n.usuario_ci}
                                                 
    @instructores= Seccion.where("periodo_id = ? AND esta_abierta = ?", session[:parametros][:periodo_calificacion],1).collect{|x| x.instructor}.uniq.compact.sort_by{|i| "#{i.estado} #{i.fecha_que_califico(session[:parametros][:periodo_calificacion])}"}
    @instructores = @instructores.delete_if{|x| notificados.index x.usuario_ci}
    @instructores_notificados = Instructor.where(:usuario_ci => notificados).sort_by{|x| x.fecha_notificacion(session[:parametros][:periodo_calificacion])}
  end
  
  def enviar_notificaciones
    no_notificados = NotificacionCalificacion.where(:periodo_id => session[:parametros][:periodo_calificacion],
                                                 :correo_enviado => false).collect{|n| n.usuario_ci}
    @instructores_no_notificados = Instructor.where(:usuario_ci => no_notificados)
    @texto = ""
    @instructores_no_notificados.each{ |ins|
      cantidad = 39 - ins.nombre_completo.size
      @texto = @texto + "#{ins.nombre_completo}"
      cantidad.times{|can|
        @texto+= " "
      }
       @texto += "CI: #{ins.usuario_ci} \n"
    }
    @texto = @texto.strip
    render :layout => false
  end
  
  def enviar_correos
    no_notificados = NotificacionCalificacion.where(:periodo_id => session[:parametros][:periodo_calificacion],
                                                 :correo_enviado => false).collect{|n| n.usuario_ci}
    @instructores_no_notificados = Instructor.where(:usuario_ci => no_notificados).sort_by{|x| x.usuario.nombre_completo}
    texto = "Se notificó a los siguientes instructores: "
    @instructores_no_notificados.each{ |ins|
      ins.guardar_notificacion(session[:parametros][:periodo_calificacion])
      texto += "#{ins.nombre_completo} ci: #{ins.usuario_ci} --- "
    }
    AdministradorMailer.enviar_notificacion(@instructores_no_notificados).deliver
    flash[:mensaje] = "El correo se ha enviado satisfactoriamente"
    info_bitacora(texto)
    redirect_to :action => "estado_instructores"
  end
  
  def habilitar_honorarios
    candidatos = NotificacionCalificacion.where(:periodo_id => session[:parametros][:periodo_calificacion]).collect{|n| n.usuario_ci}
    instructores= Seccion.where("periodo_id = ? AND esta_abierta = ?", session[:parametros][:periodo_calificacion],1).collect{|x| x.instructor}.uniq.delete_if{|x| candidatos.index x.usuario_ci}
    p instructores
    
  end

  def capturar_ci
  end
  
  def confirmacion_rapida
    ci = params[:historial][:usuario_ci]
    periodo_actual=session[:parametros][:periodo_actual]
    cursos = EstudianteCurso.where(:usuario_ci=>ci)
    
    if cursos.size<1
      flash[:mensaje]="Cédula no encontrada"
      redirect_to :action => "capturar_ci"
      return
    end
    if cursos.size>1
      flash[:mensaje]="Tiene varios idiomas, debe hacerlo por gestionar estudiante"
      redirect_to :action => "validar", :controller => "admin_estudiante", :usuario => {:ci => ci}
      return
    end    
    @historial = cursos.first.ultimo_historial
    if @historial.periodo_id!=periodo_actual
      flash[:mensaje]="No está preinscrito en el periodo actual"
      redirect_to :action => "capturar_ci"
      return
    end
    if @historial.tipo_estado_inscripcion_id!="PRE"
      flash[:mensaje]="Ya está confirmado"
      redirect_to :action => "capturar_ci"
      return
    end
    
  end
  
  def confirmacion_rapida_guardar
    idioma_id = params[:historial][:idioma_id]
    tipo_categoria_id = params[:historial][:tipo_categoria_id]
    tipo_nivel_id = params[:historial][:tipo_nivel_id]
    ci = params[:historial][:usuario_ci]
    periodo = session[:parametros][:periodo_actual]
    unless params[:historial][:numero_deposito].eql? ""
      @historial = HistorialAcademico.where(:periodo_id=>periodo, :idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id, :usuario_ci=>ci, :tipo_nivel_id=>tipo_nivel_id).limit(1).first
      @historial.tipo_estado_inscripcion_id = "INS"
      @historial.numero_deposito = params[:historial][:numero_deposito]
  
      if @historial.save
        info_bitacora("Confirmación de Curos: #{@historial.curso.descripcion}")
        flash[:mensaje]="Confirmacion de Inscripcion Exitosa"
        redirect_to :action=> "capturar_ci"
      else
        flash[:mensaje]="no se pudo confirmar la seccion"
        redirect_to :action=> "capturar_ci"
      end
    else
      flash[:mensaje]="debe agregar un numero de depósito"
      respond_to :action=>"capturar_ci"
    end
  end
  
  respond_to do |format|
    if @usuario.save
      flash[:mensaje] = "Instructor Actualizado Satisfactoriamente"
      format.html { redirect_to(:action=>"index") }
    else
      flash[:mensaje] = "Errores en el Formulario impiden que el instructor sea actualizado"
      format.html { render :action => "modificar" }
      format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
    end
  end
  
  def redactar_correo
    @titulo_pagina = "Enviar Correo a Instructores"
    @instructor = Instructor.all.delete_if{|i| !i.seccion_periodo}
    @instructor = @instructor.sort_by{|i| i.usuario.nombre_completo}
    
  end
  
  def enviar_correo
    titulo = params[:correo][:titulo]
    #1/0
    seleccion = params[:seleccion]
    contenido = params[:correo][:contenido]
    intructores_ci = []
    seleccion.each do |s|
      intructores_ci << s.at(0) if s.at(1).eql? "1"
    end
    
    instructores = Instructor.where(:usuario_ci=>intructores_ci)
    destinatarios = instructores.collect{|x| x.usuario.correo}
    destinatarios << "cursosdeidiomas.ucv.eim@gmail.com"
    destinatarios << "sergiorivas@gmail.com"
    destinatarios << "yosamar_morin@provincial.com"
    mail=[]
    destinatarios.each do |i|
    mail = AdministradorMailer.aviso_general(i,titulo,contenido).deliver
    end 
    if mail
      info_bitacora("Correo enviado a instructores: #{titulo}")
      flash[:mensaje] = "Se ha enviado el correo a los instructores seleccionadas" 
    else
      flash[:mensaje] = "En estos momentos no es posible efectuar el envío de correos" 
    end
    redirect_to :action=>"redactar_correo"
    return
  end

  def prueba
    render :layout => "layout"
  end
  
end
