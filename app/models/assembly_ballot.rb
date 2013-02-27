class AssemblyBallot < ActiveRecord::Base
  attr_accessible :data, :horario_encerramento, :horario_inicio, :item_pauta, :ordem_dia, :proposicao, :situacao, :tipo, :uuid
end
