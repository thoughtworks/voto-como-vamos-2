require 'open-uri'
require 'uri'
require 'nokogiri'

class SessionVotesPageWorker

  include Sidekiq::Worker

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(session_id, session_html)
    tabela = session_html.css('table tr').map(&:text).reject {|x| x == "" }.map {|x| x.split(/\t\t/).map &:strip }
    detalhes_links = session_html.css('table tr a @href').map(&:text).uniq
    _ = tabela.shift # discard headers

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

    data = votacoes.map do |votacao|
      votacao_detalhes = begin
        Nokogiri::HTML open(URI.join(BASE_URL, votacao[:detalhes_link]).to_s).read.force_encoding('UTF-8')
      rescue => e
        puts "Got exception #{e}"
        retry
      end

      text = votacao_detalhes.xpath('//div[@class="box no-box"]').text

      ballot = AssemblyBallot.save! {
        uuid: sessao[:uuid],
        data: sessao[:data],
        horario_inicio: votacao[:horario],
        horario_encerramento: text.match(/Encerramento:\s+((\d{2}:?){3})/)[1],
        proposicao: votacao[:proposicao],
        tipo: votacao[:tipo],
        situacao: votacao[:situacao],
        item_pauta: text.match(/Item pauta:\s+([^\n]+)\n/)[1],
        ordem_dia: text.match(/Ordem dia:\s+([^\n]+) Resultado/)[1],
      }

      table = votacao_detalhes.css('table.list tr')
      table.shift # discarta header
      table.map {|tr| tr.text.split(/\n/)[0,3].map &:strip }.each do |e|
        AssemblyVote.save! {
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

end
