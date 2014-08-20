class AdminEstudianteController < ApplicationController

  before_filter :filtro_logueado
  before_filter :filtro_administrador

  def index
    
  end     

=begin
def autocomplete
  term = params[:term]                                                
  busqueda = "#{term}%"
  usuarios = Usuario.all(
    :conditions => ["nombres LIKE ? OR apellidos LIKE ? OR ci LIKE ?",busqueda,busqueda,busqueda],
    :limit => 50, :order => "apellidos, nombres, ci")
  render :text => usuarios.collect{|x| {:label => x.descripcion, :value => x.ci }}.to_json  
end
=end  
  def autocomplete
    term = params[:term] 
    a,b = term.split
    busqueda_a = "#{a}%"
    
    if b
      busqueda_b = "#{b}%"
      usuarios = Usuario.all(
        :conditions => ["(nombres LIKE ? OR apellidos LIKE ? OR ci LIKE ?) AND \
          (nombres LIKE ? OR apellidos LIKE ? OR ci LIKE ?)",
          busqueda_a,busqueda_a,busqueda_a,
          busqueda_b,busqueda_b,busqueda_b
          ],
        :limit => 50, :order => "apellidos, nombres, ci")
      render :text => usuarios.collect{|x| {:label => x.descripcion, :value => x.ci }}.to_json  
      return
    else                                               
      usuarios = Usuario.all(
        :conditions => ["nombres LIKE ? OR apellidos LIKE ? OR ci LIKE ?",busqueda_a,busqueda_a,busqueda_a],
        :limit => 50, :order => "apellidos, nombres, ci")
      render :text => usuarios.collect{|x| {:label => x.descripcion, :value => x.ci }}.to_json  
      return
    end
  end
  
  def validar
    ci = params[:usuario][:ci]    
    if session[:estudiante]=Estudiante.where(:usuario_ci=>ci).limit(1).first
      session[:estudiante_ci] = ci
      redirect_to :action=> "opciones_menu"
    else
      flash[:mensaje]="Estudiante no encontrado"
      redirect_to :action=> "index"
    end
  end
  
  def opciones_menu
    ci = session[:estudiante_ci] 
    periodo_actual = session[:parametros][:periodo_actual]
    @usuario = Usuario.where(:ci=>ci).limit(1).first
    @datos_estudiante = @usuario.datos_estudiante
    @estudiante = @usuario.estudiante

    @inscripciones = @usuario.estudiante.inscripciones


  end
  
  def cambiar_convenio_sel_curso
    periodo = session[:parametros][:periodo_actual]
    ci = session[:estudiante_ci]
    @usuario = Usuario.where(:ci=>ci).limit(1).first
    @cursos = EstudianteCurso.where(:usuario_ci => ci).collect{|c| c.tipo_curso}
    @titulo_pagina = "Modificar Estudiante: #{@usuario.descripcion}"
    @subtitulo_pagina = "Seleccione el Curso"
  end
  
  def cambiar_convenio
    idioma_id,tipo_categoria_id = params[:parametros][:tipo_curso].split(",")
    ci = params[:parametros][:usuario_ci]
    @estudiante_curso= EstudianteCurso.where(:usuario_ci=>ci,:idioma_id=>idioma_id,:tipo_categoria_id=>tipo_categoria_id).limit(1).first
    render :layout => false
  end

  def cambiar_convenio_guardar
    tipo_convenio_id = params[:estudiante_curso][:tipo_convenio_id]
    periodo = session[:parametros][:periodo_actual]
    idioma_id = params[:estudiante_curso][:idioma_id]
    tipo_categoria_id = params[:estudiante_curso][:tipo_categoria_id]
    ci = params[:estudiante_curso][:usuario_ci]
    estudiante_curso= EstudianteCurso.where(:usuario_ci=>ci,
    :idioma_id=>idioma_id, 
    :tipo_categoria_id=>tipo_categoria_id).limit(1).first
    
    if estudiante_curso.tipo_convenio_id != tipo_convenio_id
      historial = HistorialAcademico.where(:usuario_ci=>ci,
        :idioma_id=>idioma_id, 
        :tipo_categoria_id=>tipo_categoria_id, 
        :periodo_id=>periodo).limit(1).first
      estudiante_curso.tipo_convenio_id = tipo_convenio_id
      
      if historial
        historial.tipo_convenio_id = tipo_convenio_id
        historial.save
      end
    
      if estudiante_curso.save
        info_bitacora("Convenio modificado: #{estudiante_curso.tipo_convenio.descripcion}")
        flash[:mensaje]="convenio actualizado"
        redirect_to :action=>"opciones_menu"
      else
        flash[:mensaje]="no se pudo actualizar"
        redirect_to :action=> "cambiar_convenio"
      end
    else
      info_bitacora("Intento de modificar convenio - se mantiene el convenio: #{estudiante_curso.tipo_convenio.descripcion}")
      flash[:mensaje]="se mantiene el convenio"
      redirect_to :action=>"opciones_menu"
    end
  end
  
  def modificar_datos_personales
    ci = session[:estudiante_ci]
    @usuario = Usuario.where(:ci=>ci).limit(1).first
    @accion = "validar_datos"
  end
  
  def modificar_datos_personales_guardar 
    usr = params[:usuario]
    @usuario = Usuario.where(:ci=>usr[:ci]).limit(1).first
    @usuario.nombres = usr[:nombres]
    @usuario.apellidos = usr[:apellidos]
    @usuario.tipo_sexo_id = usr[:tipo_sexo_id]
    @usuario.fecha_nacimiento = usr[:fecha_nacimiento]
    @usuario.correo = usr[:correo]
    @usuario.telefono_movil = usr[:telefono_movil]
    @usuario.telefono_habitacion = usr[:telefono_habitacion]
    @usuario.direccion = usr[:direccion]
    
    respond_to do |format|
      if @usuario.save
        info_bitacora("Datos personales modifcados")
        flash[:mensaje] = "Estudiante Actualizado Satisfactoriamente"
        format.html { redirect_to(:action=>"opciones_menu") }
      else
        flash[:mensaje] = "Errores en el Formulario impiden que el estudiante sea actualizado"
        format.html { render :action => "modificar_datos_personales" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def cambiar_seccion_sel_curso
    periodo = session[:parametros][:periodo_actual]
    ci = session[:estudiante_ci]
    @usuario = Usuario.where(:ci=>ci).limit(1).first
    @cursos = EstudianteCurso.where(:usuario_ci => ci).collect{|c| c.tipo_curso}
    @titulo_pagina = "Modificar Estudiante: #{@usuario.descripcion}"
    @subtitulo_pagina = "Seleccione el Curso"
  end
  
  def cambiar_seccion
    p=params[:parametros]
    periodo = session[:parametros][:periodo_actual]
    idioma_id = p[:idioma_id]
    tipo_categoria_id = p[:tipo_categoria_id]
    ci = p[:usuario_ci]
    @historial = HistorialAcademico.where(:periodo_id=>periodo, :idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id, :usuario_ci=>ci).limit(1).first
    @secciones = Seccion.where(:idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id, :periodo_id => periodo, :tipo_nivel_id=>@historial.tipo_nivel_id)
    render :layout=> false
  end
  
  def cambiar_seccion_guardar
    
    periodo_id,idioma_id,tipo_categoria_id, tipo_nivel_id, numero = params[:historial][:seccion].split(",")
    ci = params[:historial][:usuario_ci]    
    historial = HistorialAcademico.where(:periodo_id=>periodo_id, :idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id, :usuario_ci=>ci).limit(1).first
    unless historial.seccion_numero.eql? numero
      historial.seccion_numero = numero
      if historial.save
        info_bitacora("Sección Modificada: #{historial.seccion.descripcion}")
        flash[:mensaje]="Sección Modificada Satisfactoriamente"
        redirect_to :action=>"opciones_menu"
      else
        flash[:mensaje]="no se pudo modificar la Seccion"
        redirect_to :action=> "cambiar_seccion"
      end    
    else
      info_bitacora("Intento de modificar sección, se mantien la sección: #{historial.seccion.descripcion}")
      flash[:mensaje]="se mantiene la sección"
      redirect_to :action=>"opciones_menu"
    end
  end
  
  def seleccionar_curso
    periodo = session[:parametros][:periodo_actual]
    ci = session[:estudiante_ci]
    @usuario = Usuario.where(:ci=>ci).limit(1).first
    @cursos = EstudianteCurso.where(:usuario_ci => ci).collect{|c| c.tipo_curso}
    @titulo_pagina = "Modificar Estudiante: #{@usuario.descripcion}"
    @subtitulo_pagina = "Seleccione el Curso"
    @accion = params[:accion]
        
  end
  
  def confirmar_inscripcion
    p=params[:parametros]
    periodo = session[:parametros][:periodo_actual]
    ci = p[:usuario_ci]
    @historial = HistorialAcademico.where(:periodo_id=>periodo, :idioma_id=>p[:idioma_id], :tipo_categoria_id=>p[:tipo_categoria_id], :usuario_ci=>ci).limit(1).first
    render :layout => false   
  end

  def cambiar_nota
    if (session[:administrador].usuario_ci != "aceim")
      pa = params[:parametros]
      @historial = HistorialAcademico.where(:usuario_ci => pa[:usuario_ci],
                                            :idioma_id => pa[:idioma_id],
                                            :tipo_categoria_id => pa[:tipo_categoria_id],
                                            :tipo_nivel_id => pa[:tipo_nivel_id],
                                            :periodo_id => pa[:periodo_id],
                                            :seccion_numero => pa[:seccion_numero]
   ).limit(1).first
      render :layout => false   
    else
      redirect_to :action => "opciones_menu"
    end
  end
  
  def confirmar_inscripcion_guardar
    idioma_id = params[:historial][:idioma_id]
    tipo_categoria_id = params[:historial][:tipo_categoria_id]
    tipo_nivel_id = params[:historial][:tipo_nivel_id]
    ci = params[:historial][:usuario_ci]
    periodo = session[:parametros][:periodo_actual]
    unless params[:historial][:numero_deposito].eql? ""
      @historial = HistorialAcademico.where(:periodo_id=>periodo, :idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id, :usuario_ci=>ci, :tipo_nivel_id=>tipo_nivel_id).limit(1).first
      @historial.tipo_estado_inscripcion_id = "INS"
      @historial.numero_deposito = params[:historial][:numero_deposito]
  
      if @historial.save
        info_bitacora("Confirmación de Curos: #{@historial.curso.descripcion}")
        flash[:mensaje]="Confirmacion de Inscripcion Exitosa"
        redirect_to :action=> "opciones_menu"
      else
        flash[:mensaje]="no se pudo confirmar la seccion"
        redirect_to :action=> "opciones_menu"
      end
    else
      flash[:mensaje]="debe agregar un numero de depósito"
      redirect_to :action=> "opciones_menu"
    end
  end
  
  def confirmar_eliminar
    p=params[:parametros]
    ci = p[:usuario_ci]
    periodo = session[:parametros][:periodo_actual]
    @historial = HistorialAcademico.where(:idioma_id=>p[:idioma_id],:tipo_categoria_id=>p[:tipo_categoria_id],:periodo_id=>periodo,:usuario_ci=>ci).limit(1).first
    render :layout => false
  end
  
  def eliminar_curso
    periodo = session[:parametros][:periodo_actual]
    idioma_id,tipo_categoria_id = params[:tipo_curso].split(",")
    ci = params[:usuario_ci]
    h = HistorialAcademico.where(:usuario_ci=>ci, :periodo_id=>periodo, :idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id).limit(1).first
    if h.destroy
      session[:estudiante] = Estudiante.find(ci)
      info_bitacora("Eliminado Curso: #{h.curso.descripcion}")
      flash[:mensaje] = "curso eliminado corréctamente"
      redirect_to  :action=>"opciones_menu"
    else
      flash[:mensaje] = "el curso no pudo ser eliminado"
      redirect_to  :action=>"opciones_menu"
    end
   
   
  end
  
  def confirmar_resetear
    @usuario = Usuario.where(:ci =>session[:estudiante_ci]).limit(1).first
    render :layout=> false
  end
  
  def resetear_contrasena
    @usuario = Usuario.where(:ci =>session[:estudiante_ci]).limit(1).first
    @usuario.contrasena = @usuario.ci
    
    if @usuario.save
      info_bitacora("Contraseña reseteada, estudiante: #{@usuario.ci}")
      AdministradorMailer.aviso_general("#{@usuario.correo}","Su Contraseña fue Reseteada II", "su contraseña fue reseteada, ahora es:#{@usuario.contrasena}. Si ud. no solicitó este servicio dirijase a nuestras oficinas a fin de aclarar la situación").deliver
      flash[:mensaje] = "Contraseña reseteada corréctamente, un correo electrónico con la información fue enviado a la cuenta de correo del estudiante"
      redirect_to  :action=>"opciones_menu"
    else
      flash[:mensaje] = "no se pudo resetear la contraseña"
      redirect_to  :action=>"opciones_menu"
    end
    
  end
  
  def generar_constancia_notas

    idioma_id,tipo_categoria_id = params[:tipo_curso].split(",")
    ci = session[:estudiante_ci]
    
    
    periodo_actual = session[:parametros][:periodo_actual]

    if HistorialAcademico.where(:usuario_ci=>ci, :idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id).delete_if{|x| !x.aprobo_curso?}.count > 0 &&  pdf = DocumentosPDF.generar_constancia_notas(ci,idioma_id,tipo_categoria_id,false)
        send_data pdf.render,:filename => "constancia_notas_#{idioma_id}-#{tipo_categoria_id} #{ci}.pdf",:type => "application/pdf", :disposition => "attachment"
        info_bitacora("Constancia de Notas generada: #{idioma_id}-#{tipo_categoria_id} #{ci}")
    else
      flash[:mensaje] = "No dispone de niveles aprobados para generar constancia de este curso"
      redirect_to :action=>"opciones_menu"
    end
  end

  def remitente
    @p = params[:parametros]
    render :layout=>false
  end

  def generar_constancia_estudio
    idioma_id,tipo_categoria_id = params[:tipo_curso].split(",")
    remitente = params[:remitente]
    ci = session[:estudiante_ci]
    
    periodo_actual = session[:parametros][:periodo_actual]

    if HistorialAcademico.where(:usuario_ci=>ci, :idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id).count > 0 &&  pdf = DocumentosPDF.generar_constancia_estudio(ci,idioma_id,tipo_categoria_id,remitente,periodo_actual)
        send_data pdf.render,:filename => "constancia_estudio_#{idioma_id}-#{tipo_categoria_id} #{ci}.pdf"
        info_bitacora("Constancia de Estudio generada: #{idioma_id}-#{tipo_categoria_id} #{ci}")
    else
      flash[:mensaje] = "No dispone de niveles aprobados para generar constancia de este curso"
      redirect_to :action=>"opciones_menu"
    end
  end


  
  def generar_certificado
    idioma_id,tipo_categoria_id = params[:tipo_curso].split(",")
    ci = session[:estudiante_ci]
    
    
    if pdf = DocumentosPDF.generar_certificado_curso(ci,idioma_id,tipo_categoria_id,false)
      send_data pdf.render,:filename => "certificado_#{idioma_id}-#{tipo_categoria_id} #{ci}.pdf",:type => "application/pdf", :disposition => "attachment"
      info_bitacora("Certificado generado: #{idioma_id}-#{tipo_categoria_id} #{ci}")
    else
      flash[:mensaje] = "en estos momentos no se puede generar el certificado"
      redirect_to :action=>"opciones_menu"
    end
    
  end
  

  def confirmar_congelar_curso

    p=params[:parametros]
    ci = p[:usuario_ci]
    periodo = session[:parametros][:periodo_actual]
    @historial = HistorialAcademico.where(:idioma_id=>p[:idioma_id],:tipo_categoria_id=>p[:tipo_categoria_id],:periodo_id=>periodo,:usuario_ci=>ci).limit(1).first
    render :layout => false
 

  end
  
  def congelar_curso

    periodo = session[:parametros][:periodo_actual]
    idioma_id,tipo_categoria_id = params[:tipo_curso].split(",")
    ci = params[:usuario_ci]
    h = HistorialAcademico.where(:usuario_ci=>ci, :periodo_id=>periodo, :idioma_id=>idioma_id, :tipo_categoria_id=>tipo_categoria_id).limit(1).first
  
    h.tipo_estado_calificacion_id = "CO"
    h.tipo_estado_inscripcion_id = "CON"
        
    if h.save
      session[:estudiante] = Estudiante.find(ci)
      info_bitacora("Congelando Curso: #{h.curso.descripcion}")
      flash[:mensaje] = "curso congelado correctamente"
    else
      flash[:mensaje] = "el curso no pudo ser congelado"
    end
    
    redirect_to  :action=>"opciones_menu"

  end  

  def descargar_planilla
    cedula = params[:id]
    if pdf = DocumentosPDF.generar_planilla(cedula)
      send_data pdf.render,:filename => "preinscripcion_#{cedula}.pdf",:type => "application/pdf", :disposition => "attachment"
    end
  end

  def descargar_planilla_pre_diplomado_cohorte
    
    estudiante_ci = params[:estudiante_ci]
    diplomado_id = params[:diplomado_id]
    cohorte_id = params[:cohorte_id]

    if pdf = DocumentosPDF.generar_planilla_pre_diplomado_cohorte(estudiante_ci,diplomado_id,cohorte_id)
      send_data pdf.render,:filename => "preinscripcion_#{estudiante_ci}_#{diplomado_id}_#{cohorte_id}.pdf",:type => "application/pdf", :disposition => "attachment"
    end
  end

end
