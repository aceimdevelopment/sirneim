class CalMateria < ActiveRecord::Base

	attr_accessible :id, :descripcion, :cal_categoria_id

	belongs_to :cal_categoria

	has_many :cal_secciones
	accepts_nested_attributes_for :cal_secciones

end