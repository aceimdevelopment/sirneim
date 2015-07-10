class CalProfesor < ActiveRecord::Base
	set_primary_keys :cal_usuario_ci

	attr_accessible :cal_usuario_ci, :cal_departamento_id

 	belongs_to :cal_usuario,
    	:class_name => 'CalUsuario',
    	:foreign_key => ['ci']

 	belongs_to :cal_departamento,
    	:class_name => 'CalDepartamento',
    	:foreign_key => ['ci']

   	has_many :cal_secciones,
    	:class_name => 'CalSeccion',
    	:foreign_key => 'cal_profesor_ci'    	

	accepts_nested_attributes_for :cal_secciones


end
