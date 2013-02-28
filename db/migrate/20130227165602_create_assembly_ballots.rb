# -*- encoding : utf-8 -*-
class CreateAssemblyBallots < ActiveRecord::Migration
  def change
    create_table :assembly_ballots do |t|
      t.text :uuid
      t.text :data
      t.text :horario_inicio
      t.text :horario_encerramento
      t.text :proposicao
      t.text :tipo
      t.text :situacao
      t.text :item_pauta
      t.text :ordem_dia

      t.timestamps
    end
  end
end
