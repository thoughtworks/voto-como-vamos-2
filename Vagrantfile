# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = 'precise'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.forward_port 80, 8000

  config.vm.share_folder 'vagrant-root', '/vcv2', '.'

  options = {
    :module_path => ['puppet/modules', 'puppet/modules/vendor'],
    :facter => {
      :fqdn => 'precise.vagrant'
    }
  }

  config.vm.provision :puppet, options do |puppet|
    puppet.manifests_path = 'puppet'
    puppet.manifest_file  = 'site.pp'
    puppet.options        = ENV['DEBUG'] ? %w[--libdir=modules/vendor/rbenv/lib --verbose --debug] : %w[--libdir=modules/vendor/rbenv/lib]
  end

end
