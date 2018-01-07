property :destination, kind_of: String, name_attribute: true
property :key, kind_of: String, required: true
property :region, kind_of: String, required: true

action :create do
  require 'rcredstash'
  ENV['AWS_REGION'] = new_resource.region
  secret = CredStash.get(new_resource.key)
  file new_resource.destination do
    content secret
  end
end

action :delete do
  file destination do
    action :delete
  end
end
