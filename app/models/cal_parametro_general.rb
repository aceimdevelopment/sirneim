class CalParametroGeneral < ActiveRecord::Base
  attr_accessible :id, :valor
  
  def self.cal_semestre_actual_id
    CalParametroGeneral.first(:conditions=>["id = ?", "SEMESTRE_ACTUAL"]).valor
  end

  def self.cal_semestre_actual
    id = CalParametroGeneral.first(:conditions=>["id = ?", "SEMESTRE_ACTUAL"]).valor
    CalSemestre.where(:id => id).limit(1).first
  end

end 
