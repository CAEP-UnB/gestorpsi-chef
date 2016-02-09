execute 'createuser:gestorpsi' do
  command 'createuser gestorpsi'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_user where usename = 'gestorpsi';"`.strip.to_i == 0
  end
end

execute 'createdb:gestorpsi' do
  command 'createdb --owner=gestorpsi gestorpsi'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(1) from pg_database where datname = 'gestorpsi';"`.strip.to_i == 0
  end
end