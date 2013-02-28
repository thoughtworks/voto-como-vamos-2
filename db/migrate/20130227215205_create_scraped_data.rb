# -*- encoding : utf-8 -*-
class CreateScrapedData < ActiveRecord::Migration

  def change
    create_table :scraped_data do |t|
      t.string :kind, :null => false
      t.hstore :data, :null => false
      t.string :sha1, :null => false

      t.timestamps
    end
  end

end
