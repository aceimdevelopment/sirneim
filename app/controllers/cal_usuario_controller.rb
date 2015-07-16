class CalUsuarioController < ApplicationController

  def modificar_guardar
    controlador = params[:controlador]
    accion = params[:accion]
    usr = params[:cal_usuario]

    @usuario = session[:cal_usuario]

    if @usuario.update_attributes(usr)
    	flash[:success] = "Datos guardados Satisfactoriamente"
    else
    	flash[:error] = "No se pudo guardar los datos"
    end

    redirect_to :controller => controlador, :action => accion    
  end

end
