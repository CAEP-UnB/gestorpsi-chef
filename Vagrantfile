# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 8000, host: 8080

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "gestorpsi::development"

    chef.json = {
      "mariadb" => {
        "db_name" => "gestorpsi",
        "user" => "root",
        "password" => ""
      }
    }
  end
end
