# Install localstack dependencies
include_recipe "nodejs"
include_recipe "java"
include_recipe "maven"

execute 'install_localstack' do
  command 'pip install localstack'
  action :run
  not_if { system('which localstack 1>2 > /dev/null') == 0 }
end
