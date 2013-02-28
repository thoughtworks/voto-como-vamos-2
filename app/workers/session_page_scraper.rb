require 'open-uri'
require 'uri'
require 'nokogiri'
require 'digest/md5'

class SessionPageWorker

  include Sidekiq::Worker

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(url)
    html = begin
      Nokogiri::HTML open(URI.join(BASE_URL, url).to_s).read
    rescue => e
      puts "Got exception #{e}"
      retry
    end

    title = html.css('#sessao_mais_recente').text.split(/\n/)[2].strip.split

    assembly_session = AssemblySession.create! {
      uuid:   Digest::MD5.hexdigest("#{title[0]}-#{title[4]}-#{title[2].gsub(/[^\d]/, '')}"),
      data:   title[0],
      tipo:   title[4],
      numero: title[2].gsub(/[^\d]/, ''),
    }

    SessionVotesPageWorker.perform_async assembly_session.uuid, html
  end

end
