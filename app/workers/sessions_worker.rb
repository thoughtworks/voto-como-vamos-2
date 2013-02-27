require 'open-uri'
require 'uri'
require 'nokogiri'
require 'digest/md5'

class SessionVotesPageWorker

  include Sidekiq::Worker

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(session_id, session_html)
    tabela = session_html.css('table tr').map(&:text).reject {|x| x == "" }.map {|x| x.split(/\t\t/).map &:strip }
    detalhes_links = session_html.css('table tr a @href').map(&:text).uniq
    _ = tabela.shift # discarta headers

    i = 0
    votacoes = tabela.inject([]) do |a, e|
      a << {
        horario: e[0],
        proposicao: e[1],
        tipo: e[2],
        situacao: e[4],
        detalhes_link: detalhes_links[i].gsub(/parlamentares\?/, 'parlamentares_nome?')
      }
      i += 1
      a
    end

    data = votacoes.map {|votacao| detalhes_da votacao, session_id }
    ScraperWiki::save_sqlite(%w[sessao_uuid horario_inicio], data, 'votacoes')
  end

  def detalhes_da(votacao, sessao)
    votacao_detalhes = begin
      Nokogiri::HTML open(URI.join(BASE_URL, votacao[:detalhes_link]).to_s).read.force_encoding('UTF-8')
    rescue => e
      puts "Got exception #{e}"
      retry
    end

    text = votacao_detalhes.xpath('//div[@class="box no-box"]').text

    {
      uuid: sessao[:uuid],
      data: sessao[:data],
      horario_inicio: votacao[:horario],
      horario_encerramento: text.match(/Encerramento:\s+((\d{2}:?){3})/)[1],
      proposicao: votacao[:proposicao],
      tipo: votacao[:tipo],
      situacao: votacao[:situacao],
      item_pauta: text.match(/Item pauta:\s+([^\n]+)\n/)[1],
      ordem_dia: text.match(/Ordem dia:\s+([^\n]+) Resultado/)[1],
    }.tap do |votacao|
      data = presencas_da(votacao_detalhes, votacao, sessao)
      ScraperWiki::save_sqlite(%w[data_sessao tipo_sessao numero_sessao horario_inicio_votacao parlamentar], data, 'presencas')
    end
  end

  def presencas_da(votacao_detalhes, votacao, sessao)
    table = votacao_detalhes.css('table.list tr')
    table.shift # discarta header
    table.map {|tr| tr.text.split(/\n/)[0,3].map &:strip }.inject([]) do |a, e|
      a << {
        data_sessao: sessao[:data],
        tipo_sessao: sessao[:tipo],
        numero_sessao: sessao[:numero],

        horario_inicio_votacao: votacao[:horario_inicio],
        parlamentar: e[0],
        partido: e[1],
        voto: e[2],
      }
    end
  end



end

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

class SessionsWorker

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(url=BASE_URL)
    index = Nokogiri::HTML open(url).read

    index.css('a.sessoes @href').each do |href|
      SessionPageWorker.perform_async href.text
    end

    next_link = index.css('a.next_page @href').first
    SessionsWorker.perform_async URI.join(BASE_URL, next_link.text).to_s if next_link
  end

end
