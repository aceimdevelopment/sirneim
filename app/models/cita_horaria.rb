class CitaHoraria < ActiveRecord::Base
	set_primary_key :estudiante_ci

	attr_accessible :estudiante_ci, :fecha, :hora

 	belongs_to :cal_estudiante,
    	:class_name => 'CalEstudiante',
    	:foreign_key => ['estudiante_ci']

    def descripcion
    	"#{fecha} - #{hora}"
    end

end