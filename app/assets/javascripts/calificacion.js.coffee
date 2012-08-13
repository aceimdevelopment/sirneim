# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#------palabra = Función que retorna la palabra dado un número------------------
$ ->
  palabra = (numero) ->
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
  
  
#elementos = Función que retorna los elementos que empiezan por variable
#            y que siguen de numeros, por ejemplo nota1_15235547,
#            alguna_constante_1545264, historial_academico_15236256  
  elementos = (variable) ->
    $('input[type=text]').filter ->
      expresion = new RegExp(variable+"[0-9]*")
      this.id.match(expresion)

# tomar_nota = Función que retorna 0 si no hay nota asignada, -1 en caso de 
# pérdida por inasistencia, la nota en flotante en caso de ser una nota válida
# (nota entre 0 y 20) y NaN en otro caso...  
  tomar_nota = (nota_string) ->
    if nota_string == ""
      return 0
    else
      if nota_string.toUpperCase() == "PI"
        return -1
      else
        nota_string = nota_string.replace(/[,]+/g,".");
        nota_float = parseFloat(nota_string)
        if !isNaN(nota_float) and nota_float >= 0 and nota_float <= 20
          return nota_float
        else 
          return parseFloat("No es nota válida")


#Agrega o remueve la clase de nota-invalida, según sea el caso...
  agregar_remover_clase = (t,agregar,entero) -> 
    if agregar
      $('#descripcion_'+$(t).attr('id').substring(entero)).addClass("nota-invalida")
    else
      $('#descripcion_'+$(t).attr('id').substring(entero)).removeClass("nota-invalida")

            
#historial_academico_cedula.change, para asignar la nota
  elementos("historial_academico_").change ->
    valor = $(this).val()
    pal = palabra valor 
    
    if pal == "Nota Inválida"
      agregar_remover_clase this,true,20
    else
      agregar_remover_clase this,false,20

    $(this).val($(this).val().toUpperCase())
    $('#descripcion_'+$(this).attr('id').substring(20)).html(pal)
  
#funcion que determina si una nota es pérdida por inasistencia
  isPi = (nota) ->
    nota == -1
  
  
#nota1,2,3,4_cedula.change, para asignar la nota (solo ingles, por ahora)
  for i in [1..4]    
    elementos("nota"+i+"_").change ->
      cedula = $(this).attr("id").substring(6)
      nota1 = tomar_nota $("#nota1_"+ cedula).val()
      nota2 = tomar_nota $("#nota2_"+ cedula).val()
      nota3 = tomar_nota $("#nota3_"+ cedula).val()
      nota4 = tomar_nota $("#nota4_"+ cedula).val()
        
      if isNaN(nota1) or isNaN(nota2) or isNaN(nota3) or isNaN(nota4)
        $('#nota_final_'+cedula).html("NI")
        $('#notafinal_'+cedula).val("NI")
        $('#descripcion_'+cedula).html(palabra "NI")
        agregar_remover_clase this,true,6
      else  if isPi(nota1) or isPi(nota2) or isPi(nota3) or isPi(nota4)
      
#mosca!!! -------------------------      
        for i in [1..4]
          if $("#nota"+i+"_"+cedula).val() == "" or $("#nota"+i+"_"+cedula).val().toUpperCase() == "PI"
            $("#nota"+i+"_"+cedula).val("PI")
#mosca!!! -------------------------
        $('#nota_final_'+cedula).html("PI")
        $('#notafinal_'+cedula).val(-1)
        $('#descripcion_'+cedula).html(palabra "PI")
        agregar_remover_clase this,false,6
      else
        nota_final = Math.round(nota1*0.3 + nota2*0.3 + nota3*0.2 + nota4*0.2)
        $('#nota_final_'+cedula).html(nota_final)
        $('#notafinal_'+cedula).val(nota_final)
        $('#descripcion_'+cedula).html(palabra nota_final.toString())
        agregar_remover_clase this,false,6
      
