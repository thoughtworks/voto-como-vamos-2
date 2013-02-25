# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = 'precise'
  config.vm.forward_port 80, 8000

  options = {
    module_path: 'puppet/modules',
    facter: {
      :fqdn => 'precise.vagrant'
    }
  }

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet'
    puppet.manifest_file  = 'site.pp'
    puppet.options        = %w[ --libdir=\\$modulepath/rbenv/lib --verbose --debug]
  end

end
