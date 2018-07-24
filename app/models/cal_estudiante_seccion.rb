class CalEstudianteSeccion < ActiveRecord::Base

	set_primary_keys :cal_estudiante_ci, :cal_numero, :cal_materia_id, :cal_semestre_id

	attr_accessible :cal_estudiante_ci, :cal_numero, :cal_materia_id, :cal_semestre_id, 
	:calificacion_primera, :calificacion_segunda, :calificacion_tercera, :calificacion_final, 
	:cal_tipo_estado_calificacion_id, :cal_tipo_estado_inscripcion_id, :retirada

	belongs_to :cal_seccion,
    	:foreign_key => [:cal_numero, :cal_materia_id, :cal_semestre_id]

	belongs_to :cal_estudiante,
    	:primary_key => :cal_usuario_ci,
    	:foreign_key => :cal_estudiante_ci

	belongs_to :cal_tipo_estado_calificacion
	belongs_to :cal_tipo_estado_inscripcion

	scope :confirmados, -> {where "confirmar_inscripcion = ?", 1}
	scope :del_semestre_actual, -> {where "cal_semestre_id = ?", CalParametroGeneral.cal_semestre_actual_id}

	scope :no_retirados, -> {where "cal_tipo_estado_inscripcion_id != ?", 'RET'}
	scope :retirados, -> {where "cal_tipo_estado_inscripcion_id = ?", 'RET'}
	scope :del_semestre, lambda { |semestre_id| where "cal_semestre_id = ?", semestre_id}

	def descripcion
		aux = cal_seccion.cal_materia.descripcion
		aux += " <b>(Retirada)</b>" if retirada?
		return aux
	end

	def pi?
		cal_tipo_estado_calificacion_id.eql? 'PI'
	end

	def tipo_calificacion
		tipo = ''
		if retirada?
			tipo = 'RT'
		elsif pi?
			tipo = 'PI'
		elsif calificacion_final.nil?
			tipo = 'PD'
		else

			if cal_seccion.numero.include? 'R'
				tipo = calificacion_final.to_i > 9 ? 'RA' : 'RR'
			else
				tipo = calificacion_final.to_i > 9 ? 'NF' : 'AP'
			end
		end
		return tipo
	end

	def nombre_estudiante_con_retiro
		aux = cal_estudiante.cal_usuario.apellido_nombre
		aux += " (retirado)" if retirada? 
		return aux
	end

	def retirada?
		return (cal_tipo_estado_inscripcion_id.eql? 'RET') ? true : false
	end
	# validates :id, :presence => true, :uniqueness => true	

end