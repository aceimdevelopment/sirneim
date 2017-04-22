# encoding: utf-8
class TipoEstadoInscripcionController < ApplicationController
	before_filter :filtro_logueado
	before_filter :filtro_administrador

	def index
		@titulo = "Lista de Estados de Inscripción"
		@estados_inscripciones = TipoEstadoInscripcion.all
	end

	def nuevo
		@titulo = "Nuevo Tipo Estado de Inscripción"
		@estado_inscripcion = TipoEstadoInscripcion.new
	end

	def crear
		@estado_inscripcion = TipoEstadoInscripcion.new (params[:tipo_estado_inscripcion])

		if @estado_inscripcion.save
			flash[:success] = "Tipo Estado Inscripcion Registrado Satisfactoriamente"
			redirect_to :action => "index"
		else
			render :action => "nuevo"
		end

	end

	def editar
		@titulo = "Editar Tipo Estado de Inscripción"
		@estado_inscripcion = TipoEstadoInscripcion.find params[:id]
	end

	def guardar
		@estado_inscripcion = TipoEstadoInscripcion.find params[:tipo_estado_inscripcion][:id]
		if @estado_inscripcion.update_attributes(params[:tipo_estado_inscripcion])
			flash[:success] = "Tipo Estado Inscripcion Registrado Satisfactoriamente"
			redirect_to :action => "index"
		else
			render :action => "editar"
		end
	end
end
