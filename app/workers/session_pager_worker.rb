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

    titulo = html.css('#sessao_mais_recente').text.split(/\n/)[2].strip.split

    as = AssemblySession.create! {
      uuid:   Digest::MD5.hexdigest("#{titulo[0]}-#{titulo[4]}-#{titulo[2].gsub(/[^\d]/, '')}"),
      data:   titulo[0],
      tipo:   titulo[4],
      numero: titulo[2].gsub(/[^\d]/, ''),
    }

    SessionVotesPageWorker.perform_async as.uuid, html
  end

end
