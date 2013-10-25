# -*- mode: ruby -*-
# vi: set ft=ruby :

DOMAIN="example.com"
SUBNET="172.16.0"

#Vagrant.configure("2") do |config|
Vagrant::Config.run do |config|
  config.vm.define :foreman do |vmconfig|
    vmconfig.vm.box = "puppetnode1"
    vmconfig.vm.box_url = "https://yum.cegeka.be/vagrant/baseboxes/puppetnode1-centos6-x86_64.box"

    vmconfig.vm.host_name = "foreman.#{DOMAIN}"

    config.vm.forward_port 3000, 3000
    #config.vm.network "forwarded_port", guest: 3000, host: 3000

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
