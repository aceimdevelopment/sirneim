class CalMateriaController < ApplicationController

	before_filter :cal_filtro_logueado
	before_filter :cal_filtro_administrador

	def index

		@departamentos = CalDepartamento.all
		
	end

	def nueva
		@departamentos = CalDepartamento.all
		@catedras = CalCategoria.all
		@cal_materia = CalMateria.new

	end

	def crear

		params[:cal_materia][:id] = params[:cal_materia][:id].upcase 
		@cal_materia = CalMateria.new(params[:cal_materia])

		if @cal_materia.save
			flash[:success] = "Asignatura Registrada Satisfactoriamente"
			redirect_to :action => 'index'
		else
			@departamentos = CalDepartamento.all
			@catedras = CalCategoria.all			
			render :action => 'nueva'
		end

		
	end

end