#creada por db2models
class Inscripcion < ActiveRecord::Base
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['estudiante_ci']
	
end
