class CalCategoria < ActiveRecord::Base

	attr_accessible :id, :descripcion, :cal_departamento_id

	belongs_to :cal_departamento

	has_many :cal_materias,
	:class_name => 'CalMateria',
	:foreign_key => 'cal_departamento_id'
	accepts_nested_attributes_for :cal_materias

end
