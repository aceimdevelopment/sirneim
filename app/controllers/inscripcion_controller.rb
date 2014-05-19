class InscripcionController < ApplicationController
  before_filter :filtro_logueado
  
  def paso0
    session[:diplomado] = params[:diplomado] if params[:diplomado] 
    @usuario = session[:estudiante].usuario
    @accion = "paso0_guardar"
    @titulo = "Preinscripcion > Paso 0: Actualización de Datos Personales" 
  end

  def paso0_guardar
    @usuario = session[:estudiante].usuario
    # Ajustes menores de Capitalize de nombres, apellidos y nacimiento
    aux = params[:usuario][:nombres]
    aux = aux.split.map(&:capitalize).join(' ') if aux
    params[:usuario][:nombres] = aux

    aux = params[:usuario][:apellidos]
    aux = aux.split.map(&:capitalize).join(' ') if aux
    params[:usuario][:apellidos] = aux

    aux = params[:usuario][:lugar_nacimiento]
    aux = aux.split.map(&:capitalize).join(' ') if aux
    params[:usuario][:lugar_nacimiento] = aux

    @estudiante = Estudiante.where(:usuario_ci => @usuario.ci).first
    @estudiante.cuenta_twitter = params[:estudiante][:cuenta_twitter]
    @estudiante.save

    # fn = params[:usuario][:fecha_nacimiento]
    # dia,mes,año = fn.split("/")
    # params[:usuario][:fecha_nacimiento] = "#{mes}/#{dia}#{año}" 
    if @usuario.update_attributes(params[:usuario])
      flash[:success] = "Datos Actualizados Satisfactoriamente"
      info_bitacora("Usuario: #{@usuario.descripcion} Actualizado.")
      session[:usuario] = @usuario unless session[:administrador]
      session[:estudiante] = @estudiante
      redirect_to :action => "paso1"
    else
      render :action => "paso0"
    end
  end

  def paso1
    @usuario = session[:estudiante].usuario
    @inscripcion = Inscripcion.new
    unless @datos_estudiante = @usuario.datos_estudiante 
      @datos_estudiante = DatosEstudiante.new
    end
    @titulo = "Preinscripcion > Paso 1: Actualización de Datos Académicos"
    @diplomado = session[:diplomado]
  end


  def paso1_guardar
    # datos_estudiante = params[:datos_estudiante]

    @usuario = session[:estudiante].usuario
    unless @datos_estudiante = @usuario.datos_estudiante 
      @datos_estudiante = DatosEstudiante.new params[:datos_estudiante]
    end

    @datos_estudiante.estudiante_ci = @usuario.ci

    
    if @datos_estudiante.save
      unless session[:administrador]
        diplomado_id = session[:diplomado]
        cohorte_actual = Cohorte.actual
        @inscripcion = Inscripcion.new
        @inscripcion.fecha_hora = DateTime.now
        @inscripcion.estudiante_ci = @usuario.ci
        @inscripcion.tipo_estado_inscripcion_id = "PRE"
        @inscripcion.diplomado_id = diplomado_id 
        @inscripcion.cohorte_id = cohorte_actual.id
        @inscripcion.tipo_forma_pago_id = "UNICO"

        if @inscripcion.save
          session[:diplomado] = nil
          flash[:success] = "Inscripción del Diplomado: #{diplomado_id} para la Cohorte: #{cohorte_actual.descripcion}"
          info_bitacora("Preinscripcion de #{@usuario.ci} Satisfactoriamente en Diplomado #{diplomado_id} para Cohorte: #{cohorte_actual.descripcion}")
          redirect_to :controller => "principal"
        else
          render :action => "paso1"
        end
      else
        redirect_to :action => "seleccionar_diplomado"
      end

    else
      render :action => 'paso1'
    end
    
  end

  def seleccionar_diplomado
    @usuario = session[:estudiante].usuario
    @cohorte_actual = Cohorte.actual
    @diplomado_cohorte = DiplomadoCohorte.where(:cohorte_id => @cohorte_actual.id) 
    @inscripcion = Inscripcion.new

  end

  def completar_inscripcion
    diplomado_id = params[:inscripcion][:diplomado_id]
    @usuario = session[:estudiante].usuario
    @cohorte_actual = Cohorte.actual
    @inscripcion = Inscripcion.new
    @inscripcion.fecha_hora = DateTime.now
    @inscripcion.estudiante_ci = @usuario.ci
    @inscripcion.tipo_estado_inscripcion_id = "PRE"
    @inscripcion.diplomado_id = diplomado_id 
    @inscripcion.cohorte_id = @cohorte_actual.id
    @inscripcion.tipo_forma_pago_id = "UNICO"

    if @inscripcion.save
      flash[:success] = "#{@usuario.descripcion}, ha sido inscrit@ satisfactoriamente en el Diplomado: #{diplomado_id}"
      redirect_to :controller => "inscripcion_admin", :action => "buscar"
    else
      @diplomado_cohorte = DiplomadoCohorte.where(:cohorte_id => @cohorte_actual.id) 
      render :action => 'seleccionar_diplomado'
    end
  end

    def paso2

      # @usuario = session[:usuario]
      # unless @inscripcion = @usuario.inscripcion 
      #   @inscripcion = Inscripcion.new
      # end
      # # @tipos = TipoFormaPago.all
      # # @grupos = Grupo.all
      # # @cohorte = Cohorte.all
      # @preinscripcion = Preinscripcion.find @usuario.ci

      @usuario = session[:estudiante].usuario
      unless @datos_estudiante = @usuario.datos_estudiante 
        @datos_estudiante = DatosEstudiante.new
      end

      @titulo_pagina = "Preinscripción - Paso 2"
    end

    def paso2_guardar


      @usuario = session[:estudiante].usuario
      unless @datos_estudiante = @usuario.datos_estudiante 
        @datos_estudiante = DatosEstudiante.new
      end


      if !@usuario.contrasena || @usuario.contrasena.size < 1
        @usuario.contrasena = "00#{@usuario.ci}11"
        @usuario.contrasena_confirmation = @usuario.contrasena
      end
      
      @usuario.nombres = usuario[:nombres]
      @usuario.apellidos = usuario[:apellidos]
      @usuario.lugar_nacimiento = usuario[:lugar_nacimiento]
      @usuario.fecha_nacimiento = usuario[:fecha_nacimiento]
      @usuario.tipo_sexo_id = usuario[:tipo_sexo_id]
      @usuario.telefono_habitacion = usuario[:telefono_habitacion]
      @usuario.telefono_movil = usuario[:telefono_movil]
      @usuario.correo = usuario[:correo]
      @usuario.direccion = usuario[:direccion]
      @usuario.correo_alternativo = usuario[:correo_alternativo]
      @datos_estudiante.trabaja = datos_estudiante[:trabaja]
      @datos_estudiante.trabaja = datos_estudiante[:trabaja]
      @datos_estudiante.ocupacion = datos_estudiante[:ocupacion]
      @datos_estudiante.institucion = datos_estudiante[:institucion]
      @datos_estudiante.cargo_actual = datos_estudiante[:cargo_actual]
      @datos_estudiante.antiguedad = datos_estudiante[:antiguedad]
      @datos_estudiante.direccion_de_trabajo = datos_estudiante[:direccion_de_trabajo]
      @datos_estudiante.titulo_estudio = datos_estudiante[:titulo_estudio]
      @datos_estudiante.institucion_estudio = datos_estudiante[:institucion_estudio]
      @datos_estudiante.ano_graduacion_estudio = datos_estudiante[:ano_graduacion_estudio]
      @datos_estudiante.titulo_estudio_concluido = datos_estudiante[:titulo_estudio_concluido]
      @datos_estudiante.institucion_estudio_concluido = datos_estudiante[:institucion_estudio_concluido]
      @datos_estudiante.ano_estudio_concluido = datos_estudiante[:ano_estudio_concluido]
      @datos_estudiante.titulo_estudio_en_curso = datos_estudiante[:titulo_estudio_en_curso]
      @datos_estudiante.institucion_estudio_en_curso = datos_estudiante[:institucion_estudio_en_curso]
      @datos_estudiante.fecha_inicio_estudio_en_curso = datos_estudiante[:fecha_inicio_estudio_en_curso]
      @datos_estudiante.tiene_experiencia_ensenanza_idiomas = datos_estudiante[:tiene_experiencia_ensenanza_idiomas]
      @datos_estudiante.descripcion_experiencia = datos_estudiante[:descripcion_experiencia]
      @datos_estudiante.ha_dado_clases_espanol = datos_estudiante[:ha_dado_clases_espanol]
      @datos_estudiante.donde_clases_espanol = datos_estudiante[:donde_clases_espanol]
      @datos_estudiante.tiempo_clases_espanol = datos_estudiante[:tiempo_clases_espanol]
      @datos_estudiante.por_que_interesa_diplomado = datos_estudiante[:por_que_interesa_diplomado]
      @datos_estudiante.expectativas_sobre_diplomado = datos_estudiante[:expectativas_sobre_diplomado]

      a = @usuario.valid?
      b = @datos_estudiante.valid?
      if a && b 
        @usuario.save

        unless @estudiante = Estudiante.where(:usuario_ci => @usuario.ci).first
          @estudiante = Estudiante.new
          @estudiante.usuario_ci = @usuario.ci
          @estudiante.cuenta_twitter = params[:estudiante][:cuenta_twitter]
        end
        @estudiante.save

        @datos_estudiante.estudiante_ci = @estudiante.usuario_ci
        @datos_estudiante.save

        @inscripcion = Inscripcion.new
        @inscripcion.estudiante_ci = @usuario.ci
        @inscripcion.tipo_estado_id = "PRE"

        # unless @preinscripcion = Preinscripcion.where(:estudiante_ci => @usuario.ci).first
        #   @preinscripcion = Preinscripcion.new
        #   @preinscripcion.estudiante_ci = @usuario.ci
        # end
        @inscripcion.fecha_hora = Time.now
        @inscripcion.save

        begin
          EstudianteMailer.bienvenida(@usuario).deliver
        rescue
        end
        info_bitacora("Paso 2 preinscripcion realizado")
        redirect_to :action => "paso3"
        return
      end

      # usuario = session[:usuario]
      # unless @inscripcion = usuario.inscripcion 
      #   @inscripcion = Inscripcion.new
      # end

      # @usuario = session[:usuario]
      # @inscripcion.estudiante_ci = usuario.ci
      # @inscripcion.tipo_forma_pago_id = params[:tipo_forma_pago_id]
      # @inscripcion.grupo_id = params[:grupo_id]
      # @inscripcion.cohorte_id = params[:cohorte_id]
      # @inscripcion.fecha_hora = Time.now

      # a = @usuario.valid?
      # b = @inscripcion.valid?
      # if a && b 
      #   @inscripcion.save

      #   begin
      #     EstudianteMailer.bienvenida2(@usuario).deliver
      #   rescue
      #   end
      #   info_bitacora("Paso 2 inscripcion realizado")
      #   redirect_to :action => "paso3"
      #   return
      # end

      render :action => "paso2"
    end

    def paso3
      @usuario = session[:usuario]
      info_bitacora("Paso 3 inscripcion realizado")
      @titulo_pagina = "Inscripción - Paso 3"
    end

    def planilla_inscripcion
      ci = params[:usuario_ci] || session[:usuario].ci
      @usuario = Usuario.where(:ci => ci).first
      info_bitacora "Se busco la planilla de inscripcion de #{@usuario.descripcion}"
      pdf = Reportes.planilla_inscripcion(@usuario)
      # send_data pdf.render,:filename => "planilla_inscripcion_#{ci}.pdf", "3QELtype" => "application/pdf", :disposition => "attachment"
    end

    def habilitar_inscripcion
      @usuario = Usuario.where(:ci => params[:usuario_ci]).first
      @cohortes = Cohorte.all
      @tipos_forma_pago = TipoFormaPago.all
      @grupos = Grupo.all
    end

    def habilitar_guardar
      @usuario = Preinscripcion.where(:estudiante_ci => params[:ci]).first
      @usuario.grupo_id = params[:preinscrito][:grupo_id]
      @usuario.tipo_forma_pago_id = params[:preinscrito][:tipo_forma_pago_id]
      if @usuario.save
        flash[:mensaje] = "Estudiante habilitado para inscribirse"
        redirect_to :controller => 'admin_estudiante' , :action => 'opciones_menu'
       
      else
        flash[:mensaje] = "No se pudo habilitar, pongase en contacto con el Administrador del sistema"
        render :action => 'habilitar_inscripcion'
      end
    end

end