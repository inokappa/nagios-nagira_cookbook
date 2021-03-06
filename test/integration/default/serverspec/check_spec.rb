require 'serverspec'
#require 'spec_helper.rb'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe package('nagios3') do
  it { should be_installed }
end

describe package('g++') do
  it { should be_installed }
end

describe package('libssl-dev') do
  it { should be_installed }
end

describe package('ruby2.0') do
  it { should be_installed }
end

describe package('ruby2.0-dev') do
  it { should be_installed }
end

describe package('build-essential') do
  it { should be_installed }
end

describe process('nagios3') do
  it { should be_running }
  its(:args) { should match /nagios3/ }
end

describe process('ruby2.0') do
  it { should be_running }
  its(:args) { should match /nagira/ }
end
