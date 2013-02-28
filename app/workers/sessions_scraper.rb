# -*- encoding : utf-8 -*-
require 'open-uri'
require 'uri'
require 'nokogiri'

class SessionsScraper

  include Sidekiq::Worker
  sidekiq_options backtrace: true

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(url=BASE_URL)
    index = Nokogiri::HTML open(url).read

    index.css('a.sessoes @href').each do |href|
      SessionPageScraper.perform_async href.text
    end

    next_link = index.css('a.next_page @href').first
    SessionsScraper.perform_async URI.join(BASE_URL, next_link.text).to_s if next_link
  end

end
