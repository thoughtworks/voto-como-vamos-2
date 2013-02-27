require 'open-uri'
require 'uri'
require 'nokogiri'

class SessionVotesPageWorker

  include Sidekiq::Worker

  BASE_URL = 'http://votacoes.camarapoa.rs.gov.br/'

  def perform(session_id, session_html)
    session = AssemblySession.find(session_id)
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

    data = ballots.map do |ballot|
      ballot_details = begin
        Nokogiri::HTML open(URI.join(BASE_URL, ballot[:details_link]).to_s).read.force_encoding('UTF-8')
      rescue => e
        puts "Got exception #{e}"
        retry
      end

      text = ballot_details.xpath('//div[@class="box no-box"]').text

      ballot = AssemblyBallot.save! {
        uuid: session[:uuid],
        data: session[:data],
        horario_inicio: ballot[:horario],
        horario_encerramento: text.match(/Encerramento:\s+((\d{2}:?){3})/)[1],
        proposicao: ballot[:proposicao],
        tipo: ballot[:tipo],
        situacao: ballot[:situacao],
        item_pauta: text.match(/Item pauta:\s+([^\n]+)\n/)[1],
        ordem_dia: text.match(/Ordem dia:\s+([^\n]+) Resultado/)[1],
      }

      table = ballot_details.css('table.list tr')
      table.shift # discarta header
      table.map {|tr| tr.text.split(/\n/)[0,3].map &:strip }.each do |e|
        AssemblyVote.save! {
          data_sessao: session[:data],
          tipo_sessao: session[:tipo],
          numero_sessao: session[:numero],

          horario_inicio_votacao: ballot[:horario_inicio],
          parlamentar: e[0],
          partido: e[1],
          voto: e[2],
        }
      end
    end
  end

end
