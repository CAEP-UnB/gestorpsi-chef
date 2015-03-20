# License: GNU GPL v2
# Configure GestorPSI development environment


# Variables
HOME = "/home/vagrant"
SHARED_DIR = "/vagrant"
VENV_DIR = "#{SHARED_DIR}/virtualenv"
REPO_DIR = "#{SHARED_DIR}/repo/gestorpsi"
EMAIL_DIR = "/tmp/gestorpsi-emails"
PYTHON = "#{VENV_DIR}/bin/python"
DJANGO_RUN = "#{PYTHON} #{REPO_DIR}/manage.py"

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
  action :sync
end


# Configure MariaDB
include_recipe "mariadb::server"
include_recipe "mariadb::client"

package "libmysqlclient-dev"

execute "create_database" do
  command "mysqladmin create gestorpsi -u root"
  not_if "mysql -u root -e 'use gestorpsi;'"
end

# Configure Python environment
include_recipe "python"

package "python-dev"
package "libyaml-dev"

python_virtualenv "#{VENV_DIR}" do
  owner "vagrant"
  group "vagrant"
  action :create
end

python_pip "" do
  virtualenv "#{VENV_DIR}"
  options "-r #{REPO_DIR}/requirements.txt"
end

python_pip "flake8" do
  virtualenv "#{VENV_DIR}"
end

python_pip "ipython" do
  virtualenv "#{VENV_DIR}"
end

template "#{HOME}/.bashrc" do
  owner "vagrant"
  group "vagrant"
  source "bashrc.erb"
  variables({
    :venv_dir => "#{VENV_DIR}",
    :shared_dir => "#{SHARED_DIR}/repo",
    :repo_dir => "#{REPO_DIR}"
  })
end

# Configure GestorPSI

template "#{REPO_DIR}/gestorpsi/settings.py" do
  owner "vagrant"
  group "vagrant"
  source "settings.erb"
end

directory "email_folder" do
  owner "vagrant"
  group "vagrant"
  path "#{EMAIL_DIR}"
  mode 777
  recursive true
  action :create
end

execute "syncdb" do
  command "#{DJANGO_RUN} syncdb --noinput"
end

execute "migrate" do
  command "#{DJANGO_RUN} migrate"
end

execute "create_groups" do
  cwd "#{REPO_DIR}/scripts"
  command "#{PYTHON} creategroups.py"
end

execute "create_payments" do
  cwd "#{REPO_DIR}"
  command "#{DJANGO_RUN} shell < scripts/createpayments.py > /dev/null"
end