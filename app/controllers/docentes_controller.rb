class DocentesController < ApplicationController
  # GET /docentes
  # GET /docentes.json
  before_filter :filtro_logueado
  before_filter :filtro_administrador

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
    @titulo = "Nuevo Docente"
    @accion = "crear"
    @usuario = Usuario.new
    @docente = Docente.new
  end

  # GET /docentes/1/edit
  def editar
    @titulo = "Editar Docente"
    @accion = "actualizar"
    # @usuario = Usuario.where (:ci => params[:id]).limit(1).first
    # @docente = Docente.where (:usuario_ci => @usuario.ci).limit(1).first unless @usuario.nil?

    @docente = Docente.where (:usuario_ci => params[:id]).limit(1).first
    @usuario = @docente.usuario if @docente

  end

  # POST /docentes
  # POST /docentes.json
  def crear
    @usuario = Usuario.new (params[:usuario])

    #Correccion Capitalizar nombre y datos
    @usuario.nombres = @usuario.nombres.split.map(&:capitalize).join(' ') if @usuario.nombres
    @usuario.apellidos = @usuario.apellidos.split.map(&:capitalize).join(' ') if @usuario.apellidos
    @usuario.lugar_nacimiento = @usuario.lugar_nacimiento.split.map(&:capitalize).join(' ') if @usuario.lugar_nacimiento

    # Creación de Contraseña Inicial
    @usuario.contrasena = "00#{@usuario.ci}11"
    @usuario.contrasena_confirmation = @usuario.contrasena

    # Buscamos que no exista ningun estudiante con esa ci y lo creamos 
    @docente = Docente.new
    @docente.usuario_ci = @usuario.ci
    @docente.experiencia = params[:docente][:experiencia]

    if @usuario.save and @docente.save
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
    @docente = Docente.where(:usuario_ci => params[:usuario][:ci]).limit(1).first
    @usuario = Usuario.where(:ci => params[:usuario][:ci]).limit(1).first

    params[:usuario][:nombres] = params[:usuario][:nombres].split.map(&:capitalize).join(' ') if params[:usuario][:nombres]
    params[:usuario][:apellidos] = params[:usuario][:apellidos].split.map(&:capitalize).join(' ') if params[:usuario][:apellidos]
    params[:usuario][:lugar_nacimiento] = params[:usuario][:lugar_nacimiento].split.map(&:capitalize).join(' ') if params[:usuario][:lugar_nacimiento]



    if @docente.update_attributes(params[:docente]) and @usuario.update_attributes(params[:usuario])
      flash[:success] = "Usuario Actualizado Satisfactoriamente"
      info_bitacora("Docente: #{@usuario.descripcion} Actualizado.")
      redirect_to :action => "index"
    else
      render :action => "editar"
    end
 
  end

  def modificar_ci
    id = params[:id]
    nueva_ci  = params[:nueva_ci]
    repetir_ci = params[:repetir_ci]
    if (nueva_ci.eql? repetir_ci)
      if usuario = Usuario.find(id)
        respuesta = usuario.modificar_ci nueva_ci 
        if (respuesta).blank?
          flash[:success] = "Cédula modificada con éxito"
          id = nueva_ci
        else
          flash[:alert] = "No se pudo modificar la cédula: #{respuesta}"
        end
      else
        flash[:alert] = "Usuario no encontrado, verifique los parámetros"
      end
    else
      flash[:alert] = "La cédula y su confirmación deben deben ser iguales"
    end
    redirect_to :action => "editar", :id => id   
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
