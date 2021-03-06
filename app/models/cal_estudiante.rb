class CalEstudiante <  ActiveRecord::Base
	set_primary_key :cal_usuario_ci

	attr_accessible :cal_usuario_ci, :idioma1_id, :idioma2_id, :plan, :cal_tipo_estado_inscripcion_id

 	belongs_to :cal_usuario,
    	:class_name => 'CalUsuario',
    	:foreign_key => ['cal_usuario_ci']

 	belongs_to :idioma1,
    	:class_name => 'CalDepartamento',
    	:foreign_key => ['idioma1_id']

 	belongs_to :idioma2,
    	:class_name => 'CalDepartamento',
    	:foreign_key => ['idioma2_id']

    has_one :cita_horaria,
    	:class_name => 'CitaHoraria',
    	:foreign_key => :estudiante_ci,
    	:primary_key => :cal_usuario_ci
	accepts_nested_attributes_for :cita_horaria

	has_many :cal_estudiantes_secciones,
		:class_name => 'CalEstudianteSeccion',
 		:foreign_key => :cal_estudiante_ci,
 		:primary_key => :cal_usuario_ci

	accepts_nested_attributes_for :cal_estudiantes_secciones

	has_many :cal_secciones, through: :cal_estudiantes_secciones, source: :cal_seccion

	# has_many :categorias, :through => :tipo_curso, :source => :tipo_categoria
	# has_many :cal_estudiante_en_secciones,
	# 	:class_name => 'CalEstudianteSeccion',
	# 	:foreign_key => :estudiante_ci
	# accepts_nested_attributes_for :cal_secciones

	has_many :historiales_planes,
		class_name: 'CalEstudianteTipoPlan',
		:foreign_key => :cal_estudiante_ci,
		:primary_key => :cal_usuario_ci


	accepts_nested_attributes_for :historiales_planes

	has_many :planes, :through => :historiales_planes, :source => :tipo_plan

	has_many :combinaciones,
		:class_name => 'Combinacion',
		:foreign_key => :cal_estudiante_ci, dependent: :delete_all

	accepts_nested_attributes_for :combinaciones

	def inactivo?
		total_materias = cal_estudiantes_secciones.del_semestre_actual.count
		total_retiradas = cal_estudiantes_secciones.del_semestre_actual.where(cal_tipo_estado_inscripcion_id: 'RET').count
		(total_materias > 0 and total_materias == total_retiradas)
	end

	def inscrito?
		cal_estudiantes_secciones.del_semestre_actual.count > 0
	end

	def valido_para_inscribir?
		# cal_estudiantes_secciones.del_semestre_actual.count < 1
		! inscrito?
	end

	def ultimo_plan
		hp = historiales_planes.order("desde_cal_semestre_id DESC").first
		hp ? hp.tipo_plan_id : ""
	end

	def annos
		cal_secciones.collect{|s| s.cal_materia.anno}.uniq
	end
	def annos_del_semestre_actual
		cal_estudiantes_secciones.del_semestre_actual.collect{|s| s.cal_seccion.cal_materia.anno}.uniq
	end

	# def secciones
	# 	estudiante_en_secciones.secciones
	# end
	scope :con_cita_horaria, -> {where "cita_horaria_id IS NOT NULL"}

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

	def archivos_disponibles_para_descarga
		secciones_aux = cal_secciones.where(:cal_semestre_id => CalParametroGeneral.cal_semestre_anterior_id)

		archivos = []
		annos = []
		if secciones_aux.all.count > 0

			# Selecciono los posibles niveles

			reprobadas = 0

			joins_seccion_materia = secciones_aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia)
			secciones_aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).group("cal_materia.anno").each{|x| annos << x.anno if x.anno > 0}

			cal_estudiantes_secciones.delete_if{|es| es.numero.eql? 'R'}.each do |est_sec|
				
				if est_sec.calificacion_final and est_sec.calificacion_final < 10
					reparacion = cal_estudiantes_secciones.where('cal_estudiante_ci = ? and cal_materia_id = ? and numero = ?', cal_usuario_ci, est_sec.cal_materia_id, 'R').first

					if reparacion
						reprobadas = reprobadas + 1 if reparacion.calificacion_final < 10
					else
						reprobadas = reprobadas + 1
					end 
				end
				# break if reprobadas > 1	
			end
			begin
				
				if annos.count.eql? 1
					if reprobadas.eql? 0 
						annos[0] = annos[0]+1 if annos.first < 5 
					else
						annos << annos.first+1 if annos.first < 5
					end
				else

					aux = secciones_aux.where('calificacion_final < ? ', 10)
					menor_anno = aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).where(' cal_materia.anno = ?', annos.min).all
					annos.delete annos.min if menor_anno.count.eql? 0
					
					mayor_anno = aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).where(' cal_materia.anno = ?', annos.max).all.count
					if mayor_anno.eql? 0
						total_materias = CalMateria.where(:anno => annos.max).count
						if total_materias.eql? secciones_aux.joins(:cal_materia).where('cal_materia.anno = ?', annos.max).all.count
							if annos.max<5
								annos << annos.max+1
								# annos.delete annos.max
							end
						end

					end
					
					annos << annos.last+1 if (reprobadas < 2 and annos.max<5)

				end

			rescue Exception => e
				annos << 1 << 2 << 3 << 4 << 5
			end

		else

			if cal_tipo_estado_inscripcion_id.eql? 'NUEVO'
				annos << 1
			else
				annos << 1 << 2 << 3 << 4 << 5
			end
		end

		# Selecciono los posibles idiomas

		if idioma1_id.nil? and idioma2_id.nil?
			annos.each do |anno|
				archivos << "FRA-ALE-#{anno}"
				archivos << "FRA-ITA-#{anno}"
				archivos << "FRA-POR-#{anno}"
				archivos << "ING-ALE-#{anno}"
				archivos << "ING-FRA-#{anno}"
				archivos << "ING-ITA-#{anno}"
				archivos << "ING-POR-#{anno}"
			end
		else 
			ni_ingles_ni_frances = false

			unless (idioma1_id.eql? 'ING' or idioma1_id.eql? 'FRA') or (idioma2_id.eql? 'ING' or idioma2_id.eql? 'FRA')

				idiomas = "ING-#{idioma1_id}-"
				idiomas_2 = "ING-#{idioma2_id}-"
				idiomas_3 = "FRA-#{idioma1_id}-"
				idiomas_4 = "FRA-#{idioma2_id}-"
				ni_ingles_ni_frances = true
			else
				idiomas = "#{idioma1_id}-#{idioma2_id}-"
			end

			# Compilo los archivos en relacion idiomas niveles

			annos.each{|ano| archivos << idiomas+ano.to_s}

			if ni_ingles_ni_frances
				annos.each{|ano| archivos << idiomas_2+ano.to_s}
				annos.each{|ano| archivos << idiomas_3+ano.to_s}
				annos.each{|ano| archivos << idiomas_4+ano.to_s}
			end
		end
		# puts "AÑÑÑÑÑOOOOOOOOOOSSSSS antes del retorno: #{annos}"

		return archivos
	end # Fin de funcion archivos_disponibles_para_descarga
end # Fin clase 
