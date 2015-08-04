class CalCategoria < ActiveRecord::Base

	attr_accessible :id, :descripcion, :orden

	# belongs_to :cal_departamento

	has_many :cal_materias,
	:class_name => 'CalMateria',
	:foreign_key => 'cal_categoria_id'
	accepts_nested_attributes_for :cal_materias


	has_many :cal_departamentos_categorias,
		:class_name => 'CalDepartamentoCalCategoria'

	accepts_nested_attributes_for :cal_departamentos_categorias

	has_many :cal_departamentos, :through => :cal_departamentos_categorias, :source => :cal_departamento 

end
