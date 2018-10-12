# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # def info_bitacora(descripcion, estudiante_ci = nil)
  #   usuario_ci = (session[:usuario]) ? session[:usuario].ci : nil
  #   estudiante_ci = (session[:estudiante]) ? session[:estudiante].usuario_ci : nil
  #   administrador_ci = (session[:administrador]) ? session[:administrador].usuario_ci : nil                     
    
  #   Bitacora.info(
  #     :descripcion => descripcion, 
  #     usuario_ci: usuario_ci,
  #     :estudiante_usuario_ci =>estudiante_ci,
  #     :administrador_usuario_ci =>administrador_ci,
  #     :ip_origen => request.remote_ip
  #     )
  # end
    
private  

  def cal_cargar_parametros_generales   
    session[:cal_parametros] = {}
    CalParametroGeneral.all.each{|registro|
      session[:cal_parametros][registro.id.downcase.to_sym] = registro.valor.strip
    }
  end

  
# Funciones especiales y temporales para calificar

  def cal_filtro_logueado
    unless session[:cal_usuario]
      reset_session
      flash[:alert] = "Debe iniciar sesión"
      redirect_to :action => "index", :controller => "cal_inicio"  
      return false
    end
  end
  
  def cal_filtro_administrador
    unless session[:cal_administrador]
      reset_session
      flash[:alert] = "Debe iniciar sesión como Administrador"  
      redirect_to :action => "index", :controller => "cal_inicio"
      return false
    end
  end

  def cal_filtro_admin_profe
    unless session[:cal_administrador] or session[:cal_profesor] 
      reset_session
      flash[:alert] = "Debe iniciar sesión como Profesor o Administrador"  
      redirect_to :action => "index", :controller => "cal_inicio"
      return false
    end
  end


  def cal_filtro_profesor
    unless session[:cal_profesor]
      reset_session
      flash[:alert] = "Debe iniciar sesión como Profesor"  
      redirect_to :action => "index", :controller => "cal_inicio"
      return false
    end
  end

  def cal_filtro_estudiante
    unless session[:cal_estudiante]
      reset_session
      flash[:alert] = "Debe iniciar sesión como Profesor"  
      redirect_to :action => "index", :controller => "cal_inicio"
      return false
    end
  end


  
end
