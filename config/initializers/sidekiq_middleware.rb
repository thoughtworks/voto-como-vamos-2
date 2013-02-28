# -*- encoding : utf-8 -*-
Sidekiq.configure_server do |config|

  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler
  end

end
