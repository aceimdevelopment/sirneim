# encoding: utf-8

class EstudianteMailer < ActionMailer::Base
  default :from => "diplomado.ele.eim.ucv@gmail.com"      
  
  def bienvenida(usuario)
    mail(:to => usuario.correo, :subject => "DIPLOMADO: Bienvenido - Preinscripción Realizada")
  end

  def bienvenida2(usuario)
    @inscripcion = usuario.inscripcion
    mail(:to => usuario.correo, :subject => "DIPLOMADO: Bienvenido - Inscripción Realizada")
  end


  def recordatorio(usuario)
    @nombre = usuario.nombre_completo     
    @clave = usuario.contrasena   
    attachments['folleto_inscripcion_A_2012.pdf'] = File.read("#{Rails.root}/attachments/folleto_inscripcion_A_2012.pdf")
    mail(:to => usuario.correo, :subject => "Inscripción de los Cursos de Idiomas Modernos")
  end

  def cambio_aulas_faces(usuario,seccion)
    @nombre = usuario.nombre_completo
    @seccion = seccion
    attachments['cambio_salones_sabado.pdf'] = File.read("#{Rails.root}/attachments/cambio_salones_sabado.pdf")
    mail(:to => usuario.correo, :subject => "DIPLOMADO: Cambio de aula de la sección: #{seccion.descripcion}")
  end

  def olvido_clave(usuario)
    @nombre = usuario.nombre_completo
    @clave = usuario.contrasena
    mail(:to => usuario.correo, :subject => "DIPLOMADO: Recordatorio de clave")
  end

end
