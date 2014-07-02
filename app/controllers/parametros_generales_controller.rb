class ParametrosGeneralesController < ApplicationController
  
  before_filter :filtro_logueado
  before_filter :filtro_administrador
  def index
    @titulo = "Configuraciones Generales"
    @preinscripcion_general = ParametroGeneral.find("PREINSCRIPCION_ABIERTA").valor
  end
  

  def guardar_parametros
    preinscripcion_general = ParametroGeneral.find("PREINSCRIPCION_ABIERTA")
    preinscripcion_general.valor = params[:preinscripcion_general]

    if preinscripcion_general.save
      flash[:success] = 'Configuraciones almacenadas con éxito'
    else
      flash[:alert] = 'No se pudo abrir la Preinscrición'
    end
    redirect_to(:action=>'index')

  end

  def cambiar_cohorte
    @cohortes = Cohorte.all.sort_by{|x| "#{x.id}"}.reverse()
    # render :layout => false    
  end

  def guardar_cambio_cohorte
      cohorte_actual = ParametroGeneral.find("COHORTE_ACTUAL")
      cohorte_actual.valor = params[:cohorte][:id] 
      cohorte_actual.save
      session[:parametros][:cohorte_actual] = cohorte_actual.valor
      url = params[:url] ? params[:url] : '/aceim_diplomados/principal_admin/index'  
      redirect_to url
  end
  
end
