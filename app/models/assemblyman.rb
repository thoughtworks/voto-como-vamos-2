# -*- encoding : utf-8 -*-
class Assemblyman < ActiveRecord::Base
  attr_accessible :email, :nome, :partido, :telefone_1, :telefone_2, :telefone_3
end
