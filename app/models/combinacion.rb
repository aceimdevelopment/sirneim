# encoding: utf-8
class Combinacion < ActiveRecord::Base

  set_primary_keys :cal_estudiante_ci, :desde_cal_semestre_id

  attr_accessible :cal_estudiante_ci, :idioma_id1, :idioma_id2, :desde_cal_semestre_id

  validates_uniqueness_of :cal_estudiante_ci, scope: :desde_cal_semestre_id, message: 'Combinación de idiomas ya registrado en este período. Por favor búsquelo y edítelo.', field_name: false

  belongs_to :cal_estudiante,
  foreign_key: 'cal_estudiante_ci'
  accepts_nested_attributes_for :cal_estudiante, allow_destroy: true

  belongs_to :idioma1,
  class_name: 'CalDepartamento',
  foreign_key: 'idioma_id1'
  accepts_nested_attributes_for :idioma1

  belongs_to :idioma2,
  class_name: 'CalDepartamento',
  foreign_key: 'idioma_id2'
  accepts_nested_attributes_for :idioma2

  belongs_to :cal_semestre,
  foreign_key: 'desde_cal_semestre_id'
  accepts_nested_attributes_for :cal_semestre

  def descripcion
    desc1 = idioma1.descripcion if idioma1
    desc2 = idioma2.descripcion if idioma2
  	"#{desc1} / #{desc2} - #{desde_cal_semestre_id}"
  end

  def self.migrar_combinaciones
    CalEstudiante.all.each do |es|
      unless es.idioma1_id.nil? and es.idioma2_id.nil?
        c = es.combinaciones.new
        c.idioma_id1 = es.idioma1_id
        c.idioma_id2 = es.idioma2_id
        c.desde_cal_semestre_id = CalParametroGeneral.cal_semestre_actual_id
        if c.save
          p "." 
        else
          p "X"
        end
      end
    end
  end


end
