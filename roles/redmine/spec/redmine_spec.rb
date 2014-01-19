require 'spec_helper'

## direcotory
describe file('/home/redmine/redmine') do
  it { should be_directory }
end

describe service('redmine') do
  it { should be_enabled   }
  it { should be_running   }
end

## network
describe file('/home/redmine/redmine/tmp/sockets/redmine.socket') do
  it { should be_socket }
end

describe port(8081) do
  it { should be_listening }
end

# file
describe file('/home/redmine/redmine/config/database.yml') do
  it { should be_file }
end

describe file('/etc/init.d/redmine') do
  it { should be_file }
end

describe file('/etc/nginx/conf.d/redmine.conf') do
  it { should be_file }
end

## permisson
describe command("ls -ltad /home/redmine/redmine/log |awk '{print $1}'") do
  it { should return_stdout 'drwxr-xr-x' }
end

describe command("ls -ltad /home/redmine/redmine/tmp |awk '{print $1}'") do
  it { should return_stdout 'drwxr-xr-x' }
end
