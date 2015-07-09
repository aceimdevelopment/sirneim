class CalInicioController < ApplicationController
  def index
  end

  def validar
    unless params[:cal_usuario]
      flash[:danger] = "Error en login o clave."
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
        redirect_to :action => "un_rol", :tipo => roles.first
        return
      else
        flash[:warning] = "Usted tiene más de un rol, debe seleccionar un rol"
        redirect_to :action => "seleccionar_rol"
        return
      end
    end           
    flash[:danger] = "Error en login o clave."
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
    flash[:success] = "Bienvenido" 
    tipo = params[:tipo]
    cal_usuario = CalUsuario.find session[:cal_usuario]['ci']
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
    reset_session
    redirect_to :action => "index", :controller => "cal_inicio"
  end 


end
