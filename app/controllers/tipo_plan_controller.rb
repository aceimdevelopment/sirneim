class TipoPlanController < ApplicationController
  before_filter :cal_filtro_logueado

  # GET /tipo_planes
  # GET /tipo_planes.json
  def index
    @tipo_planes = TipoPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipo_planes }
    end
  end

  # GET /tipo_planes/1
  # GET /tipo_planes/1.json
  def show
    @tipo_plan = TipoPlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tipo_plan }
    end
  end

  # GET /tipo_planes/new
  # GET /tipo_planes/new.json
  def new
    @tipo_plan = TipoPlan.new
    @accion = 'create'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tipo_plan }
    end
  end

  # GET /tipo_planes/1/edit
  def edit
    @tipo_plan = TipoPlan.find(params[:id])
    @accion = 'update'
  end

  # POST /tipo_planes
  # POST /tipo_planes.json
  def create
    @tipo_plan = TipoPlan.new(params[:tipo_plan])

    respond_to do |format|
      if @tipo_plan.save
        format.html { redirect_to tipo_plan_index_path, notice: 'Plan creado.' }
        format.json { render json: @tipo_plan, status: :created, location: @tipo_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @tipo_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tipo_planes/1
  # PUT /tipo_planes/1.json
  def update
    @tipo_plan = TipoPlan.find(params[:id])
      unless params[:id].eql? params[:tipo_plan][:id]
        begin
          update_ci = true
          connection = ActiveRecord::Base.connection()
          sql = "UPDATE tipo_plan SET id = '#{params[:tipo_plan][:id]}' WHERE id = '#{params[:id]}';"
          connection.execute(sql)        
        rescue Exception => e
          update_ci = false
        end
      end
    respond_to do |format|
      if @tipo_plan.update_attributes(params[:tipo_plan]) and update_ci
        format.html { redirect_to tipo_plan_index_path, notice: 'Tipo plan actualizado.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @tipo_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_planes/1
  # DELETE /tipo_planes/1.json
  def destroy
    @tipo_plan = TipoPlan.find(params[:id])
    @tipo_plan.destroy

    respond_to do |format|
      format.html { redirect_to tipo_plane_index_path }
      format.json { head :ok }
    end
  end
end
