package 'postgresql-9.4'

execute 'postgresql-setup initdb || true'

template '/etc/postgresql/9.4/main/pg_hba.conf' do
    user 'postgres'
    group 'postgres'
    mode 0600
    notifies :restart, 'service[postgresql]'
end

service 'postgresql' do
    action [:enable, :start]
    supports :restart => true
end