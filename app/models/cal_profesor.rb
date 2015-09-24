class CalProfesor < ActiveRecord::Base
	set_primary_keys :cal_usuario_ci

	attr_accessible :cal_usuario_ci, :cal_departamento_id

 	belongs_to :cal_usuario,
    	:class_name => 'CalUsuario',
    	:foreign_key => ['cal_usuario_ci']

 	belongs_to :cal_departamento,
    	:class_name => 'CalDepartamento',
    	:foreign_key => ['cal_departamento_id']

   	has_many :cal_secciones,
    	:class_name => 'CalSeccion',
    	:foreign_key => 'cal_profesor_ci'    	

	accepts_nested_attributes_for :cal_secciones

    def descripcion
        "#{cal_usuario.descripcion} - #{cal_departamento.descripcion if cal_departamento}"
    end

    def descripcion_apellido
        "#{cal_usuario.descripcion_apellido} - #{cal_departamento.descripcion if cal_departamento}"        
    end

    def descripcion_usuario
        if cal_usuario
            return cal_usuario.descripcion
        else
            "Profesor Sin descripcion"
        end
    end


end
