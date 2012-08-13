# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if aceim.es_accion("paso2") or aceim.es_accion("paso2_guardar")
    
    #trabaja
    if $("#datos_estudiante_trabaja_1").is(':checked')
      $("#div-trabaja").show()
    else
      $("#div-trabaja").hide()

    $("#datos_estudiante_trabaja_1").click ->
      $("#div-trabaja").show()

    $("#datos_estudiante_trabaja_0").click ->
      $("#div-trabaja").hide()

    #experiencia
    if $("#datos_estudiante_tiene_experiencia_ensenanza_idiomas_1").is(':checked')
      $("#div-experiencia").show()
    else
      $("#div-experiencia").hide()

    $("#datos_estudiante_tiene_experiencia_ensenanza_idiomas_1").click ->
      $("#div-experiencia").show()

    $("#datos_estudiante_tiene_experiencia_ensenanza_idiomas_0").click ->
      $("#div-experiencia").hide()

    #espanol
    if $("#datos_estudiante_ha_dado_clases_espanol_1").is(':checked')
      $("#div-espanol").show()
    else
      $("#div-espanol").hide()

    $("#datos_estudiante_ha_dado_clases_espanol_1").click ->
      $("#div-espanol").show()

    $("#datos_estudiante_ha_dado_clases_espanol_0").click ->
      $("#div-espanol").hide()

    $('#usuario_fecha_nacimiento').datepicker
      changeYear: true,
      changeMonth: true,
      yearRange: '-90Y:-3Y',
      defaultDate: '-20Y',
      showOn: 'both',
      dateFormat: 'yy-mm-dd'

    $('#datos_estudiante_fecha_inicio_estudio_en_curso').datepicker
      changeYear: true,
      changeMonth: true,
      yearRange: '-90Y:-0Y',
      showOn: 'both',
      dateFormat: 'yy-mm-dd'



