class UsuarioController < ApplicationController
  before_filter :filtro_logueado
  # before_filter :filtro_administrador

  def registrar
    @usuario = Usuario.new
    @usuario.ci = params[:usuario_ci]
    @titulo = "Registro de Usuario"
    @inscripcion_admin = params[:inscripcion]
  end

   def registrar_guardar
    @usuario = Usuario.new (params[:usuario])

    #Correccion Capitalizar nombre y datos
    @usuario.nombres = @usuario.nombres.split.map(&:capitalize).join(' ') if @usuario.nombres
    @usuario.apellidos = @usuario.apellidos.split.map(&:capitalize).join(' ') if @usuario.apellidos
    @usuario.lugar_nacimiento = @usuario.lugar_nacimiento.split.map(&:capitalize).join(' ') if @usuario.lugar_nacimiento

    # Creación de Contraseña Inicial
    @usuario.contrasena = "00#{@usuario.ci}11"
    @usuario.contrasena_confirmation = @usuario.contrasena

    if @usuario.save
      flash[:success] = "Usuario Registrado Satisfactoriamente\n"
      flash[:success] << "Su contraseña inicial es: #{@usuario.contrasena}, puede cambiarla en el menú de la parte superior."
      info_bitacora("Usuario: #{@usuario.descripcion} registrado por administrador #{session[:administrador].usuario.descripcion}")
      redirect_to :controller => "inscripcion_admin", :action => "paso1"
    else
      render :action => "registrar"
    end
  end

  def modificar
    @usuario = session[:usuario] 
    @controlador = params[:controlador]
    @accion = params[:accion]
  end
  
  def modificar_guardar
    controlador = params[:controlador]
    accion = params[:accion]
    usr = params[:usuario]

    @usuario = session[:usuario]

    @usuario.ultima_modificacion_sistema = Time.now
    @usuario.nombres = usr[:nombres]
    @usuario.apellidos = usr[:apellidos]
    @usuario.correo = usr[:correo]
    @usuario.tipo_sexo_id = usr[:tipo_sexo_id]
    @usuario.telefono_movil = usr[:telefono_movil]
    @usuario.fecha_nacimiento = usr[:fecha_nacimiento]
    @usuario.telefono_habitacion = usr[:telefono_habitacion]
    @usuario.direccion = usr[:direccion]
    respond_to do |format|
       p "<#{controlador} #{accion}>"
      if @usuario.save
        info_bitacora "datos personales cambiados"
        flash[:mensaje] = "Datos Personales Actualizados Satisfactoriamente"
        
        format.html { redirect_to(:controller=> controlador, :action=>accion) }
      else
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
        format.html { render :action => "modificar"}
      end
    end
    
  end
  
  def contrasena
    @usuario = session[:usuario] 
    @controlador = params[:controlador]
    @accion = params[:accion]
    p @controlador
    @controlador = controller_name unless @controlador
    p @controlador
  end
  
  def contrasena_guardar
    controlador = params[:controlador]
    accion = params[:accion]
    usr = params[:usuario]
    @usuario = session[:usuario]
    @usuario.ultima_modificacion_sistema = Time.now
    @usuario.contrasena = usr[:contrasena]
    @usuario.contrasena_confirmation = usr[:contrasena_confirmation]

    respond_to do |format|
     
      if @usuario.save
        info_bitacora "contraseña cambiada"
        flash[:mensaje] = "Contraseña Actualizado Satisfactoriamente"
        format.html { redirect_to(:controller=> controlador, :action=>accion) }
      else
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
        
        format.html { render :action => "contrasena"}
      end
    end
    
  end

end