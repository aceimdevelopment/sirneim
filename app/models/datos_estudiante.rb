#creada por db2models
class DatosEstudiante < ActiveRecord::Base

  validates :ocupacion, :presence => true, :if => :esta_trabajando?
  validates :institucion, :presence => true, :if => :esta_trabajando?
  validates :cargo_actual, :presence => true, :if => :esta_trabajando?
  validates :antiguedad, :presence => true, :if => :esta_trabajando?
  validates :direccion_de_trabajo, :presence => true, :if => :esta_trabajando?

  validates :institucion_estudio, :presence => true
  validates :ano_graduacion_estudio, :presence => true

  validates :descripcion_experiencia, :presence => true, :if => :tiene_experiencia?

  validates :institucion_estudio_en_curso, :presence => true, :if => :tiene_estudio_en_curso?
  validates :fecha_inicio_estudio_en_curso, :presence => true, :if => :tiene_estudio_en_curso?

  validates :institucion_estudio_concluido, :presence => true, :if => :tiene_estudio_concluido?
  validates :ano_estudio_concluido, :presence => true, :if => :tiene_estudio_concluido?

  validates :titulo_estudio_concluido, :presence => true, :if => :no_tiene_estudio_en_curso?
  validates :institucion_estudio_concluido, :presence => true, :if => :no_tiene_estudio_en_curso?
  validates :ano_estudio_concluido, :presence => true, :if => :no_tiene_estudio_en_curso?


  validates :titulo_estudio_en_curso, :presence => true, :if => :no_tiene_estudio_concluido?
  validates :institucion_estudio_en_curso, :presence => true, :if => :no_tiene_estudio_concluido?
  validates :fecha_inicio_estudio_en_curso, :presence => true, :if => :no_tiene_estudio_concluido?

  validates :donde_clases_espanol, :presence => true, :if => :dio_espanol?
  validates :tiempo_clases_espanol, :presence => true, :if => :dio_espanol?

  validates :por_que_interesa_diplomado, :presence => true
  validates :expectativas_sobre_diplomado, :presence => true

  def no_tiene_estudio_en_curso?
    titulo_estudio_en_curso.size == 0
  end

  def no_tiene_estudio_concluido?
    titulo_estudio_concluido.size == 0
  end

  def esta_trabajando?
    trabaja == 1
  end

  def tiene_experiencia?
    tiene_experiencia_ensenanza_idiomas == 1
  end

  def tiene_estudio_en_curso?
    titulo_estudio_en_curso.size > 0
  end

  def tiene_estudio_concluido?
    titulo_estudio_concluido.size > 0
  end	

  def dio_espanol?
    ha_dado_clases_espanol == 1
  end
	  
end
