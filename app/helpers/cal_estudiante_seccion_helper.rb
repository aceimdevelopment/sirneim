# encoding: utf-8
module CalEstudianteSeccionHelper

	def borrar_seleccion_link cal_materia_id
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: 'Borrar Seleccion' do
 			link_to "×", "javascript:void(0)", onclick: "borrar_seleccion('#{cal_materia_id}');", class: 'btn btn-mini btn-danger'
		end

	end 

 end
