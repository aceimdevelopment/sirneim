# encoding: utf-8

class EstudianteNivelacionesController < ApplicationController
  # GET /estudiante_nivelaciones
  # GET /estudiante_nivelaciones.json
  def index 
    @titulo_pagina = "Estudiantes con nivelación - Periodo #{session[:parametros][:periodo_actual]}"
    @estudiante_nivelaciones = EstudianteNivelacion.where(:periodo_id => session[:parametros][:periodo_actual])
  end

  # GET /estudiante_nivelaciones/1
  # GET /estudiante_nivelaciones/1.json
  def buscar
    @titulo_pagina = "Agregar estudiante con nivelación"
    @usuario = Usuario.where(:ci => params[:usuario][:ci]).first
    unless @usuario                      
      @usuario = Usuario.new
      @usuario.ci = params[:usuario][:ci]
    end
    @tipo_curso = TipoCurso.all.sort_by{|x| x.descripcion}
    @tipo_nivel = TipoNivel.all.sort_by{|x| x.id.to_i}
  end
  
  def agregar
    @usuario = Usuario.where(:ci => params[:usuario][:ci]).first
     unless @usuario                      
       @usuario = Usuario.new
       @usuario.ci = params[:usuario][:ci]
       @usuario.telefono_habitacion = ""
       @usuario.direccion = ""
       @usuario.contrasena = params[:usuario][:ci]  
       @usuario.contrasena_confirmation = params[:usuario][:ci]  
       @usuario.fecha_nacimiento = "1990-01-01"
    end                
    usr = params[:usuario]
    @usuario.nombres = usr[:nombres]
    @usuario.apellidos = usr[:apellidos]
    @usuario.correo = usr[:correo]
    @usuario.tipo_sexo_id = usr[:tipo_sexo_id]
    @usuario.telefono_movil = usr[:telefono_movil]                    
    if @usuario.save  
      unless Estudiante.where(usuario_ci: params[:usuario][:ci]).first
        est = Estudiante.new
        est.usuario_ci = params[:usuario][:ci]
        est.save
      end                   

      unless EstudianteCurso.where(usuario_ci: params[:usuario][:ci]).first
        ec = EstudianteCurso.new
        ec.usuario_ci = @usuario.ci
        ec.idioma_id = idioma_id
        ec.tipo_categoria_id = tipo_categoria_id
        ec.tipo_convenio_id = "EXO"
        ec.save
      end
      
      en = EstudianteNivelacion.new
      en.usuario_ci = @usuario.ci
      en.periodo_id = session[:parametros][:periodo_actual]
      en.observaciones = params[:varios][:observaciones]
      idioma_id, tipo_categoria_id = params[:varios][:tipo_curso_id].split","
      en.idioma_id = idioma_id
      en.tipo_nivel_id = params[:varios][:tipo_nivel_id]
      en.tipo_categoria_id = tipo_categoria_id
      en.save!



      flash[:mensaje] = "El estudiante con nivelación ha sido agregado"
      redirect_to :action => "index"
    else                       
      @tipo_curso = TipoCurso.all.sort_by{|x| x.descripcion}
      @tipo_nivel = TipoNivel.all.sort_by{|x| x.id.to_i}
      render :action => "buscar"
    end
    
  end

  # GET /estudiante_nivelaciones/new
  # GET /estudiante_nivelaciones/new.json
  def new
    @estudiante_nivelacion = EstudianteNivelacion.new
  end 

  def ver_correos
  @titulo_pagina = "Correos de los estudiantes en nivelación"
   @correos = EstudianteNivelacion.where(:periodo_id => session[:parametros][:periodo_actual]).collect{|x| x.usuario.correo}.join(", ")
  end
  
  
  def inscribir
    session[:estudiante_ci] = params[:id]
    redirect_to :controller => "inscripcion_admin", :action => "paso0", :idioma => params[:idioma]
  end



  def eliminar
    @estudiante_nivelacion = EstudianteNivelacion.find(params[:id])
    @estudiante_nivelacion.destroy
    flash[:mensaje] = "Se ha eliminado la nivelación"
    redirect_to :action => "index"
  end
end
