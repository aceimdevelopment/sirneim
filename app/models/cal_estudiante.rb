class CalEstudiante <  ActiveRecord::Base
	set_primary_key :cal_usuario_ci

	attr_accessible :cal_usuario_ci, :idioma1_id, :idioma2_id, :plan

 	belongs_to :cal_usuario,
    	:class_name => 'CalUsuario',
    	:foreign_key => ['cal_usuario_ci']


 	belongs_to :idioma1,
    	:class_name => 'CalDepartamento',
    	:foreign_key => ['idioma1_id']

 	belongs_to :idioma2,
    	:class_name => 'CalDepartamento',
    	:foreign_key => ['idioma2_id']

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

	def combo_idiomas
		aux = ""
		aux += "#{idioma1.descripcion}" if idioma1
		aux += " - #{idioma2.descripcion}" if idioma2

		aux = "Sin Idiomas Registrados" if aux.eql? ""

		return aux 
	end

	def descripcion 
		cal_usuario.descripcion
	end

end
