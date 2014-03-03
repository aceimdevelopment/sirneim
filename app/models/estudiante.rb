#creada por db2models
class Estudiante < ActiveRecord::Base

  belongs_to :tipo_forma_pago

  #autogenerado por db2models
  set_primary_key :usuario_ci
  #autogenerado por db2models
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['usuario_ci']

  #autogenerado por db2models
  belongs_to :tipo_nivel_academico,
    :class_name => 'TipoNivelAcademico',
    :foreign_key => ['tipo_nivel_academico_id']

  has_many :inscripciones,
    :foreign_key => ['estudiante_ci']
  accepts_nested_attributes_for :inscripciones

  # validates_associated :inscripcion    
   def preinscrito?          
     @periodo = ParametroGeneral.periodo_actual
     HistorialAcademico.first(
     :conditions => ["usuario_ci = ? AND periodo_id = ?",
       usuario_ci,@periodo.id])
   end    

   def asistencias_cargadas(periodo)
    AsistenciaEnCurso.where(:historial_academico_usuario_ci => usuario_ci, 
                            :historial_academico_periodo_id => periodo,
                            :esta_tomada => true).count
   end


end
