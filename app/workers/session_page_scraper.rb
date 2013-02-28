# -*- encoding : utf-8 -*-
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'digest/sha1'

class SessionPageScraper

  include Sidekiq::Worker
  sidekiq_options backtrace: true, throttle: { threshold: 100, period: 1.hour }

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(url)
    url_sha1 = Digest::SHA1.hexdigest(url)
    return if ScrapedData.find_by_sha1 url_sha1

    html = open(URI.join(BASE_URL, url).to_s).read
    doc = Nokogiri::HTML html

    title = doc.css('#sessao_mais_recente').text.split(/\n/)[2].strip.split
    data = {
      data:   title[0],
      tipo:   title[4],
      numero: title[2].gsub(/[^\d]/, ''),
    }

    sha1 = Digest::SHA1.hexdigest(data.sort.to_s)

    session = if s = ScrapedData.find_by_sha1(sha1)
      s.data.merge!(data)
      s.save!
    else
      ScrapedData.create!(sha1: sha1, kind: 'Sessão', data: data)
    end

    table = doc.css('table tr').map(&:text).reject {|x| x == '' }.map {|x| x.split(/\t\t/).map &:strip }
    details_links = doc.css('table tr a @href').map(&:text).uniq
    _ = table.shift # discard headers

    i = 0
    ballots = table.each do |e|
      ballot = {
        horario: e[0],
        proposicao: e[1],
        tipo: e[2],
        situacao: e[4],
        details_link: details_links[i].gsub(/parlamentares\?/, 'parlamentares_nome?')
      }
      i += 1

      BallotResultsPageScraper.perform_in 5.minutes, sha1, ballot
    end

    ScrapedData.create! kind: 'Page', sha1: url_sha1, data: { url: url }
  end

end
