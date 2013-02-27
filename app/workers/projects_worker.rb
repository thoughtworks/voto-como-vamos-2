require 'csv'
require 'nokogiri'
require 'open-uri'

class ProjectsWorker

  include Sidekiq::Worker

  def perform
    data = open('http://projetos.camarapoa.rs.gov.br/consultas/em_tramitacao.csv')

    dump = []
    CSV.new(data, col_sep: ';', headers: true).each do |line|
      hash = line.to_hash.inject({}) do |a, kv|
        a.merge(kv[0].downcase.gsub(/[^0-9a-z]/, "_") => (kv[1] || '').strip)
      end

      hash['link'] = find_project_href hash['numero']

      Projeto.create! hash
    end
  end

  def find_project_href(number)
    data = open("http://informatica.camarapoa.rs.gov.br/search?q=#{number}&btnG=Buscar&site=camara_poa_projetos&client=projetos")
    xml = Nokogiri::XML(data)
    (xml / '//U').first.text
  end

end
