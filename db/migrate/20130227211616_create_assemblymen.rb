class CreateAssemblymen < ActiveRecord::Migration
  def change
    create_table :assemblymen do |t|
      t.text :nome
      t.text :email
      t.text :partido
      t.text :telefone_1
      t.text :telefone_2
      t.text :telefone_3

      t.timestamps
    end
  end
end
