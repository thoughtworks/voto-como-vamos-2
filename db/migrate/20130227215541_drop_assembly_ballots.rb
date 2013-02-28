# -*- encoding : utf-8 -*-
class DropAssemblyBallots < ActiveRecord::Migration

  def up
    drop_table :assembly_ballots
  end

end
