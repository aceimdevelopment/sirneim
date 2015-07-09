class CalEstudiante <  ActiveRecord::Base
	set_primary_keys :cal_usuario_ci

	attr_accessible :cal_usuario_ci

 	belongs_to :cal_usuario,
    	:class_name => 'CalUsuario',
    	:foreign_key => ['ci']

	has_many :cal_secciones, :through => :cal_estudiante_secciones, :source => :cal_seccion  
	
	# has_many :cal_estudiante_en_secciones,
	# 	:class_name => 'CalEstudianteSeccion',
	# 	:foreign_key => :estudiante_ci
	# accepts_nested_attributes_for :cal_estudiante_en_seccionesaawsq

	# def secciones
	# 	estudiante_en_secciones.secciones
	# end

end
