class AdministradorMailer < ActionMailer::Base
  #layout 'layout'
  default :from => "diplomado.ele.eim.ucv@gmail.com"        

  def enviar_notificacion(instructores)
    @instructores = instructores
    # aleidajave@yahoo.com   
    #joyce Gutiérrez Juárez <joygutierrez@hotmail.com>
    #carlos A. Saavedra A. <saavedraazuaje73@gmail.com>
    #sergiorivas@gmail.com,
    mail(:to => 'aleidajave@yahoo.com',
         :bcc => 'diplomado.ele.eim.ucv@gmail.com',
         :subject => "Notificación de Pago")
  end 
  
  def aviso_general(correo,titulo,info)
    @info = info
    mail(:to => correo, :bcc => "aceim.development@gmail.com", :subject => "DIPLOMADO: Aviso General - #{titulo}")
  end
  
  def enviar_correo_general(para,asunto,mensaje,adjunto)
    #attachments.inline['fondo_correo.png'] = File.read("#{Rails.root}/app/assets/images/fondo_correo.png")
    @mensaje = mensaje
    @asunto = asunto
    if adjunto
      attachments[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}")
    end
    mail(:to => para, :subject => asunto)
  end
  
end
