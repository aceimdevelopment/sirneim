# encoding: utf-8

class CalUsuarioController < ApplicationController

  before_filter :cal_filtro_logueado
  # before_filter :cal_filtro_administrador

  def index
    @super_user = session[:cal_administrador] and session[:cal_administrador].cal_tipo_admin_id < 3
    @admin = session[:cal_administrador] and session[:cal_administrador].cal_tipo_admin_id < 4
    if params[:search]
      @usuarios = CalUsuario.search(params[:search]).limit(50)
      if @usuarios.count > 0 && @usuarios.count < 50  
        flash[:success] = "Total de coincidencias: #{@usuarios.count}"
      elsif @usuarios.count == 0
        flash[:error] = "No se encontraron conincidencas. Intenta con otra búsqueda"
      else
        flash[:error] = "50 o más conincidencia. Puedes ser más explicito en la búsqueda. Recuerda que puedes buscar por CI, Nombre, Apellido, Correo Electrónico o incluso Número Telefónico"
      end

    else
      @usuarios = CalUsuario.limit(50).order("apellidos, nombres, ci")      
    end
  end


  def editar
    if params[:ci]
      @cal_usuario = CalUsuario.find params[:ci]
    else  
      @cal_usuario = session[:cal_usuario]
    end 
    @editar = (session[:cal_administrador] and session[:cal_administrador].cal_tipo_admin_id <= 3) #true

    if params[:controlador] and params[:accion]
      @accion = params[:accion]
      @controlador = params[:controlador]
    end
    @titulo = "Editar Datos Personales y de contacto de: #{@cal_usuario.descripcion}"
  end

  def modificar_guardar
    controlador = params[:controlador]
    accion = params[:accion]
    usr = params[:cal_usuario]
    ci = params[:ci]
    @usuario = CalUsuario.find ci #session[:cal_usuario]

    if @usuario.update_attributes(usr)
    	flash[:success] = "Datos guardados Satisfactoriamente"
    else
    	flash[:error] = "No se pudo guardar los datos: #{@usuario.errors.full_messages.join' | '}"
    end

    redirect_to controller: controlador, action: accion, ci: @usuario.ci
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

  def resetear_contrasena
    @usuario = CalUsuario.where(:ci => params[:ci]).limit(1).first
    @usuario.contrasena = @usuario.ci
    
    if @usuario.save
      flash[:success] = "Contraseña reseteada corréctamente"
      redirect_to  :back
    else
      flash[:error] = "no se pudo resetear la contraseña"
      redirect_to  :back
    end
    
  end


  def cambiar_ci
    begin
      cedula = Integer(params[:cedula])
      connection = ActiveRecord::Base.connection()
      sql = "update cal_usuario set ci = '#{cedula}' where ci = '#{params[:usuario_ci]}';"
      connection.execute(sql)
      flash[:success] = "Cambio de cédula de identidad correcto."
      redirect_to controller: 'cal_principal_admin', action: 'detalle_usuario', ci: cedula


    rescue Exception => e
      flash[:error] = "Error excepcional: #{e}"
      p " Error ".center(200," !! ")
      p "Error excepcional: #{e}".center(200," -- ")
      p " Error ".center(200," !! ")
      redirect_to controller: 'cal_principal_admin', action: 'detalle_usuario', ci: params[:usuario_ci]
    end

  end


end
