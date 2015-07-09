class CalCalificarController < ApplicationController

	def seleccionar_seccion
		@profesor = CalProfesor.find (session[:cal_profesor].cal_usuario_ci)

		@secciones = CalSeccion.where(:cal_profesor_ci => @profesor.cal_usuario_ci)
	end

	def ver_seccion
		@seccion = Seccion.where(:id => params[:id]).first if params[:id]

	end

	def importar_secciones
		data = File.readlines("AlemIV.rtf") #read file into array
		data.map! {|line| line.gsub(/world/, "ruby")} #invoke on each line gsub
		File.open("test2.txt", "a") {|f| f.puts "Nueva Linea: #{data}"} #output data to other file
	end


end