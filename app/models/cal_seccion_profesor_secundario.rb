class CalSeccionProfesorSecundario < ActiveRecord::Base

	attr_accessible :numero, :cal_materia_id, :cal_semestre_id, :cal_profesor_ci

	set_primary_keys :numero, :cal_materia_id, :cal_semestre_id, :cal_profesor_ci
	
	belongs_to :cal_seccion,
 		:foreign_key => [:numero, :cal_materia_id, :cal_semestre_id]	

	belongs_to :cal_profesor,
		:foreign_key => :cal_profesor_ci	

end