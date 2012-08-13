class InstructorMailer < ActionMailer::Base
  default :from => "diplomado.ele.eim.ucv@gmail.com"      
  
  def inicio_clave(usuario)
    @nombre = usuario.nombre_completo
    @clave = usuario.contrasena
    mail(:to => usuario.correo, :subject => "Bienvenido a ACEIM - Calificación en línea de FUNDEIM")
  end
  
  def bienvenida(usuario)
    @nombre = usuario.nombre_completo
    @clave = usuario.contrasena
    mail(:to => usuario.correo, :subject => "Bienvenido a ACEIM - Nuevo período")
  end
  
  def recordatorio_calificacion(usuario, seccion, plazo)
    @nombre = usuario.nombre_completo
    @clave = usuario.contrasena
    @seccion = seccion
    @plazo = plazo
    mail(:to => usuario.correo, :subject => "FUNDEIM - Recordatorio de calificacíon del curso: #{seccion.descripcion}")
  end          
  
  def cambio_aulas_faces(usuario,seccion)
    @nombre = usuario.nombre_completo
    @seccion = seccion
    attachments['cambio_salones_sabado.pdf'] = File.read("#{Rails.root}/attachments/cambio_salones_sabado.pdf")
    mail(:to => usuario.correo, :subject => "DIPLOMADO: Cambio de aula de la sección: #{seccion.descripcion}")
  end
  
end
