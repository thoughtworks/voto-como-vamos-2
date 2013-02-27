class ScrapedData < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore

  attr_accessible :data, :hash, :kind
end
