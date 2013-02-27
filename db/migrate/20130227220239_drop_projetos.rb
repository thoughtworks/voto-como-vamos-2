class DropProjetos < ActiveRecord::Migration

  def up
    drop_table :projetos
  end

end
