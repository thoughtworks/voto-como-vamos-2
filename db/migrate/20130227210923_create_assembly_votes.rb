class CreateAssemblyVotes < ActiveRecord::Migration
  def change
    create_table :assembly_votes do |t|
      t.text :data_sessao
      t.text :tipo_sessao
      t.text :numero_sessao
      t.text :horario_inicio_votacao
      t.text :parlamentar
      t.text :partido
      t.text :voto

      t.timestamps
    end
  end
end
