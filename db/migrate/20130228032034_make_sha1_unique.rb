# -*- encoding : utf-8 -*-
class MakeSha1Unique < ActiveRecord::Migration

  def up
    add_index :scraped_data, :sha1, unique: true
  end

end
