# encoding: utf-8

class CalDepartamentoCalCategoria < ActiveRecord::Base

	set_primary_keys :cal_departamento_id, :cal_categoria_id

	attr_accessible  :cal_departamento_id, :cal_categoria_id

	belongs_to :cal_departamento
	belongs_to :cal_categoria

end