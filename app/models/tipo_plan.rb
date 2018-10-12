
class TipoPlan <  ActiveRecord::Base

	attr_accessible :id, :descripcion

	has_many :historiales_planes,
		class_name: 'CalEstudianteTipoPlan',
		:foreign_key => :tipo_plan_id

	accepts_nested_attributes_for :historiales_planes

	has_many :cal_estudiantes, :through => :historiales_planes, :source => :cal_estudiante, :foreign_key => :cal_estudiante_ci 

	def descripcion_completa
		"#{id} - #{descripcion}"
	end

end # Fin clase 
