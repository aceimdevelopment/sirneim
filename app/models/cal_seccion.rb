# encoding: utf-8

class CalSeccion < ActiveRecord::Base
	attr_accessible :numero, :cal_materia_id, :cal_semestre_id, :cal_profesor_ci, :capacidad

	set_primary_keys :numero, :cal_materia_id, :cal_semestre_id

	belongs_to :cal_materia

	belongs_to :cal_profesor,
		:foreign_key => :cal_profesor_ci

	belongs_to :cal_semestre

	has_many :cal_estudiantes_secciones,
		class_name: 'CalEstudianteSeccion',
 		foreign_key: [:cal_numero, :cal_materia_id, :cal_semestre_id],
 		# :primary_key => [:cal_numero, :cal_materia_id, :cal_semestre_id]
 		# ojo al colocar la linea anterior dejan de aparecer los estudiantes_secciones de las secciones
 		primary_key: [:numero, :cal_materia_id, :cal_semestre_id], 
 		dependent: :delete_all
	accepts_nested_attributes_for :cal_estudiantes_secciones

	has_many :cal_estudiantes, through: :cal_estudiantes_secciones, source: :cal_estudiante


	has_many :cal_secciones_profesores_secundarios,
		:class_name => 'CalSeccionProfesorSecundario',
 		:foreign_key => [:numero, :cal_materia_id, :cal_semestre_id],
 		:primary_key => [:numero, :cal_materia_id, :cal_semestre_id]

	accepts_nested_attributes_for :cal_secciones_profesores_secundarios

	has_many :cal_profesores, :through => :cal_secciones_profesores_secundarios, :source => :cal_profesor

	# validates_uniqueness_of :numero, :cal_materia_id, :cal_semestre_id

  	# has_many :categorias, :through => :tipo_curso, :source => :tipo_categoria

	# has_and_belongs_to_many :estudiantes, :join_table => "estudiante_en_seccion", :foreign_key => [:seccion_id, :materia_id, :categoria_id, :departamento_id, :semestre_id]
	# accepts_nested_attributes_for :estudiantes

	scope :calificadas, -> {where "calificada IS TRUE"}
	scope :sin_calificar, -> {where "calificada IS FALSE"}
	scope :del_periodo, lambda { |semestre_id| where "cal_semestre_id = ?", semestre_id}
	scope :del_periodo_actual, -> { where "cal_semestre_id = ?", CalParametroGeneral.cal_semestre_actual_id}


	def total_estudiantes
		cal_estudiantes_secciones.count
	end

	def total_confirmados
		cal_estudiantes_secciones.confirmados.count
	end

	def total_aprobados
		cal_estudiantes_secciones.where(:cal_tipo_estado_calificacion_id => 'AP').count
	end

	def total_reprobados
		cal_estudiantes_secciones.where(:cal_tipo_estado_calificacion_id => 'RE').count
	end

	def total_perdidos
		cal_estudiantes_secciones.where(:cal_tipo_estado_calificacion_id => 'PI').count
	end

	def total_sin_calificar
		cal_estudiantes_secciones.where(:cal_tipo_estado_calificacion_id => 'SC').count
	end

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

	def ejercicio
		"#{cal_semestre.id}"
	end

	def r_or_f?
		if numero.include? 'R'
			return 'R'
		else 
			'F'
		end
	end

	def reparacion?
		return numero.include? 'R'
	end

	def tipo_convocatoria
		aux = numero[0..1]
		if reparacion?
			aux = "RA2" #{aux}"
		else
			aux = "FA2" #"F#{aux}"
		end
		return aux
	end

	def acta_no
		"#{self.cal_materia.id_upsi}#{self.numero}#{self.cal_semestre.id}"
	end
end