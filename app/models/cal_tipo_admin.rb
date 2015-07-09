class CalTipoAdmin < ActiveRecord::Base
 	attr_accessible :id, :descripcion

	has_many :cal_administradores,
		:class_name => 'CalAdministrador'

	accepts_nested_attributes_for :cal_administradores


end