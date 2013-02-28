require 'open-uri'
require 'uri'
require 'nokogiri'
require 'digest/sha1'

class SessionPageScraper

  include Sidekiq::Worker

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(url)
    html = Nokogiri::HTML open(URI.join(BASE_URL, url).to_s).read

    title = html.css('#sessao_mais_recente').text.split(/\n/)[2].strip.split

    session = ScrapedData.create! {
      sha1: Digest::SHA1.hexdigest("#{title[0]}-#{title[4]}-#{title[2].gsub(/[^\d]/, '')}"),
      kind: 'Sessão',
      data: {
        data:   title[0],
        tipo:   title[4],
        numero: title[2].gsub(/[^\d]/, ''),
      }
    }

    SessionVotesPageScraper.perform_async session.sha1, html
  end

end
