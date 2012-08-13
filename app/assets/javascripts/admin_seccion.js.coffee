# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->       
  if aceim.es_accion("index")
    $('#filtro_particular').keyup ->
      valor = $(this).val()
      valor2 = $("#ubicacion_id").val()
      valor3 = $("#horario_id").val()
      valor4 = $("#tipo_curso_id").val()
      valor = valor + " " + valor2 + " " + valor3 + " " + valor4
      tabla = $('table.tablefilter')
      $.uiTableFilter(tabla, valor) 
    
    $("#tipo_curso_id").change ->
      valor = $(this).val()
      valor2 = $("#ubicacion_id").val()
      valor3 = $("#horario_id").val()
      valor = valor + " " + valor2 + " " + valor3
      tabla = $('table.tablefilter')
      $.uiTableFilter(tabla, valor);

    $("#ubicacion_id").change ->
      valor = $(this).val()
      valor2 = $("#tipo_curso_id").val()
      valor3 = $("#horario_id").val()
      valor = valor + " " + valor2 + " " + valor3
      tabla = $('table.tablefilter')
      $.uiTableFilter(tabla, valor);

    $("#horario_id").change ->
      valor = $(this).val()
      valor2 = $("#ubicacion_id").val()
      valor3 = $("#tipo_curso_id").val()
      valor = valor + " " + valor2 + " " + valor3
      tabla = $('table.tablefilter')
      $.uiTableFilter(tabla, valor);

