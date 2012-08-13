class PrincipalController < ApplicationController
  
  before_filter :filtro_logueado
  
  def index
    session[:nuevo] = nil 
    @titulo_pagina = "Principal"
    @preinscrito = !!HistorialAcademico.where(
      :usuario_ci => session[:usuario].ci,
      :idioma_id => session[:tipo_curso].idioma_id,
      :tipo_categoria_id => session[:tipo_curso].tipo_categoria_id,
      :periodo_id => session[:parametros][:periodo_inscripcion]).limit(1).first
  end

  def principal
    mensaje = flash[:mensaje]
    rol = session[:rol]
    if rol == "Administrador"
      flash[:mensaje] = mensaje
      redirect_to :controller => "principal_admin"
      return
    end
    if rol == "Instructor"
      flash[:mensaje] = mensaje
      redirect_to :controller => "principal_instructor"
      return
    end           
    flash[:mensaje] = mensaje
    redirect_to :controller => "principal"
    return
  end
  
  
  def cambiar_periodo_modal
    @periodos = Periodo.all.collect{|x| x}.sort_by{|x| "#{x.ano} #{x.id}"}.reverse()
    @controlador = params[:parametros][:controlador]
    @accion = params[:parametros][:accion]
    render :layout => false
  end
  
  def cambiar_periodo
    controlador = params[:controlador]
    accion = params[:accion]
    session[:parametros][:periodo_actual] = params[:periodo][:id] 
    flash[:mensaje]= "El periodo fue cambiado a #{session[:parametros][:periodo_actual]}"
    redirect_to :controller => controlador, :action => accion
  end

  
end
