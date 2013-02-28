# -*- encoding : utf-8 -*-
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'digest/sha1'

class BallotResultsPageScraper

  include Sidekiq::Worker
  sidekiq_options backtrace: true, throttle: { threshold: 50, period: 1.hour }

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(session_sha1, hash)
    url = URI.join(BASE_URL, hash['details_link']).to_s
    url_sha1 = Digest::SHA1.hexdigest url

    return if ScrapedData.find_by_sha1 url_sha1

    ballot_details = Nokogiri::HTML open(url).read

    text = ballot_details.xpath('//div[@class="box no-box"]').text
    inicio = hash['inicio']
    encerramento = text.match(/Encerramento:\s+((\d{2}:?){3})/)[1]
    proposicao = hash['proposicao']
    tipo = hash['tipo']

    sha1 = Digest::SHA1.hexdigest(hash['details_link'])

    data = {
      sessao_id: session_sha1,
      horario_inicio: inicio,
      horario_encerramento: encerramento,
      proposicao: proposicao,
      tipo: tipo,
      situacao: hash['situacao'],
      item_pauta: text.match(/Item pauta:\s+([^\n]+)\n/)[1],
      ordem_dia: text.match(/Ordem dia:\s+([^\n]+) Resultado/)[1],
    }

    votacao = ScrapedData.find_by_sha1(sha1)
    ballot = if votacao
      votacao.data.merge!(data)
      votacao.save!
    else
      ScrapedData.create! kind: 'Votação', sha1: sha1, data: data
    end

    table = ballot_details.css('table.list tr')
    table.shift # discarta header
    table.map {|tr| tr.text.split(/\n/)[0,3].map &:strip }.each do |e|
      ScrapedData.create!(
        kind: 'Voto',
        sha1: Digest::SHA1.hexdigest("#{ballot.sha1}-#{e[0]}-#{e[1]}-#{e[2]}"),
        data: {
          sessao_id: session_sha1,
          votacao_id: ballot.sha1,

          parlamentar: e[0],
          partido: e[1],
          voto: e[2],
        }
      )
    end

    ScrapedData.create! kind: 'Page', sha1: url_sha1, data: { url: url }
  end

end
