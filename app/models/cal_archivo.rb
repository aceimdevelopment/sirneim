# encoding: utf-8
class CalArchivo

	def self.listado_excel(tipo,usuarios)
		require 'spreadsheet'

		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet :name => "reporte #{tipo}"

		data = %w{NOMBRES CORREO MOVIL CI}
		@sheet.row(0).concat data

		data = []
		usuarios.each_with_index do |usuario,i|
			aux = { "MOVIL" => usuario.telefono_movil,"NOMBRE" => usuario.apellido_nombre, "CI" => usuario.ci, "CORREO" => usuario.correo_electronico}
			@sheet.row(i+1).concat aux.values
		end

		file_name = "Reporte_#{tipo}_#{DateTime.now.strftime('%d_%m_%Y_%H_%M')}.xls"
		return file_name if @book.write file_name
	end

end