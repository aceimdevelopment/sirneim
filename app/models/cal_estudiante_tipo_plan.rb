class CalEstudianteTipoPlan <  ActiveRecord::Base

	set_primary_keys :cal_estudiante_ci, :tipo_plan_id

	attr_accessible  :cal_estudiante_ci, :tipo_plan_id, :desde_cal_semestre_id

	validates :tipo_plan_id, uniqueness: {scope: [:cal_estudiante_ci, :desde_cal_semestre_id]}

#	validates_uniqueness_of [:cal_estudiante_ci, :tipo_plan_id], message: 'Plan de Estudio ya existe. Por favor edítelo.', field_name: false
#	validates :id, presence: true, uniqueness: true

	belongs_to :cal_estudiante,
		foreign_key: 'cal_estudiante_ci' 	

	belongs_to :tipo_plan

	belongs_to :cal_semestre,
		class_name: 'CalTipoAdmin',
		foreign_key: 'desde_cal_semestre_id'	
		
	def descripcion
		"#{tipo_plan.descripcion_completa} - #{desde_cal_semestre_id}"
	end


	def self.carga_inicial
		begin
			CalEstudiante.where("plan IS NOT NULL").each do |e|
				if e.plan and e.plan.include? '290'
					plan_id = TipoPlan.where("id LIKE '%290%'").limit(1).first.id
				elsif e.plan and e.plan.include? '280'
					plan_id = TipoPlan.where("id LIKE '%280%'").limit(1).first.id
				else
					plan_id = TipoPlan.where("id LIKE '%270%'").limit(1).first.id
				end

				print "ID: #{e.id}--- Plan: #{plan_id} .#{e.plan}."
				CalEstudianteTipoPlan.create(cal_estudiante_ci: e.id, tipo_plan_id: plan_id)
			end			
		rescue Exception => e
			return e
		end
	end

end # Fin clase 
