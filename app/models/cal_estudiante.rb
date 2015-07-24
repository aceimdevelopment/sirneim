class CalEstudiante <  ActiveRecord::Base
	set_primary_key :cal_usuario_ci

	attr_accessible :cal_usuario_ci

 	belongs_to :cal_usuario,
    	:class_name => 'CalUsuario',
    	:foreign_key => ['cal_usuario_ci']

	has_many :cal_estudiantes_secciones,
		:class_name => 'CalEstudianteSeccion',
 		:foreign_key => :cal_estudiante_ci,
 		:primary_key => :cal_usuario_ci

	accepts_nested_attributes_for :cal_estudiantes_secciones

	has_many :cal_secciones, :through => :cal_estudiantes_secciones, :source => :cal_seccion  
	# has_many :categorias, :through => :tipo_curso, :source => :tipo_categoria
	# has_many :cal_estudiante_en_secciones,
	# 	:class_name => 'CalEstudianteSeccion',
	# 	:foreign_key => :estudiante_ci
	# accepts_nested_attributes_for :cal_estudiante_en_seccionesaawsq

	# def secciones
	# 	estudiante_en_secciones.secciones
	# end

	def descripcion 
		cal_usuario.descripcion
	end

end
