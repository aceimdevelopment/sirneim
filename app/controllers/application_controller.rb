class ApplicationController < ActionController::Base
  protect_from_forgery
  def historiales_usuarios
      @historiales = HistorialAcademico.where(:periodo_id => session[:periodo_id],
                                              :idioma_id => session[:idioma_id],
                                              :tipo_categoria_id => session[:tipo_categoria_id],
					      :tipo_estado_inscripcion_id => "INS",
                                              :tipo_nivel_id => session[:tipo_nivel_id],
                                              :seccion_numero => session[:seccion_numero]
                                             )                                          
      cedulas = @historiales.collect{|ced| ced.usuario_ci}
      @historiales = @historiales.sort_by{|x| x.usuario.nombre_completo}
      @usuarios = Usuario.where(:ci => cedulas).sort_by{|x| x.nombre_completo}
      return @historiales, @usuarios
  end  
  
  def info_bitacora(descripcion, estudiante_ci = nil)
    usuario_ci = (session[:usuario]) ? session[:usuario].ci : nil
    estudiante_ci = (session[:estudiante]) ? session[:estudiante].usuario_ci : nil
    administrador_ci = (session[:administrador]) ? session[:administrador].usuario_ci : nil                     
    
    Bitacora.info(
      :descripcion => descripcion, 
      :usuario_ci => usuario_ci,
      :estudiante_usuario_ci =>estudiante_ci,
      :administrador_usuario_ci =>administrador_ci,
      :ip_origen => request.remote_ip
      )
  end
    
private  
  def cargar_parametros_generales   
    session[:parametros] = {}
    ParametroGeneral.all.each{|registro|
      session[:parametros][registro.id.downcase.to_sym] = registro.valor.strip
    }
  end

  def cal_cargar_parametros_generales   
    session[:cal_parametros] = {}
    CalParametroGeneral.all.each{|registro|
      session[:cal_parametros][registro.id.downcase.to_sym] = registro.valor.strip
    }
  end

  
  def filtro_inscripcion_abierta
    if session[:parametros][:inscripcion_abierta] != "SI"                    
      if session[:parametros][:inscripcion_nuevos_abierta] != "SI" || !session[:nuevo]
        flash[:mensaje] = "Esta funcionalidad no está activa en este momento"  
        info_bitacora "Intento inscribirse pero por filtro de inscripcion no pudo"
        redirect_to :action => "principal", :controller => "principal"  
        return false
      end
    end
  end
  
  def filtro_logueado
    unless session[:usuario]
      flash[:mensaje_login] = "Debe iniciar sesión"  
      redirect_to :action => "index", :controller => "inicio"  
      return false
    end
  end
  
  def filtro_administrador
    unless session[:administrador]
      flash[:alert] = "Debe iniciar sesión como administrador"  
      info_bitacora "Intento malo del administrador"
      redirect_to :action => "index", :controller => "inicio"  
      return false
    end
  end    
  
  def filtro_primer_dia
    usuario_curso = EstudianteCurso.find(session[:usuario], 
        session[:tipo_curso].idioma_id, 
        session[:tipo_curso].tipo_categoria_id)
    ultimo = usuario_curso.ultimo_historial
    if session[:parametros][:inscripcion_permitir_cambio_horario] != "SI"
      if (usuario_curso.tipo_estudiante != EstudianteCurso::REGULAR || !ultimo.aprobo_curso?) && !session[:nuevo] 
        info_bitacora "Intento inscribirse pero por filtro del primer dia no pudo"
        flash[:mensaje] = "Aún no puede preinscribirse debe esperar a las fechas que corresponden a su caso"
        redirect_to :action => "principal", :controller => "principal"  
        return false
      end
    end
    return true
  end 
  
  def filtro_nuevos 
    #return 
    if controller_name == "incripcion" && action_name == "paso0"
      authenticate_or_request_with_http_basic do |id, password|
         id.downcase == "nuevos" && password.downcase == "jnuevos"
      end  
    end
  end    

# Funciones especiales y temporales para calificar

  def cal_filtro_logueado
    unless session[:cal_usuario]
      reset_session
      flash[:alert] = "Debe iniciar sesión"
      redirect_to :action => "index", :controller => "cal_inicio"  
      return false
    end
  end
  
  def cal_filtro_administrador
    unless session[:cal_administrador]
      reset_session
      flash[:alert] = "Debe iniciar sesión como Administrador"  
      redirect_to :action => "index", :controller => "cal_inicio"
      return false
    end
  end

  def cal_filtro_admin_profe
    unless session[:cal_administrador] or session[:cal_profesor] 
      reset_session
      flash[:alert] = "Debe iniciar sesión como Profesor o Administrador"  
      redirect_to :action => "index", :controller => "cal_inicio"
      return false
    end
  end


  def cal_filtro_profesor
    unless session[:cal_profesor]
      reset_session
      flash[:alert] = "Debe iniciar sesión como Profesor"  
      redirect_to :action => "index", :controller => "cal_inicio"
      return false
    end
  end

  def cal_filtro_estudiante
    unless session[:cal_estudiante]
      reset_session
      flash[:alert] = "Debe iniciar sesión como Profesor"  
      redirect_to :action => "index", :controller => "cal_inicio"
      return false
    end
  end


  
end
