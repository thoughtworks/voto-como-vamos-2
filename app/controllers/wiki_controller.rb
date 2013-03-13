# -*- encoding : utf-8 -*-
class WikiController < ApplicationController

  def display
    wiki = Gollum::Wiki.new(Rails.root, page_file_dir: 'wiki')
    @page = wiki.page(params[:page]) || not_found
  end

end
