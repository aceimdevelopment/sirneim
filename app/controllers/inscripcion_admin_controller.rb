# encoding: utf-8

class InscripcionAdminController < ApplicationController
  
  before_filter :filtro_logueado
  before_filter :filtro_administrador
  
  def buscar
    @titulo = "Participante"
    @url = "/aceim_diplomados/inscripcion_admin/encontrar"
    @nuevo = params[:nuevo]
    @usuario_ci = params[:usuario_ci]
    session[:inscripcion] = true

    @sin_diplomados_ofertados = DiplomadoCohorte.where(:cohorte_id => Cohorte.actual.id).count < 1
    flash[:alert] = "No se encontraron diplomados ofertados para esta Cohorte. Primero gestione los diplomados para esta cohorte." if @sin_diplomados_ofertados
     
  end

  def encontrar
    usuario_ci = params[:usuario][:ci]
    unless @usuario = Usuario.where(:ci => usuario_ci).limit(1).first
      redirect_to :action => "buscar", :nuevo => true, usuario_ci: usuario_ci
    else
      if not estudiante = Estudiante.where(usuario_ci: usuario_ci).limit(1).first
        estudiante = Estudiante.new
        estudiante.usuario_ci = usuario_ci
        flash[:success] = "Estudiante Registrado" if estudiante.save!
      end

    # cohorte_actual = Cohorte.actual
    # diplomados_ofertados = DiplomadoCohorte.where(:cohorte_id => cohorte_actual.id)
    # inscripciones = Inscripcion.where(:estudiante_ci => estudiante.usuario_ci, :cohorte_id => cohorte_actual.id)

    # diplomados_ofertados.each do |oferta|
    #   if inscripcion = inscripciones.where(:diplomado_id => oferta.diplomado_id, :cohorte_id => oferta.cohorte_id).limit(1).first


      session[:estudiante] = estudiante
      redirect_to :controller => 'inscripcion', :action => 'paso0'
    end

  end


  def gestionar
    @cohorte_actual = Cohorte.actual
    @diplomados_ofertados = DiplomadoCohorte.where(:cohorte_id => @cohorte_actual.id)
    @diplomado_actual_id = params[:diplomado_actual_id]

    @lista_actual = params[:lista_actual].nil? ? "" : params[:lista_actual]
    @lista_actual = "#{@diplomado_actual_id}_#{@lista_actual}"

    # @grupos = Grupo.all
    # @tipo_forma_pago = TipoFormaPago.all
  end
  
  def planilla_inscripcion
    ci, idioma_id, tipo_categoria_id, tipo_nivel_id, periodo_id, seccion_numero = params[:historial].split","
    @historial = HistorialAcademico.where(
      usuario_ci: ci,
      idioma_id:  idioma_id,
      tipo_categoria_id:  tipo_categoria_id,
      :periodo_id => periodo_id).limit(1).first
    info_bitacora "Se busco la planilla de inscripcion desde el  ADMIN en #{@historial.seccion.descripcion_con_periodo}"
    pdf = DocumentosPDF.planilla_inscripcion(@historial)
    send_data pdf.render,:filename => "planilla_inscripcion_#{ci}.pdf",
                         :type => "application/pdf", :disposition => "attachment"
  end  

  def admitir
    diplomado_id = params[:id][2]
    @inscrito = Inscripcion.find(params[:id])

    @inscrito.tipo_estado_inscripcion_id = "APR"
    @diplomados_ofertados = DiplomadoCohorte.where(:cohorte_id => Cohorte.actual.id)
    # if @inscripcion.save
    #   render :parcial => "diplomados"
    # else
    #   render "gestionar"
    # end

    respond_to do |format|
      if @inscrito.save
        info_bitacora "#{session[:administrador].usuario_ci} Aprobó Preinscrito #{@inscrito.id}"
        flash[:success] = "Estudiante Admitido"
        format.html { redirect_to :action => "gestionar", :diplomado_actual_id => diplomado_id, :lista_actual => "preinscritos"}
        format.json { render :json => @inscrito, :status => :created, :location => @inscrito }
        format.js
      else
        format.html { render :action => "gestionar" }
        # format.json { render :json => @inscrito.errors, :status => :unprocessable_entity }
        format.json { render :json => @inscrito.errors, :status => :unprocessable_entity }
        format.js
      end
    end

  end

  def desaprobar
    diplomado_id = params[:id][2]
    @inscrito = Inscripcion.find(params[:id])

    @inscrito.tipo_estado_inscripcion_id = "PRE"
    @diplomados_ofertados = DiplomadoCohorte.where(:cohorte_id => Cohorte.actual.id)
    # if @inscripcion.save
    #   render :parcial => "diplomados"
    # else
    #   render "gestionar"
    # end

    respond_to do |format|
      if @inscrito.save
        info_bitacora "#{session[:administrador].usuario_ci} Desaprobó Preinscrito #{@inscrito.id}"
        flash[:alert] = "Estudiante Rechazado"
        format.html { redirect_to :action => "gestionar", :diplomado_actual_id => diplomado_id, :lista_actual => "preinscritos"}
        format.json { render :json => @inscrito, :status => :created, :location => @inscrito }
        format.js
      else
        format.html { render :action => "gestionar" }
        # format.json { render :json => @inscrito.errors, :status => :unprocessable_entity }
        format.json { render :json => @inscrito.errors, :status => :unprocessable_entity }
        format.js
      end
    end

  end

  def asignar
    inscripcion = params[:inscripcion]
    @inscrito = Inscripcion.find(inscripcion[:id])
    @diplomados_ofertados = DiplomadoCohorte.where(:cohorte_id => Cohorte.actual.id)

    @inscrito.tipo_estado_inscripcion_id = "INS"

    respond_to do |format|
      if @inscrito.update_attributes(inscripcion)
        flash[:success] = "Inscripción Completada y grupo asociado"
        info_bitacora "#{session[:administrador].usuario_ci} Asigno Aprobado #{@inscrito.id}"

        format.html { redirect_to :action => "gestionar", :diplomado_actual_id => @inscrito.diplomado_id, :lista_actual => "aprobados"}
        format.json { render :json => @inscrito, :status => :created, :location => @inscrito }
        format.js
      else
        format.html { render :action => "gestionar" }
        # format.json { render :json => @inscrito.errors, :status => :unprocessable_entity }
        format.json { render :json => @inscrito.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def retirar
    diplomado_id = params[:id][2]
    @inscrito = Inscripcion.find(params[:id])

    @inscrito.tipo_estado_inscripcion_id = "APR"

    @inscrito.grupo = nil
    # @inscrito.tipo_forma_pago_id = nil
    @diplomados_ofertados = DiplomadoCohorte.where(:cohorte_id => Cohorte.actual.id)
    # if @inscripcion.save
    #   render :parcial => "diplomados"
    # else
    #   render "gestionar"
    # end

    respond_to do |format|
      if @inscrito.save
        info_bitacora "#{session[:administrador].usuario_ci} Desaprobó Preinscrito #{@inscrito.id}"
        flash[:alert] = "Estudiante Desaprobado"
        format.html { redirect_to :action => "gestionar", :diplomado_actual_id => diplomado_id, :lista_actual => "aprobados"}
        format.json { render :json => @inscrito, :status => :created, :location => @inscrito }
        format.js
      else
        flash[:alert] = "Error al intentar retirar: "
        @inscrito.errors.full_messages.each do |msg|
          flash[:alert] += "#{msg}\n"
        end
        format.html { render :action => "gestionar" }
        # format.json { render :json => @inscrito.errors, :status => :unprocessable_entity }
        format.json { render :json => @inscrito.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def eliminar_preinscrito
    @preinscripcion = Inscripcion.find(params[:id])
    @preinscripcion.destroy
    flash[:info] = "Participante desincorporado"
    redirect_to :controller => 'inscripcion_admin', :action => 'gestionar'
  end

  # def paso1      
  #   @titulo_pagina = "Preinscripción - Admin"  
  #   @subtitulo_pagina = "Actualización de Datos Personales"
  #   @usuario = session[:especial_usuario]
  # end  

  # def paso1_guardar
  #   usr = params[:usuario]
  #   if @usuario = Usuario.where(:ci => usr[:ci]).limit(1).first
  #     @usuario.ultima_modificacion_sistema = Time.now
  #     @usuario.nombres = usr[:nombres]
  #     @usuario.apellidos = usr[:apellidos]
  #     @usuario.correo = usr[:correo]
  #     @usuario.telefono_habitacion = usr[:telefono_habitacion]
  #     @usuario.telefono_movil = usr[:telefono_movil]
  #     @usuario.direccion = usr[:direccion] 
  #     if @usuario.contrasena == nil || @usuario.contrasena == "" || @usuario.contrasena.empty?
  #       @usuario.contrasena = usr[:ci]
  #       @usuario.contrasena_confirmation = usr[:ci]
  #     else                                         
  #       @usuario.contrasena_confirmation = @usuario.contrasena
  #     end                                                     
      
  #     @usuario.tipo_sexo_id = usr[:tipo_sexo_id]
  #     @usuario.fecha_nacimiento = usr[:fecha_nacimiento]
  #     session[:especial_usuario] = @usuario
      
  #     if @usuario.save 
  #       info_bitacora "Paso1 realizado"
  #       redirect_to :action => "paso1_1"
  #     else
  #       @titulo_pagina = "Preinscripción - Admin"  
  #       @subtitulo_pagina = "Actualización de Datos Personales"
  #       render :action => "paso1"
  #     end
  #   else
  #     flash[:mensaje] = "Error Usuario no encontrado #{usr[:ci]}"
  #     render :action => "paso1"
  #   end
  # end
  
  # def paso1_1
  #   @titulo_pagina = "Preinscripción - Admin"  
  #   @subtitulo_pagina = "Selección de Nivel"
  #   @usuario = session[:especial_usuario]
  #   @tipo_curso = session[:especial_tipo_curso] 
  #   @niveles = Seccion.where(idioma_id:  @tipo_curso.idioma_id,
  #     tipo_categoria_id:  @tipo_curso.tipo_categoria_id,
  #     :periodo_id => session[:parametros][:periodo_inscripcion]).collect{|x| x.curso}.uniq.sort_by{|y| y.grado}.collect{|w| w.tipo_nivel}
  # end
  
  # def paso1_1_guardar
  #   session[:especial_nivel] = params[:seleccion][:nivel]
  #   redirect_to :action => "paso2"
  # end
  
  # def paso2
  #   @titulo_pagina = "Preinscripción - Admin"
  #   @subtitulo_pagina = "Selección de Sección"
  #   @tipo_nivel = TipoNivel.find session[:especial_nivel]
  #   ec = EstudianteCurso.find(session[:especial_usuario].ci, 
  #     session[:especial_tipo_curso].idioma_id, 
  #     session[:especial_tipo_curso].tipo_categoria_id)
  #   @ec = ec
  #   @secciones = Seccion.where(
  #     :periodo_id => session[:parametros][:periodo_actual],
  #     idioma_id:  ec.idioma_id,
  #     tipo_categoria_id:  ec.tipo_categoria_id,
  #     :tipo_nivel_id => session[:especial_nivel]
  #     ).sort_by{|s| s.cupo}
  # end

  # def paso2_guardar
  #   ec = EstudianteCurso.find(session[:especial_usuario].ci, 
  #     session[:especial_tipo_curso].idioma_id, 
  #     session[:especial_tipo_curso].tipo_categoria_id) 
  #   periodo_id, idioma_id, tipo_categoria_id, tipo_nivel_id, seccion_numero = params[:datos][:seccion].split","
  #   @historial = HistorialAcademico.new
  #   @historial.usuario_ci = session[:especial_usuario].ci
  #   @historial.tipo_categoria_id = tipo_categoria_id
  #   @historial.idioma_id = idioma_id
  #   @historial.periodo_id = periodo_id
  #   @historial.tipo_convenio_id = ec.tipo_convenio_id 
  #   @historial.tipo_nivel_id = tipo_nivel_id 
  #   @historial.tipo_estado_calificacion_id = "SC"
  #   @historial.tipo_estado_inscripcion_id = "INS"
  #   @historial.cuenta_bancaria_id = @historial.cuenta_nueva
  #   @historial.nota_final = -2
  #   @historial.numero_deposito = ""
  #   @historial.seccion_numero = seccion_numero
    
  #   if HistorialAcademico.where(
  #     usuario_ci: @historial.usuario_ci,
  #     idioma_id:  @historial.idioma_id,
  #     tipo_categoria_id:  @historial.tipo_categoria_id,
  #     :periodo_id => @historial.periodo_id
  #     ).limit(1).first
  #     flash[:mensaje] = "El estudiante ya estaba inscrito en este periodo"
  #     info_bitacora "El estudiante ya estaba inscrito en este periodo"
  #     redirect_to :action => "principal", :controller => "principal"
  #     return
  #   end
    
  #   @historial.save  
  #   @historial.crear_asistencia
    
  #   info_bitacora "Paso 2 realizado inscripcion realizada en #{@historial.seccion.descripcion_con_periodo}"
  #   flash[:mensaje] = "Inscripción realizada"
  #   redirect_to :action => "paso3"
  # end

  # def paso3 
  #   @titulo_pagina = "Inscripción - Admin"  
  #   @subtitulo_pagina = "Impresión de Planilla"
  #   @historial = HistorialAcademico.where(
  #     usuario_ci: session[:especial_usuario].ci,
  #     idioma_id:  session[:especial_tipo_curso].idioma_id,
  #     tipo_categoria_id:  session[:especial_tipo_curso].tipo_categoria_id,
  #     :periodo_id => session[:parametros][:periodo_actual]).limit(1).first
  # end

  # def paso3_guardar                                              
  #   flash[:mensaje] = "Preinscripción finalizada"
  #   redirect_to :action => "principal", :controller => "principal"
  # end     

end
