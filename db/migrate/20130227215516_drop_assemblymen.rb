# -*- encoding : utf-8 -*-
class DropAssemblymen < ActiveRecord::Migration

  def up
    drop_table :assemblymen
  end

end
