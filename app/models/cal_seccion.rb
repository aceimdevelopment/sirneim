class CalSeccion < ActiveRecord::Base
	attr_accessible :numero, :cal_materia_id, :cal_semestre_id, :cal_profesor_id

	set_primary_key [:numero, :cal_materia_id, :cal_semestre_id]

	belongs_to :cal_materia

	belongs_to :cal_profesor

	belongs_to :cal_semestre

	# has_many :cal_estudiante_en_secciones,
 	#	:foreign_key => [:seccion_id, :materia_id, :categoria_id, :departamento_id, :semestre_id]
	# accepts_nested_attributes_for :estudiante_en_secciones

	has_many :cal_estudiantes, :through => :cal_estudiante_secciones, :source => :cal_estudiantes  

	# has_and_belongs_to_many :estudiantes, :join_table => "estudiante_en_seccion", :foreign_key => [:seccion_id, :materia_id, :categoria_id, :departamento_id, :semestre_id]
	# accepts_nested_attributes_for :estudiantes


	# def descripcion
	# 	"#{id.join(' - ')}"
	# end

end