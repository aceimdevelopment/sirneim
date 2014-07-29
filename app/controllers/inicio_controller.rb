class InicioController < ApplicationController
  # layout "visitante"
  
  def index
    @cohorte_actual = Cohorte.actual
    @titulo = "Diplomados Ofertados para la Cohorte #{@cohorte_actual.descripcion}"
    @diplomados = DiplomadoCohorte.where (:cohorte_id => @cohorte_actual.id)
		reg = ContenidoWeb.where(:id => 'INI_CONTENT').first
    @content = reg.contenido

    diplomado = @diplomados.first.diplomado
    diplomado.normativa = @content
    diplomado.save
    # flash[:info] = @content.html_safe
    @docentes_ct = CohorteTema.where(:cohorte_id => @cohorte_actual.id).group(:docente_ci)
  end
  
  def registrar
    session[:usuario] = nil unless session[:administrador]
    @usuario = Usuario.new
    @usuario.ci = params[:usuario_ci]
    @titulo = "Registro de Usuario"
  end
  
  def registrar_guardar
    @usuario = Usuario.new (params[:usuario])

    #Correccion Capitalizar nombre y datos
    @usuario.nombres = @usuario.nombres.split.map(&:capitalize).join(' ') if @usuario.nombres
    @usuario.apellidos = @usuario.apellidos.split.map(&:capitalize).join(' ') if @usuario.apellidos
    @usuario.lugar_nacimiento = @usuario.lugar_nacimiento.split.map(&:capitalize).join(' ') if @usuario.lugar_nacimiento

    # Creación de Contraseña Inicial
    @usuario.contrasena = "00#{@usuario.ci}11"
    @usuario.contrasena_confirmation = @usuario.contrasena

    if @usuario.save
      # Buscamos que no exista ningun estudiante con esa ci y lo creamos 
      unless @estudiante = Estudiante.where(:usuario_ci => @usuario.ci).first
        @estudiante = Estudiante.new
        @estudiante.usuario_ci = @usuario.ci
        @estudiante.cuenta_twitter = params[:estudiante][:cuenta_twitter]
      end
      @estudiante.save

      session[:usuario] = @usuario unless session[:administrador]
      session[:estudiante] = @estudiante
      session[:ci] = @usuario.ci

      flash[:success] = "Usuario Registrado Satisfactoriamente\n"

      
      if session[:administrador]
        info_bitacora("Usuario: #{@usuario.descripcion} registrado por Adminsitrador #{session[:administrador]}.")
        redirect_to :controller => "inscripcion", :action => "paso1"
      else
        flash[:success] << "Su contraseña inicial es: #{@usuario.contrasena}, puede cambiarla en el menú de la parte superior."
        info_bitacora("Usuario: #{@usuario.descripcion} registrado.")
        redirect_to :controller => "principal"
      end
    else
      render :action => "registrar"
    end
  end

  def registrar_datos_profesionales
    @datos_estudiante = DatosEstudiante.new
    @titulo_pagina = "Registro de Datos Profesionales"
  end

  def registrar_datos_profesionales_guardar
    @usuario = session[:usuario]
    # @usuario = Usuario.find(session[:ci])
    @datos_estudiante = DatosEstudiante.new (params[:datos_estudiante])
    @datos_estudiante.estudiante_ci = @usuario.ci
    if @datos_estudiante.save
      flash[:mensaje] = "Datos Profesionales Registrado Satisfactoriamente, su registro ha sido completado con éxito"
      info_bitacora("Datos Estudiantes: #{@usuario.descripcion} registrado.")
      redirect_to :action => "index"
      begin
        EstudianteMailer.bienvenida(@usuario).deliver
      rescue
      end

    end
  end

  def validar  
    unless params[:user]
      redirect_to :action => "index"
      return
    end
    login = params[:user][:cedula]
    clave = params[:user][:clave]     
    reset_session
    #if login == '20028743' || login == '20616058' || login == '20756521'
    #	redirect_to :action => "index"
    #  return
    #end
    if usuario = Usuario.autenticar(login,clave)
      session[:usuario] = usuario
      roles = []
      roles << "Administrador" if usuario.administrador
      roles << "Estudiante" if usuario.estudiante
      # roles << "Docente" if usuario.docente
      #ests = EstudianteCurso.where(:usuario_ci => login) 
      #ests.each{ |ec|
      #  roles << "Estudiante"
      #}                       
      if roles.size == 0
        info_bitacora "No tiene roles el usuario #{login}"
        flash[:alert] = "Usuario sin rol"
        redirect_to :action => "index"          
        return
      elsif roles.size == 1 
        cargar_parametros_generales   
        redirect_to :action => "un_rol", :tipo => roles.first
        return
      else   
        info_bitacora "Tiene mas de un rol el usuario #{login}"
        cargar_parametros_generales   
        flash[:info] = "Usted tiene más de un rol, debe seleccionar un rol"
        redirect_to :action => "seleccionar_rol"
        return
      end
    end           
    info_bitacora "Error en el login o clave #{login}"
    flash[:alert] = "Error en login o clave"
    redirect_to :action => "index"
  end  
  
  def seleccionar_rol
    @titulo = "Roles en el Sistema" 
    usuario = session[:usuario]
    @roles = []
    @roles << { :tipo => "Administrador", :descripcion => "Administrador"} if usuario.administrador
    @roles << { :tipo => "Docente", :descripcion => "Docente"} if usuario.docente
    @roles << { :tipo => "Estudiante", :descripcion => "Estudiante"} if usuario.estudiante
    # usuario.estudiante_curso.each{|ec|
    #   @roles << { 
    #     :tipo => "Estudiante",
    #     :descripcion => ec.descripcion,
    #     :tipo_categoria_id => ec.tipo_categoria_id,
    #     :idioma_id => ec.idioma_id
    #   }  
    # }
  end 
  
  def un_rol 
    tipo = params[:tipo]
    usuario = session[:usuario]
    if tipo ==  "Administrador" && usuario.administrador
      session[:rol] = tipo
      session[:administrador] = usuario.administrador 
      info_bitacora "Inicio de sesion del adminitrador"
      redirect_to :controller => "principal_admin"
      return
    elsif tipo ==  "Instructor" && usuario.instructor
      session[:rol] = tipo
      session[:instructor] = usuario.instructor 
      info_bitacora "Inicio de sesion del instructor"
      redirect_to :controller => "principal_instructor"
      return  
    elsif tipo ==  "Estudiante"
      session[:rol] = tipo
      session[:estudiante] = usuario.estudiante 
      info_bitacora "Inicio de sesion del Estudiante"
      redirect_to :controller => "principal"
      return
      # ec = nil
      # if params[:tipo_categoria_id] && params[:idioma_id]
      #   ec = EstudianteCurso.where(
      #     :usuario_ci => usuario.ci,
      #     :tipo_categoria_id => params[:tipo_categoria_id],
      #     :idioma_id => params[:idioma_id]).limit(1).first
      # else
      #   ec = EstudianteCurso.where(
      #     :usuario_ci => usuario.ci).limit(1).first
      # end
      # if ec      
      #   session[:estudiante] = usuario.estudiante
      #   session[:rol] = ec.descripcion
      #   session[:tipo_curso] = ec.tipo_curso  
      #   info_bitacora "Inicio de sesion del estudiante"
      #   redirect_to :controller => "principal"
      #   return
      # end
    else
      flash[:alert] = "Inicio inválido"
      redirect_to :action => "index"
      return
    end
  end
  
  def cerrar_sesion
    reset_session
    flash[:info] = "Sesión finalizada"
    redirect_to :action => "index", :controller => "inicio"
  end 
  
  def autenticacion_nuevo
    redirect_to :action => "paso0", :controller => "inscripcion"
  end
  
  def validar_nuevo
    unless params[:usuario]
      redirect_to :action => "index"
      return
    end
    usuario = params[:usuario][:usuario]
    clave = params[:usuario][:clave]   
    
    if usuario == "new" && clave == "coursesa12" || usuario == "invitado" && clave == "invitado"
      redirect_to :action => "paso0", :controller => "inscripcion"
    else
      flash[:mensaje] = "Datos Inválidos"
      redirect_to :action => "autenticacion_nuevo"
    end
  end

  def olvido_clave_guardar
    cedula = params[:usuario][:ci]
    usuario = Usuario.where(:ci => cedula).limit(0).first
    if usuario
      EstudianteMailer.olvido_clave(usuario).deliver  
      info_bitacora "El usuario #{usuario.descripcion} olvido su clave y la pidio recuperar"
      flash[:info] = "Se ha enviado la clave al correo: #{usuario.correo}"
      redirect_to :action => :index
    else
      flash[:alert] = "Usuario no registrado"
      redirect_to :action => :olvido_clave
    end
    
  end

end
