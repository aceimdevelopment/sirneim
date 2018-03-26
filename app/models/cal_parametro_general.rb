class CalParametroGeneral < ActiveRecord::Base
  attr_accessible :id, :valor

  def self.programaciones
    CalParametroGeneral.first(:conditions=>["id = 'ACTIVAR_PROGRAMACIONES'"]).valor
  end

  def self.programaciones_encendidas
    val = CalParametroGeneral.first(:conditions=>["id = 'ACTIVAR_PROGRAMACIONES'"]).valor
    val.eql? 'ENCENDIDAS'
  end


  def self.cambiar_programacion(v)
    programaciones = CalParametroGeneral.first(:conditions=>["id = 'ACTIVAR_PROGRAMACIONES'"])
    programaciones.valor = (v.eql? 'ENCENDIDAS') ? 'APAGADAS' : 'ENCENDIDAS'
    programaciones.save
  end
  
  def self.cal_semestre_actual_id
    CalParametroGeneral.first(:conditions=>["id = ?", "SEMESTRE_ACTUAL"]).valor
  end

  def self.cal_semestre_actual
    id = CalParametroGeneral.first(:conditions=>["id = ?", "SEMESTRE_ACTUAL"]).valor
    CalSemestre.where(:id => id).limit(1).first
  end

  def self.cal_semestre_anterior
    id = CalParametroGeneral.first(:conditions=>["id = ?", "SEMESTRE_ANTERIOR"]).valor
    CalSemestre.where(:id => id).limit(1).first
  end

  def self.cal_semestre_anterior_id
    CalParametroGeneral.first(:conditions=>["id = ?", "SEMESTRE_ANTERIOR"]).valor
  end


end 
