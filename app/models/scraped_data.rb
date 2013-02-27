class ScrapedData < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore

  attr_accessible :data, :sha1, :kind
end
