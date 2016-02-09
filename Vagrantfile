# -*- mode: ruby -*-
# vi: set ft=ruby :
require "yaml"

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  env = ENV.fetch('SPB_ENV', 'local')
  ips = YAML.load_file("config/#{env}/ips.yaml")

  config.vm.define "gestorpsi" do |gestorpsi|
    gestorpsi.vm.provider "virtualbox" do |vm, override|
        override.vm.network 'private_network', ip: ips['gestorpsi']
    end
  end

end
