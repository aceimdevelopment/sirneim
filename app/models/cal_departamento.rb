class CalDepartamento < ActiveRecord::Base
	attr_accessible :id, :descripcion 

	has_many :cal_materias,
	:class_name => 'CalMateria',
	:foreign_key => 'cal_departamento_id'
	accepts_nested_attributes_for :cal_materias

	has_many :cal_profesores,
	:class_name => 'CalProfesor',
	:foreign_key => 'cal_departamento_id'
	accepts_nested_attributes_for :cal_profesores


end
