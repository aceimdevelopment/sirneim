# encoding: utf-8

class Cohorte < ActiveRecord::Base

  has_many :diplomados_cohortes
  accepts_nested_attributes_for :diplomados_cohortes

  has_many :cohortes_temas
  accepts_nested_attributes_for :cohortes_temas

	validates :id, :presence => true, :uniqueness => true,  :numericality => { :greater_than => 2010, :less_than_or_equal_to => 2030}
  validates :nombre, :presence => true, :uniqueness => true
	def descripcion

    unless nombre.blank?
    	return nombre
    else
      return "Año: #{id}"
    end
	end

  def self.actual
    Cohorte.find ParametroGeneral.cohorte_actual
  end
  # has_many :inscripcion
  # accepts_nested_attributes_for :inscripcion

  # has_many :preinscripcion
  # accepts_nested_attributes_for :preinscripcion

end