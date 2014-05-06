class DocentesController < ApplicationController
  # GET /docentes
  # GET /docentes.json
  def index
    @titulo = "Lista de Docentes"
    @docentes = Docente.all
  end

  # GET /docentes/1
  # GET /docentes/1.json
  def vista
    @docente = Docente.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @docente }
    end
  end

  def nuevo
    @usuario = Usuario.new
    @accion = "crear"
    @titulo = "Nuevo Docente"


  end

  # GET /docentes/1/edit
  def editar
    @titulo = "Editar Docente"
    @accion = "actualizar"
    @usuario = Usuario.where (:ci => params[:id]).limit(1).first
  end

  # POST /docentes
  # POST /docentes.json
  def crear
    1/0
    @usuario = Usuario.new (params[:usuario])

    #Correccion Capitalizar nombre y datos
    @usuario.nombres = @usuario.nombres.split.map(&:capitalize).join(' ') if @usuario.nombres
    @usuario.apellidos = @usuario.apellidos.split.map(&:capitalize).join(' ') if @usuario.apellidos
    @usuario.lugar_nacimiento = @usuario.lugar_nacimiento.split.map(&:capitalize).join(' ') if @usuario.lugar_nacimiento

    # Creación de Contraseña Inicial
    @usuario.contrasena = "00#{@usuario.ci}11"
    @usuario.contrasena_confirmation = @usuario.contrasena

    if @usuario.save
      # Buscamos que no exista ningun estudiante con esa ci y lo creamos 
      @docente = Docente.new
      @docente.usuario_ci = @usuario.ci
      @docente.experiencia = params[:docente][:experiencia]

      @docente.save
      session[:usuario] = @usuario
      session[:docente] = @estudiante
      session[:ci] = @usuario.ci

      flash[:success] = "Usuario Registrado Satisfactoriamente\n"
      flash[:success] << "Su contraseña inicial es: #{@usuario.contrasena}, puede cambiarla en el menú de la parte superior."
      info_bitacora("Docente: #{@usuario.descripcion} registrado.")
      redirect_to :action => "index"
    else
      render :action => "nuevo"
    end
  end

  # PUT /docentes/1
  # PUT /docentes/1.json
  def actualizar
    1/0
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
  def eliminar
    @docente = Docente.find(params[:id])
    @docente.destroy

    respond_to do |format|
      format.html { redirect_to docentes_url }
      format.json { head :ok }
    end
  end
end
