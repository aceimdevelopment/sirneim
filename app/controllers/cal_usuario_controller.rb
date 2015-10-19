class CalUsuarioController < ApplicationController

  before_filter :cal_filtro_logueado
  # before_filter :cal_filtro_administrador

  def editar
    @cal_usuario = session[:cal_usuario]
    @editar = true

    if params[:controlador] and params[:accion]
      @accion = params[:accion]
      @controlador = params[:controlador]
    end

  end

  def modificar_guardar
    controlador = params[:controlador]
    accion = params[:accion]
    usr = params[:cal_usuario]

    @usuario = session[:cal_usuario]

    if @usuario.update_attributes(usr)
    	flash[:success] = "Datos guardados Satisfactoriamente"
    else
    	flash[:error] = "No se pudo guardar los datos: #{@usuario.errors.full_messages.join' | '}"
    end

    redirect_to :controller => controlador, :action => accion    
  end

  def olvido_clave_enviar
    1/0
    cedula = params[:usuario][:ci]
    usuario = Usuario.where(:ci => cedula).limit(0).first
    if usuario
      EstudianteMailer.olvido_clave(usuario).deliver  
      info_bitacora "El usuario #{usuario.descripcion} olvido su clave y la pidio recuperar"
      flash[:mensaje] = "Se ha enviado la clave al correo: #{usuario.correo}"
      redirect_to :action => :index
    else
      flash[:mensaje] = "Usuario no registrado"
      redirect_to :action => :olvido_clave
    end
    



  end

end
