# -*- encoding : utf-8 -*-
class CreateProjetos < ActiveRecord::Migration

  def change
    create_table :projetos do |t|
      t.text :ano
      t.text :autores
      t.text :data_lei
      t.text :data_tramitacao
      t.text :ementa
      t.text :materia
      t.text :numero
      t.text :numero_lei
      t.text :setor
      t.text :situacao
      t.text :tipo_lei
      t.text :tipo_sigla
      t.text :veto
      t.text :link

      t.timestamps
    end
  end

end
