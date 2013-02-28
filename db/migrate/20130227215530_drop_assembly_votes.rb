# -*- encoding : utf-8 -*-
class DropAssemblyVotes < ActiveRecord::Migration

  def up
    drop_table :assembly_votes
  end

end
