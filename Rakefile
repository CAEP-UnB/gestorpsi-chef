require 'yaml'

$GESTORPSI_ENV = ENV.fetch('GESTORPSI_ENV', 'local')

ssh_config_file = "config/#{$GESTORPSI_ENV}/ssh_config"
ips_file = "config/#{$GESTORPSI_ENV}/ips.yaml"
config_file = "config/#{$GESTORPSI_ENV}/config.yaml"
iptables_file = "config/#{$GESTORPSI_ENV}/iptables-filter-rules"

ENV['CHAKE_TMPDIR'] = "tmp/chake.#{$GESTORPSI_ENV}"
ENV['CHAKE_SSH_CONFIG'] = ssh_config_file

chake_rsync_options = ENV['CHAKE_RSYNC_OPTIONS'].to_s.clone
chake_rsync_options += ' --exclude backups'
chake_rsync_options += ' --exclude src'
ENV['CHAKE_RSYNC_OPTIONS'] = chake_rsync_options

require "chake"

ips ||= YAML.load_file(ips_file)
config ||= YAML.load_file(config_file)
firewall ||= File.open(iptables_file).read

$nodes.each do |node|
  node.data['environment'] = $GESTORPSI_ENV
  node.data['config'] = config
  node.data['peers'] = ips
  node.data['firewall'] = firewall
end

file 'ssh_config.erb'
if ['local', 'lxc'].include?($GESTORPSI_ENV)
  file ssh_config_file => ['nodes.yaml', ips_file, 'ssh_config.erb', 'Rakefile'] do |t|
    require 'erb'
    template = ERB.new(File.read('ssh_config.erb'))
    File.open(t.name, 'w') do |f|
      f.write(template.result(binding))
    end
    puts 'ERB %s' % t.name
  end
end
task 'bootstrap_common' => ssh_config_file