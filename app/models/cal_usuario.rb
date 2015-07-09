class CalUsuario < ActiveRecord::Base

	set_primary_keys :ci

	attr_accessor :contrasena_confirmation
 	attr_accessible :ci, :nombres, :apellidos, :fecha_nacimiento, :contrasena, :telefono_movil, :correo, :correo_alternativo, :direccion, :lugar_nacimiento, :cal_tipo_sexo_id, :telefono_habitacion

	has_one :cal_administrador,
    	:class_name => 'CalAdministrador',
    	:foreign_key => ['cal_usuario_ci']

	has_one :cal_estudiante,
    	:class_name => 'CalEstudiante',
    	:foreign_key => ['cal_usuario_ci']

	has_one :cal_profesor,
    	:class_name => 'CalProfesor',
    	:foreign_key => ['cal_usuario_ci']


	def nombre_completo
		if nombres and apellidos
			"#{nombres}, #{apellidos}"
		else
			""
		end
	end

	def self.autenticar(login,clave)
    	return CalUsuario.where(:ci => login, :contrasena => clave).limit(1).first
  	end  
end
