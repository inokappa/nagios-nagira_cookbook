#
%w(build-essential g++ libssl-dev nagios3 ruby2.0 ruby2.0-dev).each do |pkg|
  package pkg do
    action :install
  end
end
#
service "nagios3" do
  action :nothing
  supports :status => true, :restart => true, :reload => true
end
#
service "nagira" do
  action :nothing
  supports :start => true, :status => true, :restart => true
end

gem_package "nagira" do
  action :install
  only_if {File.exists?("/usr/bin/gem")}
end

cookbook_file "/tmp/nagira" do
  source "nagira.patch"
  owner "root"
  group "root"
  mode 00644
  action :create
end

bash "nagira.patch" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    nagira-setup config:config
    cd /etc/init.d/
    patch -u --ignore-whitespace nagira < /tmp/nagira
  EOH
  only_if {File.exists?("/usr/local/bin/nagira-setup")}
  notifies :start, resources(:service => "nagira"),:immediately
end
