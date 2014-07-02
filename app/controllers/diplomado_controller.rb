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
    @accion = "registrar"
  end

  def registrar
    diplomado = params[:diplomado]
    diplomado["id"] = diplomado["id"].gsub(/[\t\n\r \/]/, '')
    @diplomado = Diplomado.new (diplomado)
    # @diplomado.id = params[:diplomado][:id]
    # @diplomado.descripcion = params[:diplomado][:descripcion]

    if @diplomado.save
      flash[:success] = "Diplomado Registrado Satisfactoriamente"
      redirect_to :action => "vista", :id => @diplomado.id 
    else
      render :action => "nuevo"
  	end
  end

  def editar
    @diplomado = Diplomado.find(params[:id])
    @accion = "actualizar"
    @titulo = "Editar Diplomado"
  end

  def actualizar
    @diplomado = Diplomado.find(params[:id])

    if @diplomado.update_attributes(params[:diplomado])
      flash[:success] = "Datos actualizados correctamente"
      if session[:wizard]
        redirect_to :back
      else
        redirect_to :action => 'index', :id => @diplomado
      end
    else
      if session[:wizard]
        redirect_to :back
      else
        redirect_to :action => 'editar', :id => @diplomado
      end
    end

  end

  def vista
    @diplomado = Diplomado.where(:id => params[:id]).first
    @titulo = "Diplomado: #{@diplomado.descripcion_completa}"
    # @nuevo_modulo = params[:nuevo_modulo]
  end
end