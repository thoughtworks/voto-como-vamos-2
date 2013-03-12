# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = 'precise'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.forward_port 80, 8000

  options = {
    :module_path => ['puppet/modules', 'puppet/modules/vendors'],
    :facter => {
      :fqdn => 'precise.vagrant'
    }
  }

  config.vm.provision :puppet, options do |puppet|
    puppet.manifests_path = 'puppet'
    puppet.manifest_file  = 'site.pp'
    puppet.options        = %w[ --libdir=modules/vendors/rbenv/lib --verbose --debug]
  end

end
