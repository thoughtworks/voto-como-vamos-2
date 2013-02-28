# -*- encoding : utf-8 -*-
class AddIndexesToScrapedData < ActiveRecord::Migration

  def change
    add_hstore_index :scraped_data, :data
  end

end
