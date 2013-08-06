class PreinscripcionController < ApplicationController
  layout "visitante2"

  def paso1
    session[:usuario] = nil
    @usuario = Usuario.new
    @titulo_pagina = "Preinscripción - Paso 1"
  end

  def paso1_guardar
    ci = params[:usuario][:ci]
    ci = ci.gsub(".","").gsub("-","").gsub(" ","").strip
    if ci.size < 3
      flash[:mensaje] = "Cédula invalida"
      redirect_to :action => "paso1"
      return
    end
    if usuario = Usuario.where(:ci => ci).first
      session[:usuario] = usuario
    else
      usuario = Usuario.new
      usuario.ci = ci
      session[:usuario] = usuario
    end

    if Preinscripcion.where(:estudiante_ci => ci).first
      flash[:mensaje] = "Usted ya estaba preinscrito, pero puede actualizar sus datos si lo desea."
    end
    info_bitacora("Paso 1 preinscripcion realizado")
    redirect_to :action => "paso2"
    return
  end

  def paso2
    @usuario = session[:usuario]
    unless @datos_estudiante = @usuario.datos_estudiante 
      @datos_estudiante = DatosEstudiante.new
    end
    
    @titulo_pagina = "Preinscripción - Paso 2"
  end

  def paso2_guardar
    usuario = params[:usuario]
    datos_estudiante = params[:datos_estudiante]

    @usuario = session[:usuario]
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

      unless @preinscripcion = Preinscripcion.where(:estudiante_ci => @usuario.ci).first
        @preinscripcion = Preinscripcion.new
        @preinscripcion.estudiante_ci = @usuario.ci
      end
      @preinscripcion.fecha_hora = Time.now
      @preinscripcion.save

      begin
        EstudianteMailer.bienvenida(@usuario).deliver
      rescue
      end
      info_bitacora("Paso 2 preinscripcion realizado")
      redirect_to :action => "paso3"
      return
    end

    render :action => "paso2"
    
    
  end

  def paso3
    @usuario = session[:usuario]
    info_bitacora("Paso 3 preinscripcion realizado")
    @titulo_pagina = "Preinscripción - Paso 3"
  end

  def seleccionar_estudiantes
    @preinscritos = Preinscripcion.all
    @grupos = Grupo.all
    @cohorte = Cohorte.all
  end

  def guardar_seleccionados
    
    seleccionados = params[:seleccionados]
    puts "------------------"
    seleccionados.each{|s| puts s}
    puts "------------------"
    1/0
    seleccionados.each do |seleccionado|
      intructores_ci << seleccionado.at(0) if seleccionado.at(1).eql? "1"
    end    
  end


end
