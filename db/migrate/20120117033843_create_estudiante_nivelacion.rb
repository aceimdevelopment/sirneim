class CreateEstudianteNivelacion < ActiveRecord::Migration
  def change
    create_table :estudiante_nivelacion do |t|

      t.timestamps
    end
  end
end
