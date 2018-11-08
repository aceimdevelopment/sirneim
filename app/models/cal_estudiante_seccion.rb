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

	def nota_final_para_csv
		# Notas 00 a 20 / AP = Aplasado, A = Aprobado, PI = , SN = Sin nota, NP
		if pi?
			return'00'
		elsif retirada?
			return 'RT'
		elsif !calificacion_completa?
			return 'SN'
		elsif cal_materia_id.eql? 'SERCOM'
			if aprobada?
				return 'A'
			else
				return 'AP'
			end
		elsif reprobada?
			return 'AP'
		else
			return colocar_nota.to_s
		end

	end

	def calificacion_para_kardex
		return calificacion_completa? ? calificacion_final : 'SN'
	end

	def reprobada?
		return cal_tipo_estado_calificacion_id.eql? 'RE'
	end

	def aprobada?
		return cal_tipo_estado_calificacion_id.eql? 'AP'
	end

	def calificacion_completa?
		if calificacion_primera.nil? or calificacion_segunda.nil? or calificacion_tercera.nil? or calificacion_final.nil?
			return false
		else
			return true
		end
	end

	def descripcion
		aux = cal_seccion.cal_materia.descripcion
		aux += " <b>(Retirada)</b>" if retirada?
		return aux
	end

	def pi?
		cal_tipo_estado_calificacion_id.eql? 'PI'
	end

	def colocar_nota
		if calificacion_final.nil?
			return '--'
		else
			return sprintf("%02i",calificacion_final)
		end
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

	def calificacion_en_letras

		valor = ''
		if retirada?
			valor = 'RETIRADA'
		elsif pi?
			valor = 'PERDIDA POR INASISTENCIA'
		elsif calificacion_final.nil?
			valor = 'POR DEFINIR'
		else
			case calificacion_final
			when 1
				valor = "CERO UNO"
			when 2
				valor = "CERO DOS"
			when 3
				valor = "CERO TRES"
			when 4
				valor = "CERO CUATRO"
			when 5
				valor = "CERO CINCO"
			when 6
				valor = "CERO SEIS"
			when 7
				valor = "CERO SIETE"
			when 8
				valor = "CERO OCHO"
			when 9
				valor = "CERO NUEVE"
			when 10
				valor = "DIEZ"
			when 11
				valor = "ONCE"
			when 12
				valor = "DOCE"
			when 13
				valor = "TRECE"
			when 14
				valor = "CATORCE"
			when 15
				valor = "QUINCE"
			when 16
				valor = "DIEZ Y SEIS"
			when 17
				valor = "DIEZ Y SIETE"
			when 18
				valor = "DIEZ Y OCHO"
			when 19
				valor = "DIEZ Y NUEVE"
			when 20
				valor = "VEINTE"
			else
				valor = "SIN VALOR"
			end						
		end
		return valor
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