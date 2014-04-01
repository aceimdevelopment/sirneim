#creada por db2models
class Usuario < ActiveRecord::Base
	
	include ActiveModel::Validations    
	attr_accessor :contrasena_confirmation
  #autogenerado por db2models
  set_primary_key :ci
  has_one :preinscripcion, :foreign_key => 'estudiante_ci'
  #autogenerado por db2models
  attr_accessible :ci, :nombres, :apellidos, :fecha_nacimiento, :contrasena, :telefono_movil, :correo, :correo_alternativo, :direccion, :lugar_nacimiento, :tipo_sexo_id, :telefono_habitacion
  # attr_protected
  belongs_to :tipo_sexo,
    :class_name => 'TipoSexo',
    :foreign_key => ['tipo_sexo_id']

  has_one :docente, :foreign_key => 'usuario_ci'
  has_one :administrador, :foreign_key => 'usuario_ci'
  has_one :estudiante, :foreign_key => 'usuario_ci'

  validates :ci, :presence => true,  
                 :uniqueness => true,
                :numericality => { :only_integer => true, 
                                   :greater_than => 1000, 
                                   :less_than => 90000000 }
                 
  validates :nombres,  :presence => true
  validates :apellidos, :presence => true  
  validates :fecha_nacimiento, :presence => true  
  validates :contrasena, :presence => true  
  validates :telefono_movil, :tlf => true	
  validates :correo, :presence => true, :email => true
  validates :correo_alternativo, :presence => true, :email => true, :if => :hay_correo_alternativo
  validates :direccion, :presence => true
  validates :lugar_nacimiento, :presence => true

  validates :tipo_sexo_id, :presence => true
  validates :contrasena, :confirmation => true
  validates :contrasena, :length => 5..30

  def hay_correo_alternativo
    correo_alternativo.size>0
  end

  def self.autenticar(login,clave)
    usuario = Usuario.where(:ci => login,:activo => true).limit(1).first
    return usuario if usuario && (usuario.contrasena.downcase == clave.downcase)
    return usuario if usuario && (usuario.contrasena.downcase.gsub("vp","") == clave.downcase)
    return nil
  end    
  
  def edad
    Time.now.year - fecha_nacimiento.year
  end     
  
  def nombre_completo
    "#{apellidos} #{nombres}"
  end 
  
  # def administrador
  #   Administrador.where(:usuario_ci => ci).limit(1).first
  # end          

  # def estudiante
  #   Estudiante.where(:usuario_ci => ci).limit(1).first
  # end

  def datos_estudiante
    DatosEstudiante.where(:estudiante_ci => ci).limit(1).first
  end           

  def inscripcion
    Inscripcion.where(:estudiante_ci => ci).limit(1).first
  end           
     
  def estudiante_curso
    EstudianteCurso.where(:usuario_ci => ci)
  end
  
  def descripcion
    "#{apellidos} #{nombres}, (#{ci})"
  end

  def telefonos
    "#{telefono_movil}, #{telefono_habitacion}"
  end
  
  def datos_contacto
    "#{telefono_movil}, #{correo}"
  end
  
end
