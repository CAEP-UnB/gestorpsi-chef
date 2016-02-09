require 'net/http'
require 'json'

DEPENDENCIES = ['python', 'python-dev', 'python-pip']

DEPENDENCIES.each { |package_name|
  package "#{package_name}"
}

uri = URI("#{node['config']['repository_url']}/releases/latest")
response = Net::HTTP.get(uri)
json_response = JSON.parse(response)
latest_release_url = json_response['tarball_url']

remote_file '/tmp/gestorpsi-latest.tar.gz' do
    source latest_release_url
    action :create
end

execute 'extract:gestorpsi-latest' do
    cwd '/tmp/'
    command 'tar xzf gestorpsi-latest.tar.gz'
end

execute 'copy-to-system:gestorpsi-latest' do
    cwd '/tmp/'
    command "cp -R caep-unb-gestorpsi-*/ #{node['config']['installation_dir']} "
end