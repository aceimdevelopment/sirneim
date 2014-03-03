#creada por db2models
class Inscripcion < ActiveRecord::Base

  set_primary_keys :estudiante_ci, :cohorte_id, :diplomado_id

  # belongs_to :usuario,
  #   :class_name => 'Usuario',
  #   :foreign_key => ['estudiante_ci']

  belongs_to :estudiante,
    :class_name => 'Estudiante',
    :foreign_key => ['estudiante_ci']
  
  belongs_to :tipo_forma_pago

  belongs_to :grupo
  
  belongs_to :diplomado_cohorte,
    :class_name => 'DiplomadoCohorte',
    :foreign_key => ['diplomado_id','cohorte_id']

  belongs_to :tipo_estado_inscripcion

  # belongs_to :diplomado
  # belongs_to :cohorte
  

  def descripcion_cohorte_grupo
  	"#{grupo.nombre} - #{cohorte.nombre}"
  end

  # validates_uniqueness_of [:estudiante_id, :grupo, :cohorte]	
  
  # validates_uniqueness_of :estudiante_id, :scope => :friend_id
end
