# License: GNU GPL v2
# Configure GestorPSI development environment


# Variables
HOME = "/home/vagrant"
SHARED_DIR = "/vagrant"
VENV_DIR = "#{SHARED_DIR}/virtualenv"
REPO_DIR = "#{SHARED_DIR}/repo/gestorpsi"

# Configure Git
include_recipe "git"

directory "repo_dir" do
  owner "vagrant"
  group "vagrant"
  path "#{REPO_DIR}"
  recursive true
  action :create
end

git "#{REPO_DIR}" do
  repository "https://github.com/CAEP-UnB/gestorpsi.git"
  reference "unb"
  action :sync
end


# Configure MariaDB
include_recipe "mariadb::server"
include_recipe "mariadb::client"

package "libmysqlclient-dev"


# Configure Python environment
include_recipe "python"

package "python-dev"

python_virtualenv "#{VENV_DIR}" do
  owner "vagrant"
  group "vagrant"
  action :create
end

template "#{HOME}/.bashrc" do
  owner "vagrant"
  group "vagrant"
  source "bashrc.erb"
  variables({
    :venv_dir => "#{VENV_DIR}",
    :shared_dir => "#{SHARED_DIR}/repo"
  })
end

python_pip "" do
  virtualenv "#{VENV_DIR}"
  options "-r #{REPO_DIR}/requirements.txt"
end