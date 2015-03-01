require 'spec_helper'

describe yumrepo('epel') do
  it { should exist }
end
describe yumrepo('remi') do
  it { should exist }
end
