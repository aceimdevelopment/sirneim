class ParametrosGeneralesController < ApplicationController
  
  
  def index

    @titulo_pagina = "Configuraciones Generales"

    @preinscripcion_general = ParametroGeneral.find("PREINSCRIPCION_ABIERTA").valor

    @inscripcion_general = ParametroGeneral.find("INSCRIPCION_ABIERTA").valor
  
  end
  

  def guardar_parametros
    
    inscripcion_general = ParametroGeneral.find("INSCRIPCION_ABIERTA")
    inscripcion_general.valor = params[:inscripcion_general]
    inscripcion_general.save

    inscripcion_general = ParametroGeneral.find("PREINSCRIPCION_ABIERTA")
    inscripcion_general.valor = params[:preinscripcion_general]
    inscripcion_general.save

  
    flash[:mensaje] = "Configuraciones almacenadas con éxito"
    redirect_to(:action=>"index")    

  end

  def cambiar_periodo_modal
    @metodo_invocador = params[:parametros][:invocador]
    @periodos = Periodo.all.collect{|x| x}.sort_by{|x| "#{x.ano} #{x.id}"}.reverse()
    render :layout => false
  end
  
  def cambiar_periodo
    
    if params[:metodo_invocador] == "cambiar_periodo_general"
    
      periodo_actual = ParametroGeneral.find("PERIODO_ACTUAL")
      periodo_actual.valor = params[:periodo][:id] 
      periodo_actual.save

      letra , ano = params[:periodo][:id].split "-"

      case letra
    	  when "A"
    		  nueva_letra = "D"
          ano = ano.to_i - 1
    		when "B"
    			nueva_letra = "A"
    		when "C"
    			nueva_letra = "B"
    		when "D"
    			nueva_letra = "C"
      end

      periodo_anterior = ParametroGeneral.find("PERIODO_ANTERIOR")
      periodo_anterior.valor = nueva_letra + "-" + ano.to_s
      periodo_anterior.save

      session[:parametros][:periodo_actual] = params[:periodo][:id] 

      flash[:mensaje] = "Periodo General por defecto cambiado con éxito"
    
    else
      
      if params[:metodo_invocador] == "cambiar_periodo_calificacion"
     
        periodo_calificacion = ParametroGeneral.find("PERIODO_CALIFICACION") 
        periodo_calificacion.valor = params[:periodo][:id] 
        periodo_calificacion.save

        flash[:mensaje] = "Periodo de Calificación cambiado con éxito"
     
      else

        periodo_inscripcion = ParametroGeneral.find("PERIODO_INSCRIPCION")
        periodo_inscripcion.valor = params[:periodo][:id] 
        periodo_inscripcion.save

      end
      

    end    
  
    redirect_to(:action=>"index")    

  end

  def crear_nuevo_periodo_modal
    
    ultimo_periodo = Periodo.order("periodo.ano ASC, periodo.id ASC").last
  
    letra , ano = ultimo_periodo.id.split "-"

    case letra
  	  when "A"
  		  nueva_letra = "B"
  		when "B"
  			nueva_letra = "C"
  		when "C"
  			nueva_letra = "D"
  		when "D"
  			nueva_letra = "A"
        ano = ano.to_i + 1
    end

    @nuevo_periodo = nueva_letra + "-" + ano.to_s
    
    render :layout => false
  
  end



  def crear_nuevo_periodo

    nuevo_periodo = params[:periodo_id]
    letra , ano = nuevo_periodo.split "-"

    @periodo = Periodo.new
  	@periodo.id = nuevo_periodo
    @periodo.ano = ano
    @periodo.fecha_inicio = '0000-00-00'
             
    if @periodo.save
      info_bitacora("Nueva Periodo Creado: #{nuevo_periodo}")
      flash[:mensaje] = "Periodo Creado Satisfactoriamente"
      redirect_to(:action=>"index")
    else
      flash[:mensaje] = "No se pudo crear el nuevo periodo"
      redirect_to(:action=>"index")
    end
  
  end

  
end
