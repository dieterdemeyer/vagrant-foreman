# -*- mode: ruby -*-
# vi: set ft=ruby :

DOMAIN="example.com"
SUBNET="172.16.0"

Vagrant::Config.run do |config|
  config.vm.define :foreman do |vmconfig|
    vmconfig.vm.box = "puppetnode1"
    vmconfig.vm.box_url = "https://yum.cegeka.be/vagrant/baseboxes/puppetnode1-centos6-x86_64.box"
    vmconfig.vm.host_name = "foreman.#{DOMAIN}"

    #vmconfig.vm.network :hostonly, "#{SUBNET}.2"
    config.vm.forward_port 3000, 3000

    vmconfig.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "foreman.pp"
      puppet.module_path = [ "../", "./modules" ]
      puppet.facter = {
        "vagrant_host_name" => "foreman.#{DOMAIN}",
        "vagrant_box_name" => "puppetnode1-centos6-x86_64"
      }
      puppet.options = "--verbose"
    end
  end
end
