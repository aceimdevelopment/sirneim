#creada por db2models
class Administrador < ActiveRecord::Base
# class Administrador < Usuario

  #autogenerado por db2models
  set_primary_key :usuario_ci
  #autogenerado por db2models
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['usuario_ci']

end
