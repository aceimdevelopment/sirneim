class CalUsuario < ActiveRecord::Base

	set_primary_keys :ci

	attr_accessor :contrasena_confirmation
 	attr_accessible :ci, :nombres, :apellidos, :contrasena, :telefono_movil, :correo_electronico, :cal_tipo_sexo_id, :telefono_habitacion, :direccion_habitacion

	has_one :cal_administrador,
    	:class_name => 'CalAdministrador',
    	:foreign_key => ['cal_usuario_ci']

	has_one :cal_estudiante,
    	:class_name => 'CalEstudiante',
    	:foreign_key => ['cal_usuario_ci']

	has_one :cal_profesor,
    	:class_name => 'CalProfesor',
    	:foreign_key => 'cal_usuario_ci'

	validates :nombres,  :presence => true
	validates :apellidos, :presence => true
	# validates :telefono_movil, :presence => true	
	# validates :correo_electronico, :presence => true
	validates :cal_tipo_sexo_id, :presence => true
	validates :contrasena, :presence => true
	validates :contrasena, :confirmation => true


	def nombre_completo
		if nombres and apellidos
			"#{nombres}, #{apellidos}"
		else
			""
		end
	end

	def apellido_nombre
		if nombres and apellidos
			"#{apellidos}, #{nombres}"
		else
			""
		end

	end

	def descripcion
		"(#{ci}) #{nombre_completo}"
	end

	def descripcion_apellido
		"(#{ci}) #{apellido_nombre}"		
	end

	def self.autenticar(login,clave)
    	return CalUsuario.where(:ci => login, :contrasena => clave).limit(1).first
  	end  
end
