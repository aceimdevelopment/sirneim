class CalAdministrador < ActiveRecord::Base
	set_primary_keys :cal_usuario_ci

	attr_accessible :cal_usuario_ci, :cal_tipo_admin_id

 	belongs_to :cal_usuario,
    	:class_name => 'CalUsuario',
    	:foreign_key => ['ci']

	belongs_to :cal_tipo_admin,
    	:class_name => 'CalTipoAdmin',
    	:foreign_key => ['cal_tipo_admin_id']

end
