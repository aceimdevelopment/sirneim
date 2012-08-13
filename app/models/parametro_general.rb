#creada por db2models
class ParametroGeneral < ActiveRecord::Base

  
  def self.inscripcion_abierta                                          
    ParametroGeneral.first(:conditions=>["id = ?", "INSCRIPCION_ABIERTA"]).valor == "SI"
  end

  def self.inscripcion_nuevos_abierta                                          
    false #ParametroGeneral.first(:conditions=>["id = ?", "INSCRIPCION_ABIERTA"]).valor == "SI"
  end


end 
