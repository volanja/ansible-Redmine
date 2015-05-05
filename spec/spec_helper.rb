require 'serverspec'
require 'net/ssh'
require 'infrataster/rspec'
require 'resolv'
require 'ipaddr'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:user] ||= ENV['TARGET_USER']
options[:port] ||= ENV['TARGET_PORT']
options[:keys] ||= ENV['TARGET_PRIVATE_KEY']

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'

# Config Infrataster

## Resolv name unless host is ip-address
def valid_ip?(str)
  begin
    IPAddr.new(str).ipv4?
    true
  rescue
    false
  end
end

if valid_ip?(host)
  target = "#{host}"
else
  begin
    target = "#{Resolv.getaddress(host)}"
  rescue Resolv::ResolvError
    fail "can't resolv name. please check DNS settings"
  end
end

Infrataster::Server.define(
  :redmine,           # name
  target, # ip address or hostname
  vagrant: false     # for vagrant VM
)

## set property for access in roles/redmine/spec/infrataster_spec.rb
property = Hash.new
property['infra_url'] = host
set_property property
