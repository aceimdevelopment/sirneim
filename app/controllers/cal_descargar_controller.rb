class CalDescargarController < ApplicationController
	before_filter :cal_filtro_logueado

	def horario
		anno = (params[:id].split"-")[2]
		send_file "#{Rails.root}/attachments/horarios/#{anno}/#{params[:id]}.pdf", :type => "application/pdf", :x_sendfile => true, :disposition => "attachment"
	end

end