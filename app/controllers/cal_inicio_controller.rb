# encoding: utf-8

class CalInicioController < ApplicationController
  def index
    reset_session

  end

  def validar
    unless params[:cal_usuario]
      flash[:error] = "Error, debe ingresar Cédula y contraseña"
      redirect_to :action => "index"
      return
    end
    login = params[:cal_usuario][:ci]
    clave = params[:cal_usuario][:contrasena]
    reset_session
    if cal_usuario = CalUsuario.autenticar(login,clave)
      session[:cal_usuario] = cal_usuario
      roles = []
      roles << "Administrador" if cal_usuario.cal_administrador
      roles << "Profesor" if cal_usuario.cal_profesor
      roles << "Estudiante" if cal_usuario.cal_estudiante
      if roles.size == 0
        reset_session
        flash[:error] = "Usuario sin rol"
        redirect_to :action => "index" 
        return
      elsif roles.size == 1
        cal_cargar_parametros_generales
        redirect_to :action => "un_rol", :tipo => roles.first
        return
      else
        cal_cargar_parametros_generales
        flash[:warning] = "Tiene más de un rol, selecciona uno de ellos"
        redirect_to :action => "seleccionar_rol"
        return
      end
    end           
    flash[:error] = "Error en Cédula o contraseña"
    redirect_to :action => "index"
  end  
  
  def seleccionar_rol    
    cal_usuario = session[:cal_usuario]
    @roles = []
    @roles << { :tipo => "Administrador", :descripcion => "Administrador"} if cal_usuario.cal_administrador
    @roles << { :tipo => "Profesor", :descripcion => "Profesor"} if cal_usuario.cal_profesor
    @roles << { :tipo => "Estudiante", :descripcion => "Estudiante"} if cal_usuario.cal_estudiante
  end
  
  def un_rol 
    tipo = params[:tipo]
    cal_usuario = CalUsuario.find session[:cal_usuario]['ci']

    flash[:success] = "Bienvenid@ #{cal_usuario.nombres}" 
    if tipo == "Administrador" && cal_usuario.cal_administrador
      session[:rol] = tipo
      session[:cal_administrador] = cal_usuario.cal_administrador
      redirect_to :controller => "cal_principal_admin"
      return
    elsif tipo == "Profesor" && cal_usuario.cal_profesor
      session[:rol] = tipo
      session[:cal_profesor] = cal_usuario.cal_profesor
      redirect_to :controller => "cal_principal_profesor"
      return
    elsif tipo == "Estudiante"
      session[:rol] = tipo
      session[:cal_estudiante] = cal_usuario.cal_estudiante
      redirect_to :controller => "cal_principal_estudiante"
      return
    end
  end
  
  def cerrar_sesion
    msg = "Hasta pronto #{session[:cal_usuario].nombres}"    
    reset_session
    flash[:success] = msg
    redirect_to :action => "index", :controller => "cal_inicio"
  end 

  def olvido_clave_enviar
    cedula = params[:cal_usuario][:ci]
    usuario = CalUsuario.where(:ci => cedula).limit(0).first
    if usuario
      CalEstudianteMailer.olvido_clave(usuario).deliver  
      # info_bitacora "El usuario #{usuario.descripcion} olvido su clave y la pidio recuperar"
      flash[:success] = "#{usuario.nombres}, se ha enviado la clave al correo: #{usuario.correo_electronico}"
      redirect_to :action => :index
    else
      flash[:error] = "Usuario no registrado"
      redirect_to :action => :index
    end
    
  end


end
