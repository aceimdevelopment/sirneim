# encoding: utf-8
class CalSemestre < ActiveRecord::Base

	attr_accessible :id, :fecha_inicio, :fecha_culminacion

	has_many :cal_secciones,
		:class_name => 'CalSeccion'

	accepts_nested_attributes_for :cal_secciones

	has_many :cal_estudiantes_secciones, :through => :cal_secciones, :source => :cal_estudiantes

	def anno
		"#{id.split('-').first}"
	end

	def semestre_anterior
		todos = CalSemestre.all
		indice = todos.index self
		indice -= 1
		indice = 0 if indice < 0
		
		return todos[indice]

		
	end
end
