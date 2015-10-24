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

	def archivos_disponibles_para_descarga
		secciones_aux = cal_secciones.where(:cal_semestre_id => CalParametroGeneral.cal_semestre_anterior_id)
		# Selecciono los posibles idiomas
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

		# Selecciono los posibles niveles

		reprobadas = 0

		annos = []

		joins_seccion_materia = secciones_aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia)
		secciones_aux.select("cal_seccion.*, cal_materia.*").joins(:cal_materia).group("cal_materia.anno").each{|x| annos << x.anno if x.anno > 0}

		
		cal_estudiantes_secciones.delete_if{|es| es.cal_numero.eql? 'R'}.each do |est_sec|
			
			if est_sec.calificacion_final < 10
				reparacion = cal_estudiantes_secciones.where('cal_estudiante_ci = ? and cal_materia_id = ? and cal_numero = ?', cal_usuario_ci, est_sec.cal_materia_id, 'R').first

				if reparacion
					reprobadas = reprobadas + 1 if reparacion.calificacion_final < 10
				else
					reprobadas = reprobadas + 1
				end 
			end
			# break if reprobadas > 1	
		end

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

		# Compilo los archivos en relacion idiomas niveles

		archivos = []

		annos.each{|ano| archivos << idiomas+ano.to_s}

		if ni_ingles_ni_frances
			annos.each{|ano| archivos << idiomas_2+ano.to_s}
			annos.each{|ano| archivos << idiomas_3+ano.to_s}
			annos.each{|ano| archivos << idiomas_4+ano.to_s}
		end

		# puts "AÑÑÑÑÑOOOOOOOOOOSSSSS antes del retorno: #{annos}"

		return archivos
		
	end

end
