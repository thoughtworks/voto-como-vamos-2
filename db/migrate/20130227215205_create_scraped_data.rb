class CreateScrapedData < ActiveRecord::Migration
  def change
    create_table :scraped_data do |t|
      t.string :kind
      t.hstore :data
      t.uuid :hash

      t.timestamps
    end
  end
end
