# -*- encoding : utf-8 -*-
class DropAssemblySessions < ActiveRecord::Migration

  def up
    drop_table :assembly_sessions
  end

end
