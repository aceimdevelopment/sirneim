class InscripcionController < ApplicationController
  layout "visitante2"

  def paso1
    session[:usuario] = nil
    @usuario = Usuario.new
    @titulo_pagina = "Incripción - Paso 1"
  end

  def paso1_guardar
    ci = params[:usuario][:ci]


    unless estudiante=Preinscripcion.where(:estudiante_ci => ci).first
      flash[:mensaje] = "Cédula invalida, la persona no está preinscrita"
      redirect_to :action => "paso1"
      return
    end
    usuario = Usuario.where(:ci => ci).first
    session[:usuario] = usuario
    
    if Inscripcion.where(:estudiante_ci => ci).first
      flash[:mensaje] = "Usted ya estaba inscrito, pero puede actualizar sus datos si lo desea."
      redirect_to :action => "paso1"
      return
    end

    info_bitacora("Paso 1 inscripcion realizado")
    redirect_to :action => "paso2"
    return
  end

  def paso2
    @usuario = session[:usuario]
    unless @inscripcion = @usuario.inscripcion 
      @inscripcion = Inscripcion.new
    end
    @tipos = TipoFormaPago.all
    @titulo_pagina = "Inscripción - Paso 2"
  end

  def paso2_guardar
    usuario = session[:usuario]
    inscripcion = params[:inscripcion]
    unless @inscripcion = usuario.inscripcion 
      @inscripcion = Inscripcion.new
    end


    @usuario = session[:usuario]
    @inscripcion.estudiante_ci = usuario.ci
    @inscripcion.tipo_forma_pago_id = inscripcion[:tipo_forma_pago_id]
    @inscripcion.fecha_hora = Time.now

    a = @usuario.valid?
    b = @inscripcion.valid?
    if a && b 
      @inscripcion.save

      begin
        EstudianteMailer.bienvenida2(@usuario).deliver
      rescue
      end
      info_bitacora("Paso 2 inscripcion realizado")
      redirect_to :action => "paso3"
      return
    end

    render :action => "paso2"
    
    
  end

  def paso3
    @usuario = session[:usuario]
    info_bitacora("Paso 3 inscripcion realizado")
    @titulo_pagina = "Inscripción - Paso 3"
  end

  def planilla_inscripcion
    @usuario = Usuario.where(:ci => session[:usuario].ci).first
    info_bitacora "Se busco la planilla de inscripcion de #{@usuario.descripcion}"
    pdf = Reportes.planilla_inscripcion(@usuario)
    send_data pdf.render,:filename => "planilla_inscripcion_#{session[:usuario].ci}.pdf",
                         :type => "application/pdf", :disposition => "attachment"
  end

end
