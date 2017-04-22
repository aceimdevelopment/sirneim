# encoding: utf-8

class CalEstudianteMailer < ActionMailer::Base
  default :from => "sirneim@gmail.com"
  
  def olvido_clave(usuario)
    @nombre = usuario.nombre_completo
    @clave = usuario.contrasena
    mail(:to => usuario.correo_electronico, :subject => "SIRNEIM: Recordatorio de clave")
  end

end
