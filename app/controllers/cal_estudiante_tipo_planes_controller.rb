class CalEstudianteTipoPlanesController < ApplicationController
  # GET /cal_estudiante_tipo_planes
  # GET /cal_estudiante_tipo_planes.json
  def index
    @cal_estudiante_tipo_planes = CalEstudianteTipoPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cal_estudiante_tipo_planes }
    end
  end

  # GET /cal_estudiante_tipo_planes/1
  # GET /cal_estudiante_tipo_planes/1.json
  def show
    @cal_estudiante_tipo_plan = CalEstudianteTipoPlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cal_estudiante_tipo_plan }
    end
  end

  # GET /cal_estudiante_tipo_planes/new
  # GET /cal_estudiante_tipo_planes/new.json
  def new
    @cal_estudiante_tipo_plan = CalEstudianteTipoPlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cal_estudiante_tipo_plan }
    end
  end

  # GET /cal_estudiante_tipo_planes/1/edit
  def edit
    @cal_estudiante_tipo_plan = CalEstudianteTipoPlan.find(params[:id])
  end

  # POST /cal_estudiante_tipo_planes
  # POST /cal_estudiante_tipo_planes.json
  def create
    @cal_estudiante_tipo_plan = CalEstudianteTipoPlan.new(params[:cal_estudiante_tipo_plan])

    if @cal_estudiante_tipo_plan.save
      flash[:success] = 'Plan de Estudio Agregado.'
    else
      flash[:danger] = "#{@cal_estudiante_tipo_plan.errors}"
    end
    redirect_to controller: "cal_principal_admin", action: "detalle_usuario", ci: "#{@cal_estudiante_tipo_plan.cal_estudiante_ci}"

  end

  # PUT /cal_estudiante_tipo_planes/1
  # PUT /cal_estudiante_tipo_planes/1.json
  def update
    @cal_estudiante_tipo_plan = CalEstudianteTipoPlan.find(params[:id])

    begin    
      if @cal_estudiante_tipo_plan.update_attributes(params[:cal_estudiante_tipo_plan])
        # format.html { redirect_to controller: "cal_principal_admin", action: "detalle_usuario?ci=#{@cal_estudiante_tipo_plan.cal_estudiante_ci}", notice: 'Plan de Estudio Actualizado.' }
        flash[:success] = 'Plan de Estudio Actualizado.'
      else
        flash[:danger] = "#{@cal_estudiante_tipo_plan.errors}"
      end
    rescue Exception => e
      flash[:danger] = "#{@cal_estudiante_tipo_plan.errors}"   
    end
    redirect_to controller: "cal_principal_admin", action: "detalle_usuario", ci: "#{@cal_estudiante_tipo_plan.cal_estudiante_ci}"

  end

  # DELETE /cal_estudiante_tipo_planes/1
  # DELETE /cal_estudiante_tipo_planes/1.json
  def destroy
    @cal_estudiante_tipo_plan = CalEstudianteTipoPlan.find(params[:id])
    @cal_estudiante_tipo_plan.destroy

    respond_to do |format|
      format.html { redirect_to cal_estudiante_tipo_planes_url }
      format.json { head :ok }
    end
  end
end
