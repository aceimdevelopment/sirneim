class CalSeccion < ActiveRecord::Base
	attr_accessible :numero, :cal_materia_id, :cal_semestre_id, :cal_profesor_ci

	set_primary_keys :numero, :cal_materia_id, :cal_semestre_id

	belongs_to :cal_materia

	belongs_to :cal_profesor,
		:foreign_key => :cal_profesor_ci

	belongs_to :cal_semestre

	has_many :cal_estudiantes_secciones,
		:class_name => 'CalEstudianteSeccion',
 		:foreign_key => [:cal_numero, :cal_materia_id, :cal_semestre_id],
 		:primary_key => [:numero, :cal_materia_id, :cal_semestre_id]

	accepts_nested_attributes_for :cal_estudiantes_secciones

	has_many :cal_estudiantes, :through => :cal_estudiantes_secciones, :source => :cal_estudiante  

  	# has_many :categorias, :through => :tipo_curso, :source => :tipo_categoria

	# has_and_belongs_to_many :estudiantes, :join_table => "estudiante_en_seccion", :foreign_key => [:seccion_id, :materia_id, :categoria_id, :departamento_id, :semestre_id]
	# accepts_nested_attributes_for :estudiantes

	def descripcion
		descripcion = ""
		descripcion += cal_materia.descripcion if cal_materia
		
		if numero
			if numero.eql? "S"
				descripcion += " (Suficiencia)"
			elsif numero.eql? "R"
				descripcion += " (Reparación)"
			else
				descripcion += " - #{numero}"
			end
		end 
		return descripcion
	end

	def descripcion_profesor_asignado
		if cal_profesor
			cal_profesor.descripcion_usuario
		else
			"No asignado"
		end
	end
end