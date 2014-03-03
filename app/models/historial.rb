class Historial < ActiveRecord::Base
	set_primary_keys :cohorte_id, :tema_id, :modulo_id, :diplomado_id, :grupo_id, :estudiante_ci

	belongs_to :estudiante,
    :class_name => 'Estudiante',
    :foreign_key => ['estudiante_ci']

    belongs_to :cohorte_tema,
    :class_name => 'CohorteTema',
    :foreign_key => ['cohorte_id', 'tema_id', 'modulo_id', 'diplomado_id', 'grupo_id']

    validates_uniqueness_of :estudiante_ci, :scope => [:cohorte_id, :tema_id, :modulo_id, :diplomado_id, :grupo_id]
end
