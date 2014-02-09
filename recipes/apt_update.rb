package "software-properties-common" do
  action :install
end

execute "add-apt-repository" do
  command "add-apt-repository ppa:brightbox/ruby-ng-experimental"
  only_if {File.exists?("/usr/bin/add-apt-repository")}
end

execute "apt_get_update" do
  command "apt-get update"
end
