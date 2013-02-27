class Projeto < ActiveRecord::Base

  attr_accessible :ano,
    :autores,
    :data_lei,
    :data_tramitacao,
    :ementa,
    :link,
    :materia,
    :numero,
    :numero_lei,
    :setor,
    :situacao,
    :tipo_lei,
    :tipo_sigla,
    :veto

end
