class DropAssemblyBallots < ActiveRecord::Migration

  def up
    drop_table :assembly_ballots
  end

end
