# encoding: utf-8
class CombinacionesController < ApplicationController
  # GET /combinaciones
  # GET /combinaciones.json
  def index
    @combinaciones = Combinacion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @combinaciones }
    end
  end

  # GET /combinaciones/1
  # GET /combinaciones/1.json
  def show
    @combinacion = Combinacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @combinacion }
    end
  end

  # GET /combinaciones/new
  # GET /combinaciones/new.json
  def new
    @combinacion = Combinacion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @combinacion }
    end
  end

  # GET /combinaciones/1/edit
  def edit
    @combinacion = Combinacion.find(params[:id])
  end

  # POST /combinaciones
  # POST /combinaciones.json
  def create
    @combinacion = Combinacion.new(params[:combinacion])
    if @combinacion.save
      flash[:success] = "Combinación de idiomas agregada exitosamente."
    else
      flash[:error] = "#{@combinacion.errors.full_messages.join(' ')}"
    end
    redirect_to :back
  end

  # PUT /combinaciones/1
  # PUT /combinaciones/1.json
  def update
    @combinacion = Combinacion.find(params[:id])

    if @combinacion.update_attributes(params[:combinacion])
      flash[:success] = "Combinación de idiomas actualizada con éxito."
    else
      flash[:error] = "#{@combinacion.errors.full_messages.join(' ')}"
    end
    redirect_to :back
  end

  # DELETE /combinaciones/1
  # DELETE /combinaciones/1.json
  def destroy
    @combinacion = Combinacion.find(params[:id])
    cal_estudiante_ci = @combinacion.cal_estudiante_ci
    @combinacion.destroy
    flash[:info] = "combinación eliminada correctamente."
    redirect_to controller: :cal_principal_admin, action: 'detalle_usuario', ci: cal_estudiante_ci
  end
end
