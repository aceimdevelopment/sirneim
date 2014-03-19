

$ ->
  
    $("#horario_id").change ->
      valor = $(this).val()    
      unless valor is ""
        $.ajax
          url: "/aceim_diplomados/admin_seccion/elegir_ubicacion_segun_horario?identificador=#{valor}",
          success: (datos) ->
            $('#ubicacion').html(datos)  
            return
      

$ ->
  $('.tablesorter').tablesorter widgets:['zebra']
  $('.datepicker').datepicker
    format: "yyyy-mm-dd"
  $('.barraprogreso').progressbar value:0
  $('.tooltip').tooltip()

$ ->
  if aceim.es_accion("paso1") or aceim.es_accion("paso1_guardar") or aceim.es_accion("modificar_datos_personales") or aceim.es_accion("modificar") or aceim.es_accion("nuevo") or aceim.es_accion("datos")
    $('.datepicker_nac').datepicker
      changeYear: true,
      changeMonth: true,
      yearRange: '-90Y:-3Y',
      defaultDate: '-20Y',
      showOn: 'both',
      dateFormat: 'yy-mm-dd'

$ ->
  $("ul.subnav").parent().append "<span></span>"
  $("ul.topnav li ").click ->
    $(this).parent().find("ul.subnav").slideDown('fast').show()
    $(this).parent().hover ->
      $(this).parent().find("ul.subnav").slideUp "fast"
    .hover ->
      $(this).addClass "subhover", ->
        $(this).removeClass "subhover"



$ ->
  $("#submit_correo").click ->
    #confirm "Tilulo:<"+titulo.value

$ ->
  menu = $("ul.dropdown")
  
  displayOptions = (e) ->
    e.show()
  hideOptions = (e) ->
    e.find("li").hide()
    e.find("li.active").show()
  
  menu.click ->
    displayOptions $(this).find("li")

  menu.find("li").click ->
    hideOptions $(this)

$ -> 
  tabla = $('table.tablefilter')
  $("#filtro").keyup ->
    $.uiTableFilter(tabla, this.value);


clase_aceim = 
  es_accion: (nombre) ->
    $("#action_"+nombre).length > 0
      
  modal_remota: (direccion,titulo,ancho) -> 
    $.ajax
      url: direccion,
      success: (datos) ->
        $('#ventana-modal').html(datos)  
        $("#ventana-modal").dialog
          title:titulo, 
       	  width: ancho,
          modal:true,
          show: "explode",
          hide: "explode",
        return          
  
  cerrar_modal: ->
    $('#ventana-modal').dialog('close')




  mostrar_descripcion: ->
    $('#nota_individual').keyup ->
      $('.descripcion_nota_individual').html(aceim.palabra this.value)

  palabra: (numero) ->
    numero = numero.toUpperCase()
    switch numero
      when "PI" then "Pérdida por Inasistencia"
      when "0" then "Cero"
      when "00" then "Cero"
      when "1" then "Uno"
      when  "01" then "Uno"
      when "2" then  "Dos"
      when "02" then "Dos"
      when "3" then "Tres"
      when "03" then "Tres"
      when "4" then "Cuatro"
      when "04" then "Cuatro"
      when "5" then "Cinco"
      when "05" then "Cinco"
      when "6" then "Seis"
      when "06" then "Seis"
      when "7" then "Siente"
      when "07" then "Siente"
      when "8" then "Ocho"
      when "08" then "Ocho"
      when "9" then "Nueve"
      when "09" then "Nueve"
      when "10" then "Diez"
      when "11" then "Once"
      when "12" then "Doce"
      when "13" then "Trece"
      when "14" then "Catorce"
      when "15" then "Quince"
      when "16" then "Dieciseis"
      when "17" then "Diecisiete"
      when "18" then "Dieciocho"
      when "19" then "Diecinueve"
      when "20" then "Veinte"
      else "Nota Inválida"
      
  recolectar: (action,param) ->
    elems = $("table.tablefilter > tbody:first > tr:visible > td > div.oculto-param")
    params = ""
    elems.each ->
      valor = $.trim($(this).text())
      params += (valor+"_")        
    direccion = action #location.href.split('?')[0]    
    url = "#{direccion}?#{param}=#{params}"
    location.href = url
    return false
    
  recolectar_enviar_correo: (action,param) ->
    elems = $("table.tablefilter > tbody:first > tr:visible > td > div.oculto-param")
    params = ""
    elems.each ->
      valor = $.trim($(this).text())
      params += (valor+"_")        
    direccion = action #location.href.split('?')[0]    
    url = "#{direccion}?#{param}=#{params}"
    aceim.modal_remota(url,"Enviar Correo",800) 
    return false
  
  sleep: (milisegundos) ->
    inicio = new Date().getTime()
    for num in [1..1e7]
      if ((new Date().getTime() - inicio) > milisegundos)
        break;
    
  refrescar: (direccion) ->
    $.ajax
      url: direccion
      success: (datos) ->
        valor = datos
        $( ".barraprogreso" ).progressbar( "option", "value", eval(valor));
        $( ".numero_barra_progreso").html(Math.round(valor)+"%")
        if valor < 100
          setTimeout("aceim.refrescar('actualizar_estado')",5000)
        else
          if $("#valor").val() == "true"
            url = "http://blues.ciens.ucv.ve/aceim_diplomados/principal_admin/index?ci=1"
            location.href = url
            return
          else
            url = "ver_secciones?ce=1"
            location.href = url
            return 
    
      


window.aceim = clase_aceim
