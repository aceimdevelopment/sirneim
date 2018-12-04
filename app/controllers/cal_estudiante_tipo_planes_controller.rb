class CalEstudianteTipoPlanesController < ApplicationController

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

    begin    

      if @cal_estudiante_tipo_plan.save
        flash[:success] = 'Plan de Estudio Agregado.'
      else
        flash[:success] = "#{@cal_estudiante_tipo_plan.errors.full_messages.join' | '}"
      end
    rescue Exception => e
        flash[:success] = "Error Excepcional: #{e}"
    end
    redirect_to controller: "cal_principal_admin", action: "detalle_usuario", ci: "#{@cal_estudiante_tipo_plan.cal_estudiante_ci}"
  end

  # PUT /cal_estudiante_tipo_planes/1
  # PUT /cal_estudiante_tipo_planes/1.json
  def update
    est_plan = params[:cal_estudiante_tipo_plan]
    ci,plan,semestre = params[:id].split(',')

    begin
      update_ci = true
      connection = ActiveRecord::Base.connection()
      sql = "UPDATE cal_estudiante_tipo_plan SET desde_cal_semestre_id='#{est_plan[:desde_cal_semestre_id]}', tipo_plan_id='#{est_plan[:tipo_plan_id]}' WHERE (cal_estudiante_ci='#{ci}') AND (tipo_plan_id='#{plan}') AND (desde_cal_semestre_id='#{semestre}');"
      connection.execute(sql)        
    rescue Exception => e
      flash[:danger] = "No es posible actualizar el plan. por favor verifique: #{e}"
    end

    redirect_to controller: "cal_principal_admin", action: "detalle_usuario", ci: ci

  end

  # DELETE /cal_estudiante_tipo_planes/1
  # DELETE /cal_estudiante_tipo_planes/1.json
  def destroy
    @cal_estudiante_tipo_plan = CalEstudianteTipoPlan.find(params[:id])

    ci = @cal_estudiante_tipo_plan.cal_estudiante_ci
    @cal_estudiante_tipo_plan.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Plan eliminado'}
      format.json { head :ok }
    end
  end
end
