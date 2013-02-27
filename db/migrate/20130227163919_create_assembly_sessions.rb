class CreateAssemblySessions < ActiveRecord::Migration
  def change
    create_table :assembly_sessions do |t|
      t.text :uuid
      t.text :data
      t.text :tipo
      t.text :numero

      t.timestamps
    end
  end
end
