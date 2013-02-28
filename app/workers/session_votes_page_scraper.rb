# -*- encoding : utf-8 -*-
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'digest/sha1'

class SessionVotesPageScraper

  include Sidekiq::Worker
  sidekiq_options backtrace: true, throttle: { threshold: 50, period: 1.hour }

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(session_id, session_html)
    session_html = Nokogiri::HTML(session_html)
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

    ballots.map do |ballot|
      BallotResultsPageScraper.perform_async(session.uuid, ballot)
    end

  end
end
