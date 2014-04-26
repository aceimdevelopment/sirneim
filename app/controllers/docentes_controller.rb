class DocentesController < ApplicationController
  # GET /docentes
  # GET /docentes.json
  def index
    @titulo = "Lista de Docentes"
    @docentes = Docente.all
  end

  # GET /docentes/1
  # GET /docentes/1.json
  def show
    @docente = Docente.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @docente }
    end
  end

  # GET /docentes/new
  # GET /docentes/new.json
  def new
    @docente = Docente.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @docente }
    end
  end

  # GET /docentes/1/edit
  def edit
    @docente = Docente.find(params[:id])
  end

  # POST /docentes
  # POST /docentes.json
  def create
    @docente = Docente.new(params[:docente])

    respond_to do |format|
      if @docente.save
        format.html { redirect_to @docente, :notice => 'Docente was successfully created.' }
        format.json { render :json => @docente, :status => :created, :location => @docente }
      else
        format.html { render :action => "new" }
        format.json { render :json => @docente.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /docentes/1
  # PUT /docentes/1.json
  def update
    @docente = Docente.find(params[:id])

    respond_to do |format|
      if @docente.update_attributes(params[:docente])
        format.html { redirect_to @docente, :notice => 'Docente was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @docente.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /docentes/1
  # DELETE /docentes/1.json
  def destroy
    @docente = Docente.find(params[:id])
    @docente.destroy

    respond_to do |format|
      format.html { redirect_to docentes_url }
      format.json { head :ok }
    end
  end
end
