# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ -> 
  elementos = (variable) ->
    $('input[type=checkbox]').filter ->
      expresion = new RegExp(variable+"[0-9]*_[0-9]*")
      this.id.match(expresion)

#acomodar
  for elemento in elementos("asistencia_")
    if $(elemento).is(':checked')
      split = $(elemento).attr("id").split("_")
      $("#combo_#{split[1]}_#{split[2]}").hide()

  #console.log(elementos("asistencia_"))
  elementos("asistencia_").click ->
    split = $(this).attr("id").split("_")
    if $(this).is(':checked')
      $("#combo_#{split[1]}_#{split[2]}").hide()
    else
      $("#combo_#{split[1]}_#{split[2]}").show()


