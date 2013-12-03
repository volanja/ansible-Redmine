require 'spec_helper'

describe group('git') do
  it { should exist }
end

describe user('redmine') do
  it { should exist }
  it { should have_home_directory '/home/redmine' }
end
