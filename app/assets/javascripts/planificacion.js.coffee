# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("ul.subnavegador").hide()
  $("a.desplegable").toggle (->
    $(this).parent().find("ul.subnavegador").slideDown "fast" 
  ), ->
    $(this).parent().find("ul.subnavegador").slideUp "fast"
