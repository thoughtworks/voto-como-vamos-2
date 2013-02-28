# -*- encoding : utf-8 -*-
require 'open-uri'
require 'uri'
require 'nokogiri'

class SessionsScraper

  include Sidekiq::Worker
  sidekiq_options backtrace: true, throttle: { threshold: 100, period: 1.hour }

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(url=BASE_URL)
    url_sha1 = Digest::SHA1.hexdigest url
    return if ScrapedData.find_by_sha1 url_sha1

    index = Nokogiri::HTML open(url).read

    index.css('a.sessoes @href').each do |href|
      SessionPageScraper.perform_in 5.minutes, href.text
    end

    next_link = index.css('a.next_page @href').first
    SessionsScraper.perform_async URI.join(BASE_URL, next_link.text).to_s if next_link

    ScrapedData.create! kind: 'Page', sha1: url_sha1, data: { url: url }
  end

end
