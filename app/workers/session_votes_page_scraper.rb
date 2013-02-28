# -*- encoding : utf-8 -*-
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'digest/sha1'

class SessionVotesPageScraper

  include Sidekiq::Worker

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(session_id, session_html)
    session = ScrapedData.find_by_sha1 session_id
    table = session_html.css('table tr').map(&:text).reject {|x| x == "" }.map {|x| x.split(/\t\t/).map &:strip }
    details_links = session_html.css('table tr a @href').map(&:text).uniq
    _ = table.shift # discard headers

    i = 0
    ballots = table.inject([]) do |a, e|
      a << {
        horario: e[0],
        proposicao: e[1],
        tipo: e[2],
        situacao: e[4],
        details_link: details_links[i].gsub(/parlamentares\?/, 'parlamentares_nome?')
      }
      i += 1
      a
    end

    data = ballots.map do |ballot|
      ballot_details = Nokogiri::HTML open(URI.join(BASE_URL, ballot[:details_link]).to_s).read

      text = ballot_details.xpath('//div[@class="box no-box"]').text

      ballot = ScrapedData.create! {
        kind: 'Votação',
        sha1: Digest::SHA1.hexdigest("#{session[:uuid]}-#{}-#{}"),
        data: {
          sessao_id: session.sha1,
          horario_inicio: ballot[:horario],
          horario_encerramento: text.match(/Encerramento:\s+((\d{2}:?){3})/)[1],
          proposicao: ballot[:proposicao],
          tipo: ballot[:tipo],
          situacao: ballot[:situacao],
          item_pauta: text.match(/Item pauta:\s+([^\n]+)\n/)[1],
          ordem_dia: text.match(/Ordem dia:\s+([^\n]+) Resultado/)[1],
        }
      }

      table = ballot_details.css('table.list tr')
      table.shift # discarta header
      table.map {|tr| tr.text.split(/\n/)[0,3].map &:strip }.each do |e|
        ScrapedData.create! {
          kind: 'Voto',
          sha1: Digest::SHA1.hexdigest("#{ballot.sha1}-#{e[0]}-#{e[1]}-#{e[2]}"),
          data: {
            sessao_id: session.sha1,
            votacao_id: ballot.sha1,

            parlamentar: e[0],
            partido: e[1],
            voto: e[2],
          }
        }
      end
    end
  end

end
