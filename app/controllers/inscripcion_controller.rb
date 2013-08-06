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

    if estudiante=Preinscripcion.where(['estudiante_ci = ? AND grupo_id = ?', ci, nil]).first
      flash[:mensaje] = "Cédula invalida, la persona no ha sido seleccionada para ningún grupo"
      redirect_to :action => "paso1"
      return
    end

    usuario = Usuario.where(:ci => ci).first
    session[:usuario] = usuario
    
    if Inscripcion.where(:estudiante_ci => ci).first
      flash[:mensaje] = "Usted ya ha sido inscrito"
      redirect_to :action => "paso3"
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
    # @tipos = TipoFormaPago.all
    # @grupos = Grupo.all
    # @cohorte = Cohorte.all
    @preinscripcion = Preinscripcion.find @usuario.ci
    @titulo_pagina = "Inscripción - Paso 2"
  end

  def paso2_guardar

    usuario = session[:usuario]
    unless @inscripcion = usuario.inscripcion 
      @inscripcion = Inscripcion.new
    end

    @usuario = session[:usuario]
    @inscripcion.estudiante_ci = usuario.ci
    @inscripcion.tipo_forma_pago_id = params[:tipo_forma_pago_id]
    @inscripcion.grupo_id = params[:grupo_id]
    @inscripcion.cohorte_id = params[:cohorte_id]
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
    ci = params[:usuario_ci] || session[:usuario].ci
    @usuario = Usuario.where(:ci => ci).first
    info_bitacora "Se busco la planilla de inscripcion de #{@usuario.descripcion}"
    pdf = Reportes.planilla_inscripcion(@usuario)
    send_data pdf.render,:filename => "planilla_inscripcion_#{ci}.pdf",
                         :type => "application/pdf", :disposition => "attachment"
  end

end
