class AddIndexesToScrapedData < ActiveRecord::Migration

  def change
    add_hstore_index :scraped_data, :data
  end

end
