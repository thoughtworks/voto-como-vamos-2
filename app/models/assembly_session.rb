# -*- encoding : utf-8 -*-
class AssemblySession < ActiveRecord::Base
  attr_accessible :data, :numero, :tipo, :uuid
end
