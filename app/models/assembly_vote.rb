class AssemblyVote < ActiveRecord::Base
  attr_accessible :data_sessao, :horario_inicio_votacao, :numero_sessao, :parlamentar, :partido, :tipo_sessao, :voto
end
