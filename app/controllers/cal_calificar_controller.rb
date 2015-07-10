class CalCalificarController < ApplicationController

	def seleccionar_seccion
		@profesor = CalProfesor.find (session[:cal_profesor].cal_usuario_ci)
		@titulo = "Secciones disponibles para Caficicar"
	end

	def ver_seccion
		id = params[:id]
		@cal_seccion = CalSeccion.where(:numero => id[0], :cal_materia_id => id[1], :cal_semestre_id => id[2]).first
		@titulo = @cal_seccion.descripcion
	end

	def importar_secciones
		data = File.readlines("AlemIV.rtf") #read file into array
		data.map! {|line| line.gsub(/world/, "ruby")} #invoke on each line gsub
		File.open("test2.txt", "a") {|f| f.puts "Nueva Linea: #{data}"} #output data to other file
	end


end