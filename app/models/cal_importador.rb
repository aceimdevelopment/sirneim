class CalImportador
	def self.importar_secciones
		data = File.readlines("attachments/AlemIV.rtf") #read file into array
		data.map! {|line| line.gsub(/world/, "ruby")} #invoke on each line gsub
		File.open("test2.txt", "a") {|f| f.puts "Nueva Linea: #{data}"} #output data to other file
	end
end