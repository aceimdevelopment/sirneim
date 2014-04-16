class DiplomadoController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_administrador

  # attr_accessible :id

  def index
    @titulo = "Diplomados"
  	@diplomados = Diplomado.all
  end

  def nuevo
  	@diplomado = Diplomado.new
    @titulo = "Registro de Nuevo Diplomado"
  end

  def crear
    @diplomado = Diplomado.new #(params[:tipo_estado])
    @diplomado.id = params[:diplomado][:id]
    @diplomado.descripcion = params[:diplomado][:descripcion]

    if @diplomado.save
      flash[:success] = "Diplomado Registrado Satisfactoriamente"
      redirect_to :action => "vista", :id => @diplomado.id 
    else
      render :action => "nuevo"
  	end
  end

  def editar
    1/0
  end

  def vista
    @diplomado = Diplomado.where(:id => params[:id]).first
    @titulo = "Diplomado: #{@diplomado.descripcion_completa}"
    # @nuevo_modulo = params[:nuevo_modulo]
  end
end