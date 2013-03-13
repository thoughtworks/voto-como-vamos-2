# -*- encoding : utf-8 -*-
class WelcomeController < ApplicationController

  def index
    @page = Wiki.page('Home') or render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false
  end

end
