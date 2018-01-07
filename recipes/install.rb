YUM_DEPS = %w(gcc libffi-devel python-devel openssl-devel)
APT_DEPS = %w(build-essential libssl-dev libffi-dev python-dev)

include_recipe 'chef-sugar::default'

if rhel?
  DEPS = YUM_DEPS
elsif debian?
  DEPS = APT_DEPS
else
  raise "Platform family #{node[:platform_family]} not supported."
end

DEPS.each do |d|
  package d do
    action :install
  end
end

directory '/opt/python/installer/' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

remote_file '/opt/python/installer/get-pip.py' do
  source 'https://bootstrap.pypa.io/get-pip.py'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :run, 'execute[install_pip]', :immediately
  notifies :run, 'execute[install_credstash]', :immediately
end

execute 'install_pip' do
  command '/opt/python/installer/get-pip.py'
  action :nothing
end

execute 'install_credstash' do
  command 'pip install credstash'
  action :nothing
end

credstash_secret_file '/tmp/test' do
  key 'test'
  region 'us-west-2'
  action :create
end
