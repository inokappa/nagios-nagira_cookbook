#
%w(build-essential g++ libssl-dev nagios3 ruby2.0 ruby2.0-dev).each do |pkg|
  package pkg do
    action :install
  end
end
#
service "nagios" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end
#
service "nagira" do
  supports :start => true, :status => true, :restart => true
  action :nothing
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
    patch -u nagira < /tmp/nagira
  EOH
  not_if {File.exists?("/usr/local/bin/nagira-setup")}
  notifies :start, resources(:service => "nagira")
end
