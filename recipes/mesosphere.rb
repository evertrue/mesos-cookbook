#
# Cookbook Name:: mesos
# Recipe:: mesosphere
#

::Chef::Recipe.send(:include, ::Helpers::Mesos)
::Chef::Recipe.send(:include, ::Helpers::Mesosphere)
Chef::Resource::Service.send(:include, ::Helpers::Mesos)

include_recipe 'mesos::zookeeper' if node[:mesos][:mesosphere][:with_zookeeper]

if !(installed?) then
  install_mesos
  deploy_service_scripts
else
  Chef::Log.info("Mesos is already installed!! Installation will be skipped.")
end

end

%w(master slave).each do |role|
  service "mesos-#{role}" do
    provider Chef::Provider::Service::Upstart
    supports :restart => true, :reload => true
    action :nothing
  end
end
