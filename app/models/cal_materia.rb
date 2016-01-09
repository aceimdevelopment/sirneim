class CalMateria < ActiveRecord::Base

	attr_accessible :id, :descripcion, :cal_categoria_id, :cal_departamento_id, :orden, :anno, :id_upsi

	belongs_to :cal_categoria

	belongs_to :cal_departamento

	has_many :cal_secciones
	accepts_nested_attributes_for :cal_secciones

	validates :id, :presence => true, :uniqueness => true
	validates :id_upsi, :presence => true, :uniqueness => true
	validates :descripcion, :presence => true

	def descripcion_completa
		desc = "#{descripcion} "
		desc += "- #{cal_categoria.descripcion}" if cal_categoria
		desc += "- #{cal_departamento.descripcion}" if cal_departamento
		return desc
	end

	def descripcion_reversa
		desc = cal_departamento.descripcion if cal_departamento
		desc += "| #{cal_categoria.descripcion}" if cal_categoria		
		return desc

		
	end
end