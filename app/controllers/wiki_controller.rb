# -*- encoding : utf-8 -*-
class WikiController < ApplicationController

  def display
    @page = Wiki.page(params[:page]) || not_found
  end

end
