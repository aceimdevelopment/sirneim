# encoding: utf-8

class CalSemestreController < ApplicationController

  before_filter :cal_filtro_logueado
  before_filter :cal_filtro_administrador

  def lista
    @estudiantes = CalEstudiante.where(cal_tipo_estado_inscripcion_id: 'NUEVO')
  end

  def nuevo
    @cal_semestre = CalSemestre.new
  end

  def registrar
    if params[:set_periodo_actual]
      periodo_actual = CalParametroGeneral.find("SEMESTRE_ACTUAL")
      periodo_anterior = CalParametroGeneral.find("SEMESTRE_ANTERIOR")
      periodo_anterior.valor = periodo_actual.valor
      periodo_actual.valor = params[:cal_semestre][:id]
      periodo_actual.save
      periodo_anterior.save
    end
    @cal_semestre = CalSemestre.new(params[:cal_semestre])

    if @cal_semestre.save
      flash[:success] = "Registro satisfactorio de nuevo semestre"
      redirect_to :controller => 'cal_principal_admin', :action => 'configuracion_general'
    else
      render :action => 'nuevo'
    end

  end

  def cambiar_periodo_actual

      periodo_actual = CalParametroGeneral.find("SEMESTRE_ACTUAL")
      periodo_anterior = CalParametroGeneral.find("SEMESTRE_ANTERIOR")
      periodo_anterior.valor = params[:cal_semestre_anterior][:id]
      periodo_actual.valor = params[:cal_semestre][:id]
      if periodo_actual.save and periodo_anterior.save 
        session[:cal_parametros][:semestre_actual] = periodo_actual.valor
        flash[:success] = "Se realizó el cambio de periodo actual a #{periodo_actual.valor}"
      else
        flash[:danger] = "No se pudo realizar el cambio de periodo"
      end

      redirect_to :controller => 'cal_principal_admin', :action => 'configuracion_general'
  end

end
