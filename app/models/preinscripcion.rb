#creada por db2models
class Preinscripcion < ActiveRecord::Base
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['estudiante_ci']
  belongs_to :tipo_forma_pago

  belongs_to :grupo
  belongs_to :cohorte	
end
