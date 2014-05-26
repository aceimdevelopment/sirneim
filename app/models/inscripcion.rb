#creada por db2models 
class Inscripcion < ActiveRecord::Base


  COHORTE_ACTUAL = Cohorte.actual
  set_primary_keys :estudiante_ci, :cohorte_id, :diplomado_id
  # attr_accessible :estudiante_ci, :cohorte_id, :diplomado_id, :tipo_estado_inscripcion_id
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

  # scope :actuales, -> {where("cohorte_id IS ?", ParametroGeneral.cohorte_actual)}
  # belongs_to :diplomado
  # belongs_to :cohorte

  scope :preinscritos_actuales_diplomado, lambda { |diplomado_id| where(:tipo_estado_inscripcion_id => "PRE", :cohorte_id => COHORTE_ACTUAL.id, :diplomado_id => diplomado_id) }

  scope :aprobados_actuales_diplomado, lambda { |diplomado_id| where(:tipo_estado_inscripcion_id => "APR", :cohorte_id => COHORTE_ACTUAL.id, :diplomado_id => diplomado_id) }

  scope :aprobados_actuales_diplomado_sin_grupo, lambda { |diplomado_id| where(:tipo_estado_inscripcion_id => "APR", :cohorte_id => COHORTE_ACTUAL.id, :diplomado_id => diplomado_id, :grupo_id => nil) }

  scope :aprobados_actuales_diplomado_con_grupo, lambda { |diplomado_id| where("tipo_estado_inscripcion_id = ? AND cohorte_id = ? AND diplomado_id = ? AND grupo_id IS NOT ?", 'APR', COHORTE_ACTUAL.id, diplomado_id, nil) }

  scope :inscritos_actuales_diplomado, lambda { |diplomado_id| where(:tipo_estado_inscripcion_id => "INS", :cohorte_id => COHORTE_ACTUAL.id, :diplomado_id => diplomado_id) }

  scope :otros_actuales_diplomado, lambda { |diplomado_id| where(:tipo_estado_inscripcion_id => nil, :cohorte_id => COHORTE_ACTUAL.id, :diplomado_id => diplomado_id) }

  scope :preinscritos_actuales, :conditions => {:tipo_estado_inscripcion_id => "PRE", :cohorte_id => COHORTE_ACTUAL.id}

  scope :aprobados_actuales, :conditions => {:tipo_estado_inscripcion_id => "APR", :cohorte_id => COHORTE_ACTUAL.id}

  scope :inscritos_actuales, :conditions => {:tipo_estado_inscripcion_id => "INS", :cohorte_id => COHORTE_ACTUAL.id}

  scope :otros_actuales, :conditions => {:tipo_estado_inscripcion_id => nil, :cohorte_id => COHORTE_ACTUAL.id}

# ids = LevelsQuestion.all(:select => "question_id", 
#         :conditions => "level_id = 15").collect(&:question_id)
# Question.all(:select => "id, name", :conditions => ["id not in (?)", ids])
# One shot:

# Question.all(:select => "id, name",
# :conditions => ["id not in (select question_id from levels_questions where level_id=15)"])


  def descripcion_cohorte_grupo
    if grupo
      "#{grupo.nombre} - #{diplomado_cohorte.cohorte.nombre}"
    else
      "#{cohorte_id}"
    end
  end

  validates_uniqueness_of :estudiante_ci, :scope => [:diplomado_id, :cohorte_id], :message => "Ud. ya inscribió este diplomado en esta Cohorte", :on => :create
  
  # validates_uniqueness_of :estudiante_id, :scope => :friend_id

end
