# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/  

$ ->       
  if aceim.es_accion("ver_secciones")
    $('#filtro_particular').keyup ->
      valor = $(this).val()
#      valor2 = $("#ubicacion_id").val()
#      valor3 = $("#horario_id").val()
#      valor4 = $("#tipo_curso_id").val()
#      valor = valor + " " + valor2 + " " + valor3 + " " + valor4
      tabla = $('table.tablefilter')
      $.uiTableFilter(tabla, valor) 
    
    $('#tipo_curso_id').change ->
#      alert "tipo cursi"
      valor = $(this).val()
#      valor2 = $("#ubicacion_id").val()
#      valor3 = $("#horario_id").val()
#      valor = valor + " " + valor2 + " " + valor3
#      tabla = $('table.tablefilter')
#      $.uiTableFilter(tabla, valor)  
      direccion = location.href.split('?')[0]
      url = "#{direccion}?filtrar=#{valor}"
      location.href = url
      return false
    $('#ubicacion_id').change ->
#      alert "ubicacion"
#      valor = $(this).val()
#       valor2 = $("#tipo_curso_id").val()
#       valor3 = $("#horario_id").val()
#       valor = valor + " " + valor2 + " " + valor3
#       tabla = $('table.tablefilter')
#       $.uiTableFilter(tabla, valor)
      valor = $(this).val()  
      direccion = location.href.split('?')[0]
      url = "#{direccion}?filtrar2=#{valor}"
      location.href = url
      return false

    $('#horario_id').change ->
#      alert "horRIO"
#      valor = $(this).val()
#      valor2 = $("#ubicacion_id").val()
#      valor3 = $("#tipo_curso_id").val()
#      valor = valor + " " + valor2 + " " + valor3
#      tabla = $('table.tablefilter')
#      $.uiTableFilter(tabla, valor)
      valor = $(this).val()  
      direccion = location.href.split('?')[0]
      url = "#{direccion}?filtrar3=#{valor}"
      location.href = url
      return false
      
  if aceim.es_accion("ver_estado_envio")
      #setInterval aceim.refrescar("actualizar_estado"), 1000
      aceim.refrescar("actualizar_estado")
