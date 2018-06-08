class CalAdministrador < ActiveRecord::Base
	set_primary_key :cal_usuario_ci

	attr_accessible :cal_usuario_ci, :cal_tipo_admin_id

 	belongs_to :cal_usuario,
    	:class_name => 'CalUsuario',
    	:foreign_key => ['cal_usuario_ci']

	belongs_to :cal_tipo_admin,
    	:class_name => 'CalTipoAdmin',
    	:foreign_key => ['cal_tipo_admin_id']


  def super_admin?
  	return (cal_tipo_admin_id and cal_tipo_admin_id <2) 
  end

end
