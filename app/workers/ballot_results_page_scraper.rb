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
      ballot_details = Nokogiri::HTML open(URI.join(BASE_URL, hash[:details_link]).to_s).read

      text = ballot_details.xpath('//div[@class="box no-box"]').text
      inicio = hash[:inicio]
      encerramento = text.match(/Encerramento:\s+((\d{2}:?){3})/)[1]
      sha1 = Digest::SHA1.hexdigest("#{session_sha1}-#{inicio}-#{encerramento}"),

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
            sessao_id: session.sha1,
            votacao_id: ballot.sha1,

            parlamentar: e[0],
            partido: e[1],
            voto: e[2],
          }
        )
      end
    end
  end

end
