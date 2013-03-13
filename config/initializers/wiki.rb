# -*- encoding : utf-8 -*-
unless Kernel.const_defined? :Wiki
  Gollum::Wiki.default_committer_email = 'contato@votocomovamos.com.br'
  Gollum::Wiki.default_committer_name  = 'Anônimo'

  Wiki = Gollum::Wiki.new(Rails.root.to_s, page_file_dir: 'wiki')
end
