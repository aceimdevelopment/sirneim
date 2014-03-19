class DiplomadoController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_administrador

  # attr_accessible :id

  def index
    @titulo_pagina = "Diplomados"
  	@diplomados = Diplomado.all
  	@mensaje = params[:mensaje] if params[:mensaje]
  end

  def nuevo
  	@diplomado = Diplomado.new
  end

  def crear
    @diplomado = Diplomado.new #(params[:tipo_estado])
    @diplomado.id = params[:diplomado][:id]
    @diplomado.descripcion = params[:diplomado][:descripcion]

    if @diplomado.save
      redirect_to :action => "vista", :id => @diplomado.id, :mensaje => "Diplomado Registrado"
    else
      render :action => "nuevo"
  	end
  end

  def vista
    @mensaje = params[:mensaje]
    @diplomado = Diplomado.where(:id => params[:id]).first
    @titulo_pagina = "Diplomado: #{@diplomado.descripcion_completa}"
    @nuevo_modulo = params[:nuevo_modulo]
  end
end