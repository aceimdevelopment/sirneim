class CalTipoSexo < ActiveRecord::Base
	has_many :cal_usuarios,
		:class_name => 'CalUsuario'

	accepts_nested_attributes_for :cal_usuarios

 	attr_accessible :id, :descripcion
end