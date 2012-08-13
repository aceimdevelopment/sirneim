# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110911041805) do

  create_table "administrador", :primary_key => "usuario_ci", :force => true do |t|
    t.string "rol", :limit => 45
  end

  add_index "administrador", ["usuario_ci"], :name => "administrador_usuario_ci"

  create_table "aula", :force => true do |t|
    t.string  "tipo_ubicacion_id", :limit => 10,                :null => false
    t.string  "descripcion"
    t.integer "disponible",                      :default => 1, :null => false
  end

  add_index "aula", ["tipo_ubicacion_id"], :name => "fk_aula_tipo_ubicacion1"

  create_table "bitacora", :force => true do |t|
    t.datetime "fecha",                                  :null => false
    t.string   "descripcion",                            :null => false
    t.string   "usuario_ci",               :limit => 20
    t.string   "estudiante_usuario_ci",    :limit => 20
    t.string   "administrador_usuario_ci", :limit => 20
  end

  add_index "bitacora", ["administrador_usuario_ci"], :name => "fk_bitacora_administrador1"
  add_index "bitacora", ["estudiante_usuario_ci"], :name => "fk_bitacora_estudiante1"
  add_index "bitacora", ["usuario_ci"], :name => "fk_bitacora_usuario1"

  create_table "bloque_aula_disponible", :id => false, :force => true do |t|
    t.string "tipo_hora_id", :limit => 10, :null => false
    t.string "tipo_dia_id",  :limit => 10, :null => false
    t.string "aula_id",      :limit => 20, :null => false
  end

  add_index "bloque_aula_disponible", ["aula_id"], :name => "fk_bloque_aula_disponible_aula1"

  create_table "curso", :id => false, :force => true do |t|
    t.string  "idioma_id",         :limit => 10, :null => false
    t.string  "tipo_categoria_id", :limit => 10, :null => false
    t.string  "tipo_nivel_id",     :limit => 10, :null => false
    t.integer "grado"
  end

  add_index "curso", ["idioma_id", "tipo_categoria_id"], :name => "fk_curso_tipo_curso1"
  add_index "curso", ["tipo_nivel_id"], :name => "fk_curso_tipo_nivel1"

  create_table "curso_periodo", :id => false, :force => true do |t|
    t.string "periodo_id",        :limit => 10, :null => false
    t.string "idioma_id",         :limit => 10, :null => false
    t.string "tipo_categoria_id", :limit => 10, :null => false
    t.string "tipo_nivel_id",     :limit => 10, :null => false
  end

  add_index "curso_periodo", ["periodo_id"], :name => "fk_curso_periodo_periodo1"
  add_index "curso_periodo", ["tipo_nivel_id", "idioma_id", "tipo_categoria_id"], :name => "fk_curso_periodo_curso1"

  create_table "curso_periodo_temp", :id => false, :force => true do |t|
    t.string "periodo_id"
    t.string "tipo_nivel_id"
    t.string "idioma_id"
    t.string "tipo_categoria_id"
  end

  create_table "domina", :id => false, :force => true do |t|
    t.string  "idioma_id",             :limit => 10, :null => false
    t.string  "instructor_usuario_ci", :limit => 20, :null => false
    t.integer "grado",                               :null => false
  end

  add_index "domina", ["idioma_id"], :name => "fk_domina_idioma1"
  add_index "domina", ["instructor_usuario_ci"], :name => "fk_domina_instructor1"

  create_table "estudiante", :primary_key => "usuario_ci", :force => true do |t|
    t.string "tipo_nivel_academico_id", :limit => 10
  end

  add_index "estudiante", ["tipo_nivel_academico_id"], :name => "fk_estudiante_tipo_nivel_academico1"
  add_index "estudiante", ["usuario_ci"], :name => "estudiante_usuario_ci_fk"

  create_table "estudiante_curso", :id => false, :force => true do |t|
    t.string "usuario_ci",        :limit => 20, :null => false
    t.string "idioma_id",         :limit => 10, :null => false
    t.string "tipo_categoria_id", :limit => 10, :null => false
    t.string "tipo_convenio_id",  :limit => 10, :null => false
  end

  add_index "estudiante_curso", ["tipo_categoria_id", "idioma_id"], :name => "fk_estudiante_curso_tipo_curso1"
  add_index "estudiante_curso", ["tipo_convenio_id"], :name => "fk_estudiante_curso_tipo_convenio1"
  add_index "estudiante_curso", ["usuario_ci"], :name => "fk_estudiante_curso_estudiante1"

  create_table "estudiante_curso_temp", :id => false, :force => true do |t|
    t.string "usuario_ci"
    t.string "idioma_id"
    t.string "tipo_categoria_id"
    t.string "tipo_convenio_id"
  end

  create_table "estudiante_nivelacion", :id => false, :force => true do |t|
    t.string "usuario_ci",        :limit => 20, :null => false
    t.string "periodo_id",        :limit => 10, :null => false
    t.string "idioma_id",         :limit => 10, :null => false
    t.string "tipo_categoria_id", :limit => 10, :null => false
    t.string "tipo_nivel_id",     :limit => 10, :null => false
  end

  add_index "estudiante_nivelacion", ["periodo_id", "idioma_id", "tipo_categoria_id", "tipo_nivel_id"], :name => "fk_estudiante_nivelacion_curso_periodo1"
  add_index "estudiante_nivelacion", ["usuario_ci"], :name => "fk_estudiante_nivelacion_estudiante1"

  create_table "historial_academico", :id => false, :force => true do |t|
    t.string  "usuario_ci",                  :limit => 20,                  :null => false
    t.string  "idioma_id",                   :limit => 10,                  :null => false
    t.string  "tipo_categoria_id",           :limit => 10,                  :null => false
    t.string  "tipo_nivel_id",               :limit => 10,                  :null => false
    t.string  "tipo_convenio_id",            :limit => 10,                  :null => false
    t.string  "tipo_estado_calificacion_id", :limit => 10,                  :null => false
    t.string  "tipo_estado_inscripcion_id",  :limit => 10,                  :null => false
    t.float   "nota_final",                                :default => 0.0
    t.string  "periodo_id",                  :limit => 10,                  :null => false
    t.integer "seccion_numero",                                             :null => false
    t.string  "numero_deposito"
  end

  add_index "historial_academico", ["periodo_id", "idioma_id", "tipo_categoria_id", "tipo_nivel_id", "seccion_numero"], :name => "fk_historial_academico_estudiante_seccion1"
  add_index "historial_academico", ["tipo_convenio_id"], :name => "fk_historial_academico_tipo_ingreso1"
  add_index "historial_academico", ["tipo_estado_calificacion_id"], :name => "fk_historial_academico_tipo_estado_calificacion1"
  add_index "historial_academico", ["tipo_estado_inscripcion_id"], :name => "fk_historial_academico_tipo_estado_inscripcion1"
  add_index "historial_academico", ["usuario_ci", "idioma_id", "tipo_categoria_id", "tipo_convenio_id"], :name => "fk_historial_academico_estudiante_curso1"

  create_table "historial_academico_temp", :id => false, :force => true do |t|
    t.string "usuario_ci"
    t.string "idioma_id"
    t.string "tipo_categoria_id"
    t.string "tipo_nivel_id"
    t.string "tipo_convenio_id"
    t.string "tipo_estado_inscripcion_id"
    t.string "tipo_estado_calificacion_id"
    t.string "nota_final"
    t.string "periodo_id"
    t.string "seccion_numero"
  end

  create_table "horario_disponible_instructor", :primary_key => "instructor_ci", :force => true do |t|
    t.string "horario"
  end

  add_index "horario_disponible_instructor", ["instructor_ci"], :name => "fk_horario_disponible_instructor_instructor1"

  create_table "horario_seccion", :id => false, :force => true do |t|
    t.string  "periodo_id",        :limit => 10, :null => false
    t.string  "idioma_id",         :limit => 10, :null => false
    t.string  "tipo_categoria_id", :limit => 10, :null => false
    t.string  "tipo_nivel_id",     :limit => 10, :null => false
    t.integer "seccion_numero",                  :null => false
    t.string  "tipo_hora_id",      :limit => 10, :null => false
    t.string  "tipo_dia_id",       :limit => 10, :null => false
    t.string  "aula_id",           :limit => 20, :null => false
  end

  add_index "horario_seccion", ["aula_id"], :name => "fk_horario_seccion_aula1"
  add_index "horario_seccion", ["tipo_hora_id", "tipo_dia_id"], :name => "fk_horario_seccion_tipo_bloque1"

  create_table "horario_seccion_temp", :id => false, :force => true do |t|
    t.string "periodo_id"
    t.string "idioma_id"
    t.string "tipo_categoria_id"
    t.string "tipo_nivel_id"
    t.string "seccion_numero"
    t.string "tipo_hora_id"
    t.string "tipo_dia_id"
    t.string "aula_id"
  end

  create_table "idioma", :force => true do |t|
    t.string "descripcion", :null => false
  end

  create_table "instructor", :primary_key => "usuario_ci", :force => true do |t|
    t.string "numero_cuenta", :limit => 45
  end

  add_index "instructor", ["usuario_ci"], :name => "usuario_ci_fk"

  create_table "parametro_general", :force => true do |t|
    t.string "valor", :null => false
  end

  create_table "periodo", :force => true do |t|
    t.integer "ano",          :null => false
    t.date    "fecha_inicio", :null => false
  end

  create_table "seccion", :id => false, :force => true do |t|
    t.string  "periodo_id",              :limit => 10,                :null => false
    t.string  "idioma_id",               :limit => 10,                :null => false
    t.string  "tipo_categoria_id",       :limit => 10,                :null => false
    t.string  "tipo_nivel_id",           :limit => 10,                :null => false
    t.integer "seccion_numero",                                       :null => false
    t.integer "esta_abierta",                          :default => 1, :null => false
    t.string  "instructor_ci",           :limit => 20
    t.string  "instructor_evaluador_ci", :limit => 20
  end

  add_index "seccion", ["instructor_ci"], :name => "fk_seccion_instructor1"
  add_index "seccion", ["instructor_evaluador_ci"], :name => "fk_seccion_instructor2"
  add_index "seccion", ["periodo_id", "idioma_id", "tipo_categoria_id", "tipo_nivel_id"], :name => "fk_seccion_curso_periodo1"

  create_table "seccion_temp", :id => false, :force => true do |t|
    t.string "periodo_id"
    t.string "idioma_id"
    t.string "tipo_categoria_id"
    t.string "tipo_nivel_id"
    t.string "seccion_numero"
    t.string "esta_abierta"
    t.string "instructor_ci"
    t.string "instructor_evaluador_ci"
  end

  create_table "session", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "session", ["session_id"], :name => "index_session_on_session_id"
  add_index "session", ["updated_at"], :name => "index_session_on_updated_at"

  create_table "tipo_bloque", :id => false, :force => true do |t|
    t.string "tipo_hora_id", :limit => 10, :null => false
    t.string "tipo_dia_id",  :limit => 10, :null => false
  end

  add_index "tipo_bloque", ["tipo_dia_id"], :name => "fk_tipo_bloque_tipo_dia1"

  create_table "tipo_categoria", :force => true do |t|
    t.string "descripcion", :null => false
  end

  create_table "tipo_convenio", :force => true do |t|
    t.string "descripcion", :null => false
    t.float  "monto",       :null => false
  end

  create_table "tipo_curso", :id => false, :force => true do |t|
    t.string  "idioma_id",         :limit => 10, :null => false
    t.string  "tipo_categoria_id", :limit => 10, :null => false
    t.integer "numero_grados",                   :null => false
  end

  add_index "tipo_curso", ["idioma_id"], :name => "fk_tipo_curso_idioma1"
  add_index "tipo_curso", ["tipo_categoria_id"], :name => "fk_tipo_curso_tipo_categoria1"

  create_table "tipo_dia", :force => true do |t|
    t.string  "descripcion", :null => false
    t.integer "orden",       :null => false
  end

  create_table "tipo_estado_calificacion", :force => true do |t|
    t.string "descripcion", :default => "Sin Calificar", :null => false
  end

  create_table "tipo_estado_inscripcion", :force => true do |t|
    t.string "descripcion", :null => false
  end

  create_table "tipo_hora", :force => true do |t|
    t.time "hora_entrada", :null => false
    t.time "hora_salida",  :null => false
  end

  create_table "tipo_nivel", :force => true do |t|
    t.string "descripcion", :null => false
  end

  create_table "tipo_nivel_academico", :force => true do |t|
    t.string "descripcion", :null => false
  end

  create_table "tipo_sexo", :force => true do |t|
    t.string "descripcion", :null => false
  end

  create_table "tipo_ubicacion", :force => true do |t|
    t.string "descripcion", :null => false
  end

  create_table "usuario", :primary_key => "ci", :force => true do |t|
    t.string   "nombres",                     :limit => 45, :null => false
    t.string   "apellidos",                   :limit => 45, :null => false
    t.string   "correo"
    t.string   "telefono_habitacion",         :limit => 45, :null => false
    t.string   "telefono_movil",              :limit => 45
    t.string   "direccion"
    t.string   "contrasena"
    t.string   "tipo_sexo_id",                :limit => 10
    t.datetime "ultimo_ingreso_sistema"
    t.datetime "ultima_modificacion_sistema"
    t.date     "fecha_nacimiento",                          :null => false
  end

  add_index "usuario", ["tipo_sexo_id"], :name => "fk_usuario_tipo_sexo1"

end
